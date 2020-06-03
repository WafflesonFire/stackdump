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
            RAISE NOTICE 'caught fk constraint';
            INSERT INTO stackdump.comments VALUES($1, NULL, $3, $4, $5, NULL);
    END;
$$;

COMMIT;
