-- Verify stackdump:voteTypes on pg

BEGIN;

SELECT id, name
    FROM stackdump.voteTypes
    WHERE FALSE;

ROLLBACK;
