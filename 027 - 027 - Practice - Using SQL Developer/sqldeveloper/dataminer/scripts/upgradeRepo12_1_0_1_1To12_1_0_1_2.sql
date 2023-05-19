ALTER session set current_schema = "ODMRSYS";

EXECUTE dbms_output.put_line('Start repository upgrade from 12.1.0.1.1 to 12.1.0.1.2. ' || systimestamp);

DECLARE
  repos_version VARCHAR2(30);
BEGIN
  SELECT PROPERTY_STR_VALUE INTO repos_version FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'VERSION';
  IF ( repos_version = '12.1.0.1.1' ) THEN
  
    EXECUTE IMMEDIATE 'INSERT INTO ODMRSYS.ODMR$REPOSITORY_PROPERTIES (PROPERTY_NAME, PROPERTY_STR_VALUE, "COMMENT") VALUES (''PARALLEL_QUERY_ON_ALLOWED'', ''TRUE'', ''If FALSE, the repository implementation will not honor the inserting of parallel query on.'')';
    EXECUTE IMMEDIATE 'INSERT INTO ODMRSYS.ODMR$REPOSITORY_PROPERTIES (PROPERTY_NAME, PROPERTY_STR_VALUE, "COMMENT") VALUES (''PARALLEL_QUERY_OFF_ALLOWED'', ''TRUE'', ''If FALSE, the repository implementation will not honor the inserting of parallel query off.'')';

     -- uptick the VERSION
    UPDATE ODMRSYS.ODMR$REPOSITORY_PROPERTIES SET PROPERTY_STR_VALUE = '12.1.0.1.2' WHERE PROPERTY_NAME = 'VERSION';
    COMMIT;  
    dbms_output.put_line('Repository version updated to 12.1.0.1.2.');
  ELSE
    dbms_output.put_line('Upgrade is not necessary.');
  END IF;
  EXCEPTION WHEN OTHERS THEN
   dbms_output.put_line('Failure during upgrade: '||DBMS_UTILITY.FORMAT_ERROR_STACK());
   RAISE;
END;
/

EXECUTE dbms_output.put_line('End repository upgrade from 12.1.0.1.1 to 12.1.0.1.2. ' || systimestamp);
