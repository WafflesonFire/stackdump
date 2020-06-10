-- Deploy stackdump:insert_postLink to pg
-- requires: appschema
-- requires: postLinks

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.insert_postLink(
    id INTEGER,
    creationDate TIMESTAMP,
    postId INTEGER,
    relatedPostId INTEGER,
    linkTypeId INTEGER
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
    INSERT INTO stackdump.postLinks VALUES($1, $2, $3, $4, $5);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'Caught fk violation: ';
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.posts WHERE posts.id = $3) AND $3 IS NOT NULL) THEN
                $3 := NULL;
                RAISE NOTICE 'Invalid postId on post link with id = (%)', $1;
            END IF;
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.posts WHERE posts.id = $4) AND $4 IS NOT NULL) THEN
                $4 := NULL;
                RAISE NOTICE 'Invalid relatedPostId on post link with id = (%)', $1;
            END IF;
            INSERT INTO stackdump.postLinks VALUES($1, $2, $3, $4, $5);
    END;
$$;

COMMIT;
