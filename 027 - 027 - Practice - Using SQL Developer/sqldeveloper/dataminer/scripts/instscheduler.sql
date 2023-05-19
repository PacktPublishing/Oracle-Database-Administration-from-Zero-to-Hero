-- Usage @instsynonyms.sql 
--        
-- Description: This script installs all public synonyms referencing ODMRSYS objects.
--
-- Example:
--   @instsynonyms.sql
WHENEVER SQLERROR EXIT SQL.SQLCODE;

EXECUTE dbms_output.put_line('Start creation of oracle scheduler programs. ' || systimestamp);

-- grant rights for dbms scheduler use
BEGIN
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.START_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.CLEANUP_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.SUBFLOW_START_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.SUBFLOW_CLEANUP_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.DATASOURCE_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.DATAPROFILE_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.CLASS_BUILD_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.REGRESS_BUILD_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.CLUST_BUILD_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.ASSOC_BUILD_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.ANOMALY_BUILD_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.MODEL_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.TEST_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.APPLY_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.MODELDETAILS_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.CREATETABLE_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.TRANSFORMATIONS_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.JOIN_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.UPDATETABLE_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.AGGREGATION_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.COLUMNFILTER_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.FILTERDETAILS_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.SAMPLE_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.ROWFILTER_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.FEATURE_BUILD_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.BUILDTEXT_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.APPLYTEXT_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.BUILDTEXT_REF_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;  
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
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.JSONQUERY_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.EFE_BUILD_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.FEATURECOMPARE_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('ODMRSYS.R_BUILD_PROG', TRUE);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  
  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.START_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE.START_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Startup Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.START_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.START_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.START_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.CLEANUP_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE.CLEANUP_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Cleanup Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.CLEANUP_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.CLEANUP_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.CLEANUP_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.SUBFLOW_START_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_MINING.SUBFLOW_START_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Subflow Startup Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.SUBFLOW_START_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.SUBFLOW_START_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.SUBFLOW_START_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.SUBFLOW_CLEANUP_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_MINING.SUBFLOW_CLEANUP_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Subflow Cleanup Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.SUBFLOW_CLEANUP_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.SUBFLOW_CLEANUP_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.SUBFLOW_CLEANUP_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.DATASOURCE_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_DATA.DATASOURCE_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Data Source Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.DATASOURCE_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.DATASOURCE_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.DATASOURCE_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.DATAPROFILE_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_DATA.DATAPROFILE_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Data Profile Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.DATAPROFILE_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.DATAPROFILE_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.DATAPROFILE_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.CREATETABLE_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_DATA.CREATETABLE_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Create Table Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.CREATETABLE_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.CREATETABLE_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.CREATETABLE_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.UPDATETABLE_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_DATA.UPDATETABLE_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Update Table Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.UPDATETABLE_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.UPDATETABLE_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.UPDATETABLE_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.AGGREGATION_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_DATA.AGGREGATION_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Aggregation Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.AGGREGATION_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.AGGREGATION_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.AGGREGATION_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.CLASS_BUILD_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_MINING.CLASS_BUILD_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Class Build Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.CLASS_BUILD_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.CLASS_BUILD_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.CLASS_BUILD_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.REGRESS_BUILD_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_MINING.REGRESS_BUILD_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Regress Build Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.REGRESS_BUILD_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.REGRESS_BUILD_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.REGRESS_BUILD_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.CLUST_BUILD_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_MINING.CLUST_BUILD_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Clust Build Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.CLUST_BUILD_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.CLUST_BUILD_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.CLUST_BUILD_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.ASSOC_BUILD_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_MINING.ASSOC_BUILD_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Assoc Build Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.ASSOC_BUILD_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.ASSOC_BUILD_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.ASSOC_BUILD_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.ANOMALY_BUILD_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_MINING.ANOMALY_BUILD_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Anomaly Build Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.ANOMALY_BUILD_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.ANOMALY_BUILD_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.ANOMALY_BUILD_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.MODEL_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_MINING.MODEL_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Model Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.MODEL_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.MODEL_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.MODEL_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.TEST_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_MINING.TEST_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Test Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.TEST_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.TEST_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.TEST_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.APPLY_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_MINING.APPLY_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Apply Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.APPLY_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.APPLY_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.APPLY_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.MODELDETAILS_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_OUTPUT.MODELDETAILS_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'ModelDetails Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.MODELDETAILS_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.MODELDETAILS_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.MODELDETAILS_PROG');
  
  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.JOIN_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_TRANSFORMS.JOIN_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Join Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.JOIN_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.JOIN_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.JOIN_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.TRANSFORMATIONS_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_TRANSFORMS.TRANSFORMATIONS_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Transformations Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.TRANSFORMATIONS_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.TRANSFORMATIONS_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.TRANSFORMATIONS_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.COLUMNFILTER_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_TRANSFORMS.COLUMNFILTER_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Column Filter Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.COLUMNFILTER_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.COLUMNFILTER_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.COLUMNFILTER_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.SAMPLE_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_TRANSFORMS.SAMPLE_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Column Filter Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.SAMPLE_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.SAMPLE_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.SAMPLE_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.FILTERDETAILS_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_OUTPUT.FILTERDETAILS_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'FilterDetails Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.FILTERDETAILS_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.FILTERDETAILS_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.FILTERDETAILS_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.ROWFILTER_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_TRANSFORMS.ROWFILTER_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Row Filter Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.ROWFILTER_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.ROWFILTER_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.ROWFILTER_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.FEATURE_BUILD_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_MINING.FEATURE_BUILD_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Feature Build Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.FEATURE_BUILD_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.FEATURE_BUILD_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.FEATURE_BUILD_PROG');
  
  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.BUILDTEXT_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_TEXT.BUILDTEXT_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Build Text Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.BUILDTEXT_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.BUILDTEXT_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.BUILDTEXT_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.APPLYTEXT_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_TEXT.APPLYTEXT_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Apply Text Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.APPLYTEXT_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.APPLYTEXT_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.APPLYTEXT_PROG');

  DBMS_SCHEDULER.CREATE_PROGRAM (
    program_name        => 'ODMRSYS.BUILDTEXT_REF_PROG',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'ODMR_ENGINE_TEXT.BUILDTEXT_REF_PROG',
    number_of_arguments => 2,
    enabled             => FALSE,
    comments            => 'Build Text Reference Program');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.BUILDTEXT_REF_PROG',
    metadata_attribute => 'job_name',
    argument_position  => 1,
    argument_name      => 'p_job_name');

  DBMS_SCHEDULER.DEFINE_METADATA_ARGUMENT (
    program_name       => 'ODMRSYS.BUILDTEXT_REF_PROG',
    metadata_attribute => 'job_subname',
    argument_position  => 2,
    argument_name      => 'p_chain_step');
  DBMS_SCHEDULER.ENABLE('ODMRSYS.BUILDTEXT_REF_PROG');
  
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
END;
/

EXECUTE dbms_output.put_line('Finshed creation of oracle scheduler programs. ' || systimestamp);

