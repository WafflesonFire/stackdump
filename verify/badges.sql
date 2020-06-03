-- Verify stackdump:badges on pg

BEGIN;

SELECT id, userId, name
    FROM stackdump.badges
    WHERE FALSE;

ROLLBACK;
