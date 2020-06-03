-- Verify stackdump:insert_badge on pg

BEGIN;

SELECT has_function_privilege('stackdump.insert_badge(INTEGER, INTEGER, TEXT, TIMESTAMP, INTEGER, BOOLEAN)', 'execute');

ROLLBACK;
