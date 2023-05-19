-- Usage @dropODMRSYST.sql
-- Drops the ODMRSYST account
-- Example: @dropODMRSYST.sql <account name>

EXECUTE dbms_output.put_line('Start drop ODMRSYST account. ' || systimestamp);

DEFINE USER_NAME = &&1

DROP USER "&USER_NAME" CASCADE;

EXECUTE dbms_output.put_line('Finished drop ODMRSYST account. ' || systimestamp);
