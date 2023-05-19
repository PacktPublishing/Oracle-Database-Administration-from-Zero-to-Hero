--script to validate if the current repository implementation has the following attributes:
-- 1)If the Repository version number is already equal to the new one, then cancel migration
-- as it is unecessary. 
-- 2)Repository version is at a minimum 12.1.0.1.3 which is what is installed by SQL Dev 4.0
-- 3)Database must be 11.2.0.4 or higher.
-- Example:
-- @isBinaryMigrationAllowed.sql

WHENEVER SQLERROR EXIT SQL.SQLCODE;

@@version.sql

EXECUTE dbms_output.put_line('Start is migration allowed. ' || systimestamp);

DEFINE NEW_REPOSITORY_VERSION = '&REPOSITORY_VERSION'
DEFINE MINIMUM_DB_VERSION = '11.2.0.4'
DEFINE MINIMUM_REPO_VERSION = '11.2.2.1.1'

ALTER session set current_schema = "SYS";
/

EXECUTE dbms_output.put_line('Start Data Miner Validation to determine a migration is allowed');

-- Check that ODMRSYS Repository Version Number is not greater than or equal to the NEW_REPOSITORY_VERSION
-- And also check ODMRSYS Repository Version Number is at least the  MINIMUM_REPO_VERSION or greater
DECLARE
  v_repo_version VARCHAR(35);
BEGIN
  EXECUTE IMMEDIATE 'SELECT PROPERTY_STR_VALUE FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = ''VERSION''' INTO v_repo_version;

  IF( v_repo_version >= '&NEW_REPOSITORY_VERSION') THEN
      RAISE_APPLICATION_ERROR(-20000, 'The current Data Miner repository version is ' || v_repo_version || ' which already meets or exceeds the target repository version of ' || '&NEW_REPOSITORY_VERSION' || '.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('The current Data Miner repository version is ' || v_repo_version || ' so it is not yet upgraded to the target repository version of  ' || '&NEW_REPOSITORY_VERSION' || '.');
  END IF;  

  IF( v_repo_version < '&MINIMUM_REPO_VERSION') THEN
      RAISE_APPLICATION_ERROR(-20000, 'The current Data Miner repository version is ' || v_repo_version || ' which does not satisify the than minimum requirement of ' || '&MINIMUM_REPO_VERSION' || ' or greater.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('The current Data Miner repository version is ' || v_repo_version || ' which meets the minimum requirement of ' || '&MINIMUM_REPO_VERSION' || ' or greater.');
  END IF;  
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Failed repository version test, migration is unable to proceed.');
    RAISE;
END;
/


-- Check DB Version. Must be MINIMUM_DB_VERSION or greater.
DECLARE
  v_version VARCHAR(30);
BEGIN
  SELECT DISTINCT DB.VERSION INTO v_version FROM PRODUCT_COMPONENT_VERSION DB WHERE DB.PRODUCT LIKE '%Oracle Database%';
  IF( v_version < '&MINIMUM_DB_VERSION') THEN
      RAISE_APPLICATION_ERROR(-20000, 'Database version is ' || v_version || ' which does not satisify the than minimum requirement of ' || '&MINIMUM_DB_VERSION' || ' or greater.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Datbase version is ' || v_version || ' which meets the minimum requirement of ' || '&MINIMUM_DB_VERSION' || ' or greater.');
  END IF;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Failed database version test, unable to proceed with migration.');
  RAISE;

END;
/

EXECUTE dbms_output.put_line('Finished is migration allowed. ' || systimestamp);