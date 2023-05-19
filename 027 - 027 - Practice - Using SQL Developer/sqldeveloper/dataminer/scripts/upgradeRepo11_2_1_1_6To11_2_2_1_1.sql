ALTER session set current_schema = "ODMRSYS";

EXECUTE dbms_output.put_line('Start repository upgrade from 11.2.1.1.6 to 11.2.2.1.1. ' || systimestamp);

DECLARE
  sql_text varchar2(256);
  repos_version VARCHAR2(30);
  SYS_TABLE_NAME  VARCHAR2(30);
  DB_VER  VARCHAR2(30);
BEGIN
  SELECT VERSION INTO DB_VER FROM PRODUCT_COMPONENT_VERSION WHERE PRODUCT LIKE 'Oracle Database%' OR PRODUCT LIKE 'Personal Oracle Database %' ;
  SELECT PROPERTY_STR_VALUE INTO repos_version FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'VERSION';
  IF ( repos_version = '11.2.1.1.6' ) THEN
    BEGIN
      sql_text := 'drop VIEW ODMRSYS.ODMR_ALL_WORKFLOW_MODELS' ;
      DBMS_OUTPUT.PUT_LINE (sql_text ); 
      execute immediate sql_text;
      EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE ('Table/View does not exist' );
    END;
  
    -- create types for nested prediction target
    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE ODMRSYS.ODMR_NESTED_VARCHAR2 
        is TABLE OF VARCHAR2(4000)';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_NESTED_VARCHAR2 FOR ODMRSYS.ODMR_NESTED_VARCHAR2';
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON ODMR_NESTED_VARCHAR2 TO PUBLIC';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE ODMRSYS.ODMR_NESTED_NVARCHAR2 
        is TABLE OF NVARCHAR2(4000)';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_NESTED_NVARCHAR2 FOR ODMRSYS.ODMR_NESTED_NVARCHAR2';
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON ODMR_NESTED_NVARCHAR2 TO PUBLIC';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE ODMRSYS.ODMR_NESTED_CHAR
        is TABLE OF CHAR(4000)';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_NESTED_CHAR FOR ODMRSYS.ODMR_NESTED_CHAR';
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON ODMR_NESTED_CHAR TO PUBLIC';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE ODMRSYS.ODMR_NESTED_NCHAR 
        is TABLE OF NCHAR(4000)';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_NESTED_NCHAR FOR ODMRSYS.ODMR_NESTED_NCHAR';
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON ODMR_NESTED_NCHAR TO PUBLIC';

    -- create types for supporting new function: ODMR_UTIL.GET_MODELS_WITH_COST_MATRIX
    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE ODMRSYS.ODMR_QUALIFIED_OBJECT_NAME    
      IS OBJECT
      (
        user_name   VARCHAR2(128),
        object_name VARCHAR2(128)
      )';

    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ODMRSYS.ODMR_ALL_WORKFLOW_MODELS
      AS
        select p.PROJECT_ID "PROJ_ID", p.PROJECT_NAME "PROJ_NAME", x.workflow_id "WF_ID", x.workflow_name "WF_NAME", t.NodeType "NODE_TYPE", t.NodeId "NODE_ID", t.NodeName "NODE_NAME", tt.ModelType "MODEL_TYPE", tt.ModelId "MODEL_ID", tt.ModelName "MODEL_NAME"
        from ODMRSYS.ODMR$WORKFLOWS x, ODMRSYS.ODMR$PROJECTS p,
          xmltable (xmlnamespaces(default ''http://xmlns.oracle.com/odmr11''), ''/WorkflowProcess/Nodes/*'' 
          passing x.WORKFLOW_DATA 
          columns NodeType varchar2(30) path ''node-name(.)'', 
          NodeId varchar2(30) path ''@Id'', 
          NodeName varchar2(30) path ''@Name'', 
          Models xmltype path ''Models'') t, 
          xmltable (xmlnamespaces(default ''http://xmlns.oracle.com/odmr11''),''/Models/*''
          passing t.Models 
          columns 
          ModelType varchar2(30) path ''node-name(.)'', 
          ModelId varchar2(30) path ''@Id'', 
          ModelName varchar2(30) path ''@Name'') tt
        WHERE
          p.PROJECT_ID = x.PROJECT_ID (+)';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_ALL_WORKFLOW_MODELS FOR ODMRSYS.ODMR_ALL_WORKFLOW_MODELS';
    IF (DB_VER >= '12.1.0.2' ) THEN
      EXECUTE IMMEDIATE 'GRANT READ ON ODMR_ALL_WORKFLOW_MODELS TO ODMRUSER';
    ELSE
      EXECUTE IMMEDIATE 'GRANT SELECT ON ODMR_ALL_WORKFLOW_MODELS TO ODMRUSER';
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_QUALIFIED_OBJECT_NAME FOR ODMRSYS.ODMR_QUALIFIED_OBJECT_NAME';
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON ODMR_QUALIFIED_OBJECT_NAME TO PUBLIC';    

    EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE ODMRSYS.ODMR_QUALIFIED_OBJECT_NAMES
      IS TABLE OF ODMRSYS.ODMR_QUALIFIED_OBJECT_NAME ';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ODMR_QUALIFIED_OBJECT_NAMES FOR ODMRSYS.ODMR_QUALIFIED_OBJECT_NAMES';
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON ODMR_QUALIFIED_OBJECT_NAMES TO PUBLIC';    

    BEGIN
      DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.PREDICTION_PROG', TRUE);
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;

    BEGIN
      DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.CLUSTER_PROG', TRUE);
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.FEATURE_PROG', TRUE);
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.ANOMALY_PROG', TRUE);
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.SQLQUERY_PROG', TRUE);
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.GRAPH_PROG', TRUE);
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;

    DBMS_SCHEDULER.CREATE_PROGRAM (
      program_name        => 'ODMRSYS.PREDICTION_PROG',
      program_type        => 'STORED_PROCEDURE',
      program_action      => 'ODMR_ENGINE_DYNAMIC_NODE.PREDICTION_PROG',
      number_of_arguments => 2,
      enabled             => FALSE,
      comments            => 'Dynamic Prediction Program');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.PREDICTION_PROG',
      metadata_attribute => 'job_name',
      argument_position  => 1,
      argument_name      => 'p_job_name');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.PREDICTION_PROG',
      metadata_attribute => 'job_subname',
      argument_position  => 2,
      argument_name      => 'p_chain_step');
    DBMS_SCHEDULER.ENABLE('ODMRSYS.PREDICTION_PROG');
  
    DBMS_SCHEDULER.CREATE_PROGRAM (
      program_name        => 'ODMRSYS.CLUSTER_PROG',
      program_type        => 'STORED_PROCEDURE',
      program_action      => 'ODMR_ENGINE_DYNAMIC_NODE.CLUSTER_PROG',
      number_of_arguments => 2,
      enabled             => FALSE,
      comments            => 'Dynamic Prediction Program');

    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.CLUSTER_PROG',
      metadata_attribute => 'job_name',
      argument_position  => 1,
      argument_name      => 'p_job_name');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.CLUSTER_PROG',
      metadata_attribute => 'job_subname',
      argument_position  => 2,
      argument_name      => 'p_chain_step');
    DBMS_SCHEDULER.ENABLE('ODMRSYS.CLUSTER_PROG');
  
    DBMS_SCHEDULER.CREATE_PROGRAM (
      program_name        => 'ODMRSYS.FEATURE_PROG',
      program_type        => 'STORED_PROCEDURE',
      program_action      => 'ODMR_ENGINE_DYNAMIC_NODE.FEATURE_PROG',
      number_of_arguments => 2,
      enabled             => FALSE,
      comments            => 'Dynamic Prediction Program');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.FEATURE_PROG',
      metadata_attribute => 'job_name',
      argument_position  => 1,
      argument_name      => 'p_job_name');

    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.FEATURE_PROG',
      metadata_attribute => 'job_subname',
      argument_position  => 2,
      argument_name      => 'p_chain_step');
    DBMS_SCHEDULER.ENABLE('ODMRSYS.FEATURE_PROG');

    DBMS_SCHEDULER.CREATE_PROGRAM (
      program_name        => 'ODMRSYS.ANOMALY_PROG',
      program_type        => 'STORED_PROCEDURE',
      program_action      => 'ODMR_ENGINE_DYNAMIC_NODE.ANOMALY_PROG',
      number_of_arguments => 2,
      enabled             => FALSE,
      comments            => 'Dynamic Prediction Program');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.ANOMALY_PROG',
      metadata_attribute => 'job_name',
      argument_position  => 1,
      argument_name      => 'p_job_name');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.ANOMALY_PROG',
      metadata_attribute => 'job_subname',
      argument_position  => 2,
      argument_name      => 'p_chain_step');
    DBMS_SCHEDULER.ENABLE('ODMRSYS.ANOMALY_PROG');

    DBMS_SCHEDULER.CREATE_PROGRAM (
      program_name        => 'ODMRSYS.SQLQUERY_PROG',
      program_type        => 'STORED_PROCEDURE',
      program_action      => 'ODMR_ENGINE_TRANSFORMS.SQLQUERY_PROG',
      number_of_arguments => 2,
      enabled             => FALSE,
      comments            => 'SQL Query Program');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.SQLQUERY_PROG',
      metadata_attribute => 'job_name',
      argument_position  => 1,
      argument_name      => 'p_job_name');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.SQLQUERY_PROG',
      metadata_attribute => 'job_subname',
      argument_position  => 2,
      argument_name      => 'p_chain_step');
    DBMS_SCHEDULER.ENABLE('ODMRSYS.SQLQUERY_PROG');
    
    DBMS_SCHEDULER.CREATE_PROGRAM (
      program_name        => 'ODMRSYS.GRAPH_PROG',
      program_type        => 'STORED_PROCEDURE',
      program_action      => 'ODMR_ENGINE_TRANSFORMS.GRAPH_PROG',
      number_of_arguments => 2,
      enabled             => FALSE,
      comments            => 'Graph Program');

    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.GRAPH_PROG',
      metadata_attribute => 'job_name',
      argument_position  => 1,
      argument_name      => 'p_job_name');
  
    DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
      program_name       => 'ODMRSYS.GRAPH_PROG',
      metadata_attribute => 'job_subname',
      argument_position  => 2,
      argument_name      => 'p_chain_step');
    DBMS_SCHEDULER.ENABLE('ODMRSYS.GRAPH_PROG');
    
    -- Add timezone to the ODMR$WF_LOG Table
    EXECUTE IMMEDIATE 'ALTER TABLE ODMRSYS.ODMR$WF_LOG ADD LOG_TIMESTAMP_TZ TIMESTAMP(6) WITH TIME ZONE';
    EXECUTE IMMEDIATE 'UPDATE ODMRSYS.ODMR$WF_LOG SET LOG_TIMESTAMP_TZ = LOG_TIMESTAMP';
    EXECUTE IMMEDIATE 'ALTER TABLE ODMRSYS.ODMR$WF_LOG DROP COLUMN LOG_TIMESTAMP';
    EXECUTE IMMEDIATE 'ALTER TABLE ODMRSYS.ODMR$WF_LOG RENAME COLUMN LOG_TIMESTAMP_TZ to LOG_TIMESTAMP';

    -- uptick the VERSION
    UPDATE ODMRSYS.ODMR$REPOSITORY_PROPERTIES SET PROPERTY_STR_VALUE = '11.2.2.1.1' WHERE PROPERTY_NAME = 'VERSION';
    COMMIT;  
    dbms_output.put_line('Repository version updated to  11.2.2.1.1.');
  ELSE
    dbms_output.put_line('Upgrade is not necessary.');
  END IF;
  EXCEPTION WHEN OTHERS THEN
   dbms_output.put_line('Scheduler Program creation for 12.1 new server operations failed: '||DBMS_UTILITY.FORMAT_ERROR_STACK());
   RAISE;
END;
/

EXECUTE dbms_output.put_line('End repository upgrade from 11.2.1.1.6 to 11.2.2.1.1. ' || systimestamp);

