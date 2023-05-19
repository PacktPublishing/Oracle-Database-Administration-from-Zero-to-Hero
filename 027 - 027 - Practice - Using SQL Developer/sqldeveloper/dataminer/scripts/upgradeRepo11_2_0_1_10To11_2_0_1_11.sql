alter session set current_schema = "ODMRSYS";
--@updateRepositoryProperty.sql VERSION 11.2.0.1.11

EXECUTE dbms_output.put_line('Start repository upgrade from 11.2.0.1.10 to 11.2.0.1.11. ' || systimestamp);

DECLARE
  repos_version VARCHAR2(30);
BEGIN
  SELECT PROPERTY_STR_VALUE INTO repos_version FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'VERSION';
  IF ( repos_version = '11.2.0.1.10' ) THEN
    dbms_output.put_line('Upgrade will be performed.');
    -- uptick the VERSION
    UPDATE ODMRSYS.ODMR$REPOSITORY_PROPERTIES SET PROPERTY_STR_VALUE = '11.2.0.1.11' WHERE PROPERTY_NAME = 'VERSION';
    COMMIT;
    dbms_output.put_line('Repository version updated to  11.2.0.1.11.');
  ELSE
    dbms_output.put_line('Upgrade is not necessary.');
  END IF;
END;
/

EXECUTE dbms_output.put_line('End repository upgrade from 11.2.0.1.10 to 11.2.0.1.11. ' || systimestamp);
