-- Verify stackdump:insert_tag on pg

BEGIN;

SELECT has_function_privilege('stackdump.insert_tag(INTEGER, TEXT, INTEGER, INTEGER, INTEGER)', 'execute');

ROLLBACK;
