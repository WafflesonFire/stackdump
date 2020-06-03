-- Verify stackdump:insert_postHistory on pg

BEGIN;

SELECT has_function_privilege('stackdump.insert_postHistory(INTEGER, INTEGER, INTEGER, TEXT, TIMESTAMP, INTEGER, TEXT, TEXT, TEXT)', 'execute');

ROLLBACK;
