-- Verify stackdump:insert_answer on pg

BEGIN;

SELECT has_function_privilege('stackdump.insert_answer(INTEGER, INTEGER)', 'execute');

ROLLBACK;
