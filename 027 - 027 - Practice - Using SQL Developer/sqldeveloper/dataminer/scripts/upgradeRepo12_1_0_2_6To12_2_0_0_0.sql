ALTER session set current_schema = "ODMRSYS";

@@version.sql

DEFINE OLD_REPOSITORY_VERSION = '12.1.0.2.6'
DEFINE NEW_REPOSITORY_VERSION = '12.2.0.0.0'

EXECUTE dbms_output.put_line('Start repository upgrade from ' || '&OLD_REPOSITORY_VERSION' || ' to ' || '&NEW_REPOSITORY_VERSION' || '. ' || systimestamp);


DECLARE
  REPOS_VERSION VARCHAR2(30);
  DB_VER VARCHAR2(30);
  v_id NUMBER;
  v_string_size VARCHAR2(30);
BEGIN
  SELECT PROPERTY_STR_VALUE INTO REPOS_VERSION FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'VERSION';
  SELECT VERSION INTO DB_VER FROM PRODUCT_COMPONENT_VERSION WHERE PRODUCT LIKE 'Oracle Database%' OR PRODUCT LIKE 'Personal Oracle Database %';
  IF ( repos_version = '&OLD_REPOSITORY_VERSION' ) THEN
  
    BEGIN
      DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.EFE_BUILD_PROG', TRUE);
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    
    DBMS_SCHEDULER.CREATE_PROGRAM (
      program_name        => 'ODMRSYS.EFE_BUILD_PROG',
      program_type        => 'STORED_PROCEDURE',
      program_action      => 'ODMR_ENGINE_MINING.EFE_BUILD_PROG',
      number_of_arguments => 2,
      enabled             => FALSE,
      comments            => 'Explicit Feature Extraction Build Program');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.EFE_BUILD_PROG',
      metadata_attribute => 'job_name',
      argument_position  => 1,
      argument_name      => 'p_job_name');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.EFE_BUILD_PROG',
      metadata_attribute => 'job_subname',
      argument_position  => 2,
      argument_name      => 'p_chain_step');
      
    DBMS_SCHEDULER.ENABLE('ODMRSYS.EFE_BUILD_PROG');
    
    BEGIN
      DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.FEATURECOMPARE_PROG', TRUE);
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    
    DBMS_SCHEDULER.CREATE_PROGRAM (
      program_name        => 'ODMRSYS.FEATURECOMPARE_PROG',
      program_type        => 'STORED_PROCEDURE',
      program_action      => 'ODMR_ENGINE_TRANSFORMS.FEATURECOMPARE_PROG',
      number_of_arguments => 2,
      enabled             => FALSE,
      comments            => 'Feature Compare Program');

    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.FEATURECOMPARE_PROG',
      metadata_attribute => 'job_name',
      argument_position  => 1,
      argument_name      => 'p_job_name');

    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.FEATURECOMPARE_PROG',
      metadata_attribute => 'job_subname',
      argument_position  => 2,
      argument_name      => 'p_chain_step');
      
    DBMS_SCHEDULER.ENABLE('ODMRSYS.FEATURECOMPARE_PROG');
    
    BEGIN
      DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.R_BUILD_PROG', TRUE);
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    
    DBMS_SCHEDULER.CREATE_PROGRAM (
      program_name        => 'ODMRSYS.R_BUILD_PROG',
      program_type        => 'STORED_PROCEDURE',
      program_action      => 'ODMR_ENGINE_MINING.R_BUILD_PROG',
      number_of_arguments => 2,
      enabled             => FALSE,
      comments            => 'R Build Program');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.R_BUILD_PROG',
      metadata_attribute => 'job_name',
      argument_position  => 1,
      argument_name      => 'p_job_name');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.R_BUILD_PROG',
      metadata_attribute => 'job_subname',
      argument_position  => 2,
      argument_name      => 'p_chain_step');
      
    DBMS_SCHEDULER.ENABLE('ODMRSYS.R_BUILD_PROG');
    
    EXECUTE IMMEDIATE 'INSERT INTO ODMRSYS.ODMR$REPOSITORY_PROPERTIES (PROPERTY_NAME, PROPERTY_STR_VALUE, "COMMENT") VALUES (''IN_MEMORY_ALLOWED'', ''TRUE'', ''If FALSE, the repository implementation will not honor the In Memory Database Option.'')';
    EXECUTE IMMEDIATE 'INSERT INTO ODMRSYS.ODMR$REPOSITORY_PROPERTIES (PROPERTY_NAME, PROPERTY_STR_VALUE, "COMMENT") VALUES (''WORKFLOW_JOB_CLASS_ALLOWED'', ''TRUE'', ''If FALSE, the repository implementation will not honor the user specified job class used for the workflow job run.'')';
    COMMIT;

    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE ODMRSYS.ODMR_HISTOGRAM_POINT2
                        AS OBJECT
                        ( 
                          ATTRIBUTE_NAME              VARCHAR2(128),
                          ATTRIBUTE_VALUE             VARCHAR2(4000),
                          GROUPING_ATTRIBUTE_NAME     VARCHAR2(128),
                          GROUPING_ATTRIBUTE_VALUE    VARCHAR2(4000),
                          ATTRIBUTE_PERCENT           NUMBER
                        )';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_HISTOGRAM_POINT2 FOR ODMRSYS.ODMR_HISTOGRAM_POINT2';
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON ODMR_HISTOGRAM_POINT2 TO PUBLIC';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE ODMRSYS.ODMR_HISTOGRAMS2 AS TABLE OF ODMRSYS.ODMR_HISTOGRAM_POINT2';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_HISTOGRAMS2 FOR ODMRSYS.ODMR_HISTOGRAMS2';
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON ODMR_HISTOGRAMS2 TO PUBLIC';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE ODMRSYS.ODMR_HISTOGRAM_POINT_EX2
                        AS OBJECT
                        (
                          ATTRIBUTE_NAME              VARCHAR2(128),
                          ATTRIBUTE_VALUE             VARCHAR2(32767),
                          GROUPING_ATTRIBUTE_NAME     VARCHAR2(128),
                          GROUPING_ATTRIBUTE_VALUE    VARCHAR2(32767),
                          ATTRIBUTE_PERCENT           NUMBER
                        )';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_HISTOGRAM_POINT_EX2 FOR ODMRSYS.ODMR_HISTOGRAM_POINT_EX2';
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON ODMR_HISTOGRAM_POINT_EX2 TO PUBLIC';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE ODMRSYS.ODMR_HISTOGRAMS_EX2 AS TABLE OF ODMRSYS.ODMR_HISTOGRAM_POINT_EX2';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_HISTOGRAMS_EX2 FOR ODMRSYS.ODMR_HISTOGRAMS_EX2';
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON ODMR_HISTOGRAMS_EX2 TO PUBLIC';
  
    EXECUTE IMMEDIATE 'ALTER TYPE ODMRSYS.ODMR_OBJECT_NAMES MODIFY ELEMENT TYPE VARCHAR2(128) CASCADE';

    EXECUTE IMMEDIATE 'ALTER TYPE ODMRSYS.ODMR_NODE_REFERENCE MODIFY ATTRIBUTE (
                         PROJECT_NAME   VARCHAR2(128),
                         WORKFLOW_NAME  VARCHAR2(128),
                         NODE_NAME      VARCHAR2(128)
                       ) CASCADE';
    
    EXECUTE IMMEDIATE 'ALTER TABLE ODMRSYS.ODMR$PROJECTS MODIFY ( 
                         USER_NAME      VARCHAR2(128), 
                         PROJECT_NAME   VARCHAR2(128), 
                         COMMENTS       VARCHAR2(4000) 
                       )';
                       
    EXECUTE IMMEDIATE 'ALTER TABLE ODMRSYS.ODMR$WORKFLOWS MODIFY ( 
                         WORKFLOW_NAME  VARCHAR2(128), 
                         CHAIN_NAME     VARCHAR2(128), 
                         RUN_MODE       VARCHAR2(30), 
                         COMMENTS       VARCHAR2(4000) 
                       )';
                       
    EXECUTE IMMEDIATE 'ALTER TABLE ODMRSYS.ODMR$WORKFLOW_JOBS MODIFY ( 
                         WORKFLOW_JOB_ID  VARCHAR2(128) 
                       )';
                       
    EXECUTE IMMEDIATE 'ALTER TABLE ODMRSYS.ODMR$WF_JOB_ARGS MODIFY ( 
                         CHAIN_STEP_NAME  VARCHAR2(128), 
                         ARG_NAME         VARCHAR2(60), 
                         ARG_DATA_TYPE    VARCHAR2(30), 
                         ARG_STR_VALUE    VARCHAR2(4000), 
                         WORKFLOW_JOB_ID  VARCHAR2(128) 
                       )';
                       
    EXECUTE IMMEDIATE 'ALTER TABLE ODMRSYS.ODMR$WF_LOG MODIFY (
                         USER_NAME            VARCHAR2(128),
                         JOB_NAME             VARCHAR2(128),
                         PROJ_NAME            VARCHAR2(128),
                         WF_NAME              VARCHAR2(128),
                         NODE_NAME            VARCHAR2(128),
                         NODE_ID              VARCHAR2(30),
                         SUBNODE_NAME         VARCHAR2(128),
                         SUBNODE_ID           VARCHAR2(30),
                         LOG_TYPE             VARCHAR2(30),
                         LOG_SUBTYPE          VARCHAR2(30),
                         LOG_TASK             VARCHAR2(30),
                         LOG_MESSAGE_DETAILS  VARCHAR2(4000) 
                       )';
                       
    EXECUTE IMMEDIATE 'ALTER TABLE ODMRSYS.ODMR$DEBUG_LOG MODIFY (
                         WORKFLOW_JOB_ID      VARCHAR2(128),
                         PROJECT_NAME         VARCHAR2(128),
                         WORKFLOW_NAME        VARCHAR2(128),
                         NODE_ID              VARCHAR2(30),
                         NODE_NAME            VARCHAR2(128),
                         SUB_NODE_ID          VARCHAR2(30), 
                         SUB_NODE_NAME        VARCHAR2(128),
                         OUTPUT_MSG           VARCHAR2(4000),
                         SESSION_USER         VARCHAR2(128)
                       )';
                       
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
                                NODE_NAME  VARCHAR2(128)  PATH ''@Name'',
                                NODE_STATUS VARCHAR2(10)  PATH ''@Status'')
          WHERE
            P.PROJECT_ID = X.PROJECT_ID (+)';
  
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_WORKFLOW_MODELS
        AS
          SELECT 
          P.USER_NAME, P.PROJECT_ID, P.PROJECT_NAME, X.WORKFLOW_ID, X.WORKFLOW_NAME,
          NODE_TYPE, NODE_ID, NODE_NAME, NODE_STATUS,
          MODEL_TYPE, MODEL_ID, MODEL_NAME, MODEL_STATUS, MODEL_CREATIONDATE
            FROM ODMRSYS.ODMR$WORKFLOWS X, ODMRSYS.ODMR$PROJECTS P,
                 XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                          ''/WorkflowProcess/Nodes/*''
                          PASSING X.WORKFLOW_DATA
                          COLUMNS NODE_TYPE  VARCHAR2(30) PATH ''name()'',
                                  NODE_ID    NUMBER  PATH ''@Id'',
                                  NODE_NAME  VARCHAR2(128)  PATH ''@Name'',
                                  NODE_STATUS VARCHAR2(10)  PATH ''@Status'',
                                  MODELDETAILS XMLTYPE PATH ''Models/*''),
                 XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                          ''/*''
                          PASSING MODELDETAILS
                          COLUMNS MODEL_TYPE  VARCHAR2(30)  PATH ''name()'',
                                  MODEL_ID    NUMBER  PATH ''@Id'',
                                  MODEL_NAME  VARCHAR2(128)  PATH ''@Name'',
                                  MODEL_STATUS VARCHAR2(10)  PATH ''@Status'',
                                  MODEL_CREATIONDATE VARCHAR2(30)  PATH ''@CreationDate'')
          WHERE
            P.PROJECT_ID = X.PROJECT_ID (+)';
  
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
                                  NODE_NAME  VARCHAR2(128)  PATH ''@Name'',
                                  NODE_STATUS VARCHAR2(10)  PATH ''@Status'',
                                  RESULTS XMLTYPE PATH ''Results/ClassificationResult'') XTAB,
                 XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                          ''/ClassificationResult''
                          PASSING XTAB.RESULTS
                          COLUMNS MODEL_ID    NUMBER  PATH ''@ModelId'',
                                  MODEL_NAME  VARCHAR2(128)  PATH ''@Name'',
                                  MODEL_STATUS VARCHAR2(10)  PATH ''@Status'',
                                  RESULT_CREATIONDATE VARCHAR2(30)  PATH ''@CreationDate'',
                                  TEST_METRICS VARCHAR2(128)  PATH ''TestMetrics/@Name'',
                                  CONFUSION_MATRIX VARCHAR2(128)  PATH ''ConfusionMatrix/@Name'',
                                  RESULTS XMLTYPE PATH ''*'') XTAB2,
                 XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                          ''/*/*''
                          PASSING XTAB2.RESULTS
                          COLUMNS RESULT_TYPE  VARCHAR2(30) PATH ''name()'',
                                  RESULT_NAME  VARCHAR2(128)  PATH ''@Name'',
                                  ROC_AREA        NUMBER  PATH ''@Area'',
                                  TARGET_VALUE VARCHAR2(4000)  PATH ''@TargetValue'')
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
                                  NODE_NAME  VARCHAR2(128)  PATH ''@Name'',
                                  NODE_STATUS VARCHAR2(10)  PATH ''@Status'',
                                  RESULTS XMLTYPE PATH ''Results/RegressionResult'') XTAB,
                 XMLTABLE(XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
                          ''/RegressionResult''
                          PASSING XTAB.RESULTS
                          COLUMNS MODEL_ID    NUMBER  PATH ''@ModelId'',
                                  MODEL_NAME  VARCHAR2(128)  PATH ''@Name'',
                                  MODEL_STATUS VARCHAR2(10)  PATH ''@Status'',
                                  RESULT_CREATIONDATE VARCHAR2(30)  PATH ''@CreationDate'',
                                  TEST_METRICS VARCHAR2(128)  PATH ''TestMetrics/@Name'',
                                  RESIDUAL_PLOT VARCHAR2(128)  PATH ''ResidualPlot/@Name'') XTAB2
          WHERE
            P.PROJECT_ID = X.PROJECT_ID (+)';
    END IF;
    -- add a new property MAX_STRING_SIZE
    INSERT INTO ODMRSYS.ODMR$REPOSITORY_PROPERTIES (PROPERTY_NAME, PROPERTY_STR_VALUE, "COMMENT") 
    VALUES ('MAX_STRING_SIZE', 'STANDARD', 'Current value of the MAX_STRING_SIZE parameter, which is used to control maximum size of VARCHAR2, NVARCHAR2, and RAW data types');
    BEGIN
      --SELECT value INTO v_string_size FROM v$parameter WHERE name = 'max_string_size';
      v_id := dbms_utility.get_parameter_value('max_string_size', v_id, v_string_size);
    EXCEPTION WHEN OTHERS THEN
      v_string_size := 'STANDARD';
    END;
    UPDATE ODMRSYS.ODMR$REPOSITORY_PROPERTIES SET PROPERTY_STR_VALUE = v_string_size WHERE PROPERTY_NAME = 'MAX_STRING_SIZE';
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

@@fixjsonpaths.sql

EXECUTE dbms_output.put_line('End repository upgrade from ' || '&OLD_REPOSITORY_VERSION' || ' to ' || '&NEW_REPOSITORY_VERSION' || '. ' || systimestamp);
