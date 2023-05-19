CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_ENGINE_SEC" 
AS

  -- Constants
  --c_job_args_type_table    CONSTANT VARCHAR2(30) := 'TABLE';
  c_job_args_type_number        CONSTANT VARCHAR2(30) := 'NUMBER';
  c_job_args_type_string        CONSTANT VARCHAR2(30) := 'STRING';

  --c_job_args_model_NB      CONSTANT VARCHAR2(30) := 'NB';
  --c_job_args_model_DT      CONSTANT VARCHAR2(30) := 'DT';
  --c_job_args_model_SVMC    CONSTANT VARCHAR2(30) := 'SVMC';
  --c_job_args_model_GLMC    CONSTANT VARCHAR2(30) := 'GLMC';

  c_job_args_nodeId             CONSTANT VARCHAR2(30) := 'NODE_ID';
  c_job_args_caseId             CONSTANT VARCHAR2(30) := 'CASE_ID';
  c_job_args_build_data         CONSTANT VARCHAR2(30) := 'BUILD_DATA';
  c_job_args_build_stat_data    CONSTANT VARCHAR2(30) := 'BUILD_STAT_DATA';
  c_job_args_perform_bal_weight CONSTANT VARCHAR2(30) := 'BAL_PERFORM_WEIGHT';
  --c_job_args_perform_bal_cost   CONSTANT VARCHAR2(30) := 'BAL_PERFORM_COST';
  --c_job_args_cost_benefit       CONSTANT VARCHAR2(30) := 'COST_BENEFIT';

  c_job_args_split_build        CONSTANT VARCHAR2(30) := 'BUILD:SPLIT';
  c_job_args_split_test         CONSTANT VARCHAR2(30) := 'TEST:SPLIT';
  --c_job_args_mapped_test        CONSTANT VARCHAR2(30) := 'TEST:MAPPED';
  --c_job_args_mapped_apply       CONSTANT VARCHAR2(30) := 'APPLY:MAPPED';

  /**
   -- @param p_job_name        IN VARCHAR2, 
   -- @param p_chain_step_name IN VARCHAR2, 
   -- @param p_arg_name        IN VARCHAR2
   */
  FUNCTION get_step_job_table_arg(
    p_job_name        IN VARCHAR2, 
    p_chain_step_name IN VARCHAR2, 
    p_arg_name        IN VARCHAR2) RETURN VARCHAR2;

  /**
   -- @param p_job_name        IN VARCHAR2, 
   -- @param p_chain_step_name IN VARCHAR2
   */
  FUNCTION get_all_temp_objects(
    p_job_name        IN VARCHAR2, 
    p_chain_step_name IN VARCHAR2) RETURN ODMR_INTERNAL_UTIL.DB_OBJECTS;

  /**
   -- @param p_job_name        IN VARCHAR2, 
   -- @param p_chain_step_name IN VARCHAR2, 
   -- @param p_arg_name        IN VARCHAR2
   */
  FUNCTION get_step_job_num_arg(
    p_job_name        IN VARCHAR2, 
    p_chain_step_name IN VARCHAR2, 
    p_arg_name        IN VARCHAR2) RETURN NUMBER;

  /**
   -- @param p_job_name        IN VARCHAR2, 
   -- @param p_chain_step_name IN VARCHAR2, 
   -- @param p_arg_name        IN VARCHAR2
   */
  FUNCTION get_step_job_string_arg(
    p_job_name        IN VARCHAR2, 
    p_chain_step_name IN VARCHAR2, 
    p_arg_name        IN VARCHAR2) RETURN VARCHAR2;

  /**
   -- @param p_job_name        IN VARCHAR2, 
   -- @param p_chain_step_name IN VARCHAR2, 
   -- @param p_arg_name        IN VARCHAR2, 
   -- @param p_commit          IN BOOLEAN
   */
  PROCEDURE clear_step_job_table_arg(
    p_job_name        IN VARCHAR2, 
    p_chain_step_name IN VARCHAR2, 
    p_arg_name        IN VARCHAR2, 
    p_commit          IN BOOLEAN);

  /**
   -- @param p_job_name        IN VARCHAR2, 
   -- @param p_chain_step_name IN VARCHAR2, 
   -- @param p_arg_name        IN VARCHAR2, 
   -- @param p_arg_str_value   IN VARCHAR2, 
   -- @param p_commit          IN BOOLEAN
   */
  PROCEDURE set_step_job_table_arg(
    p_job_name        IN VARCHAR2, 
    p_chain_step_name IN VARCHAR2, 
    p_arg_name        IN VARCHAR2, 
    p_arg_str_value   IN VARCHAR2, 
    p_commit          IN BOOLEAN);

  /**
   -- @param p_job_name        IN VARCHAR2, 
   -- @param p_chain_step_name IN VARCHAR2, 
   -- @param p_arg_name        IN VARCHAR2, 
   -- @param p_arg_num_value   IN NUMBER, 
   -- @param p_commit          IN BOOLEAN
   */
  PROCEDURE set_step_job_num_arg(
    p_job_name        IN VARCHAR2, 
    p_chain_step_name IN VARCHAR2, 
    p_arg_name        IN VARCHAR2, 
    p_arg_num_value   IN NUMBER, 
    p_commit          IN BOOLEAN);

  /**
   -- @param p_job_name         IN VARCHAR2, 
   -- @param p_chain_step_name  IN VARCHAR2, 
   -- @param p_arg_name         IN VARCHAR2, 
   -- @param p_arg_string_value IN VARCHAR2, 
   -- @param p_commit           IN BOOLEAN
   */
  PROCEDURE set_step_job_string_arg(
    p_job_name         IN VARCHAR2, 
    p_chain_step_name  IN VARCHAR2, 
    p_arg_name         IN VARCHAR2, 
    p_arg_string_value IN VARCHAR2, 
    p_commit           IN BOOLEAN);

  /**
   -- @parm p_job_name  IN VARCHAR2
   */
  FUNCTION get_workflow_Id(p_job_name IN VARCHAR2) RETURN NUMBER;

  /**
   -- @parm p_workflowId  IN NUMBER
   */
  FUNCTION get_workflow_job(p_workflowId IN NUMBER) RETURN VARCHAR2;

  /**
   -- @parm p_job_name  IN VARCHAR2
   */
  FUNCTION get_workflow_chain(p_job_name IN VARCHAR2) RETURN VARCHAR2;

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2
   */
  FUNCTION get_node_status(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2) RETURN VARCHAR2;

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2
   */
  FUNCTION get_nulls_label(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2) RETURN VARCHAR2;

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2
   */
  FUNCTION get_other_label(
    p_workflowId IN NUMBER, 
    p_nodeId IN VARCHAR2) RETURN VARCHAR2;

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_chain_step IN VARCHAR2, 
   -- @param p_status     IN VARCHAR2, 
   -- @param p_commit     IN BOOLEAN
   */
  PROCEDURE update_node_status(
    p_workflowId IN NUMBER, 
    p_chain_step IN VARCHAR2, 
    p_status     IN VARCHAR2, 
    p_commit     IN BOOLEAN);

  PROCEDURE update_node_status_commit(
    p_workflowId IN NUMBER, 
    p_chain_step IN VARCHAR2, 
    p_status     IN VARCHAR2);

  /**
   -- @param p_workflowId        IN NUMBER, 
   -- @param p_nodeId            IN VARCHAR2,  
   -- @param p_use_all_data      OUT NUMBER,
   -- @param p_useNumberOfRows   OUT NUMBER, 
   -- @param p_numberOfRows      OUT NUMBER, 
   -- @param p_usePercentOfTotal OUT NUMBER, 
   -- @param p_percentOfTotal    OUT NUMBER,
   -- @param p_useRandom         OUT NUMBER, 
   -- @param p_seed              OUT NUMBER, 
   -- @param p_useStratified     OUT NUMBER, 
   -- @param p_targetAttr        OUT VARCHAR2, 
   -- @param p_useTopN           OUT NUMBER, 
   -- @param p_cache_data        OUT VARCHAR2
   */
  PROCEDURE get_cache_settings_info(
    p_workflowId        IN NUMBER, 
    p_nodeId            IN VARCHAR2,  
    p_use_all_data      OUT NUMBER,
    p_useNumberOfRows   OUT NUMBER, 
    p_numberOfRows      OUT NUMBER, 
    p_usePercentOfTotal OUT NUMBER, 
    p_percentOfTotal    OUT NUMBER,
    p_useRandom         OUT NUMBER, 
    p_seed              OUT NUMBER, 
    p_useStratified     OUT NUMBER, 
    p_targetAttr        OUT VARCHAR2, 
    p_useTopN           OUT NUMBER, 
    p_cache_data        OUT VARCHAR2);

  /**
   -- @param p_workflowId IN NUMBER,
   -- @param p_nodeId IN VARCHAR2,
   -- @param p_use_all_data OUT NUMBER,
   -- @param p_useNumberOfRows OUT NUMBER,
   -- @param p_numberOfRows OUT NUMBER,
   -- @param p_usePercentOfTotal OUT NUMBER,
   -- @param p_percentOfTotal OUT NUMBER,
   -- @param p_useRandom OUT NUMBER,
   -- @param p_seed OUT NUMBER,
   -- @param p_useStratified OUT NUMBER,
   -- @param p_targetAttr OUT VARCHAR2,
   -- @param p_useTopN OUT NUMBER,
   -- @param p_sample_data OUT VARCHAR2
   */
  PROCEDURE get_sample_settings_info( p_workflowId IN NUMBER,
                                      p_nodeId IN VARCHAR2,
                                      p_use_all_data OUT NUMBER,
                                      p_useNumberOfRows OUT NUMBER,
                                      p_numberOfRows OUT NUMBER,
                                      p_usePercentOfTotal OUT NUMBER,
                                      p_percentOfTotal OUT NUMBER,
                                      p_useRandom OUT NUMBER,
                                      p_seed OUT NUMBER,
                                      p_useStratified OUT NUMBER,
                                      p_targetAttr OUT VARCHAR2,
                                      p_useTopN OUT NUMBER,
                                      p_sample_data OUT VARCHAR2);

  /**
   -- @param p_workflowId     IN NUMBER, 
   -- @param p_nodeId         IN VARCHAR2,
   -- @param p_generate_cache OUT NUMBER, 
   -- @param p_cache_data     OUT VARCHAR2
   */
  PROCEDURE get_generate_cache_info(
    p_workflowId     IN NUMBER, 
    p_nodeId         IN VARCHAR2,
    p_generate_cache OUT NUMBER, 
    p_cache_data     OUT VARCHAR2);

  /**
   -- @param p_workflowId  IN NUMBER, 
   -- @param p_nodeId      IN VARCHAR2, 
   -- @param p_cache_table IN VARCHAR2
   */
  PROCEDURE update_cache_data(
    p_workflowId  IN NUMBER, 
    p_nodeId      IN VARCHAR2, 
    p_cache_table IN VARCHAR2);

  /**
   -- @param p_workflowId   IN NUMBER, 
   -- @param p_nodeId       IN VARCHAR2, 
   -- @param p_sample_table IN VARCHAR2
   */
  PROCEDURE update_sample_data(
    p_workflowId   IN NUMBER, 
    p_nodeId       IN VARCHAR2, 
    p_sample_table IN VARCHAR2);

  /**
   -- @param p_workflowId  IN NUMBER, 
   -- @param p_nodeId      IN VARCHAR2, 
   -- @param p_stats_table IN VARCHAR2
   */
  PROCEDURE update_statistics_data(
    p_workflowId  IN NUMBER, 
    p_nodeId      IN VARCHAR2, 
    p_stats_table IN VARCHAR2);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   */
  PROCEDURE delete(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2, 
    p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS);

  /**
   -- @param p_job_name   IN VARCHAR2
   -- @param p_chain_step IN VARCHAR2
   */
  --PROCEDURE STARTUP_PROGRAM(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);

  /**
   -- @param p_job_name   IN VARCHAR2
   -- @param p_chain_step IN VARCHAR2
   -- @param p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   */
  PROCEDURE CLEANUP_PROGRAM(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2, p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS);

  /**
   -- @param p_workflowId  IN NUMBER
   -- @param p_nodeId      IN VARCHAR2
   */
  FUNCTION get_statistics_table(p_workflowId IN NUMBER, p_nodeId IN VARCHAR2) RETURN VARCHAR2;

  /**
   -- @param p_workflow_id    IN NUMBER,
   -- @param p_nodeId         IN NUMBER,
   -- @param p_sql_expression IN OUT NOCOPY ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE,
   -- @param p_commit         IN BOOLEAN
   */
  PROCEDURE update_sql_expression(p_workflow_id    IN NUMBER,
                                  p_nodeId         IN NUMBER,
                                  p_sql_expression IN OUT NOCOPY ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE);
                                  --,p_commit         IN BOOLEAN);

  PROCEDURE get_stats_selection_info( p_workflowId              IN NUMBER,
                                      p_nodeId                  IN VARCHAR2,
                                      p_calc_percent_distinct   OUT BOOLEAN,
                                      p_calc_percent_null       OUT BOOLEAN, 
                                      p_calc_max                OUT BOOLEAN, 
                                      p_calc_min                OUT BOOLEAN, 
                                      p_calc_avg                OUT BOOLEAN, 
                                      p_calc_stddev             OUT BOOLEAN, 
                                      p_calc_variance           OUT BOOLEAN, 
                                      p_calc_kurtosis           OUT BOOLEAN, 
                                      p_calc_median             OUT BOOLEAN, 
                                      p_calc_skewness           OUT BOOLEAN, 
                                      p_calc_mode               OUT BOOLEAN, 
                                      p_calc_mode_sampled       OUT BOOLEAN, 
                                      p_calc_mode_all           OUT BOOLEAN,
                                      p_calc_histogram          OUT BOOLEAN);
                                      
  PROCEDURE update_stats_row_count (  p_workflowId              IN NUMBER,
                                      p_nodeId                  IN VARCHAR2,
                                      p_calc_percent_distinct   IN BOOLEAN, 
                                      p_calc_percent_null       IN BOOLEAN, 
                                      p_calc_max                IN BOOLEAN, 
                                      p_calc_min                IN BOOLEAN, 
                                      p_calc_avg                IN BOOLEAN, 
                                      p_calc_stddev             IN BOOLEAN, 
                                      p_calc_variance           IN BOOLEAN, 
                                      p_calc_kurtosis           IN BOOLEAN, 
                                      p_calc_median             IN BOOLEAN, 
                                      p_calc_skewness           IN BOOLEAN, 
                                      p_calc_mode               IN BOOLEAN, 
                                      p_calc_mode_all           IN BOOLEAN,
                                      p_calc_histogram          IN BOOLEAN,
                                      p_row_count               IN NUMBER);

END;
/
