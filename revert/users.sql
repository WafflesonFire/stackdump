-- Revert stackdump:users from pg

BEGIN;

DROP TABLE stackdump.users;

COMMIT;
