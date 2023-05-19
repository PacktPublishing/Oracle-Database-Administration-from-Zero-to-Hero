ALTER SESSION SET NLS_NUMERIC_CHARACTERS=".,";

WHENEVER SQLERROR EXIT SQL.SQLCODE;

DEFINE MAX_VERSIONS = 30

EXECUTE dbms_output.put_line('Start Backup Data Miner Workflows ' || systimestamp);

DECLARE
  table_cnt NUMBER;
BEGIN
  SELECT count(*) INTO table_cnt FROM all_tables WHERE owner='ODMRSYS' AND table_name='ODMR$WORKFLOWS_BACKUP';
  IF (table_cnt = 0) THEN
    EXECUTE IMMEDIATE '
      CREATE TABLE ODMRSYS.ODMR$WORKFLOWS_BACKUP 
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
END;
/

DECLARE
  schema_old_ver VARCHAR2(30);
  schema_ver   VARCHAR2(30);
  patch        VARCHAR2(30);
  db_ver       VARCHAR2(30);
  v_storage    VARCHAR2(30);
  schema_data  CLOB;
  v_db_11_2_0_2 NUMBER; -- db is <= 11.2.0.2?
  row_cnt      NUMBER;
  ver_num      NUMBER := 1;
  maintaindom  NUMBER;
  workflow_rec ODMRSYS.ODMR$WORKFLOWS_BACKUP%ROWTYPE;
BEGIN
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
    SELECT count(*) INTO row_cnt FROM ODMRSYS.ODMR$WORKFLOWS_BACKUP;
    IF (row_cnt > 0) THEN
      SELECT NVL(MAX(VERSION)+1,1) INTO ver_num FROM ODMRSYS.ODMR$WORKFLOWS_BACKUP;
    END IF;
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
      workflow_rec.USER_NAME := wf.USER_NAME;
      workflow_rec.PROJECT_ID := wf.PROJECT_ID;
      workflow_rec.PROJECT_NAME := wf.PROJECT_NAME;
      workflow_rec.PJ_CREATION_TIME := wf.PJ_CREATION_TIME;
      workflow_rec.PJ_LAST_UPDATED_TIME := wf.PJ_LAST_UPDATED_TIME;
      workflow_rec.PJ_COMMENTS := wf.PJ_COMMENTS;
      workflow_rec.WORKFLOW_ID := wf.WORKFLOW_ID;
      workflow_rec.WORKFLOW_NAME := wf.WORKFLOW_NAME;
      workflow_rec.WORKFLOW_DATA := SYS.XMLTYPE(wf.WORKFLOW_DATA);
      workflow_rec.CHAIN_NAME := wf.CHAIN_NAME;
      workflow_rec.RUN_MODE := wf.RUN_MODE;
      workflow_rec.STATUS := wf.STATUS;
      workflow_rec.WF_CREATION_TIME := wf.WF_CREATION_TIME;
      workflow_rec.WF_LAST_UPDATED_TIME := wf.WF_LAST_UPDATED_TIME;
      workflow_rec.BACKUP_TIME := SYSTIMESTAMP;
      workflow_rec.VERSION := ver_num;
      workflow_rec.WF_COMMENTS := wf.WF_COMMENTS;
      BEGIN
        -- Output the ids (proj name, workflow name, proj id, workflow id) 
        dbms_output.put_line('Backup workflow: ('||wf.PROJECT_NAME||', '||wf.WORKFLOW_NAME||', '||wf.PROJECT_ID||', '||wf.WORKFLOW_ID||')');
        INSERT INTO ODMRSYS.ODMR$WORKFLOWS_BACKUP VALUES workflow_rec;
        COMMIT;
      EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Backup workflow failed: ('||wf.PROJECT_NAME||', '||wf.WORKFLOW_NAME||', '||wf.PROJECT_ID||', '||wf.WORKFLOW_ID||')');
      END;
    END LOOP;
  END IF;
  -- keep the latest 30 versions
  EXECUTE IMMEDIATE 'DELETE FROM ODMRSYS.ODMR$WORKFLOWS_BACKUP WHERE VERSION <= :1' USING (ver_num - &MAX_VERSIONS);
  COMMIT;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK;
  RAISE_APPLICATION_ERROR(-20000, 'Workflow backup failed.'||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000));
END;
/

EXECUTE dbms_output.put_line('End Backup Data Miner Workflows. ' || systimestamp);
