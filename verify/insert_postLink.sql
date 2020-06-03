-- Verify stackdump:insert_postLink on pg

BEGIN;

SELECT has_function_privilege('stackdump.insert_postLink(INTEGER, TIMESTAMP, INTEGER, INTEGER, INTEGER)', 'execute');

ROLLBACK;
