-- Revert stackdump:badges from pg

BEGIN;

DROP TABLE stackdump.badges;

COMMIT;
