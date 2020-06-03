-- Verify stackdump:insert_comment on pg

BEGIN;

SELECT has_function_privilege('stackdump.insert_comment(INTEGER, INTEGER, INTEGER, TEXT, TIMESTAMP, INTEGER)', 'execute');

ROLLBACK;
