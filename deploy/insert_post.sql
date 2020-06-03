-- Deploy stackdump:insert_post to pg
-- requires: appschema
-- requires: posts

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.insert_post(
    id INTEGER,
    postTypeId INTEGER,
    acceptedAnswerId INTEGER,
    creationDate TIMESTAMP,
    score INTEGER,
    viewCount INTEGER,
    body TEXT,
    ownerUserId INTEGER,
    ownerDisplayName TEXT,
    lastEditorUserId INTEGER,
    lastEditDate TIMESTAMP,
    lastActivityDate TIMESTAMP,
    title TEXT,
    tags TEXT,
    answerCount INTEGER,
    commentCount INTEGER,
    favoriteCount INTEGER
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
    INSERT INTO stackdump.posts VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'caught fk constraint';
            INSERT INTO stackdump.posts VALUES($1, NULL, NULL, $4, $5, $6, $7, NULL, $9, NULL, $11, $12, $13, $14, $15, $16, $17);
    END;
$$;

COMMIT;
