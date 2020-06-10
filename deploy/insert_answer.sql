-- Deploy stackdump:insert_answer to pg
-- requires: appschema
-- requires: posts
-- requires: insert_post

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.insert_answer(
    id INTEGER,
    acceptedAnswerId INTEGER
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
    UPDATE stackdump.posts SET acceptedAnswerId = $2 WHERE posts.id = $1;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'Caught fk violation: ';
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.posts WHERE posts.id = $2) AND $2 IS NOT NULL) THEN
                $2 := NULL;
                RAISE NOTICE 'Could not update acceptedAnswerId on post with id = (%)', $1;
            END IF;
    END;
$$;

COMMIT;
