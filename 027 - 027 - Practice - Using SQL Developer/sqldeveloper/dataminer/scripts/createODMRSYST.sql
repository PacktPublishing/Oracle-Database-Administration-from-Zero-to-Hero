-- Usage @createODMRSYST.sql
-- Creates the ODMRSYST account using <user table space> and <temp table space>
-- Example: @createODMRSYST.sql <account name>, <user table space>, <temp table space>

WHENEVER SQLERROR EXIT SQL.SQLCODE;

EXECUTE dbms_output.put_line('Start create ODMRSYST account. ' || systimestamp);

DEFINE USER_NAME = &&1
DEFINE USER_TABLE_SPACE = &&2
DEFINE TEMP_TABLE_SPACE = &&3

BEGIN
  EXECUTE IMMEDIATE 'DROP USER "&USER_NAME" CASCADE';
EXCEPTION WHEN OTHERS THEN
  NULL;
END;
/
-- USER SQL
CREATE USER "&USER_NAME" IDENTIFIED BY bDvy8$yk2unGjzv#21
DEFAULT TABLESPACE "&USER_TABLE_SPACE"
TEMPORARY TABLESPACE "&TEMP_TABLE_SPACE" quota UNLIMITED on "&USER_TABLE_SPACE" PASSWORD EXPIRE;

--Lock ODMRSYS
ALTER USER "&USER_NAME" ACCOUNT LOCK;
ALTER USER "&USER_NAME" PASSWORD EXPIRE;

EXECUTE dbms_output.put_line('Finished create ODMRSYST account. ' || systimestamp);
