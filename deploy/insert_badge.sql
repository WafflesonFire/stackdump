-- Deploy stackdump:insert_badge to pg
-- requires: appschema
-- requires: badges

BEGIN;

CREATE OR REPLACE FUNCTION stackdump.insert_badge(
    id INTEGER,
    userId INTEGER,
    name TEXT,
    date TIMESTAMP,
    class INTEGER,
    tagBased BOOLEAN
) RETURNS VOID LANGUAGE PLPGSQL AS $$
    BEGIN
    INSERT INTO stackdump.badges VALUES($1, $2, $3, $4, $5, $6);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'Caught fk violation: ';
            RAISE NOTICE 'Invalid userId on badge with id = (%)', $1;
            INSERT INTO stackdump.badges VALUES($1, NULL, $3, $4, $5, $6);
    END;
$$;

COMMIT;
