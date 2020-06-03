-- Verify stackdump:users on pg

BEGIN;

SELECT id, reputation
    FROM stackdump.users
    WHERE FALSE;

ROLLBACK;
