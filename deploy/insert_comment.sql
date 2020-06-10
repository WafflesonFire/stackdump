-- Deploy stackdump:insert_comment to pg
-- requires: appschema
-- requires: comments

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.insert_comment(
    id INTEGER,
    postId INTEGER,
    score INTEGER,
    text TEXT,
    creationDate TIMESTAMP,
    userId INTEGER
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
    INSERT INTO stackdump.comments VALUES($1, $2, $3, $4, $5, $6);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'Caught fk violation: ';
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.posts WHERE posts.id = $2) AND $2 IS NOT NULL) THEN
                $2 := NULL;
                RAISE NOTICE 'Invalid postId on comment with id = (%)', $1;
            END IF;
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.users WHERE users.id = $6) AND $6 IS NOT NULL) THEN
                $6 := NULL;
                RAISE NOTICE 'Invalid userId on comment with id = (%)', $1;
            END IF;
            
            INSERT INTO stackdump.comments VALUES($1, $2, $3, $4, $5, $6);
    END;
$$;

COMMIT;
