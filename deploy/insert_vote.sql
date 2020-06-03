-- Deploy stackdump:insert_vote to pg
-- requires: appschema
-- requires: votes

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.insert_vote(
    id INTEGER,
    postId INTEGER,
    voteTypeId INTEGER,
    userId INTEGER,
    creationDate TIMESTAMP,
    bountyAmount INTEGER
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
    INSERT INTO stackdump.votes VALUES($1, $2, $3, $4, $5, $6);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'caught fk constraint';
            INSERT INTO stackdump.votes VALUES($1, NULL, NULL, NULL, $5, $6);
    END;
$$;

COMMIT;
