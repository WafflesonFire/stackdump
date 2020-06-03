-- Verify stackdump:insert_user on pg

BEGIN;

SELECT has_function_privilege('stackdump.insert_user(INTEGER, INTEGER, TIMESTAMP, TEXT, TIMESTAMP, TEXT, TEXT, TEXT, INTEGER, INTEGER, INTEGER, TEXT, INTEGER)', 'execute');

ROLLBACK;
