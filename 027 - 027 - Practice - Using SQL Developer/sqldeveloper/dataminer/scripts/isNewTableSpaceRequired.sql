-- Usage @isNewTableSpaceRequired.sql
-- Determine if a conversion from OR to Binary is required (db 11.2.0.4 and up). If so, check if current ODMRSYS account Table Space has ASM setting.
-- Example: @isNewTableSpaceRequired.sql

WHENEVER SQLERROR EXIT SQL.SQLCODE;

@@version.sql

DEFINE NEW_WORKFLOW_VERSION = '&WORKFLOW_VERSION'

EXECUTE dbms_output.put_line('Start determine if a conversion from OR to Binary is required. ' || systimestamp);

ALTER session set current_schema = "SYS";
/

DECLARE
  v_wf_num  VARCHAR2(30);
  v_db_ver  VARCHAR2(30);
  v_segment VARCHAR2(30);
BEGIN
  SELECT VERSION INTO v_db_ver FROM product_component_version WHERE product LIKE 'Oracle Database%' OR product like 'Personal Oracle Database%';
  IF ( INSTR(v_db_ver, '11.2.0.3') > 0 
    OR INSTR(v_db_ver, '11.2.0.2') > 0 
    OR INSTR(v_db_ver, '11.2.0.1') > 0 
    OR INSTR(v_db_ver, '11.2.0.0') > 0) THEN
    RAISE_APPLICATION_ERROR(-20000, 'Binary xml migration is allowed only for database 11.2.0.4 and beyond.');
  ELSE
  -- Query to determine what version of workflow xml schema is currently installed in repository
    BEGIN
      SELECT PROPERTY_STR_VALUE INTO v_wf_num FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'WF_VERSION';
      dbms_output.put_line('Current xml schema version in database: ' || to_char(v_wf_num));
    EXCEPTION WHEN NO_DATA_FOUND THEN
      v_wf_num := '11.2.0.1.9'; -- if it doesn't exist, assume 11.2.0.1.9
      dbms_output.put_line('Schema version did not exist in properties so it will be added : ' || to_char(v_wf_num));
      INSERT INTO ODMRSYS.ODMR$REPOSITORY_PROPERTIES (PROPERTY_NAME, PROPERTY_STR_VALUE, "COMMENT") VALUES ('WF_VERSION', v_wf_num, 'Supported workflow version');
      COMMIT;
    END;
    IF (v_wf_num < '&NEW_WORKFLOW_VERSION') THEN -- only check for migration if schema is not equal to schema contained in this release
     dbms_output.put_line('XML Schema migration required.');  
      SELECT SEGMENT_SPACE_MANAGEMENT INTO v_segment FROM dba_tablespaces WHERE tablespace_name = (SELECT default_tablespace from DBA_USERS where username = 'ODMRSYS');
      IF (v_segment != 'AUTO') THEN
        RAISE_APPLICATION_ERROR(-20000, 'New table space with ASM setting is required.');
      END IF;
    ELSE
      RAISE_APPLICATION_ERROR(-20000, 'This is the incorrect migration script to run. Please review migration documentation.');
    END IF;
  END IF;
END;
/
EXECUTE dbms_output.put_line('Finished determine if a conversion from OR to Binary is required. ' || systimestamp);
