-- Verify stackdump:postHistoryTypes on pg

BEGIN;

SELECT id, name
    FROM stackdump.postHistoryTypes
    WHERE FALSE;

ROLLBACK;
