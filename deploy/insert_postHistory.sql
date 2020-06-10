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
            RAISE NOTICE 'Caught fk violation: ';
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.postHistoryTypes WHERE postHistoryTypes.id = $2) AND $2 IS NOT NULL) THEN
                $2 := NULL;
                RAISE NOTICE 'Invalid postHistoryTypeId on post history with id = (%)', id;
            END IF;
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.posts WHERE posts.id = $3) AND $3 IS NOT NULL) THEN
                $3 := NULL;
                RAISE NOTICE 'Invalid postId on post history with id = (%)', id;
            END IF;
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.users WHERE users.id = $6) AND $6 IS NOT NULL) THEN
                $6 := NULL;
                RAISE NOTICE 'Invalid userId on post history with id = (%)', id;
            END IF;
            INSERT INTO stackdump.postHistory VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9);
    END;
$$;

COMMIT;
