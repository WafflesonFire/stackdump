-- Deploy stackdump:insert_user to pg
-- requires: appschema
-- requires: users

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.insert_user(
    id INTEGER,
    reputation INTEGER,
    creationDate TIMESTAMP,
    displayName TEXT,
    lastAccessDate TIMESTAMP,
    websiteUrl TEXT,
    location TEXT,
    aboutMe TEXT,
    views INTEGER,
    upVotes INTEGER,
    downVotes INTEGER,
    profileImageUrl TEXT,
    accountId INTEGER
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
    INSERT INTO stackdump.users VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'caught fk violation in user, check that data was processed properly.';
    END;
$$;

COMMIT;
