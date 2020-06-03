-- Deploy stackdump:insert_postHistory to pg
-- requires: appschema
-- requires: postHistory

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.insert_postHistory(
    id INTEGER,
    postHistoryTypeId INTEGER,
    postId INTEGER,
    revisionGUID TEXT,
    creationDate TIMESTAMP,
    userId INTEGER,
    UserDisplayName TEXT,
    comment TEXT,
    text TEXT
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
    INSERT INTO stackdump.postHistory VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'caught fk constraint';
            INSERT INTO stackdump.postHistory VALUES($1, NULL, NULL, $4, $5, NULL, $7, $8, $9);
    END;
$$;

COMMIT;
