ALTER session set current_schema = "ODMRSYS";

DEFINE OLD_REPOSITORY_VERSION = '12.1.0.1.4'
DEFINE NEW_REPOSITORY_VERSION = '12.1.0.1.5'

EXECUTE dbms_output.put_line('Start repository upgrade from ' || '&OLD_REPOSITORY_VERSION' || ' to ' || '&NEW_REPOSITORY_VERSION' || '. ' || systimestamp);

DECLARE
  repos_version VARCHAR2(30);
BEGIN
  SELECT PROPERTY_STR_VALUE INTO repos_version FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'VERSION';
  IF ( repos_version = '&OLD_REPOSITORY_VERSION' ) THEN
   
    -- uptick the VERSION
    UPDATE ODMRSYS.ODMR$REPOSITORY_PROPERTIES SET PROPERTY_STR_VALUE = '&NEW_REPOSITORY_VERSION' WHERE PROPERTY_NAME = 'VERSION';
    COMMIT;  
    dbms_output.put_line('Repository version updated to ' || '&NEW_REPOSITORY_VERSION' || '.');
  ELSE
    dbms_output.put_line('Upgrade is not necessary.');
  END IF;
  EXCEPTION WHEN OTHERS THEN
   dbms_output.put_line('Failure during upgrade: '||DBMS_UTILITY.FORMAT_ERROR_STACK());
   RAISE;
END;
/

EXECUTE dbms_output.put_line('End repository upgrade from ' || '&OLD_REPOSITORY_VERSION' || ' to ' || '&NEW_REPOSITORY_VERSION' || '. ' || systimestamp);
