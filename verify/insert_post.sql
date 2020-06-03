-- Verify stackdump:insert_post on pg

BEGIN;

SELECT has_function_privilege('stackdump.insert_post(INTEGER, INTEGER, INTEGER, TIMESTAMP, INTEGER, INTEGER, TEXT, INTEGER, TEXT, INTEGER, TIMESTAMP, TIMESTAMP, TEXT, TEXT, INTEGER, INTEGER, INTEGER)', 'execute');

ROLLBACK;

