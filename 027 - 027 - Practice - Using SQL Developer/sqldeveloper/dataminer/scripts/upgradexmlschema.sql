WHENEVER SQLERROR EXIT SQL.SQLCODE;

@@version.sql

EXECUTE dbms_output.put_line('Start Data Miner Repository Workflow Schema Update.' || systimestamp);

DEFINE NEW_WF_SCHEMA_VERSION = '&WORKFLOW_VERSION'


ALTER session set current_schema = "SYS";
/

-- Update repository properties WF_VERSION to have the current schema version number
DECLARE
  ver_num         VARCHAR2(30);
BEGIN
  SELECT PROPERTY_STR_VALUE INTO ver_num FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'WF_VERSION';
  dbms_output.put_line('Current Workflow schema repository version: ' || to_char(ver_num));
  -- uptick the WF_VERSION
  UPDATE ODMRSYS.ODMR$REPOSITORY_PROPERTIES SET PROPERTY_STR_VALUE = '&NEW_WF_SCHEMA_VERSION' WHERE PROPERTY_NAME = 'WF_VERSION';
  COMMIT;
  dbms_output.put_line('Update Workflow schema repository version to version ' || '&NEW_WF_SCHEMA_VERSION' || ' succesfully.');
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dbms_output.put_line('Update of Workflow schema repository version from version ' || ver_num || ' to ' || '&NEW_WF_SCHEMA_VERSION' || ' failed: '|| DBMS_UTILITY.FORMAT_ERROR_STACK());
  RAISE;
END;
/


ALTER session set current_schema = "ODMRSYS";
/

-- Update all individual workflows to have the current workflow schema version number
DECLARE
  ver_num   VARCHAR2(30);
BEGIN
  SELECT PROPERTY_STR_VALUE INTO ver_num FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'WF_VERSION';
  UPDATE ODMRSYS.ODMR$WORKFLOWS x
    SET x.WORKFLOW_DATA = updateXML(x.WORKFLOW_DATA, '/WorkflowProcess/@Version', ver_num, 'xmlns="http://xmlns.oracle.com/odmr11"')
  WHERE XMLExists('declare default element namespace "http://xmlns.oracle.com/odmr11";
    $p/WorkflowProcess' PASSING x.WORKFLOW_DATA AS "p");
  COMMIT;
  dbms_output.put_line('All workflows have been updated to version ' || '&NEW_WF_SCHEMA_VERSION');
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  dbms_output.put_line('Updating all workflows to version failed: '||DBMS_UTILITY.FORMAT_ERROR_STACK());
  RAISE;
END;
/

-- Recreate indexes on workflow data
@@createxmlschemaindexes.sql

EXECUTE dbms_output.put_line('End Data Miner Repository Workflow Schema Update.' || systimestamp);
