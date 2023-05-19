/*
Run this script in SYS account to restore backed up workflows.
Workflow will be restored into the same user, project, workflow combination that it was backed up from.

@restorexmlworkflowfrombackup2.sql [<option>] [<backup account>] [<workflow definition schema> <workflow definition table>]
Parameter
<option> - ADD_ONLY - default option, add missing workfows (create missing projects if necessary)
           OVERRIDE_ONLY - add workflows that match, skip the ones that don't match
           OVERRIDE_AND_ADD - use OVERRIDE_ONLY and ADD_ONLY options
           DROP_AND_ADD - drop all workflows and projects, then restore all recent backed up workflows (create missing projects if necessary)
<backup account> - account to restore backup workflows from.  If not specified, default to ODMRSYS account. 
                   This parameter must be specified if <workflow definition> is used.
<workflow definition schema> <workflow definition table> - a table/view that defines what workflows to restore.  If not specified, all recent backed up workflows will be restored.
                                                           The table/view must contain these columns: USER_NAME, PROJECT_NAME, WORKFLOW_NAME, and VERSION which are used to qualify the workflows to restore.
                                                           If the VERSION number does not match any backup version number, an exception will be raised.
                                                           If the VERSION number is null, then the latest version number is used for the restore.

Selective Workflow Restore Example
Lets assume the user SCOTT had accidentally deleted all his workflows last week.
You can use the ADD_ONLY to add his workflows back. You will have to query the backup table to determine which version of backups contain his missing workflows.
In this case lets assume it is 12. Then the following script example, run as SYS will reload only those workflows.

Example: @restorexmlworkflowfrombackup2.sql ADD_ONLY BACKUPACCT BACKUPACCT WORKFLOW_V

The WORKFLOW_V View defined below, will select all the workflows present for the user SCOTT from a specified version backup number. 
CREATE VIEW BACKUPACCT.WORKFLOW_V AS SELECT USER_NAME, PROJECT_NAME, WORKFLOW_NAME, VERSION FROM BACKUPACCT.ODMR$WORKFLOWS_BACKUP WHERE USER_NAME='SCOTT' AND VERSION = 12

Full Workflow Restore Example

Lets assume that there was some critical repository failure that requires a full reload of all workflows from the latest backup.
You can use the DROP_AND_ADD option to insure that all the old workflows are dropped and all the workflows on the backup are reloaded.
In this case, the backup table is located in another account separate from the ODMRSYS account.
The latest backup version will be used for the recovery, so no workflow definition parameter is required.

Example: @restorexmlworkflowfrombackup2.sql DROP_AND_ADD BACKUPACCT 
*/

-- make all parameters optional
COLUMN 1 NEW_VALUE 1
COLUMN 2 NEW_VALUE 2
COLUMN 3 NEW_VALUE 3
COLUMN 4 NEW_VALUE 4
SET FEEDBACK off
SELECT NULL "1", NULL "2", NULL "3", NULL "4" FROM dual WHERE rownum=0;
SET FEEDBACK on

WHENEVER SQLERROR EXIT SQL.SQLCODE;

EXECUTE DBMS_OUTPUT.PUT_LINE('');
EXECUTE DBMS_OUTPUT.PUT_LINE('Start Restore Data Miner Workflows');
EXECUTE DBMS_OUTPUT.PUT_LINE('');

-- restore backup workflows to ODMR$WORKFLOWS
DECLARE
  TYPE NUM_NTAB_TYPE IS TABLE OF NUMBER;
  WF_TABLE_NO_LOCK EXCEPTION;
  PRAGMA EXCEPTION_INIT(WF_TABLE_NO_LOCK, -54);
  v_option                VARCHAR2(30) := '&&1';
  v_backup_account        VARCHAR2(30) := q'[&&2]';
  v_workflow_def_schema   VARCHAR2(30) := q'[&&3]';
  v_workflow_def_table    VARCHAR2(30) := q'[&&4]';
  v_projectId             NUMBER;
  v_workflowId            NUMBER;
  v_cnt                   NUMBER;
  v_ver                   NUMBER := 0;
  v_ver_num               VARCHAR2(30);
  v_wf_version            VARCHAR2(30);
  v_wf_versions           NUM_NTAB_TYPE;
  v_cur                   SYS_REFCURSOR;  
  v_USER_NAME             VARCHAR2(30 CHAR);
  v_PROJECT_ID            NUMBER;
  v_PROJECT_NAME          VARCHAR2(30 CHAR);
  v_PJ_CREATION_TIME      TIMESTAMP(6);
  v_PJ_LAST_UPDATED_TIME  TIMESTAMP(6);
  v_PJ_COMMENTS           VARCHAR2(4000 CHAR);
  v_WORKFLOW_ID           NUMBER;
  v_WORKFLOW_NAME         VARCHAR2(30 CHAR);
  v_WORKFLOW_DATA         SYS.XMLTYPE;
  v_CHAIN_NAME            VARCHAR2(30 CHAR);
  v_RUN_MODE              VARCHAR2(30 CHAR);
  v_STATUS                VARCHAR2(30 CHAR);
  v_WF_CREATION_TIME      TIMESTAMP(6);
  v_WF_LAST_UPDATED_TIME  TIMESTAMP(6);
  v_BACKUP_TIME           TIMESTAMP(6);
  v_VERSION               NUMBER;
  v_WF_COMMENTS           VARCHAR2(4000 CHAR);
  v_sql_stmt              VARCHAR2(4000);
  v_err_msg               VARCHAR2(4000);
  countWorkflowsAdded     NUMBER := 0;
  countWorkflowsUpdated   NUMBER := 0;

  FUNCTION parseWFVersion(p_version in varchar2) RETURN NUM_NTAB_TYPE is
    v_versions  NUM_NTAB_TYPE := NUM_NTAB_TYPE();
    v_start_pos integer := 1;
    v_end_pos   integer;
  BEGIN
    FOR i IN 1..5 LOOP -- assume version contains at most five numbers
      v_versions.extend;
      IF (v_start_pos > 0) THEN
        v_end_pos := INSTR(p_version, '.', v_start_pos);
        IF (v_end_pos > 0) THEN
          v_versions(i) := (SUBSTR(p_version, v_start_pos, v_end_pos-v_start_pos));
          v_start_pos := v_end_pos+1;
        ELSE
          v_versions(i) := SUBSTR(p_version, v_start_pos, (Length(p_version)-v_start_pos)+1);
          v_start_pos := 0; -- end of search
        END IF;
      ELSE
        v_versions(i) := 0; -- assume 0 value
      END IF;
    END LOOP;
    RETURN v_versions;
  END parseWFVersion;

  -- return TRUE if repository XMLSchema >= p_version.  For example, it returns TRUE if repository XMLSchema is 11.2.1.1.1 and p_version is 11.2.0.1.9
  FUNCTION isCompatibleXMLSchema(p_version in varchar2) RETURN BOOLEAN is
    v_comp_versions NUM_NTAB_TYPE := NUM_NTAB_TYPE();
  BEGIN
    v_comp_versions := parseWFVersion(p_version);
    -- compare version number
    FOR i IN 1..5 LOOP -- assume version contains at most five numbers
      IF (v_wf_versions(i) != v_comp_versions(i)) THEN
        RETURN (v_wf_versions(i) - v_comp_versions(i) >= 0);
      END IF;
    END LOOP;
    RETURN TRUE; -- exact same version, so it's compatible
  EXCEPTION WHEN OTHERS THEN
    RETURN FALSE; -- assume incompatible if any error
  END isCompatibleXMLSchema;

BEGIN
  -- lock the workflows table before restore to avoid any conflicts
  LOCK TABLE ODMRSYS.ODMR$WORKFLOWS IN EXCLUSIVE MODE NOWAIT;
  IF (v_option IS NULL OR LENGTH(v_option) = 0) THEN
    v_option := 'ADD_ONLY';
  END IF;
  IF (v_backup_account IS NULL OR LENGTH(v_backup_account) = 0) THEN
    v_backup_account := 'ODMRSYS';
  ELSE
    v_sql_stmt := 'SELECT COUNT(*) FROM ALL_USERS WHERE USERNAME=:1';
    EXECUTE IMMEDIATE v_sql_stmt INTO v_cnt USING v_backup_account;
    IF (v_cnt = 0) THEN
      DBMS_OUTPUT.PUT_LINE('Backup account not found: '||v_backup_account);
      RAISE_APPLICATION_ERROR(-20001, 'Backup account not found: '||v_backup_account);
    ELSE
      BEGIN
        v_sql_stmt := 'SELECT COUNT(*) FROM all_tables WHERE owner=:1 AND table_name=''ODMR$WORKFLOWS_BACKUP''';
        EXECUTE IMMEDIATE v_sql_stmt INTO v_cnt USING v_backup_account;
        IF (v_cnt = 0) THEN
          DBMS_OUTPUT.PUT_LINE('No backup workflows found in the account: '||v_backup_account);
          RAISE_APPLICATION_ERROR(-20002, 'No backup workflows found in the account: '||v_backup_account);
        END IF;
      EXCEPTION 
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Invalid backup account - backup table is not found: '||v_backup_account);
          RAISE_APPLICATION_ERROR(-20003, 'Invalid backup account - backup table is not found: '||v_backup_account);
      END;    
    END IF;
  END IF;
  IF ((v_workflow_def_schema IS NOT NULL OR LENGTH(v_workflow_def_schema) != 0) 
  AND (v_workflow_def_table IS NULL OR LENGTH(v_workflow_def_table) = 0)) THEN
    DBMS_OUTPUT.PUT_LINE('Both workflow definition schema and Workflow definition table must be specified');
    RAISE_APPLICATION_ERROR(-20004, 'Both workflow definition schema and Workflow definition table must be specified');
  END IF;
  IF (v_workflow_def_table IS NOT NULL OR LENGTH(v_workflow_def_table) != 0) THEN
    v_sql_stmt := 'SELECT COUNT(*) FROM all_tab_columns WHERE owner = :1 and table_name = :2 and column_name = ''VERSION''';
    EXECUTE IMMEDIATE v_sql_stmt INTO v_cnt USING v_workflow_def_schema, v_workflow_def_table;
    IF (v_cnt = 0) THEN
      DBMS_OUTPUT.PUT_LINE('VERSION not found in '||v_workflow_def_schema||'.'||v_workflow_def_table||', use latest backup version');
      v_ver := NULL;
    ELSE
      v_sql_stmt := 
        'SELECT COUNT(*)
        FROM "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP b, "'||v_workflow_def_schema||'"."'||v_workflow_def_table||'" w
        WHERE b.VERSION = w.VERSION AND 
              b.USER_NAME = w.USER_NAME AND b.PROJECT_NAME = w.PROJECT_NAME AND b.WORKFLOW_NAME = w.WORKFLOW_NAME';
      EXECUTE IMMEDIATE v_sql_stmt INTO v_cnt;
      IF (v_cnt = 0) THEN
        DBMS_OUTPUT.PUT_LINE('VERSION does not match any backup version');
        RAISE_APPLICATION_ERROR(-20001, 'VERSION does not match any backup version');
      END IF;
    END IF;
  END IF;
  IF (v_ver IS NULL OR v_ver = 0) THEN
    v_sql_stmt := 'SELECT MAX(VERSION) FROM "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP';
    EXECUTE IMMEDIATE v_sql_stmt INTO v_ver;    
  END IF;
  SELECT COUNT(*) INTO v_cnt FROM ODMRSYS.ODMR$WORKFLOWS;
  BEGIN
    SELECT PROPERTY_STR_VALUE INTO v_wf_version FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'WF_VERSION';
  EXCEPTION WHEN NO_DATA_FOUND THEN
    v_wf_version := '11.2.0.1.9'; -- if it doesn't exist, assume 11.2.0.1.9
  END;
  v_wf_versions := parseWFVersion(v_wf_version);
  DBMS_OUTPUT.PUT_LINE('Current xml schema version in database: ' || to_char(v_wf_version));
  IF (v_cnt = 0 OR v_option = 'DROP_AND_ADD') THEN -- add workflows from backup regardless of the option param value
    IF (v_option = 'DROP_AND_ADD') THEN
      DELETE FROM ODMRSYS.ODMR$WORKFLOWS;
      DELETE FROM ODMRSYS.ODMR$PROJECTS;
    END IF;
    IF (v_workflow_def_table IS NOT NULL OR LENGTH(v_workflow_def_table) != 0) THEN
      v_sql_stmt := 
        'SELECT 
          b.WORKFLOW_ID,
          b.WORKFLOW_NAME, 
          b.WORKFLOW_DATA,
          b.USER_NAME,
          b.PROJECT_ID,
          b.PROJECT_NAME,
          b.PJ_CREATION_TIME,
          b.PJ_LAST_UPDATED_TIME,
          b.PJ_COMMENTS,
          b.CHAIN_NAME,
          b.RUN_MODE,
          b.STATUS,
          b.WF_CREATION_TIME,
          b.WF_LAST_UPDATED_TIME,
          b.WF_COMMENTS
        FROM "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP b, "'||v_workflow_def_schema||'"."'||v_workflow_def_table||'" w
        WHERE b.VERSION = '||v_ver||' AND 
              b.USER_NAME = w.USER_NAME AND b.PROJECT_NAME = w.PROJECT_NAME AND b.WORKFLOW_NAME = w.WORKFLOW_NAME
        ORDER BY b.USER_NAME, b.PROJECT_NAME';
    ELSE
      v_sql_stmt := 
        'SELECT 
          b.WORKFLOW_ID,
          b.WORKFLOW_NAME, 
          b.WORKFLOW_DATA,
          b.USER_NAME,
          b.PROJECT_ID,
          b.PROJECT_NAME,
          b.PJ_CREATION_TIME,
          b.PJ_LAST_UPDATED_TIME,
          b.PJ_COMMENTS,
          b.CHAIN_NAME,
          b.RUN_MODE,
          b.STATUS,
          b.WF_CREATION_TIME,
          b.WF_LAST_UPDATED_TIME,
          b.WF_COMMENTS
        FROM "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP b
        WHERE b.VERSION = '||v_ver||'
        ORDER BY b.USER_NAME, b.PROJECT_NAME';
    END IF;
    OPEN v_cur for v_sql_stmt;        
    LOOP
      FETCH v_cur into v_WORKFLOW_ID,v_WORKFLOW_NAME,v_WORKFLOW_DATA,v_USER_NAME,v_PROJECT_ID,v_PROJECT_NAME,v_PJ_CREATION_TIME,
        v_PJ_LAST_UPDATED_TIME,v_PJ_COMMENTS,v_CHAIN_NAME,v_RUN_MODE,v_STATUS,v_WF_CREATION_TIME,v_WF_LAST_UPDATED_TIME,v_WF_COMMENTS;
      EXIT WHEN v_cur%NOTFOUND OR v_cur%NOTFOUND IS NULL;
      BEGIN
        SELECT extractvalue(v_WORKFLOW_DATA, '/WorkflowProcess/@Version', 'xmlns="http://xmlns.oracle.com/odmr11"') INTO v_ver_num FROM dual;
        IF (isCompatibleXMLSchema(v_ver_num) = FALSE) THEN
          DBMS_OUTPUT.PUT_LINE('Add failed: '||'User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME||' Workflow = '||v_WORKFLOW_NAME||' Error: Incompatible version: '||v_ver_num);
        ELSE
          BEGIN
            SELECT PROJECT_ID INTO v_projectId FROM ODMRSYS.ODMR$PROJECTS p WHERE p.USER_NAME=v_USER_NAME AND p.PROJECT_NAME=v_PROJECT_NAME;
          EXCEPTION WHEN NO_DATA_FOUND THEN
            v_projectId := ODMRSYS.ODMR$PROJECT_ID_SEQ.nextval;
            INSERT INTO ODMRSYS.ODMR$PROJECTS VALUES (v_USER_NAME, v_projectId, v_PROJECT_NAME, v_PJ_CREATION_TIME, v_PJ_LAST_UPDATED_TIME, v_PJ_COMMENTS);
            DBMS_OUTPUT.PUT_LINE('Add User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME);        
          END;
          v_workflowId := ODMRSYS.ODMR$WORKFLOW_ID_SEQ.nextval;
          SELECT updateXML(v_WORKFLOW_DATA, '/WorkflowProcess/@Version', v_wf_version, 'xmlns="http://xmlns.oracle.com/odmr11"') INTO v_WORKFLOW_DATA FROM dual;
          INSERT INTO ODMRSYS.ODMR$WORKFLOWS(WORKFLOW_ID,WORKFLOW_NAME,WORKFLOW_DATA, CHAIN_NAME, RUN_MODE, STATUS, CREATION_TIME, LAST_UPDATED_TIME, COMMENTS, PROJECT_ID) 
                                     VALUES (v_workflowId, v_WORKFLOW_NAME, v_WORKFLOW_DATA, v_CHAIN_NAME, v_RUN_MODE, v_STATUS, v_WF_CREATION_TIME, v_WF_LAST_UPDATED_TIME, v_WF_COMMENTS, v_projectId);
          DBMS_OUTPUT.PUT_LINE('Add User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME||' Workflow = '||v_WORKFLOW_NAME);
          countWorkflowsAdded := countWorkflowsAdded + 1;
        END IF;
      EXCEPTION WHEN OTHERS THEN
        v_err_msg := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000);
        DBMS_OUTPUT.PUT_LINE('Add failed: '||'User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME||' Workflow = '||v_WORKFLOW_NAME||' Error: '||v_err_msg);
      END;
    END LOOP;
    CLOSE v_cur;
  END IF;
  IF (v_cnt > 0 AND v_option IN ('OVERRIDE_ONLY', 'OVERRIDE_AND_ADD')) THEN
    IF (v_workflow_def_table IS NOT NULL OR LENGTH(v_workflow_def_table) != 0) THEN
      v_sql_stmt := 
        'SELECT 
          b.WORKFLOW_ID,
          b.WORKFLOW_NAME, 
          b.WORKFLOW_DATA,
          b.USER_NAME,
          b.PROJECT_ID,
          b.PROJECT_NAME,
          b.PJ_CREATION_TIME,
          b.PJ_LAST_UPDATED_TIME,
          b.PJ_COMMENTS,
          b.CHAIN_NAME,
          b.RUN_MODE,
          b.STATUS,
          b.WF_CREATION_TIME,
          b.WF_LAST_UPDATED_TIME,
          b.WF_COMMENTS
        FROM ODMRSYS.ODMR$PROJECTS p, ODMRSYS.ODMR$WORKFLOWS x, "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP b, "'||v_workflow_def_schema||'"."'||v_workflow_def_table||'" w
        WHERE p.PROJECT_ID = x.PROJECT_ID AND
              p.USER_NAME = b.USER_NAME AND p.PROJECT_NAME = b.PROJECT_NAME AND x.WORKFLOW_NAME = b.WORKFLOW_NAME AND 
              b.VERSION = '||v_ver||' AND 
              b.USER_NAME = w.USER_NAME AND b.PROJECT_NAME = w.PROJECT_NAME AND b.WORKFLOW_NAME = w.WORKFLOW_NAME
        ORDER BY b.USER_NAME, b.PROJECT_NAME';
    ELSE
      v_sql_stmt := 
        'SELECT 
          b.WORKFLOW_ID,
          b.WORKFLOW_NAME, 
          b.WORKFLOW_DATA,
          b.USER_NAME,
          b.PROJECT_ID,
          b.PROJECT_NAME,
          b.PJ_CREATION_TIME,
          b.PJ_LAST_UPDATED_TIME,
          b.PJ_COMMENTS,
          b.CHAIN_NAME,
          b.RUN_MODE,
          b.STATUS,
          b.WF_CREATION_TIME,
          b.WF_LAST_UPDATED_TIME,
          b.WF_COMMENTS
        FROM ODMRSYS.ODMR$PROJECTS p, ODMRSYS.ODMR$WORKFLOWS x, "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP b
        WHERE p.PROJECT_ID = x.PROJECT_ID AND
              p.USER_NAME = b.USER_NAME AND p.PROJECT_NAME = b.PROJECT_NAME AND x.WORKFLOW_NAME = b.WORKFLOW_NAME AND 
              b.VERSION = '||v_ver||'
        ORDER BY b.USER_NAME, b.PROJECT_NAME';
    END IF;
    OPEN v_cur for v_sql_stmt;        
    LOOP
      BEGIN
        FETCH v_cur into v_WORKFLOW_ID,v_WORKFLOW_NAME,v_WORKFLOW_DATA,v_USER_NAME,v_PROJECT_ID,v_PROJECT_NAME,v_PJ_CREATION_TIME,
          v_PJ_LAST_UPDATED_TIME,v_PJ_COMMENTS,v_CHAIN_NAME,v_RUN_MODE,v_STATUS,v_WF_CREATION_TIME,v_WF_LAST_UPDATED_TIME,v_WF_COMMENTS;
        EXIT WHEN v_cur%NOTFOUND OR v_cur%NOTFOUND IS NULL;
        SELECT extractvalue(v_WORKFLOW_DATA, '/WorkflowProcess/@Version', 'xmlns="http://xmlns.oracle.com/odmr11"') INTO v_ver_num FROM dual;
        IF (isCompatibleXMLSchema(v_ver_num) = FALSE) THEN
          DBMS_OUTPUT.PUT_LINE('Update failed: '||'User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME||' Workflow = '||v_WORKFLOW_NAME||' Error: Incompatible version: '||v_ver_num);
        ELSE
          BEGIN
            SELECT PROJECT_ID INTO v_projectId FROM ODMRSYS.ODMR$PROJECTS p WHERE p.USER_NAME=v_USER_NAME AND p.PROJECT_NAME=v_PROJECT_NAME;
          EXCEPTION WHEN NO_DATA_FOUND THEN
            v_projectId := ODMRSYS.ODMR$PROJECT_ID_SEQ.nextval;
            INSERT INTO ODMRSYS.ODMR$PROJECTS VALUES (v_USER_NAME, v_projectId, v_PROJECT_NAME, v_PJ_CREATION_TIME, v_PJ_LAST_UPDATED_TIME, v_PJ_COMMENTS);
            DBMS_OUTPUT.PUT_LINE('Add User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME);        
          END;
          BEGIN      
            SELECT updateXML(v_WORKFLOW_DATA, '/WorkflowProcess/@Version', v_wf_version, 'xmlns="http://xmlns.oracle.com/odmr11"') INTO v_WORKFLOW_DATA FROM dual;
            UPDATE ODMRSYS.ODMR$WORKFLOWS SET WORKFLOW_DATA = v_WORKFLOW_DATA, CREATION_TIME = v_WF_CREATION_TIME, LAST_UPDATED_TIME = v_WF_LAST_UPDATED_TIME, COMMENTS = v_WF_COMMENTS
            WHERE PROJECT_ID = v_projectId;
            DBMS_OUTPUT.PUT_LINE('Update User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME||' Workflow = '||v_WORKFLOW_NAME);
            countWorkflowsUpdated := countWorkflowsUpdated +1;
          EXCEPTION WHEN NO_DATA_FOUND THEN
            v_workflowId := ODMRSYS.ODMR$WORKFLOW_ID_SEQ.nextval;
            INSERT INTO ODMRSYS.ODMR$WORKFLOWS(WORKFLOW_ID,WORKFLOW_NAME,WORKFLOW_DATA, CHAIN_NAME, RUN_MODE, STATUS, CREATION_TIME, LAST_UPDATED_TIME, COMMENTS, PROJECT_ID) 
                                       VALUES (v_workflowId, v_WORKFLOW_NAME, v_WORKFLOW_DATA, v_CHAIN_NAME, v_RUN_MODE, v_STATUS, v_WF_CREATION_TIME, v_WF_LAST_UPDATED_TIME, v_WF_COMMENTS, v_projectId);
            DBMS_OUTPUT.PUT_LINE('Update User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME||' Workflow = '||v_WORKFLOW_NAME);
            countWorkflowsAdded := countWorkflowsAdded + 1;
          END;
        END IF;
      EXCEPTION WHEN OTHERS THEN
        v_err_msg := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000);
        DBMS_OUTPUT.PUT_LINE('Update failed: '||'User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME||' Workflow = '||v_WORKFLOW_NAME||' Error: '||v_err_msg);
      END;
    END LOOP;
    CLOSE v_cur;
  END IF;
  IF (v_cnt > 0 AND v_option IN ('ADD_ONLY', 'OVERRIDE_AND_ADD')) THEN
    IF (v_workflow_def_table IS NOT NULL OR LENGTH(v_workflow_def_table) != 0) THEN
      v_sql_stmt :=
       'WITH 
        r AS (
          SELECT 
            b.USER_NAME,
            b.PROJECT_NAME,
            b.WORKFLOW_NAME 
          FROM "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP b, "'||v_workflow_def_schema||'"."'||v_workflow_def_table||'" w
          WHERE b.USER_NAME = w.USER_NAME AND b.PROJECT_NAME = w.PROJECT_NAME AND b.WORKFLOW_NAME = w.WORKFLOW_NAME AND b.VERSION = w.VERSION
          MINUS
          SELECT 
            s.USER_NAME,
            s.PROJECT_NAME,
            k.WORKFLOW_NAME
          FROM ODMRSYS.ODMR$PROJECTS s, ODMRSYS.ODMR$WORKFLOWS k
          WHERE s.PROJECT_ID = k.PROJECT_ID),
        a AS (SELECT * FROM "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP)
        SELECT 
          a.WORKFLOW_ID,
          a.WORKFLOW_NAME, 
          a.WORKFLOW_DATA,
          a.USER_NAME,
          a.PROJECT_ID,
          a.PROJECT_NAME,
          a.PJ_CREATION_TIME,
          a.PJ_LAST_UPDATED_TIME,
          a.PJ_COMMENTS,
          a.CHAIN_NAME,
          a.RUN_MODE,
          a.STATUS,
          a.WF_CREATION_TIME,
          a.WF_LAST_UPDATED_TIME,
          a.WF_COMMENTS
        FROM a, r
        WHERE a.USER_NAME = r.USER_NAME AND a.PROJECT_NAME = r.PROJECT_NAME AND a.WORKFLOW_NAME = r.WORKFLOW_NAME
        ORDER BY a.USER_NAME, a.PROJECT_NAME';
    ELSE
      v_sql_stmt :=
       'WITH 
        r AS (
          SELECT 
            b.USER_NAME,
            b.PROJECT_NAME,
            b.WORKFLOW_NAME 
          FROM "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP b
          WHERE b.VERSION = '||v_ver||'
          MINUS
          SELECT 
            s.USER_NAME,
            s.PROJECT_NAME,
            k.WORKFLOW_NAME
          FROM ODMRSYS.ODMR$PROJECTS s, ODMRSYS.ODMR$WORKFLOWS k
          WHERE s.PROJECT_ID = k.PROJECT_ID),
        a AS (SELECT * FROM "'||v_backup_account||'".ODMR$WORKFLOWS_BACKUP)
        SELECT 
          a.WORKFLOW_ID,
          a.WORKFLOW_NAME, 
          a.WORKFLOW_DATA,
          a.USER_NAME,
          a.PROJECT_ID,
          a.PROJECT_NAME,
          a.PJ_CREATION_TIME,
          a.PJ_LAST_UPDATED_TIME,
          a.PJ_COMMENTS,
          a.CHAIN_NAME,
          a.RUN_MODE,
          a.STATUS,
          a.WF_CREATION_TIME,
          a.WF_LAST_UPDATED_TIME,
          a.WF_COMMENTS
        FROM a, r
        WHERE a.USER_NAME = r.USER_NAME AND a.PROJECT_NAME = r.PROJECT_NAME AND a.WORKFLOW_NAME = r.WORKFLOW_NAME
        ORDER BY a.USER_NAME, a.PROJECT_NAME';
    END IF;
    OPEN v_cur for v_sql_stmt;        
    LOOP
      FETCH v_cur into v_WORKFLOW_ID,v_WORKFLOW_NAME,v_WORKFLOW_DATA,v_USER_NAME,v_PROJECT_ID,v_PROJECT_NAME,v_PJ_CREATION_TIME,
        v_PJ_LAST_UPDATED_TIME,v_PJ_COMMENTS,v_CHAIN_NAME,v_RUN_MODE,v_STATUS,v_WF_CREATION_TIME,v_WF_LAST_UPDATED_TIME,v_WF_COMMENTS;
      EXIT WHEN v_cur%NOTFOUND OR v_cur%NOTFOUND IS NULL;
      BEGIN
        SELECT extractvalue(v_WORKFLOW_DATA, '/WorkflowProcess/@Version', 'xmlns="http://xmlns.oracle.com/odmr11"') INTO v_ver_num FROM dual;
        IF (isCompatibleXMLSchema(v_ver_num) = FALSE) THEN
          DBMS_OUTPUT.PUT_LINE('Add failed: '||'User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME||' Workflow = '||v_WORKFLOW_NAME||' Error: Incompatible version: '||v_ver_num);
        ELSE
          BEGIN
            SELECT PROJECT_ID INTO v_projectId FROM ODMRSYS.ODMR$PROJECTS p WHERE p.USER_NAME=v_USER_NAME AND p.PROJECT_NAME=v_PROJECT_NAME;
          EXCEPTION WHEN NO_DATA_FOUND THEN
            v_projectId := ODMRSYS.ODMR$PROJECT_ID_SEQ.nextval;
            INSERT INTO ODMRSYS.ODMR$PROJECTS VALUES (v_USER_NAME, v_projectId, v_PROJECT_NAME, v_PJ_CREATION_TIME, v_PJ_LAST_UPDATED_TIME, v_PJ_COMMENTS);
            DBMS_OUTPUT.PUT_LINE('Add User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME);        
          END;
          v_workflowId := ODMRSYS.ODMR$WORKFLOW_ID_SEQ.nextval;
          SELECT updateXML(v_WORKFLOW_DATA, '/WorkflowProcess/@Version', v_wf_version, 'xmlns="http://xmlns.oracle.com/odmr11"') INTO v_WORKFLOW_DATA FROM dual;
          INSERT INTO ODMRSYS.ODMR$WORKFLOWS(WORKFLOW_ID,WORKFLOW_NAME,WORKFLOW_DATA, CHAIN_NAME, RUN_MODE, STATUS, CREATION_TIME, LAST_UPDATED_TIME, COMMENTS, PROJECT_ID) 
                                     VALUES (v_workflowId, v_WORKFLOW_NAME, v_WORKFLOW_DATA, v_CHAIN_NAME, v_RUN_MODE, v_STATUS, v_WF_CREATION_TIME, v_WF_LAST_UPDATED_TIME, v_WF_COMMENTS, v_projectId);
          DBMS_OUTPUT.PUT_LINE('Add User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME||' Workflow = '||v_WORKFLOW_NAME);
          countWorkflowsAdded := countWorkflowsAdded + 1;
        END IF;
      EXCEPTION WHEN OTHERS THEN
        v_err_msg := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000);
        DBMS_OUTPUT.PUT_LINE('Add failed: '||'User = '||v_USER_NAME||' Project = '||v_PROJECT_NAME||' Workflow = '||v_WORKFLOW_NAME||' Error: '||v_err_msg);
      END;
    END LOOP;
    CLOSE v_cur;
  END IF;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE
   ('Total Number of Workflows added: ' || countWorkflowsAdded );  
  DBMS_OUTPUT.PUT_LINE
   ('Total Number of Workflows updated: ' || countWorkflowsUpdated );
EXCEPTION 
  WHEN WF_TABLE_NO_LOCK THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Workflow restore failed due to active sessions. Please close all active sessions before restore.');
    RAISE_APPLICATION_ERROR(-20000, 'Workflow restore failed due to active sessions. Please close all active sessions before restore.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Workflow restore failed: '||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000));
    RAISE_APPLICATION_ERROR(-20000, 'Workflow restore failed.'||SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000));  
END;
/

EXECUTE DBMS_OUTPUT.PUT_LINE('End Restore Data Miner Workflows');
