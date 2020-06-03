-- Verify stackdump:tags on pg

BEGIN;

SELECT id, tagName, count
    FROM stackdump.tags
    WHERE FALSE;

ROLLBACK;
