ALTER session set current_schema = "ODMRSYS";

EXECUTE dbms_output.put_line('Start repository upgrade from 12.1.0.1.3 to 12.1.0.1.4. ' || systimestamp);

DECLARE
  repos_version VARCHAR2(30);
BEGIN
  SELECT PROPERTY_STR_VALUE INTO repos_version FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'VERSION';
  IF ( repos_version = '12.1.0.1.3' ) THEN
    -- change the MAX_DISTINCT_CAT_CUTOFF from 60 to 200  bug 17928976 
    UPDATE ODMRSYS.ODMR$REPOSITORY_PROPERTIES SET PROPERTY_NUM_VALUE = 200 WHERE PROPERTY_NAME = 'MAX_DISTINCT_CAT_CUTOFF';
  
    -- uptick the VERSION
    UPDATE ODMRSYS.ODMR$REPOSITORY_PROPERTIES SET PROPERTY_STR_VALUE = '12.1.0.1.4' WHERE PROPERTY_NAME = 'VERSION';
    COMMIT;  
    dbms_output.put_line('Repository version updated to 12.1.0.1.4.');
  ELSE
    dbms_output.put_line('Upgrade is not necessary.');
  END IF;
  EXCEPTION WHEN OTHERS THEN
   dbms_output.put_line('Failure during upgrade: '||DBMS_UTILITY.FORMAT_ERROR_STACK());
   RAISE;
END;
/

EXECUTE dbms_output.put_line('End repository upgrade from 12.1.0.1.3 to 12.1.0.1.4. ' || systimestamp);
