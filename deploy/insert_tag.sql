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
            RAISE NOTICE 'caught fk constraint';
            INSERT INTO stackdump.tags VALUES($1, $2, $3, NULL, NULL);
    END;
$$;

COMMIT;
