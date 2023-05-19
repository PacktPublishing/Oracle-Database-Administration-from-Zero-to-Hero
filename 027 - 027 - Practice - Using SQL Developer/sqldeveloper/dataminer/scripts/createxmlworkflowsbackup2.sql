/*
Run this script in SYS account to back up workflows within ODMRSYS schema or user specified account.
The backup script will maintain MAX_VERSIONS distinct backups within the backup table. Older backups are automatically deleted.

@createxmlworkflowsbackup2.sql [<backup account>]
Parameter
<backup account> - account to back up workflows.  If not specified, default to ODMRSYS account.

Example:
@createxmlworkflowsbackup2.sql
@createxmlworkflowsbackup2.sql ODMR_BACKUP
*/
ALTER SESSION SET NLS_NUMERIC_CHARACTERS=".,";

-- make 1st parameter optional
COLUMN 1 NEW_VALUE 1
SET FEEDBACK off
SELECT NULL "1" FROM dual WHERE rownum=0;
SET FEEDBACK on

WHENEVER SQLERROR EXIT SQL.SQLCODE;

DEFINE MAX_VERSIONS = 30

EXECUTE dbms_output.put_line('');
EXECUTE dbms_output.put_line('Start Backup Data Miner Workflows');
EXECUTE dbms_output.put_line('');

DECLARE
  v_backup_account  VARCHAR2(30) := q'[&&1]';
  schema_old_ver    VARCHAR2(30);
  schema_ver        VARCHAR2(30);
  patch             VARCHAR2(30);
  db_ver            VARCHAR2(30);
  v_storage         VARCHAR2(30);
  schema_data       CLOB;
  v_db_11_2_0_2     NUMBER; -- db is <= 11.2.0.2?
  v_cnt             NUMBER;
  ver_num           NUMBER := 1;
  maintaindom       NUMBER;
  countWorkflowsbackedup NUMBER := 0;
BEGIN
  IF (v_backup_account IS NULL OR LENGTH(v_backup_account) = 0) THEN
    v_backup_account := 'ODMRSYS';
  ELSE
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ALL_USERS WHERE USERNAME=:1' INTO v_cnt USING v_backup_account;
    IF (v_cnt = 0) THEN
      DBMS_OUTPUT.PUT_LINE('Backup account not found: '||v_backup_account);
      RAISE_APPLICATION_ERROR(-20001, 'Backup account not found: '||v_backup_account);
    END IF;
  END IF;
  EXECUTE IMMEDIATE 'SELECT count(*) FROM ALL_TABLES WHERE owner=:1 AND table_name=''ODMR$WORKFLOWS_BACKUP''' INTO v_cnt USING v_backup_account;
  IF (v_cnt = 0) THEN
    EXECUTE IMMEDIATE '
      CREATE TABLE "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP 
      (
        USER_NAME VARCHAR2(30 CHAR) NOT NULL 
      , PROJECT_ID NUMBER NOT NULL 
      , PROJECT_NAME VARCHAR2(30 CHAR) NOT NULL 
      , PJ_CREATION_TIME TIMESTAMP(6) NOT NULL 
      , PJ_LAST_UPDATED_TIME TIMESTAMP(6) 
      , PJ_COMMENTS VARCHAR2(4000 CHAR) 
      , WORKFLOW_ID NUMBER NOT NULL 
      , WORKFLOW_NAME VARCHAR2(30 CHAR) NOT NULL 
      , WORKFLOW_DATA SYS.XMLTYPE 
      , CHAIN_NAME VARCHAR2(30 CHAR) 
      , RUN_MODE VARCHAR2(30 CHAR) 
      , STATUS VARCHAR2(30 CHAR) NOT NULL 
      , WF_CREATION_TIME TIMESTAMP(6) NOT NULL 
      , WF_LAST_UPDATED_TIME TIMESTAMP(6) 
      , BACKUP_TIME TIMESTAMP(6) NOT NULL 
      , VERSION NUMBER NOT NULL 
      , WF_COMMENTS VARCHAR2(4000 CHAR) 
      , CONSTRAINT ODMR$WORKFLOWS_BACKUP_PK PRIMARY KEY 
        (     
          PROJECT_ID
        , WORKFLOW_ID 
        , VERSION 
        )
        ENABLE 
      ) 
      LOGGING 
      PCTFREE 10 
      INITRANS 1 
      XMLTYPE COLUMN "WORKFLOW_DATA" STORE AS SECUREFILE BINARY XML';
  END IF;

  SELECT STORAGE_TYPE INTO v_storage FROM ALL_XML_TAB_COLS WHERE OWNER='ODMRSYS' AND TABLE_NAME='ODMR$WORKFLOWS' AND COLUMN_NAME='WORKFLOW_DATA';

  /*
  if (db is >= 11.2.0.3 AND SQL Dev > 3.0) OR (db is <= 11.2.0.2 AND MAINTAIN_DOM_PATCH_INSTALLED)
    back up all workflows
  end if   
  */
  IF (v_storage != 'BINARY') THEN
    -- determine xml schema version
    SELECT XMLSerialize(CONTENT SCHEMA AS CLOB) INTO schema_data
    FROM DBA_XML_SCHEMAS WHERE schema_url = 'http://xmlns.oracle.com/odmr11/odmr.xsd' AND owner = 'ODMRSYS';
    maintaindom := INSTR(schema_data, 'xdb:maintainDOM="false"', 1, 1);
    -- determine database version
    SELECT version INTO db_ver FROM product_component_version WHERE product LIKE 'Oracle Database%' OR PRODUCT like 'Personal Oracle Database %';
    
    --- Check schema compatibility
    schema_old_ver := '11.2.0.1.9'; -- default value
    BEGIN
      SELECT property_str_value INTO schema_ver
      FROM "ODMRSYS"."ODMR$REPOSITORY_PROPERTIES" WHERE property_name = 'WF_VERSION';
      
      IF schema_old_ver = schema_ver  THEN
        IF NOT (db_ver = '11.2.0.1' OR db_ver = '11.2.0.2') THEN
          dbms_output.put_line('WARNING: The backup process can not be done, The workflows need to be migrated first'); 
        RETURN;
        END IF;
      END IF;
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
      schema_ver  := schema_old_ver;
      dbms_output.put_line('No WF_VERSION found. Defaults to: '  || schema_old_ver);
    END;
        
    -- determine if MAINTAIN_DOM_PATCH_INSTALLED
    IF (INSTR(db_ver, '11.2.0.2') > 0 OR INSTR(db_ver, '11.2.0.1') > 0 OR INSTR(db_ver, '11.2.0.0') > 0) THEN
      v_db_11_2_0_2 := 1;
      BEGIN
        SELECT PROPERTY_STR_VALUE INTO patch FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'MAINTAIN_DOM_PATCH_INSTALLED';
        patch := UPPER(patch);
      EXCEPTION WHEN NO_DATA_FOUND THEN
        patch := 'FALSE';
      END;
    ELSE
      v_db_11_2_0_2 := 0;
    END IF;
  END IF;
  IF (   v_storage = 'BINARY'
      OR (v_db_11_2_0_2 = 0) -- db is >= 11.2.0.3
      OR ((v_db_11_2_0_2 > 0) AND ((patch = 'TRUE') OR (maintaindom = 0))) ) THEN -- db is <= 11.2.0.2 AND (MAINTAIN_DOM_PATCH_INSTALLED OR maintaindom="true")
    EXECUTE IMMEDIATE 'SELECT NVL(MAX(VERSION)+1,1) FROM "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP' INTO ver_num;
    FOR wf IN (
      SELECT 
        p.USER_NAME "USER_NAME",
        p.PROJECT_ID "PROJECT_ID",
        p.PROJECT_NAME "PROJECT_NAME",
        p.CREATION_TIME "PJ_CREATION_TIME",
        p.LAST_UPDATED_TIME "PJ_LAST_UPDATED_TIME",
        p.COMMENTS "PJ_COMMENTS",
        x.WORKFLOW_ID "WORKFLOW_ID", 
        x.WORKFLOW_NAME "WORKFLOW_NAME", 
        xmlserialize(DOCUMENT x.WORKFLOW_DATA as CLOB indent size = 2) "WORKFLOW_DATA",
        x.CHAIN_NAME "CHAIN_NAME",
        x.RUN_MODE "RUN_MODE",
        x.STATUS "STATUS",
        x.CREATION_TIME "WF_CREATION_TIME",
        x.LAST_UPDATED_TIME "WF_LAST_UPDATED_TIME",
        x.COMMENTS "WF_COMMENTS"
      FROM ODMRSYS.ODMR$PROJECTS p, ODMRSYS.ODMR$WORKFLOWS x
      WHERE p.PROJECT_ID = x.PROJECT_ID
    )
    LOOP
      BEGIN
        -- Output the ids (proj name, workflow name, proj id, workflow id) 
        EXECUTE IMMEDIATE 'INSERT INTO "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP VALUES (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17)' 
          USING wf.USER_NAME, wf.PROJECT_ID, wf.PROJECT_NAME, wf.PJ_CREATION_TIME, wf.PJ_LAST_UPDATED_TIME, wf.PJ_COMMENTS, 
          wf.WORKFLOW_ID, wf.WORKFLOW_NAME, SYS.XMLTYPE(wf.WORKFLOW_DATA), wf.CHAIN_NAME, wf.RUN_MODE, wf.STATUS, 
          wf.WF_CREATION_TIME, wf.WF_LAST_UPDATED_TIME, SYSTIMESTAMP, ver_num, wf.WF_COMMENTS;
        DBMS_OUTPUT.PUT_LINE('Backup User = '||wf.USER_NAME||' Project = '||wf.PROJECT_NAME||' Workflow = '||wf.WORKFLOW_NAME);
        countWorkflowsbackedup := countWorkflowsbackedup +1;
      EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Backup failed User = '||wf.USER_NAME||' Project = '||wf.PROJECT_NAME||' Workflow = '||wf.WORKFLOW_NAME);
      END;
    END LOOP;
  END IF;
  -- keep the latest MAX_VERSIONS versions
  EXECUTE IMMEDIATE 'DELETE FROM "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP WHERE VERSION <= :1' USING (ver_num - &MAX_VERSIONS);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Total Number of Workflows backed up: ' || countWorkflowsbackedup);    
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('Workflow backup failed: '||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000));
  RAISE_APPLICATION_ERROR(-20000, 'Workflow backup failed.'||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000));
END;
/

EXECUTE dbms_output.put_line('End Backup Data Miner Workflows');
