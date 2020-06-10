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
    INSERT INTO stackdump.posts VALUES($1, $2, NULL, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'Caught fk violation: ';
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.postTypes WHERE postTypes.id = $2) AND $2 IS NOT NULL) THEN
                $2 := NULL;
                RAISE NOTICE 'Invalid postTypeId on post with id = (%)', $1;
            END IF;
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.users WHERE users.id = $8) AND $8 IS NOT NULL) THEN
                $8 := NULL;
                RAISE NOTICE 'Invalid OwnerUserId on post with id = (%)', $1;
            END IF;
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.users WHERE users.id = $10) AND $10 IS NOT NULL) THEN
                $10 := NULL;
                RAISE NOTICE 'Invalid lastEditorUserId on comment with id = (%)', $1;
            END IF;
            INSERT INTO stackdump.posts VALUES($1, $2, NULL, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17);
    END;
$$;

COMMIT;
