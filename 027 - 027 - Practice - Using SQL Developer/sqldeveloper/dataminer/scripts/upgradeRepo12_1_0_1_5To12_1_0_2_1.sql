ALTER session set current_schema = "ODMRSYS";

@@version.sql

DEFINE OLD_REPOSITORY_VERSION = '12.1.0.1.5'
DEFINE NEW_REPOSITORY_VERSION = '12.1.0.2.1'

EXECUTE dbms_output.put_line('Start repository upgrade from ' || '&OLD_REPOSITORY_VERSION' || ' to ' || '&NEW_REPOSITORY_VERSION' || '. ' || systimestamp);
    
DECLARE
  REPOS_VERSION VARCHAR2(30);
  DB_VER VARCHAR2(30);
BEGIN
  SELECT PROPERTY_STR_VALUE INTO REPOS_VERSION FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'VERSION';
  SELECT VERSION INTO DB_VER FROM PRODUCT_COMPONENT_VERSION WHERE PRODUCT LIKE 'Oracle Database%' OR PRODUCT LIKE 'Personal Oracle Database %';
  IF ( repos_version = '&OLD_REPOSITORY_VERSION' ) THEN
    BEGIN
      DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.JSONQUERY_PROG', TRUE);
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    DBMS_SCHEDULER.CREATE_PROGRAM (
      program_name        => 'ODMRSYS.JSONQUERY_PROG',
      program_type        => 'STORED_PROCEDURE',
      program_action      => 'ODMR_ENGINE_TRANSFORMS.JSONQUERY_PROG',
      number_of_arguments => 2,
      enabled             => FALSE,
      comments            => 'JSON Query Program');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.JSONQUERY_PROG',
      metadata_attribute => 'job_name',
      argument_position  => 1,
      argument_name      => 'p_job_name');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.JSONQUERY_PROG',
      metadata_attribute => 'job_subname',
      argument_position  => 2,
      argument_name      => 'p_chain_step');
    DBMS_SCHEDULER.ENABLE('ODMRSYS.JSONQUERY_PROG');

    -- obsolete this view
    BEGIN
      EXECUTE IMMEDIATE 'drop VIEW ODMRSYS.ODMR_ALL_WORKFLOW_MODELS';
      EXCEPTION
      WHEN OTHERS THEN
        NULL;
        --DBMS_OUTPUT.PUT_LINE ('View ODMR_ALL_WORKFLOW_MODELS does not exist' );
    END;

    -- create a RUN_NODES column to store nodes that determine how the workflow should be rerun
    EXECUTE IMMEDIATE 'ALTER TABLE "ODMRSYS"."ODMR$WORKFLOWS" ADD(RUN_NODES ODMRSYS.ODMR_OBJECT_NAMES)
      NESTED TABLE RUN_NODES STORE AS ODMR_RUN_NODES_TAB';

    -- recreate the view due to STATUS change
    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_PROJECT_WORKFLOW AS SELECT * FROM
    (
      WITH WF_JOBS AS
      (
      SELECT WORKFLOW_ID, WORKFLOW_JOB_ID, CREATION_TIME
        FROM (
          SELECT t.*, row_number () OVER (partition by WORKFLOW_ID ORDER BY CREATION_TIME DESC) rid
          FROM ODMRSYS.ODMR$WORKFLOW_JOBS t )
        WHERE rid = 1
      ),
      CHAIN_JOBS AS
      (
      SELECT JOB_NAME, STATE FROM ALL_SCHEDULER_JOBS WHERE JOB_TYPE = ''CHAIN''
      )
      SELECT
          ODMR$PROJECTS.USER_NAME,
          ODMR$PROJECTS.PROJECT_ID,
          ODMR$PROJECTS.PROJECT_NAME,
          ODMR$PROJECTS.CREATION_TIME PJ_CREATION_TIME,
          ODMR$PROJECTS.LAST_UPDATED_TIME PJ_LAST_UPDATED_TIME,
          ODMR$PROJECTS.COMMENTS PJ_COMMENTS,
          ODMR$WORKFLOWS.WORKFLOW_ID,
          ODMR$WORKFLOWS.WORKFLOW_NAME,
          ODMR$WORKFLOWS.WORKFLOW_DATA,
          ODMR$WORKFLOWS.CHAIN_NAME,
          ODMR$WORKFLOWS.CREATION_TIME WF_CREATION_TIME,
          ODMR$WORKFLOWS.LAST_UPDATED_TIME WF_LAST_UPDATED_TIME,
          ODMR$WORKFLOWS.COMMENTS WF_COMMENTS,
          CASE UPPER(NVL(CHAIN_JOBS.STATE, ''completed''))
            WHEN ''DISABLED'' THEN ''FAILED''
            WHEN ''SCHEDULED'' THEN ''SCHEDULED''
            WHEN ''RUNNING'' THEN ''ACTIVE''
            WHEN ''COMPLETED'' THEN ''INACTIVE''
            WHEN ''STOPPED'' THEN ''STOPPED''
            WHEN ''BROKEN'' THEN ''FAILED''
            WHEN ''RETRY SCHEDULED'' THEN ''SCHEDULED''
            WHEN ''SUCCEEDED'' THEN ''INACTIVE''
            WHEN ''CHAIN_STALLED'' THEN ''FAILED''
            ELSE CHAIN_JOBS.STATE END "STATUS"
      FROM
          WF_JOBS,
          ODMRSYS.ODMR$WORKFLOWS,
          ODMRSYS.ODMR$PROJECTS,
          CHAIN_JOBS
      WHERE
          ODMR$PROJECTS.PROJECT_ID = ODMR$WORKFLOWS.PROJECT_ID (+)
          AND ODMR$WORKFLOWS.WORKFLOW_ID = WF_JOBS.WORKFLOW_ID (+)
          AND WF_JOBS.WORKFLOW_JOB_ID = CHAIN_JOBS.JOB_NAME (+)
    )';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_USER_PROJECT_WORKFLOW AS SELECT * FROM
    (
      SELECT
          PROJECT_ID,
          PROJECT_NAME,
          PJ_CREATION_TIME,
          PJ_LAST_UPDATED_TIME,
          PJ_COMMENTS,
          WORKFLOW_ID,
          WORKFLOW_NAME,
          WORKFLOW_DATA,
          CHAIN_NAME,
          WF_CREATION_TIME,
          WF_LAST_UPDATED_TIME,
          WF_COMMENTS,
          "STATUS"
      FROM
          ODMRSYS.ODMR_ALL_PROJECT_WORKFLOW
      WHERE
          ODMR_ALL_PROJECT_WORKFLOW.USER_NAME = SYS_CONTEXT(''USERENV'', ''CURRENT_USER'')
    )';
    
    /*
        Mapping (Scheduler to ODM'r)
        disabled          FAILED
        scheduled         SCHEDULED
        running           ACTIVE
        completed         INACTIVE
        stopped           STOPPED
        broken            FAILED
        retry scheduled   SCHEDULED
        succeeded         INACTIVE
        chain_stalled     FAILED
    */
    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_WORKFLOW_JOBS AS SELECT * FROM
    (
      WITH WF_JOBS AS
      (
      SELECT WORKFLOW_ID, WORKFLOW_JOB_ID, CREATION_TIME FROM ODMRSYS.ODMR$WORKFLOW_JOBS
      ),
      CHAIN_JOBS AS
      (
      SELECT JOB_NAME, STATE FROM ALL_SCHEDULER_JOBS WHERE JOB_TYPE = ''CHAIN''
      )
      SELECT
          ODMR$PROJECTS.USER_NAME,
          ODMR$PROJECTS.PROJECT_ID,
          ODMR$PROJECTS.PROJECT_NAME,
          ODMR$WORKFLOWS.WORKFLOW_NAME,
          ODMR$WORKFLOWS.CHAIN_NAME "WORKFLOW_CHAIN_NAME",
          WF_JOBS.WORKFLOW_ID,
          WF_JOBS.WORKFLOW_JOB_ID "WORKFLOW_JOB_NAME",
          WF_JOBS.CREATION_TIME "JOB_CREATION_TIME",
          CASE UPPER(NVL(CHAIN_JOBS.STATE, ''completed''))
            WHEN ''DISABLED'' THEN ''FAILED''
            WHEN ''SCHEDULED'' THEN ''SCHEDULED''
            WHEN ''RUNNING'' THEN ''ACTIVE''
            WHEN ''COMPLETED'' THEN ''INACTIVE''
            WHEN ''STOPPED'' THEN ''STOPPED''
            WHEN ''BROKEN'' THEN ''FAILED''
            WHEN ''RETRY SCHEDULED'' THEN ''SCHEDULED''
            WHEN ''SUCCEEDED'' THEN ''INACTIVE''
            WHEN ''CHAIN_STALLED'' THEN ''FAILED''
            ELSE CHAIN_JOBS.STATE END "WORKFLOW_STATUS"
      FROM
          WF_JOBS,
          ODMRSYS.ODMR$WORKFLOWS,
          ODMRSYS.ODMR$PROJECTS,
          CHAIN_JOBS
      WHERE
          ODMR$PROJECTS.PROJECT_ID = ODMR$WORKFLOWS.PROJECT_ID (+)
          AND ODMR$WORKFLOWS.WORKFLOW_ID = WF_JOBS.WORKFLOW_ID (+)
          AND WF_JOBS.WORKFLOW_JOB_ID = CHAIN_JOBS.JOB_NAME (+)
    )';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_USER_WORKFLOW_JOBS AS SELECT * FROM
    (
      SELECT
          PROJECT_ID,
          PROJECT_NAME,
          WORKFLOW_NAME,
          WORKFLOW_CHAIN_NAME,
          WORKFLOW_ID,
          WORKFLOW_JOB_NAME,
          JOB_CREATION_TIME,
          WORKFLOW_STATUS
      FROM
          ODMRSYS.ODMR_ALL_WORKFLOW_JOBS
      WHERE
          ODMR_ALL_WORKFLOW_JOBS.USER_NAME = SYS_CONTEXT(''USERENV'', ''CURRENT_USER'')
    )';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_WORKFLOW_LOG AS SELECT 
        LOG_ID,
        USER_NAME,
        JOB_NAME,
        PROJ_NAME,
        PROJ_ID,
        WF_NAME,
        WF_ID,
        NODE_ID,
        NODE_NAME,
        SUBNODE_NAME,
        SUBNODE_ID,
        LOG_TIMESTAMP,
        LOG_DURATION,
        LOG_TYPE,
        LOG_SUBTYPE,
        LOG_TASK,
        LOG_MESSAGE,
        LOG_MESSAGE_DETAILS
    FROM 
        ODMRSYS.ODMR$WF_LOG';
    
    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_USER_WORKFLOW_LOG AS SELECT 
        LOG_ID,
        JOB_NAME,
        PROJ_NAME,
        PROJ_ID,
        WF_NAME,
        WF_ID,
        NODE_ID,
        NODE_NAME,
        SUBNODE_NAME,
        SUBNODE_ID,
        LOG_TIMESTAMP,
        LOG_DURATION,
        LOG_TYPE,
        LOG_SUBTYPE,
        LOG_TASK,
        LOG_MESSAGE,
        LOG_MESSAGE_DETAILS
    FROM 
        ODMRSYS.ODMR_ALL_WORKFLOW_LOG
    WHERE
        ODMR_ALL_WORKFLOW_LOG.USER_NAME = SYS_CONTEXT(''USERENV'', ''CURRENT_USER'')';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_WORKFLOW_RUNNING AS SELECT "USER_NAME", "PROJECT_ID", "WORKFLOW_ID","WF_JOB_NAME","LOG_DATE","LOG_ID","NODE_ID","SUBNODE_ID","NODE_STATUS","SUBNODE_STATUS","NODE_START_TIME","NODE_RUN_TIME","ERROR_CODE","LOG_MESSAGE" FROM
    (
      WITH
      s AS (SELECT
            OWNER "USER_NAME",
            JOB_NAME "WF_JOB_NAME",
            NULL "LOG_DATE",
            STEP_JOB_LOG_ID "LOG_ID",
            CASE WHEN SUBSTR(STEP_NAME, 1, ((INSTR(STEP_NAME, ''$'', 1, 1)) - LENGTH(''$''))) IS NULL THEN
                   STEP_NAME
                 ELSE SUBSTR(STEP_NAME, 1, ((INSTR(STEP_NAME, ''$'', 1, 1)) - LENGTH(''$'')))
                 END "NODE_ID",
            CASE WHEN SUBSTR(STEP_NAME, 1, ((INSTR(STEP_NAME, ''$'', 1, 1)) - LENGTH(''$''))) IS NOT NULL THEN
                   SUBSTR(STEP_NAME, (INSTR(STEP_NAME, ''$'', 1, 1))+LENGTH(''$''), LENGTH(STEP_NAME) - (INSTR(STEP_NAME, ''$'', 1, 1)))
                 ELSE NULL
                 END "SUBNODE_ID",
            CASE WHEN STATE=''NOT_STARTED''  THEN ''00000001''
                 WHEN STATE=''SCHEDULED''    THEN ''00000010''
                 WHEN STATE=''RUNNING''      THEN ''00000100''
                 WHEN STATE=''PAUSED''       THEN ''00001000''
                 WHEN STATE=''SUCCEEDED''    THEN ''00010000''
                 WHEN STATE=''FAILED''       THEN ''00100000''
                 WHEN STATE=''STOPPED''      THEN ''01000000''
                 WHEN STATE=''STALLED''      THEN ''10000000''
                 END "ENCODE_STATUS",
            STATE "SUBNODE_STATUS",
            START_DATE "NODE_START_TIME",
            DURATION "NODE_RUN_TIME",
            ERROR_CODE "ERROR_CODE",
            NULL "LOG_MESSAGE"
          FROM ALL_SCHEDULER_RUNNING_CHAINS WHERE STEP_NAME IS NOT NULL),
      g AS (SELECT WF_JOB_NAME, NODE_ID, sys.mvaggrawbitor(ENCODE_STATUS) "NODE_STATUS"
            FROM s GROUP BY WF_JOB_NAME, NODE_ID)
      SELECT
        s.USER_NAME,
        w.PROJECT_ID,
        w.WORKFLOW_ID,
        s.WF_JOB_NAME,
        s.LOG_DATE,
        s.LOG_ID,
        s.NODE_ID,
        s.SUBNODE_ID,
        CASE 
          WHEN utl_raw.bit_and(g.NODE_STATUS, ''00000100'') = ''00000100'' THEN ''RUNNING''
          WHEN utl_raw.bit_or(g.NODE_STATUS, ''00010000'') = ''00010000'' THEN ''SUCCEEDED''
          WHEN utl_raw.bit_and(g.NODE_STATUS, ''00100000'') = ''00100000'' THEN ''FAILED''
          WHEN utl_raw.bit_or(g.NODE_STATUS, ''00000001'') = ''00000001'' THEN ''NOT_STARTED''
          WHEN utl_raw.bit_or(g.NODE_STATUS, ''00000010'') = ''00000010'' THEN ''SCHEDULED''
          WHEN utl_raw.bit_or(g.NODE_STATUS, ''00001000'') = ''00001000'' THEN ''PAUSED''
          WHEN utl_raw.bit_and(g.NODE_STATUS, ''01000000'') = ''01000000'' THEN ''STOPPED''
          WHEN utl_raw.bit_or(g.NODE_STATUS, ''10000000'') = ''10000000'' THEN ''STALLED''
          ELSE ''UNKNOWN'' END "NODE_STATUS",
        CASE 
          WHEN SUBNODE_ID IS NOT NULL
          THEN s.SUBNODE_STATUS
          ELSE NULL END "SUBNODE_STATUS",
        s.NODE_START_TIME,
        s.NODE_RUN_TIME,
        s.ERROR_CODE,
        s.LOG_MESSAGE
      FROM s, g, ODMRSYS.ODMR_ALL_WORKFLOW_JOBS w
      WHERE s.WF_JOB_NAME = g.WF_JOB_NAME AND s.WF_JOB_NAME = w.WORKFLOW_JOB_NAME AND s.NODE_ID = g.NODE_ID
      ORDER BY LOG_DATE
    )';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_USER_WORKFLOW_RUNNING 
      AS SELECT 
        "PROJECT_ID", 
        "WORKFLOW_ID",
        "WF_JOB_NAME",
        "LOG_DATE",
        "LOG_ID",
        "NODE_ID",
        "SUBNODE_ID",
        "NODE_STATUS",
        "SUBNODE_STATUS",
        "NODE_START_TIME",
        "NODE_RUN_TIME",
        "ERROR_CODE",
        "LOG_MESSAGE"
      FROM 
        ODMRSYS.ODMR_ALL_WORKFLOW_RUNNING
      WHERE
        ODMR_ALL_WORKFLOW_RUNNING.USER_NAME = SYS_CONTEXT(''USERENV'', ''CURRENT_USER'')';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_WORKFLOW_COMPLETE AS SELECT "USER_NAME", "PROJECT_ID", "WORKFLOW_ID","WF_JOB_NAME","LOG_DATE","LOG_ID","NODE_ID","SUBNODE_ID","NODE_STATUS","SUBNODE_STATUS","NODE_START_TIME","NODE_RUN_TIME","ERROR_CODE","LOG_MESSAGE" FROM
    (
      with
      s AS (SELECT
            OWNER "USER_NAME",
            JOB_NAME "WF_JOB_NAME",
            LOG_DATE,
            LOG_ID,
            CASE WHEN SUBSTR(job_subname, 1, ((INSTR(job_subname, ''$'', 1, 1)) - LENGTH(''$''))) IS NULL THEN
                   job_subname
                 ELSE SUBSTR(job_subname, 1, ((INSTR(job_subname, ''$'', 1, 1)) - LENGTH(''$'')))
                 END "NODE_ID",
            CASE WHEN SUBSTR(job_subname, 1, ((INSTR(job_subname, ''$'', 1, 1)) - LENGTH(''$''))) IS NOT NULL THEN
                   SUBSTR(job_subname, (INSTR(job_subname, ''$'', 1, 1))+LENGTH(''$''), LENGTH(job_subname) - (INSTR(job_subname, ''$'', 1, 1)))
                 ELSE NULL
                 END "SUBNODE_ID",
            CASE WHEN status=''NOT_STARTED''  THEN ''00000001''
                 WHEN status=''SCHEDULED''    THEN ''00000010''
                 WHEN status=''RUNNING''      THEN ''00000100''
                 WHEN status=''PAUSED''       THEN ''00001000''
                 WHEN status=''SUCCEEDED''    THEN ''00010000''
                 WHEN status=''FAILED''       THEN ''00100000''
                 WHEN status=''STOPPED''      THEN ''01000000''
                 WHEN status=''STALLED''      THEN ''10000000''
                 END "ENCODE_STATUS",
            STATUS "SUBNODE_STATUS",
            ACTUAL_START_DATE "NODE_START_TIME",
            RUN_DURATION "NODE_RUN_TIME",
            ERROR# "ERROR_CODE",
            CASE WHEN (INSTR(additional_info, '','', 1, 2)) > 0
                 THEN LTRIM(SUBSTR(additional_info, (INSTR(additional_info, '','', 1, 2))+LENGTH('',''), LENGTH(additional_info) - (INSTR(additional_info, '','', 1, 2))), '' '')
                 ELSE NULL
                 END "LOG_MESSAGE"
          FROM ALL_SCHEDULER_JOB_RUN_DETAILS WHERE job_subname IS NOT NULL),
      g AS (SELECT WF_JOB_NAME, NODE_ID, sys.mvaggrawbitor(ENCODE_STATUS) "NODE_STATUS"
            FROM s GROUP BY WF_JOB_NAME, NODE_ID)
      SELECT
        s.USER_NAME,
        w.PROJECT_ID,
        w.WORKFLOW_ID,
        s.WF_JOB_NAME,
        s.LOG_DATE,
        s.LOG_ID,
        s.NODE_ID,
        s.SUBNODE_ID,
        CASE 
          WHEN utl_raw.bit_and(g.NODE_STATUS, ''00000100'') = ''00000100'' THEN ''RUNNING''
          WHEN utl_raw.bit_or(g.NODE_STATUS, ''00010000'') = ''00010000'' THEN ''SUCCEEDED''
          WHEN utl_raw.bit_and(g.NODE_STATUS, ''00100000'') = ''00100000'' THEN ''FAILED''
          WHEN utl_raw.bit_or(g.NODE_STATUS, ''00000001'') = ''00000001'' THEN ''NOT_STARTED''
          WHEN utl_raw.bit_or(g.NODE_STATUS, ''00000010'') = ''00000010'' THEN ''SCHEDULED''
          WHEN utl_raw.bit_or(g.NODE_STATUS, ''00001000'') = ''00001000'' THEN ''PAUSED''
          WHEN utl_raw.bit_and(g.NODE_STATUS, ''01000000'') = ''01000000'' THEN ''STOPPED''
          WHEN utl_raw.bit_or(g.NODE_STATUS, ''10000000'') = ''10000000'' THEN ''STALLED''
          ELSE ''UNKNOWN'' END "NODE_STATUS",
        CASE 
          WHEN SUBNODE_ID IS NOT NULL
          THEN s.SUBNODE_STATUS
          ELSE NULL END "SUBNODE_STATUS",
        s.NODE_START_TIME,
        s.NODE_RUN_TIME,
        s.ERROR_CODE,
        s.LOG_MESSAGE
      FROM s, g, ODMRSYS.ODMR_ALL_WORKFLOW_JOBS w
      WHERE s.WF_JOB_NAME = g.WF_JOB_NAME AND s.WF_JOB_NAME = w.WORKFLOW_JOB_NAME AND s.NODE_ID = g.NODE_ID
      ORDER BY LOG_DATE
    )';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_USER_WORKFLOW_COMPLETE 
      AS SELECT
        "PROJECT_ID", 
        "WORKFLOW_ID",
        "WF_JOB_NAME",
        "LOG_DATE",
        "LOG_ID",
        "NODE_ID",
        "SUBNODE_ID",
        "NODE_STATUS",
        "SUBNODE_STATUS",
        "NODE_START_TIME",
        "NODE_RUN_TIME",
        "ERROR_CODE",
        "LOG_MESSAGE"
      FROM
        ODMRSYS.ODMR_ALL_WORKFLOW_COMPLETE
      WHERE
        ODMR_ALL_WORKFLOW_COMPLETE.USER_NAME = SYS_CONTEXT(''USERENV'', ''CURRENT_USER'')';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_WORKFLOW_ALL AS (
      SELECT "USER_NAME","PROJECT_ID","WORKFLOW_ID","WF_JOB_NAME","LOG_DATE","LOG_ID","NODE_ID","SUBNODE_ID","NODE_STATUS","SUBNODE_STATUS","NODE_START_TIME","NODE_RUN_TIME","ERROR_CODE","LOG_MESSAGE" FROM ODMRSYS.ODMR_ALL_WORKFLOW_RUNNING r
      UNION
      SELECT "USER_NAME","PROJECT_ID","WORKFLOW_ID","WF_JOB_NAME","LOG_DATE","LOG_ID","NODE_ID","SUBNODE_ID","NODE_STATUS","SUBNODE_STATUS","NODE_START_TIME","NODE_RUN_TIME","ERROR_CODE","LOG_MESSAGE" FROM ODMRSYS.ODMR_ALL_WORKFLOW_COMPLETE c WHERE c."WF_JOB_NAME"||c."NODE_ID"||c."SUBNODE_ID" NOT IN (SELECT n."WF_JOB_NAME"||n."NODE_ID"||n."SUBNODE_ID" FROM ODMRSYS.ODMR_ALL_WORKFLOW_RUNNING n)
    )';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_USER_WORKFLOW_ALL 
      AS SELECT
        "PROJECT_ID",
        "WORKFLOW_ID",
        "WF_JOB_NAME",
        "LOG_DATE",
        "LOG_ID",
        "NODE_ID",
        "SUBNODE_ID",
        "NODE_STATUS",
        "SUBNODE_STATUS",
        "NODE_START_TIME",
        "NODE_RUN_TIME",
        "ERROR_CODE",
        "LOG_MESSAGE"
      FROM
        ODMRSYS.ODMR_ALL_WORKFLOW_ALL
      WHERE
        ODMR_ALL_WORKFLOW_ALL.USER_NAME = SYS_CONTEXT(''USERENV'', ''CURRENT_USER'')';
        
    IF (DB_VER >= '11.2.0.4' ) THEN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_WORKFLOW_NODES
        AS
          SELECT P.USER_NAME, P.PROJECT_ID, P.PROJECT_NAME, X.WORKFLOW_NAME, X.WORKFLOW_ID, NODE_TYPE, NODE_ID, NODE_NAME, NODE_STATUS
          FROM ODMRSYS.ODMR$WORKFLOWS X, ODMRSYS.ODMR$PROJECTS P,
               XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                        ''/WorkflowProcess/Nodes/*''
                        PASSING X.WORKFLOW_DATA
                        COLUMNS NODE_TYPE  VARCHAR2(30) PATH ''name()'',
                                NODE_ID    NUMBER  PATH ''@Id'',
                                NODE_NAME  VARCHAR2(30)  PATH ''@Name'',
                                NODE_STATUS VARCHAR2(10)  PATH ''@Status'')
          WHERE
            P.PROJECT_ID = X.PROJECT_ID (+)';
            
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_USER_WORKFLOW_NODES
        AS SELECT 
          PROJECT_ID, 
          PROJECT_NAME, 
          WORKFLOW_NAME, 
          WORKFLOW_ID, 
          NODE_TYPE, 
          NODE_ID, 
          NODE_NAME, 
          NODE_STATUS
        FROM 
          ODMRSYS.ODMR_ALL_WORKFLOW_NODES
        WHERE
          ODMR_ALL_WORKFLOW_NODES.USER_NAME = SYS_CONTEXT(''USERENV'', ''CURRENT_USER'')';  
      EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_USER_WORKFLOW_NODES FOR ODMRSYS.ODMR_USER_WORKFLOW_NODES';
      
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_WF_CLAS_TEST_RESULTS
        AS SELECT * FROM (
        WITH "N$10001" AS (
          SELECT 
          P.USER_NAME, P.PROJECT_ID, P.PROJECT_NAME, X.WORKFLOW_ID, X.WORKFLOW_NAME,
          NODE_TYPE, NODE_ID, NODE_NAME, NODE_STATUS,
          MODEL_ID, MODEL_NAME, MODEL_STATUS, RESULT_CREATIONDATE, TEST_METRICS, CONFUSION_MATRIX,
          RESULT_TYPE, RESULT_NAME, ROC_AREA, TARGET_VALUE
            FROM ODMRSYS.ODMR$WORKFLOWS X, ODMRSYS.ODMR$PROJECTS P,
                 XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                          ''/WorkflowProcess/Nodes/*''
                          PASSING X.WORKFLOW_DATA
                          COLUMNS NODE_TYPE  VARCHAR2(30) PATH ''name()'',
                                  NODE_ID    NUMBER  PATH ''@Id'',
                                  NODE_NAME  VARCHAR2(30)  PATH ''@Name'',
                                  NODE_STATUS VARCHAR2(10)  PATH ''@Status'',
                                  RESULTS XMLTYPE PATH ''Results/ClassificationResult'') XTAB,
                 XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                          ''/ClassificationResult''
                          PASSING XTAB.RESULTS
                          COLUMNS MODEL_ID    NUMBER  PATH ''@ModelId'',
                                  MODEL_NAME  VARCHAR2(30)  PATH ''@Name'',
                                  MODEL_STATUS VARCHAR2(10)  PATH ''@Status'',
                                  RESULT_CREATIONDATE VARCHAR2(30)  PATH ''@CreationDate'',
                                  TEST_METRICS VARCHAR2(30)  PATH ''TestMetrics/@Name'',
                                  CONFUSION_MATRIX VARCHAR2(30)  PATH ''ConfusionMatrix/@Name'',
                                  RESULTS XMLTYPE PATH ''*'') XTAB2,
                 XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                          ''/*/*''
                          PASSING XTAB2.RESULTS
                          COLUMNS RESULT_TYPE  VARCHAR2(30) PATH ''name()'',
                                  RESULT_NAME  VARCHAR2(30)  PATH ''@Name'',
                                  ROC_AREA        NUMBER  PATH ''@Area'',
                                  TARGET_VALUE VARCHAR2(10)  PATH ''@TargetValue'')
          WHERE
            P.PROJECT_ID = X.PROJECT_ID (+)
        ),
        "N$10002" AS (
          SELECT DISTINCT
          USER_NAME, PROJECT_ID, PROJECT_NAME, WORKFLOW_ID, WORKFLOW_NAME,
          NODE_TYPE, NODE_ID, NODE_NAME, NODE_STATUS,
          MODEL_ID, MODEL_NAME, MODEL_STATUS, RESULT_CREATIONDATE, TEST_METRICS, CONFUSION_MATRIX
          FROM "N$10001"
        ),
        "N$10003" AS (
        SELECT WORKFLOW_ID, NODE_ID, MODEL_ID,
            CAST(COLLECT(DM_NESTED_CATEGORICAL(ID1, RESULT_STATS)) AS DM_NESTED_CATEGORICALS) LIFTS
            FROM
                (SELECT WORKFLOW_ID, NODE_ID, MODEL_ID, RESULT_TYPE,
                (TARGET_VALUE) ID1,
                STATS_MODE(RESULT_NAME) RESULT_STATS
                FROM "N$10001"  
                GROUP BY WORKFLOW_ID, NODE_ID , MODEL_ID, RESULT_TYPE, TARGET_VALUE HAVING RESULT_TYPE=''Lift'')
             GROUP BY WORKFLOW_ID, NODE_ID, MODEL_ID, RESULT_TYPE
        ),
        "N$10004" AS (
        SELECT WORKFLOW_ID, NODE_ID, MODEL_ID,
            CAST(COLLECT(DM_NESTED_CATEGORICAL(ID1, RESULT_STATS)) AS DM_NESTED_CATEGORICALS) ROCS
            FROM
                (SELECT WORKFLOW_ID, NODE_ID, MODEL_ID, RESULT_TYPE,
                (TARGET_VALUE) ID1,
                STATS_MODE(RESULT_NAME) RESULT_STATS
                FROM "N$10001"  
                GROUP BY WORKFLOW_ID, NODE_ID , MODEL_ID, RESULT_TYPE, TARGET_VALUE HAVING RESULT_TYPE=''ROC'')
             GROUP BY WORKFLOW_ID, NODE_ID, MODEL_ID, RESULT_TYPE
        ),
        "N$10005" AS (
        SELECT WORKFLOW_ID, NODE_ID, MODEL_ID,
            CAST(COLLECT(DM_NESTED_NUMERICAL(ID1, RESULT_STATS)) AS DM_NESTED_NUMERICALS) ROC_AREA
            FROM
                (SELECT WORKFLOW_ID, NODE_ID, MODEL_ID, RESULT_TYPE,
                (TARGET_VALUE) ID1,
                MAX(ROC_AREA) RESULT_STATS
                FROM "N$10001"  
                GROUP BY WORKFLOW_ID, NODE_ID , MODEL_ID, RESULT_TYPE, TARGET_VALUE HAVING RESULT_TYPE=''AreaUnderCurve'')
             GROUP BY WORKFLOW_ID, NODE_ID, MODEL_ID, RESULT_TYPE
        )
        SELECT
          A.USER_NAME, A.PROJECT_ID, A.PROJECT_NAME, A.WORKFLOW_ID, A.WORKFLOW_NAME,
          A.NODE_TYPE, A.NODE_ID, A.NODE_NAME, A.NODE_STATUS,
          A.MODEL_ID, A.MODEL_NAME, A.MODEL_STATUS, A.RESULT_CREATIONDATE, 
          A.TEST_METRICS, A.CONFUSION_MATRIX,
          B.LIFTS, C.ROCS, D.ROC_AREA
        FROM
          "N$10002" A, "N$10003" B, "N$10004" C, "N$10005" D
        WHERE A.WORKFLOW_ID = B.WORKFLOW_ID AND A.NODE_ID = B.NODE_ID AND A.MODEL_ID = B.MODEL_ID
        AND A.WORKFLOW_ID = C.WORKFLOW_ID AND A.NODE_ID = C.NODE_ID AND A.MODEL_ID = C.MODEL_ID
        AND A.WORKFLOW_ID = D.WORKFLOW_ID AND A.NODE_ID = D.NODE_ID AND A.MODEL_ID = D.MODEL_ID)';
  
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_USER_WF_CLAS_TEST_RESULTS AS SELECT
          PROJECT_ID, 
          PROJECT_NAME, 
          WORKFLOW_ID, 
          WORKFLOW_NAME,
          NODE_TYPE, 
          NODE_ID, 
          NODE_NAME, 
          NODE_STATUS,
          MODEL_ID, 
          MODEL_NAME, 
          MODEL_STATUS, 
          RESULT_CREATIONDATE, 
          TEST_METRICS, 
          CONFUSION_MATRIX,
          LIFTS, 
          ROCS, 
          ROC_AREA
        FROM
          ODMRSYS.ODMR_ALL_WF_CLAS_TEST_RESULTS
        WHERE 
          ODMR_ALL_WF_CLAS_TEST_RESULTS.USER_NAME = SYS_CONTEXT(''USERENV'', ''CURRENT_USER'')';
      EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_USER_WF_CLAS_TEST_RESULTS FOR ODMRSYS.ODMR_USER_WF_CLAS_TEST_RESULTS';
      
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_WF_REGR_TEST_RESULTS
        AS SELECT 
          P.USER_NAME, P.PROJECT_ID, P.PROJECT_NAME, X.WORKFLOW_ID, X.WORKFLOW_NAME,
          NODE_TYPE, NODE_ID, NODE_NAME, NODE_STATUS,
          MODEL_ID, MODEL_NAME, MODEL_STATUS, RESULT_CREATIONDATE, TEST_METRICS, RESIDUAL_PLOT
            FROM ODMRSYS.ODMR$WORKFLOWS X, ODMRSYS.ODMR$PROJECTS P,
                 XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                          ''/WorkflowProcess/Nodes/*''
                          PASSING X.WORKFLOW_DATA
                          COLUMNS NODE_TYPE  VARCHAR2(30) PATH ''name()'',
                                  NODE_ID    NUMBER  PATH ''@Id'',
                                  NODE_NAME  VARCHAR2(30)  PATH ''@Name'',
                                  NODE_STATUS VARCHAR2(10)  PATH ''@Status'',
                                  RESULTS XMLTYPE PATH ''Results/RegressionResult'') XTAB,
                 XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                          ''/RegressionResult''
                          PASSING XTAB.RESULTS
                          COLUMNS MODEL_ID    NUMBER  PATH ''@ModelId'',
                                  MODEL_NAME  VARCHAR2(30)  PATH ''@Name'',
                                  MODEL_STATUS VARCHAR2(10)  PATH ''@Status'',
                                  RESULT_CREATIONDATE VARCHAR2(30)  PATH ''@CreationDate'',
                                  TEST_METRICS VARCHAR2(30)  PATH ''TestMetrics/@Name'',
                                  RESIDUAL_PLOT VARCHAR2(30)  PATH ''ResidualPlot/@Name'') XTAB2
          WHERE
            P.PROJECT_ID = X.PROJECT_ID (+)';
  
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_USER_WF_REGR_TEST_RESULTS
        AS SELECT 
          USER_NAME, 
          PROJECT_ID, 
          PROJECT_NAME, 
          WORKFLOW_ID, 
          WORKFLOW_NAME,
          NODE_TYPE, 
          NODE_ID, 
          NODE_NAME, 
          NODE_STATUS,
          MODEL_ID, 
          MODEL_NAME, 
          MODEL_STATUS, 
          RESULT_CREATIONDATE, 
          TEST_METRICS, 
          RESIDUAL_PLOT
        FROM 
          ODMRSYS.ODMR_ALL_WF_REGR_TEST_RESULTS
        WHERE 
          ODMR_ALL_WF_REGR_TEST_RESULTS.USER_NAME = SYS_CONTEXT(''USERENV'', ''CURRENT_USER'')';
      EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_USER_WF_REGR_TEST_RESULTS FOR ODMRSYS.ODMR_USER_WF_REGR_TEST_RESULTS';
      
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_WF_TEST_RESULTS
        AS SELECT 
          USER_NAME, PROJECT_ID, PROJECT_NAME, WORKFLOW_ID, WORKFLOW_NAME,
          NODE_TYPE, NODE_ID, NODE_NAME, NODE_STATUS,
          MODEL_ID, MODEL_NAME, MODEL_STATUS, RESULT_CREATIONDATE, 
          TEST_METRICS, CONFUSION_MATRIX,
          LIFTS, ROCS, ROC_AREA, NULL "RESIDUAL_PLOT"
        FROM
          ODMRSYS.ODMR_ALL_WF_CLAS_TEST_RESULTS
        UNION ALL
        SELECT 
          USER_NAME, PROJECT_ID, PROJECT_NAME, WORKFLOW_ID, WORKFLOW_NAME,
          NODE_TYPE, NODE_ID, NODE_NAME, NODE_STATUS,
          MODEL_ID, MODEL_NAME, MODEL_STATUS, RESULT_CREATIONDATE,
          TEST_METRICS, NULL "CONFUSION_MATRIX",
          NULL "LIFTS", NULL "ROCS", NULL "ROC_AREA", RESIDUAL_PLOT
        FROM
          ODMRSYS.ODMR_ALL_WF_REGR_TEST_RESULTS';
          
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_USER_WF_TEST_RESULTS
        AS SELECT 
          PROJECT_ID, PROJECT_NAME, WORKFLOW_ID, WORKFLOW_NAME,
          NODE_TYPE, NODE_ID, NODE_NAME, NODE_STATUS,
          MODEL_ID, MODEL_NAME, MODEL_STATUS, RESULT_CREATIONDATE, 
          TEST_METRICS, CONFUSION_MATRIX,
          LIFTS, ROCS, ROC_AREA, NULL "RESIDUAL_PLOT"
        FROM
          ODMRSYS.ODMR_USER_WF_CLAS_TEST_RESULTS
        UNION ALL
        SELECT 
          PROJECT_ID, PROJECT_NAME, WORKFLOW_ID, WORKFLOW_NAME,
          NODE_TYPE, NODE_ID, NODE_NAME, NODE_STATUS,
          MODEL_ID, MODEL_NAME, MODEL_STATUS, RESULT_CREATIONDATE,
          TEST_METRICS, NULL "CONFUSION_MATRIX",
          NULL "LIFTS", NULL "ROCS", NULL "ROC_AREA", RESIDUAL_PLOT
        FROM
          ODMRSYS.ODMR_USER_WF_REGR_TEST_RESULTS';
      EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_USER_WF_TEST_RESULTS FOR ODMRSYS.ODMR_USER_WF_TEST_RESULTS';
      
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_WORKFLOW_MODELS
        AS SELECT 
          P.USER_NAME, P.PROJECT_ID, P.PROJECT_NAME, X.WORKFLOW_ID, X.WORKFLOW_NAME,
          NODE_TYPE, NODE_ID, NODE_NAME, NODE_STATUS,
          MODEL_TYPE, MODEL_ID, MODEL_NAME, MODEL_STATUS, MODEL_CREATIONDATE
            FROM ODMRSYS.ODMR$WORKFLOWS X, ODMRSYS.ODMR$PROJECTS P,
                 XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                          ''/WorkflowProcess/Nodes/*''
                          PASSING X.WORKFLOW_DATA
                          COLUMNS NODE_TYPE  VARCHAR2(30) PATH ''name()'',
                                  NODE_ID    NUMBER  PATH ''@Id'',
                                  NODE_NAME  VARCHAR2(30)  PATH ''@Name'',
                                  NODE_STATUS VARCHAR2(10)  PATH ''@Status'',
                                  MODELDETAILS XMLTYPE PATH ''Models/*''),
                 XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                          ''/*''
                          PASSING MODELDETAILS
                          COLUMNS MODEL_TYPE  VARCHAR2(30)  PATH ''name()'',
                                  MODEL_ID    NUMBER  PATH ''@Id'',
                                  MODEL_NAME  VARCHAR2(30)  PATH ''@Name'',
                                  MODEL_STATUS VARCHAR2(10)  PATH ''@Status'',
                                  MODEL_CREATIONDATE VARCHAR2(30)  PATH ''@CreationDate'')
          WHERE
            P.PROJECT_ID = X.PROJECT_ID (+)';
            
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_USER_WORKFLOW_MODELS
        AS SELECT 
          PROJECT_ID, 
          PROJECT_NAME, 
          WORKFLOW_ID, 
          WORKFLOW_NAME,
          NODE_TYPE, 
          NODE_ID, 
          NODE_NAME, 
          NODE_STATUS,
          MODEL_TYPE, 
          MODEL_ID, 
          MODEL_NAME, 
          MODEL_STATUS, 
          MODEL_CREATIONDATE
        FROM
          ODMRSYS.ODMR_ALL_WORKFLOW_MODELS
        WHERE
          ODMR_ALL_WORKFLOW_MODELS.USER_NAME = SYS_CONTEXT(''USERENV'', ''CURRENT_USER'')';
      EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_USER_WORKFLOW_MODELS FOR ODMRSYS.ODMR_USER_WORKFLOW_MODELS';

      IF (DB_VER >= '12.1.0.2' ) THEN
        EXECUTE IMMEDIATE 'GRANT READ ON ODMR_USER_WORKFLOW_NODES TO ODMRUSER';
        EXECUTE IMMEDIATE 'GRANT READ ON ODMR_USER_WF_CLAS_TEST_RESULTS TO ODMRUSER';
        EXECUTE IMMEDIATE 'GRANT READ ON ODMR_USER_WF_REGR_TEST_RESULTS TO ODMRUSER';
        EXECUTE IMMEDIATE 'GRANT READ ON ODMR_USER_WF_TEST_RESULTS TO ODMRUSER';
        EXECUTE IMMEDIATE 'GRANT READ ON ODMR_USER_WORKFLOW_MODELS TO ODMRUSER';
      ELSE
        EXECUTE IMMEDIATE 'GRANT SELECT ON ODMR_USER_WORKFLOW_NODES TO ODMRUSER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON ODMR_USER_WF_CLAS_TEST_RESULTS TO ODMRUSER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON ODMR_USER_WF_REGR_TEST_RESULTS TO ODMRUSER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON ODMR_USER_WF_TEST_RESULTS TO ODMRUSER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON ODMR_USER_WORKFLOW_MODELS TO ODMRUSER';
      END IF;
    END IF;
              
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
