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
            RAISE NOTICE 'caught fk constraint';
            INSERT INTO stackdump.postLinks VALUES($1, $2, NULL, NULL, $5);
    END;
$$;

COMMIT;
