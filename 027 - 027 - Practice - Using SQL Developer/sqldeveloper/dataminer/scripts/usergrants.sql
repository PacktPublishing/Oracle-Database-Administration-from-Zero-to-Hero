-- Usage @usergrants.sql <P1>
--    P1: User account being configured for use with ODMR
-- Example: @usergrants.sql DMUSER
WHENEVER SQLERROR EXIT SQL.SQLCODE;

@@version.sql

DEFINE USER_ACCOUNT = &&1

EXECUTE dbms_output.put_line('Grant access to Data Miner repository objects to specified user. ' || systimestamp);

-- Check if the repository is already installed
DECLARE
  REPOS_PROP_NOT_FOUND EXCEPTION;
  PRAGMA EXCEPTION_INIT(REPOS_PROP_NOT_FOUND, -942);
  v_repo_version VARCHAR(35);
BEGIN
  EXECUTE IMMEDIATE 'SELECT PROPERTY_STR_VALUE FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = ''VERSION'' AND PROPERTY_STR_VALUE = :1' 
  INTO v_repo_version USING '&REPOSITORY_VERSION';
  DBMS_OUTPUT.PUT_LINE('Repository version:' || v_repo_version);
EXCEPTION
  WHEN REPOS_PROP_NOT_FOUND THEN
    RAISE_APPLICATION_ERROR(-20000, 'Repository is not installed');
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20000, 'Repository version is not compatible with this grant script');
END;
/

-- grants access to required objects including the ODMRUSER role
-- also add ODMRUSER to the user's default list of roles
@@usergrantshelper.sql GRANT "&USER_ACCOUNT"

EXECUTE dbms_output.put_line('Finished grant access to Data Miner repository objects to specified user. ' || systimestamp);

exit;