-- Deploy stackdump:insert_tag to pg
-- requires: appschema
-- requires: tags

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.insert_tag(
    id INTEGER,
    tagName TEXT,
    count INTEGER,
    excerptPostId INTEGER,
    wikiPostId INTEGER
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
    INSERT INTO stackdump.tags VALUES($1, $2, $3, $4, $5);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'Caught fk violation: ';
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.posts WHERE posts.id = $4) AND $4 IS NOT NULL) THEN
                $4 := NULL;
                RAISE NOTICE 'Invalid excerptPostId on tag with id = (%)', $1;
            END IF;
            IF (SELECT NOT EXISTS(SELECT 1 FROM stackdump.posts WHERE posts.id = $5) AND $5 IS NOT NULL) THEN
                $5 := NULL;
                RAISE NOTICE 'Invalid wikiPostId on tag with id = (%)', $1;
            END IF;
            INSERT INTO stackdump.tags VALUES($1, $2, $3, $4, $5);
    END;
$$;

COMMIT;
