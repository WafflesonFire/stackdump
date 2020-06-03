-- Verify stackdump:postTypes on pg

BEGIN;

SELECT id, name
    FROM stackdump.postTypes
    WHERE FALSE;

ROLLBACK;
