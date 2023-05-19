-- validateVersionUpgrade.sql
-- validate that the repository version and workflow schema version have
-- successfully been updated to their target version numbers
-- If this has not happened, then exit with error
-- Example: This is usually called by a master script so it has the double @
-- @@validateVersionUpgrade.sql

SET serveroutput ON
SET verify OFF

@@version.sql

DEFINE REPOSITORY_VERSION = '&REPOSITORY_VERSION' -- change for each new release
DEFINE WF_SCHEMA_VERSION  = '&WORKFLOW_VERSION' -- change for each new release

EXECUTE dbms_output.put_line('');
EXECUTE dbms_output.put_line('Validate that the Repository Version and Workflow Version have beend updated.');
EXECUTE dbms_output.put_line('');
DECLARE
  w_version_type        VARCHAR2(100) := '';
  w_version_status      VARCHAR2(100) := '';
  w_repo_cur_version    VARCHAR2(100) := '';
  w_repo_cur_wf_version VARCHAR2(100) := '';
  w_load_failed         BOOLEAN       := FALSE;
  w_db_ver              VARCHAR2(30);
  w_patch               VARCHAR2(30);
  --select property_name, property_str_value
  --from ODMRSYS.ODMR$REPOSITORY_PROPERTIES
  --where property_name in ('VERSION','WF_VERSION');
  CURSOR version_cursor
  IS
    SELECT property_name,
      property_str_value
    FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES
    WHERE property_name IN ('VERSION','WF_VERSION');
BEGIN
  DBMS_OUTPUT.ENABLE(NULL);
  SELECT version
  INTO w_db_ver
  FROM product_component_version
  WHERE product LIKE 'Oracle Database%' OR product like 'Personal Oracle Database%';
  -- In SQL Dev 3.2 release, schema and repository versions must be migrated, so match must be positive in both cases
  DBMS_OUTPUT.PUT_LINE ('Workflow Schema version must match');
  OPEN version_cursor;
  FETCH version_cursor INTO w_version_type,w_version_status;
  WHILE version_cursor%FOUND
  LOOP
    IF (w_version_type = 'VERSION') THEN
      DBMS_OUTPUT.PUT_LINE ('Current Repository Version: ' || w_version_type || ' Status: ' || w_version_status);
      w_repo_cur_version := w_version_status;
    ELSE
      DBMS_OUTPUT.PUT_LINE ('Current Workflow Schema Version: ' || w_version_type || ' Status: ' || w_version_status);
      w_repo_cur_wf_version := w_version_status;
    END IF;
    FETCH version_cursor INTO w_version_type,w_version_status;
  END LOOP;
  CLOSE version_cursor;
  DBMS_OUTPUT.PUT_LINE ('Current Database Version:' || w_db_ver); -- Bug16575250
  DBMS_OUTPUT.PUT_LINE ('Target Repository Version: VERSION  Status: ' || '&REPOSITORY_VERSION');
  DBMS_OUTPUT.PUT_LINE ('Target Workflow Schema Version: WF_VERSION Status: ' || '&WF_SCHEMA_VERSION');
  -- skip check if version number is empty
  IF ('SKIP'                   != '&REPOSITORY_VERSION') THEN
    IF (w_repo_cur_version != '&REPOSITORY_VERSION') THEN
      w_load_failed        := TRUE;
    END IF;
  END IF;
  -- skip check if version number is empty
  IF ('SKIP'                        != '&WF_SCHEMA_VERSION') THEN
    DBMS_OUTPUT.PUT_LINE ('Performing schema version check');
    IF (w_repo_cur_wf_version != '&WF_SCHEMA_VERSION') THEN
      w_load_failed           := TRUE;
    END IF;
  END IF;
  -- fail if the versions were not properly updated
  IF (w_load_failed = TRUE) THEN
    RAISE_APPLICATION_ERROR(-20000, 'The Current Repository Version and/or Workflow Version were not updated to match the Target version.  Review install log.');
  END IF;
END;
/
