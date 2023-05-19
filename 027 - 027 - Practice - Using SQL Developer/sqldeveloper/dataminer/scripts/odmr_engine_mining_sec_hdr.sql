CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_ENGINE_MINING_SEC" 
AS

  TYPE PEXPTYPE IS RECORD (
    ATTRIBUTE           ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    EXPRESSION          CLOB );

  TYPE PEXPTYPES is TABLE OF PEXPTYPE;
  
   /**
   * Get the name of the preprocessed table of items.
   -- @param p_workflowId
   -- @param p_node_type
   -- @parama p_nodeId
   -- @param p_model_id
  */
  FUNCTION get_preprocessed_table_name(p_workflowId IN NUMBER, 
                                       p_node_type IN VARCHAR2, 
                                       p_nodeId IN VARCHAR2) 
                                       RETURN VARCHAR2;
  /**
  * Returns whether the preprocessed table of items has been created or not.
   -- @param p_workflowId
   -- @param p_node_type
   -- @parama p_nodeId
   -- @param p_model_id
  */
   FUNCTION is_generate_preprocessed_table(p_workflowId IN NUMBER, 
                                           p_node_type IN VARCHAR2, 
                                           p_nodeId IN VARCHAR2) 
                                           RETURN BOOLEAN;
  
   /**
   * Get the list of item rules from the specified model in the workflow.
   -- @param p_workflowId _
   -- @param p_node_type  _
   -- @param p_nodeId     _
   -- @param p_modelId    _
   -- @param p_algorithm_setting_names
   -- @param p_algorithm_setting_values
  */
  PROCEDURE get_item_rules(p_workflowId IN NUMBER, 
    p_node_type IN VARCHAR2, 
    p_nodeId IN VARCHAR2, 
    p_model_id IN VARCHAR2, 
    p_algorithm_setting_names IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_algorithm_setting_values IN OUT NOCOPY ODMR_OBJECT_VALUES);

  /**
   Method to return a list of item aggregates from the workflow
   -- @param p_workflowId _
   -- @param p_node_type  _
   -- @param p_nodeId     _
   -- @param p_algorithm_setting_names
   -- @param p_algorithm_setting_values
  **/
  PROCEDURE get_item_aggregates(p_workflowId IN NUMBER, p_node_type IN VARCHAR2, p_nodeId IN VARCHAR2,
                           p_algorithm_setting_names IN OUT NOCOPY ODMR_OBJECT_NAMES, 
                           p_algorithm_setting_values IN OUT NOCOPY ODMR_OBJECT_VALUES);

  /**
   function to verify if a column name is an item aggregate
   -- @param p_workflowId _
   -- @param p_node_type  _
   -- @param p_nodeId     _
   -- @param p_column_name
  **/
  FUNCTION is_item_aggregate(p_workflowId IN NUMBER, p_node_type IN VARCHAR2, p_nodeId IN VARCHAR2, p_column_name IN VARCHAR2)RETURN BOOLEAN;

 /**
   function to verify if the sampling option has been activated for the node.
   -- @param p_workflowId _
   -- @param p_node_type  _
   -- @param p_nodeId     _
   -- @param p_column_name
  **/
 FUNCTION is_sampling_on(p_workflowId IN NUMBER, p_node_type IN VARCHAR2, p_nodeId IN VARCHAR2) RETURN BOOLEAN;
 
   /**
   function to verify if the filtering (use antecedent/consequent) is active on the node
   -- @param p_workflowId _
   -- @param p_node_type  _
   -- @param p_nodeId     _
   -- @param p_modelId    - 
  **/
  FUNCTION is_filter_active(p_workflowId IN NUMBER, p_node_type IN VARCHAR2, p_nodeId IN VARCHAR2, p_model_id IN VARCHAR2) RETURN BOOLEAN;
 
 /**
   Procedure to get the odms_sampling option and odms_sample_size from the node
   -- @param p_workflowId _
   -- @param p_node_type  _
   -- @param p_nodeId     _
   -- @param p_column_name
  **/
 PROCEDURE get_sampling_size(p_workflowId IN NUMBER, p_node_type IN VARCHAR2, p_nodeId IN VARCHAR2,
                             p_algorithm_setting_names IN OUT NOCOPY ODMR_OBJECT_NAMES, 
                             p_algorithm_setting_values IN OUT NOCOPY ODMR_OBJECT_VALUES);  
  /**
 * Saves the preprocessed table name in the workflow for future use.
  -- @param p_workflowId _
   -- @param p_build_type  _
   -- @param p_nodeId     _
   -- @param p_model_type    _
   -- @param p_modelId
   -- @param p_table_name
  */
  PROCEDURE update_preprocess_items_table(p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2, 
    p_nodeId IN VARCHAR2, 
    p_table_name IN VARCHAR2);
  
  /**
   -- @param p_workflowId _
   -- @param p_node_type  _
   -- @param p_nodeId     _
   -- @param p_model_type _
   -- @param p_modelId    _
   */
  FUNCTION get_model_status(
    p_workflowId IN NUMBER, 
    p_node_type  IN VARCHAR2, 
    p_nodeId     IN VARCHAR2, 
    p_model_type IN VARCHAR2, 
    p_modelId    IN NUMBER) RETURN VARCHAR2;

  /**
   -- @param p_workflowId  _
   -- @param  p_build_type _
   -- @param  p_nodeId     _
   -- @param  p_model_type _
   -- @param  p_modelId    _
   -- @param  p_status     _
   -- @param  p_commit     _
   */
  PROCEDURE update_build_model_status(
    p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2, 
    p_nodeId     IN VARCHAR2, 
    p_model_type IN VARCHAR2, 
    p_modelId    IN NUMBER, 
    p_status     IN VARCHAR2, 
    p_commit     IN BOOLEAN);

  /**
   -- @param p_workflowId   _
   -- @param p_build_type   _
   -- @param p_nodeId       _
   -- @param p_model_schema _
   -- @param p_model_name   _
   -- @param p_status       _
   -- @param p_commit       _
   */
  PROCEDURE update_model_model_status(
    p_workflowId   IN NUMBER, 
    p_build_type   IN VARCHAR2, 
    p_nodeId       IN VARCHAR2, 
    p_model_schema IN VARCHAR2, 
    p_model_name   IN VARCHAR2, 
    p_status       IN VARCHAR2, 
    p_commit       IN BOOLEAN);

  /**
   -- @param p_workflowId  _
   -- @param p_build_type  _
   -- @param p_nodeId      _
   -- @param p_result_type _
   -- @param p_modelId     _
   */
  FUNCTION get_result_status(
    p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2, 
    p_nodeId IN VARCHAR2, 
    p_result_type IN VARCHAR2, 
    p_modelId IN NUMBER) RETURN VARCHAR2;

  /**
   -- @param p_workflowId  _
   -- @param p_build_type  _
   -- @param p_nodeId      _
   -- @param p_result_type _
   -- @param p_modelId     _
   -- @param p_status      _
   -- @param p_commit      _
   */
  PROCEDURE update_result_status(
    p_workflowId  IN NUMBER, 
    p_build_type  IN VARCHAR2, 
    p_nodeId      IN VARCHAR2, 
    p_result_type IN VARCHAR2, 
    p_modelId     IN NUMBER, 
    p_status      IN VARCHAR2, 
    p_commit      IN BOOLEAN);

  /**
   -- @param p_workflowId  _
   -- @param p_nodeId      _
   -- @param p_modelId     _
   -- @param p_status      _
   -- @param p_commit      _
   */
  PROCEDURE update_test_model_status(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2, 
    p_modelId    IN NUMBER, 
    p_status     IN VARCHAR2, 
    p_commit     IN BOOLEAN);

  /**
   -- @param p_workflowId     _
   -- @param p_build_type     _
   -- @param p_nodeId         _
   -- @param p_model_type     _
   -- @param p_modelId        _
   -- @param p_creation_date  _
   -- @param p_commit         _
   */
  PROCEDURE update_model_build(
    p_workflowId    IN NUMBER, 
    p_build_type    IN VARCHAR2,
    p_nodeId        IN VARCHAR2, 
    p_model_type    IN VARCHAR2, 
    p_modelId       IN NUMBER, 
    p_creation_date IN TIMESTAMP, 
    p_status        IN VARCHAR2, 
    p_commit        IN BOOLEAN);

  /**
   -- @param p_workflowId  _
   -- @param p_build_type  _
   -- @param p_nodeId      _
   -- @param p_commit      _
   */
  PROCEDURE insert_model_results(
    p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2, 
    p_nodeId     IN VARCHAR2, 
    p_commit     IN BOOLEAN);

  /**
   -- @param p_workflowId     _
   -- @param p_node_type      _
   -- @param p_nodeId         _
   -- @param p_modelId        _
   -- @param p_result_name    _
   -- @param p_result_objects _
   -- @param p_overwrite      _
   -- @param p_commit         _
   */
  PROCEDURE update_class_model_results(
    p_workflowId     IN NUMBER, 
    p_node_type      IN VARCHAR2, 
    p_nodeId         IN VARCHAR2, 
    p_modelId        IN NUMBER, 
    p_result_name    IN VARCHAR2, 
    p_result_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS, 
    p_overwrite      IN BOOLEAN, 
    p_commit         IN BOOLEAN);

  /**
   -- @param p_workflowId     _
   -- @param p_node_type      _
   -- @param p_nodeId         _
   -- @param p_modelId        _
   -- @param p_result_name    _
   -- @param p_result_objects _
   -- @param p_overwrite      _
   -- @param p_commit         _
   */
  PROCEDURE update_regress_model_results(
    p_workflowId IN NUMBER, 
    p_node_type IN VARCHAR2, 
    p_nodeId IN VARCHAR2, 
    p_modelId IN NUMBER, 
    p_result_name IN VARCHAR2, 
    p_result_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS,
    p_overwrite IN BOOLEAN, 
    p_commit IN BOOLEAN);

  /**
   -- @param p_workflowId  _
   -- @param p_nodeType    _
   -- @param p_nodeId      _
   -- @param p_column      _
   */
  FUNCTION is_col_used_by_built_models(p_workflowId IN NUMBER, 
                                       p_nodeType IN VARCHAR2, 
                                       p_nodeId IN VARCHAR2, 
                                       p_column IN VARCHAR2) RETURN BOOLEAN;
  
  /**
   -- @param p_workflowId  _
   -- @param p_nodeType    _
   -- @param p_nodeId      _
   -- @param p_input_attrs _
   */
  PROCEDURE get_cols_used_by_built_models(p_workflowId IN NUMBER, 
                                          p_nodeType IN VARCHAR2, 
                                          p_nodeId IN VARCHAR2, 
                                          p_input_attrs IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId     _
   -- @param p_build_type     _
   -- @param p_nodeId         _
   -- @param p_auto           auto mode?
   -- @param p_statisticTable _
   -- @param p_du_results     _
   -- @param p_oldStatsTables _
   */
  PROCEDURE update_build_attr_usages(p_workflowId     IN NUMBER, 
                                     p_build_type     IN VARCHAR2, 
                                     p_nodeId         IN VARCHAR2,
                                     p_auto           IN BOOLEAN, -- auto mode?
                                     p_statisticTable IN VARCHAR2,
                                     p_du_results     IN OUT NOCOPY ODMR_ENGINE_MINING.DU_RESULTS,
                                     p_oldStatsTables IN OUT NOCOPY ODMR_INTERNAL_UTIL.TABLE_ARRAY);
  
  /**
   -- @param p_workflowId       _
   -- @param p_node_type        _
   -- @param p_nodeId           _
   -- @param p_caseid_columns   _
   -- @param p_caseid_cols_type _
   */
  PROCEDURE get_case_columns(
    p_workflowId IN NUMBER, 
    p_node_type IN VARCHAR2, 
    p_nodeId IN VARCHAR2, 
    p_caseid_columns IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_caseid_cols_type IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId      _
   -- @param p_node_type       _
   -- @param p_nodeId          _
   -- @param p_case_columns    _
   -- @param p_case_columns_ex _
   */
  FUNCTION get_composite_case_column(
    p_workflowId      IN NUMBER, 
    p_node_type       IN VARCHAR2, 
    p_nodeId          IN VARCHAR2, 
    p_case_columns    IN OUT NOCOPY VARCHAR2, 
    p_case_columns_ex IN OUT NOCOPY VARCHAR2) RETURN NUMBER;

  /**
   -- @param p_workflowId  _
   -- @param  p_nodeId     _
   -- @param  p_modelId    _
   -- @param  p_build_type _
   -- @param  p_build_name _
   -- @param  p_model_type _
   -- @param  p_model_name _
   */
  PROCEDURE get_build_node_info(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2, 
    p_modelId    IN NUMBER, 
    p_build_type OUT VARCHAR2, 
    p_build_name OUT VARCHAR2, 
    p_model_type OUT VARCHAR2, 
    p_model_name OUT VARCHAR2);

  /**
   -- @param p_workflowId       IN NUMBER, 
   -- @param p_nodeId           IN VARCHAR2, 
   -- @param p_mining_function  OUT VARCHAR2, 
   -- @param p_mining_target    OUT VARCHAR2, 
   -- @param p_model_schemas    IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_model_names      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_model_algorithms IN O
   */
  PROCEDURE get_model_node_info(
    p_workflowId       IN NUMBER, 
    p_nodeId           IN VARCHAR2, 
    p_mining_function  OUT VARCHAR2, 
    p_mining_target    OUT VARCHAR2, 
    p_model_schemas    IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_model_names      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_model_algorithms IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId      IN NUMBER, 
   -- @param p_run_mode        IN VARCHAR2, 
   -- @param p_nodeId          IN VARCHAR2, 
   -- @param p_archive         OUT VARCHAR2, 
   -- @param p_mining_function OUT VARCHAR2, 
   -- @param p_mining_target   OUT VARCHAR2, 
   -- @param p_model_schemas   IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_model_names     IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_modelIds        IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_test_node_info(
    p_workflowId      IN NUMBER, 
    p_run_mode        IN VARCHAR2, 
    p_nodeId          IN VARCHAR2, 
    p_archive         OUT VARCHAR2, 
    p_mining_function OUT VARCHAR2, 
    p_mining_target   OUT VARCHAR2, 
    p_model_schemas   IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_model_names     IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_modelIds        IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId      NUMBER, 
   -- @param p_node_type       IN VARCHAR2, 
   -- @param p_nodeId          IN VARCHAR2, 
   -- @param p_target_column   OUT VARCHAR2, 
   -- @param p_target_datatype OUT VARCHAR2
   */
  PROCEDURE get_target_column(
    p_workflowId      NUMBER, 
    p_node_type       IN VARCHAR2, 
    p_nodeId          IN VARCHAR2, 
    p_target_column   OUT VARCHAR2, 
    p_target_datatype OUT VARCHAR2);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_run_mode   IN VARCHAR2,
   -- @param p_nodeId     IN VARCHAR2,
   -- @param p_isNB       OUT NUMBER, 
   -- @param p_isDT       OUT NUMBER, 
   -- @param p_isSVMC     OUT NUMBER, 
   -- @param p_isGLMC     OUT NUMBER
   */
  PROCEDURE get_create_balance_weight(
    p_workflowId IN NUMBER, 
    p_run_mode   IN VARCHAR2,
    p_nodeId     IN VARCHAR2,
    p_isNB       OUT NUMBER, 
    p_isDT       OUT NUMBER, 
    p_isSVMC     OUT NUMBER, 
    p_isGLMC     OUT NUMBER);

  /**
   -- @param p_workflowId     IN NUMBER, 
   -- @param p_nodeId         IN VARCHAR2, 
   -- @param p_model_type     IN VARCHAR2, 
   -- @param p_modelId        in NUMBER,
   -- @param p_target_values  IN OUT NOCOPY ODMR_OBJECT_VALUES,
   -- @param p_target_weights IN OUT NOCOPY ODMR_ENGINE_MINING.WEIGHTS
   */
  PROCEDURE get_create_user_weight(
    p_workflowId     IN NUMBER, 
    p_nodeId         IN VARCHAR2, 
    p_model_type     IN VARCHAR2, 
    p_modelId        in NUMBER,
    p_target_values  IN OUT NOCOPY ODMR_OBJECT_VALUES,
    p_target_weights IN OUT NOCOPY ODMR_ENGINE_MINING.WEIGHTS);

  /**
   -- @param p_workflowId    IN NUMBER, 
   -- @param p_nodeId        IN VARCHAR2, 
   -- @param p_model_type    IN VARCHAR2, 
   -- @param p_modelId       in NUMBER,
   -- @param p_target_values IN OUT NOCOPY ODMR_OBJECT_VALUES, 
   -- @param p_target_probs  IN OUT NOCOPY ODMR_ENGINE_MINING.WEIGHTS
   */
  PROCEDURE get_create_prior(
    p_workflowId    IN NUMBER, 
    p_nodeId        IN VARCHAR2, 
    p_model_type    IN VARCHAR2, 
    p_modelId       in NUMBER,
    p_target_values IN OUT NOCOPY ODMR_OBJECT_VALUES, 
    p_target_probs  IN OUT NOCOPY ODMR_ENGINE_MINING.WEIGHTS);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_model_type IN VARCHAR2, 
   -- @param p_modelId    in NUMBER,
   -- @param p_actuals    IN OUT NOCOPY ODMR_OBJECT_VALUES, 
   -- @param p_predicts   IN OUT NOCOPY ODMR_OBJECT_VALUES, 
   -- @param p_costs      IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_model_cost_matrix(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2, 
    p_model_type IN VARCHAR2, 
    p_modelId    in NUMBER,
    p_actuals    IN OUT NOCOPY ODMR_OBJECT_VALUES, 
    p_predicts   IN OUT NOCOPY ODMR_OBJECT_VALUES, 
    p_costs      IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId               IN NUMBER, 
   -- @param p_model_type               IN VARCHAR2, 
   -- @param p_nodeId                   IN NUMBER, 
   -- @param p_modelId                  IN NUMBER,
   -- @param p_algorithm_setting_names  IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_algorithm_setting_values IN OUT NOCOPY ODMR_OBJECT_VALUES
   */
  PROCEDURE get_build_settings(
    p_workflowId               IN NUMBER, 
    p_model_type               IN VARCHAR2, 
    p_nodeId                   IN NUMBER, 
    p_modelId                  IN NUMBER,
    p_algorithm_setting_names  IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_algorithm_setting_values IN OUT NOCOPY ODMR_OBJECT_VALUES);

  /**
   -- @param p_workflowId      NUMBER, 
   -- @param p_nodeId          IN VARCHAR2, 
   -- @param p_item_id         OUT VARCHAR2, 
   -- @param p_item_type       OUT VARCHAR2, 
   -- @param p_item_value      OUT VARCHAR2, 
   -- @param p_item_value_type OUT VARCHAR2, 
   -- @param p_max_value_cnt   OUT NUMBER
   */
  PROCEDURE get_assoc_model_info(
    p_workflowId      NUMBER, 
    p_nodeId          IN VARCHAR2, 
    p_item_id         OUT VARCHAR2, 
    p_item_type       OUT VARCHAR2, 
    p_item_value      OUT VARCHAR2, 
    p_item_value_type OUT VARCHAR2, 
    p_max_value_cnt   OUT NUMBER);
  
  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_run_mode   IN VARCHAR2, 
   -- @param p_build_type IN VARCHAR2, 
   -- @param p_nodeId     IN VARCHAR2
   */
  FUNCTION use_build_auto_data_prep(
    p_workflowId IN NUMBER, 
    p_run_mode   IN VARCHAR2, 
    p_build_type IN VARCHAR2, 
    p_nodeId     IN VARCHAR2) RETURN BOOLEAN;

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_build_type IN VARCHAR2, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_model_type IN VARCHAR2, 
   -- @param p_modelId    IN NUMBER
   */
  FUNCTION is_manual_data_input(
    p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2, 
    p_nodeId     IN VARCHAR2, 
    p_model_type IN VARCHAR2, 
    p_modelId    IN NUMBER) RETURN BOOLEAN;

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_build_type IN VARCHAR2, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_model_type IN VARCHAR2, 
   -- @param p_modelId    IN NUMBER
   */
  FUNCTION is_manual_mining_input(
    p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2, 
    p_nodeId     IN VARCHAR2, 
    p_model_type IN VARCHAR2, 
    p_modelId    IN NUMBER) RETURN BOOLEAN;

  /**
   -- @param p_workflowId      IN NUMBER, 
   -- @param p_node_type       IN VARCHAR2, 
   -- @param p_nodeId          IN VARCHAR2,
   -- @param p_attributes      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrDataTypes   IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrDataTypeQualifiers   IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrMiningTypes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrInputTypes  IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_build_mining_attributes(
    p_workflowId      IN NUMBER, 
    p_node_type       IN VARCHAR2, 
    p_nodeId          IN VARCHAR2,
    p_attributes      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attrDataTypes   IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attrDataTypeQualifiers IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attrMiningTypes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attrInputTypes  IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId      IN NUMBER, 
   -- @param p_node_type       IN VARCHAR2, 
   -- @param p_nodeId          IN VARCHAR2, 
   -- @param p_model_type      IN VARCHAR2, 
   -- @param p_modelId         IN NUMBER,
   -- @param p_attributes      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrDataTypes   IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_attrMiningTypes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrInputTypes  IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_create_manual_data_usage(
    p_workflowId      IN NUMBER, 
    p_node_type       IN VARCHAR2, 
    p_nodeId          IN VARCHAR2, 
    p_model_type      IN VARCHAR2, 
    p_modelId         IN NUMBER,
    p_attributes      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attrDataTypes   IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attrMiningTypes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attrInputTypes  IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId      IN NUMBER, 
   -- @param p_node_type       IN VARCHAR2, 
   -- @param p_nodeId          IN VARCHAR2, 
   -- @param p_model_type      IN VARCHAR2, 
   -- @param p_modelId         IN NUMBER,
   -- @param p_attributes      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrInputTypes  IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_attrAutoPreps   IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrDataTypes   IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrMiningTypes IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_auto_data_prep_attrs(
    p_workflowId      IN NUMBER, 
    p_node_type       IN VARCHAR2, 
    p_nodeId          IN VARCHAR2, 
    p_model_type      IN VARCHAR2, 
    p_modelId         IN NUMBER,
    p_attributes      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attrInputTypes  IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attrAutoPreps   IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attrDataTypes   IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attrMiningTypes IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_model_type IN VARCHAR2, 
   -- @param p_modelId    IN NUMBER,
   -- @param p_isBalanced OUT NUMBER, 
   -- @param p_isNatural  OUT NUMBER, 
   -- @param p_isCustom   OUT NUMBER
   */
  PROCEDURE get_generate_weight_option(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2, 
    p_model_type IN VARCHAR2, 
    p_modelId    IN NUMBER,
    p_isBalanced OUT NUMBER, 
    p_isNatural  OUT NUMBER, 
    p_isCustom   OUT NUMBER);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_build_type IN VARCHAR2,
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_model_type IN VARCHAR2, 
   -- @param p_modelId    IN NUMBER,
   -- @param p_isNone     OUT NUMBER, 
   -- @param p_isCost     OUT NUMBER, 
   -- @param p_isBenefit  OUT NUMBER, 
   -- @param p_isCustom   OUT NUMBER
   */
  PROCEDURE get_model_tune_option(
    p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2,
    p_nodeId     IN VARCHAR2, 
    p_model_type IN VARCHAR2, 
    p_modelId    IN NUMBER,
    p_isNone     OUT NUMBER, 
    p_isCost     OUT NUMBER, 
    p_isBenefit  OUT NUMBER, 
    p_isCustom   OUT NUMBER);

  /**
   -- @param p_workflowId     IN NUMBER, 
   -- @param p_build_type     IN VARCHAR2,
   -- @param p_nodeId         IN VARCHAR2, 
   -- @param p_modelId        IN NUMBER, 
   -- @param p_result_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   */
  PROCEDURE get_classification_result(
    p_workflowId     IN NUMBER, 
    p_build_type     IN VARCHAR2,
    p_nodeId         IN VARCHAR2, 
    p_modelId        IN NUMBER, 
    p_result_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS);

  /**
   -- @param p_workflowId     IN NUMBER, 
   -- @param p_nodeId         IN VARCHAR2, 
   -- @param p_modelId        IN NUMBER, 
   -- @param p_result_objects IN OUT NOCOPY ODMR_ENGINE_MINING.RS_OBJECTS
   */
  PROCEDURE get_classification_results(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2, 
    p_modelId    IN NUMBER, 
    p_results    IN OUT NOCOPY ODMR_ENGINE_MINING.RS_OBJECTS);

  /**
   -- @param p_workflowId     IN NUMBER, 
   -- @param p_build_type     IN VARCHAR2,
   -- @param p_nodeId         IN VARCHAR2, 
   -- @param p_modelId        IN NUMBER, 
   -- @param p_result_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   */
  PROCEDURE get_regression_result(
    p_workflowId     IN NUMBER, 
    p_build_type     IN VARCHAR2,
    p_nodeId         IN VARCHAR2, 
    p_modelId        IN NUMBER, 
    p_result_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS);

  /**
   -- @param p_workflowId     IN NUMBER, 
   -- @param p_nodeId         IN VARCHAR2, 
   -- @param p_modelId        IN NUMBER, 
   -- @param p_result_objects IN OUT NOCOPY ODMR_ENGINE_MINING.RS_OBJECTS
   */
  PROCEDURE get_regression_results(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2, 
    p_modelId    IN NUMBER, 
    p_results    IN OUT NOCOPY ODMR_ENGINE_MINING.RS_OBJECTS);

  /**
   -- @param p_workflowId    IN NUMBER, 
   -- @param p_build_type    IN VARCHAR2, 
   -- @param p_nodeId        IN VARCHAR2, 
   -- @param p_buildSourceId OUT NUMBER
   */
  PROCEDURE get_build_data_source(
    p_workflowId    IN NUMBER, 
    p_build_type    IN VARCHAR2, 
    p_nodeId        IN VARCHAR2, 
    p_buildSourceId OUT NUMBER);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_build_type IN VARCHAR2, 
   -- @param p_nodeId     IN VARCHAR2
   */
  FUNCTION get_build_first_model(
    p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2, 
    p_nodeId     IN VARCHAR2) RETURN VARCHAR2;

  /**
   -- @param p_workflowId   IN NUMBER, 
   -- @param p_build_type   IN VARCHAR2, 
   -- @param p_nodeId       IN VARCHAR2, 
   -- @param p_function     IN VARCHAR2, The mining function of the supervised build node, it can vary for R build nodes 
   -- @param p_useBuildData OUT NUMBER, 
   -- @param p_useTestData  OUT NUMBER,
   -- @param p_testSourceId OUT VARCHAR2, 
   -- @param p_useSplitData OUT NUMBER, 
   -- @param p_testPercent  OUT NUMBER, 
   -- @param p_dataFormat   OUT VARCHAR2, 
   -- @param p_useParallel  OUT NUMBER
   */
  PROCEDURE get_build_test_data_option(
    p_workflowId   IN NUMBER, 
    p_build_type   IN VARCHAR2, 
    p_nodeId       IN VARCHAR2, 
    p_function     IN VARCHAR2,
    p_useBuildData OUT NUMBER, 
    p_useTestData  OUT NUMBER,
    p_testSourceId OUT VARCHAR2, 
    p_useSplitData OUT NUMBER, 
    p_testPercent  OUT NUMBER, 
    p_dataFormat   OUT VARCHAR2, 
    p_useParallel  OUT NUMBER);

  /**
   -- @param p_workflowId         IN NUMBER, 
   -- @param p_build_type         IN VARCHAR2, 
   -- @param p_nodeId             IN VARCHAR2, 
   -- @param p_isTopN             OUT NUMBER, 
   -- @param p_TopNTargetValue    OUT NUMBER, 
   -- @param p_isBottomN          OUT NUMBER, 
   -- @param p_BottomNTargetValue OUT NUMBER, 
   -- @param p_isCustom           OUT NUMBER, 
   -- @param p_target_values      IN OUT NOCOPY ODMR_OBJECT_VALUES
   */
  PROCEDURE get_build_test_target_option(
    p_workflowId         IN NUMBER, 
    p_build_type         IN VARCHAR2, 
    p_nodeId             IN VARCHAR2, 
    p_isTopN             OUT NUMBER, 
    p_TopNTargetValue    OUT NUMBER, 
    p_isBottomN          OUT NUMBER, 
    p_BottomNTargetValue OUT NUMBER, 
    p_isCustom           OUT NUMBER, 
    p_target_values      IN OUT NOCOPY ODMR_OBJECT_VALUES);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_build_type IN VARCHAR2, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_attribute  IN VARCHAR2, 
   -- @param p_status     IN VARCHAR2, 
   -- @param p_commit     IN BOOLEAN
   */
  PROCEDURE update_mining_attribute_status(
    p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2, 
    p_nodeId     IN VARCHAR2, 
    p_attribute  IN VARCHAR2, 
    p_status     IN VARCHAR2, 
    p_commit     IN BOOLEAN);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_node_type  IN VARCHAR2, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_attribute  IN VARCHAR2, 
   -- @param p_status     IN VARCHAR2, 
   -- @param p_commit     IN BOOLEAN
   */
  PROCEDURE update_case_attribute_status(
    p_workflowId IN NUMBER, 
    p_node_type  IN VARCHAR2, 
    p_nodeId     IN VARCHAR2, 
    p_attribute  IN VARCHAR2, 
    p_status     IN VARCHAR2, 
    p_commit     IN BOOLEAN);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_build_type IN VARCHAR2, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_attribute  IN VARCHAR2, 
   -- @param p_status     IN VARCHAR2, 
   -- @param p_commit     IN BOOLEAN
   */
  PROCEDURE update_target_attribute_status(
    p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2, 
    p_nodeId     IN VARCHAR2, 
    p_attribute  IN VARCHAR2, 
    p_status     IN VARCHAR2, 
    p_commit     IN BOOLEAN);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_itemValue  IN VARCHAR2, 
   -- @param p_status     IN VARCHAR2, 
   -- @param p_commit     IN BOOLEAN
   */
  PROCEDURE update_item_value_status(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2, 
    p_itemValue  IN VARCHAR2, 
    p_status     IN VARCHAR2, 
    p_commit     IN BOOLEAN);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_model_type IN VARCHAR2, 
   -- @param p_modelId    IN VARCHAR2
   */
  FUNCTION get_balance_weights(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2, 
    p_model_type IN VARCHAR2, 
    p_modelId    IN VARCHAR2) RETURN VARCHAR2;

  /**
   -- @param p_workflowId   IN NUMBER, 
   -- @param p_nodeId       IN VARCHAR2, 
   -- @param p_model_type   IN VARCHAR2, 
   -- @param p_modelId      IN VARCHAR2, 
   -- @param p_weight_table IN VARCHAR2, 
   -- @param p_commit       IN BOOLEAN
   */
  FUNCTION update_balance_weights(
    p_workflowId   IN NUMBER, 
    p_nodeId       IN VARCHAR2, 
    p_model_type   IN VARCHAR2, 
    p_modelId      IN VARCHAR2, 
    p_weight_table IN VARCHAR2, 
    p_commit       IN BOOLEAN) RETURN VARCHAR2;

  /**
   -- @param p_workflowId    IN NUMBER, 
   -- @param p_nodeId        IN VARCHAR2, 
   -- @param p_model_schemas IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_model_names   IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_apply_refmodels(
    p_workflowId    IN NUMBER, 
    p_nodeId        IN VARCHAR2, 
    p_model_schemas IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_model_names   IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId              IN NUMBER,
   -- @param p_nodeType                IN VARCHAR2,
   -- @param p_nodeId                  IN VARCHAR2
   */
  FUNCTION get_build_text_cutoff(
    p_workflowId              IN NUMBER,
    p_nodeType                IN VARCHAR2,
    p_nodeId                  IN VARCHAR2) RETURN NUMBER;

/**
   -- @param p_workflowId              IN NUMBER,
   -- @param p_nodeType                IN VARCHAR2,
   -- @param p_nodeId                  IN VARCHAR2,
   -- @p_thesaurus                     IN OUT VARCHAR2,
   -- @param p_policy                  OUT VARCHAR2,
   **/
 PROCEDURE read_thesaurus_text_settings(
    p_workflowId              IN NUMBER,
    p_nodeType                IN VARCHAR2,
    p_nodeId                  IN VARCHAR2,
    p_thesaurus               IN OUT VARCHAR2,
    p_policy                  IN OUT VARCHAR2);
 /**
   -- @param p_workflowId              IN NUMBER,
   -- @param p_nodeType                IN VARCHAR2,
   -- @param p_nodeId                  IN VARCHAR2,
   -- @param p_xlst                    IN dbms_data_mining_transform.TRANSFORM_LIST,
   -- @paramp_attr_name                IN ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
   -- @param p_attr_subname            IN ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
   -- @param p_transform               IN VARCHAR2,
   -- @param p_reverse_transform       IN VARCHAR2,
   -- @param p_thesaurus               IN VARCHAR2,
   -- @param p_policy                  IN VARCHAR2,
   -- @param p_xformed_col             IN VARCHAR2,
   -- @param p_modelId                 IN NUMBER
   */
  PROCEDURE define_thesaurus_text_settings(
    p_workflowId              IN NUMBER,
    p_nodeType                IN VARCHAR2,
    p_nodeId                  IN VARCHAR2,
    p_xlst                    IN OUT NOCOPY dbms_data_mining_transform.TRANSFORM_LIST,
    p_attr_name               IN ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    p_attr_subname            IN ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    p_transform               IN VARCHAR2,
    p_reverse_transform       IN VARCHAR2,
    p_thesaurus               IN VARCHAR2,
    p_policy                  IN VARCHAR2,
    p_xformed_col             IN VARCHAR2,
    p_modelId                 IN NUMBER);
  /**
   -- @param p_workflowId              IN NUMBER,
   -- @param p_nodeType                IN VARCHAR2,
   -- @param p_nodeId                  IN VARCHAR2,
   -- @param p_maxNumberPerDoc         OUT NUMBER,
   -- @param p_maxNumberAllDocs        OUT NUMBER,
   -- @param p_policy                  OUT VARCHAR2,
   -- @param p_type                    OUT VARCHAR2
   */
  PROCEDURE get_build_text_settings(
    p_workflowId              IN NUMBER,
    p_nodeType                IN VARCHAR2,
    p_nodeId                  IN VARCHAR2,
    p_maxNumberPerDoc         OUT NUMBER,
    p_maxNumberAllDocs        OUT NUMBER,
    p_minNumberAllDocs        OUT NUMBER,    
    p_policy                  OUT VARCHAR2,
    p_type                    OUT VARCHAR2);

  /**
   -- @param p_workflowId              IN NUMBER,
   -- @param p_nodeType                IN VARCHAR2,
   -- @param p_nodeId                  IN VARCHAR2,
   -- @param p_transformType           OUT VARCHAR2,
   -- @param p_categoricalCutOffValue  OUT NUMBER,
   -- @param p_maxNumberPerDoc         OUT NUMBER,
   -- @param p_maxNumberAllDocs        OUT NUMBER,
   -- @param p_frequency               OUT VARCHAR2,
   -- @param p_policy                  OUT VARCHAR2,
   -- @param p_stoplistId              OUT VARCHAR2,
   -- @param p_lexer_type              OUT VARCHAR2,
   -- @param p_lexer_name              OUT VARCHAR2,
   -- @param p_lexer_attr_names        IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_lexer_attr_strings      IN OUT NOCOPY ODMR_OBJECT_VALUES,
   -- @param p_lexer_attr_numbers      IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_lexer_attr_types        IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_language_names          IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_language_types          IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_build_text_settings(
    p_workflowId              IN NUMBER,
    p_nodeType                IN VARCHAR2,
    p_nodeId                  IN VARCHAR2,
    p_transformType           OUT VARCHAR2,
    p_categoricalCutOffValue  OUT NUMBER,
    p_maxNumberPerDoc         OUT NUMBER,
    p_maxNumberAllDocs        OUT NUMBER,
    p_minNumberAllDocs        OUT NUMBER,    
    p_frequency               OUT VARCHAR2,
    p_policy                  OUT VARCHAR2,
    p_stoplistId              OUT VARCHAR2,
    p_lexer_type              OUT VARCHAR2,
    p_lexer_name              OUT VARCHAR2,
    p_lexer_attr_names        IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_lexer_attr_strings      IN OUT NOCOPY ODMR_OBJECT_VALUES,
    p_lexer_attr_numbers      IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_lexer_attr_types        IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_language_names          IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_language_types          IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId          IN NUMBER,
   -- @param p_nodeType            IN VARCHAR2,
   -- @param p_nodeId              IN VARCHAR2,
   -- @param p_transformType       IN VARCHAR2,
   -- @param p_stoplistId          IN VARCHAR2,
   -- @param p_stoplist_dbname     IN VARCHAR2,
   -- @param p_policy_name         IN VARCHAR2,
   -- @param p_lexer_name          IN VARCHAR2
   */
  PROCEDURE update_build_text_settings(
    p_workflowId          IN NUMBER,
    p_nodeType            IN VARCHAR2,
    p_nodeId              IN VARCHAR2,
    p_transformType       IN VARCHAR2,
    p_stoplistId          IN VARCHAR2,
    p_stoplist_dbname     IN VARCHAR2,
    p_policy_name         IN VARCHAR2,
    p_lexer_name          IN VARCHAR2);

  /**
   -- @param p_workflowId              IN NUMBER,
   -- @param p_nodeType                IN VARCHAR2,
   -- @param p_nodeId                  IN VARCHAR2,
   -- @param p_xformed_col             IN VARCHAR2,
   -- @param p_maxNumberPerDoc         OUT NUMBER,
   -- @param p_maxNumberAllDocs        OUT NUMBER,
   -- @param p_policy                  OUT VARCHAR2,
   -- @param p_type                    OUT VARCHAR2
   */
  PROCEDURE get_model_text_settings(
    p_workflowId              IN NUMBER,
    p_nodeType                IN VARCHAR2,
    p_nodeId                  IN VARCHAR2,
    p_xformed_col             IN VARCHAR2,
    p_maxNumberPerDoc         OUT NUMBER,
    p_maxNumberAllDocs        OUT NUMBER,
    p_minNumberAllDocs        OUT NUMBER,    
    p_policy                  OUT VARCHAR2,
    p_type                    OUT VARCHAR2);

  /**
   -- @param  p_workflowId          IN NUMBER,
   -- @param p_nodeType            IN VARCHAR2,
   -- @param p_nodeId              IN VARCHAR2,
   -- @param p_xformed_col         IN VARCHAR2,
   -- @param p_transformType       OUT VARCHAR2,
   -- @param p_maxNumberPerDoc     OUT NUMBER,
   -- @param p_maxNumberAllDocs    OUT NUMBER,
   -- @param p_frequency           OUT VARCHAR2,
   -- @param p_policy              OUT VARCHAR2,
   -- @param p_stoplistId          OUT VARCHAR2,
   -- @param p_lexer_type          OUT VARCHAR2,
   -- @param p_lexer_name          OUT VARCHAR2,
   -- @param p_lexer_attr_names    IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_lexer_attr_strings  IN OUT NOCOPY ODMR_OBJECT_VALUES,
   -- @param p_lexer_attr_numbers  IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_lexer_attr_types    IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_language_names      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_language_types      IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_model_text_settings(
    p_workflowId          IN NUMBER,
    p_nodeType            IN VARCHAR2,
    p_nodeId              IN VARCHAR2,
    p_xformed_col         IN VARCHAR2,
    p_transformType       OUT VARCHAR2,
    p_maxNumberPerDoc     OUT NUMBER,
    p_maxNumberAllDocs    OUT NUMBER,
    p_minNumberAllDocs    OUT NUMBER,
    p_frequency           OUT VARCHAR2,
    p_policy              OUT VARCHAR2,
    p_stoplistId          OUT VARCHAR2,
    p_lexer_type          OUT VARCHAR2,
    p_lexer_name          OUT VARCHAR2,
    p_lexer_attr_names    IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_lexer_attr_strings  IN OUT NOCOPY ODMR_OBJECT_VALUES,
    p_lexer_attr_numbers  IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_lexer_attr_types    IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_language_names      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_language_types      IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId          IN NUMBER,
   -- @param p_nodeType            IN VARCHAR2,
   -- @param p_nodeId              IN VARCHAR2,
   -- @param p_xformed_col         IN VARCHAR2,
   -- @param p_transformType       IN VARCHAR2,
   -- @param p_stoplistId          IN VARCHAR2,
   -- @param p_stoplist_dbname     IN VARCHAR2,
   -- @param p_policy_name         IN VARCHAR2,
   -- @param p_lexer_name          IN VARCHAR2
   */
  PROCEDURE update_model_text_settings(
    p_workflowId          IN NUMBER,
    p_nodeType            IN VARCHAR2,
    p_nodeId              IN VARCHAR2,
    p_xformed_col         IN VARCHAR2,
    p_transformType       IN VARCHAR2,
    p_stoplistId          IN VARCHAR2,
    p_stoplist_dbname     IN VARCHAR2,
    p_policy_name         IN VARCHAR2,
    p_lexer_name          IN VARCHAR2);

  /**
   -- @param p_workflowId IN NUMBER,
   -- @param p_run_mode   IN VARCHAR2, 
   -- @param p_build_type IN VARCHAR2, 
   -- @param p_nodeId     IN VARCHAR2
   */
  FUNCTION use_build_text_settings(
    p_workflowId IN NUMBER,
    p_run_mode   IN VARCHAR2, 
    p_build_type IN VARCHAR2, 
    p_nodeId     IN VARCHAR2) RETURN BOOLEAN;

  /**
   -- @param p_workflowId  IN NUMBER, 
   -- @param p_run_mode    IN VARCHAR2, 
   -- @param p_build_type  IN VARCHAR2, 
   -- @param p_nodeId      IN VARCHAR2, 
   -- @param p_model_types IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_auto_build_model_types(
    p_workflowId  IN NUMBER, 
    p_run_mode    IN VARCHAR2, 
    p_build_type  IN VARCHAR2, 
    p_nodeId      IN VARCHAR2, 
    p_model_types IN OUT NOCOPY ODMR_OBJECT_NAMES);
  
  /**
   -- @param p_workflowId         IN NUMBER, 
   -- @param p_run_mode           IN VARCHAR2, 
   -- @param p_nodeId             IN VARCHAR2, 
   -- @param p_build_type         IN VARCHAR2, 
   -- @param p_row_weight_columns IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_build_row_weight_column(
    p_workflowId         IN NUMBER, 
    p_run_mode           IN VARCHAR2, 
    p_nodeId             IN VARCHAR2, 
    p_build_type         IN VARCHAR2, 
    p_row_weight_columns IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId         IN NUMBER, 
   -- @param p_node_type          IN VARCHAR2, 
   -- @param p_nodeId             IN VARCHAR2, 
   -- @param p_genAccuracyMetrics OUT NUMBER, 
   -- @param p_genConfusionMatrix OUT NUMBER, 
   -- @param p_genROC             OUT NUMBER, 
   -- @param p_genLift            OUT NUMBER, 
   -- @param p_genTuning          OUT NUMBER
   */
  PROCEDURE get_class_test_result_option(
    p_workflowId         IN NUMBER, 
    p_node_type          IN VARCHAR2, 
    p_nodeId             IN VARCHAR2, 
    p_genAccuracyMetrics OUT NUMBER, 
    p_genConfusionMatrix OUT NUMBER, 
    p_genROC             OUT NUMBER, 
    p_genLift            OUT NUMBER, 
    p_genTuning          OUT NUMBER);
  
   /**
    -- @param p_workflowId         IN NUMBER, 
    -- @param p_node_type          IN VARCHAR2, 
    -- @param p_nodeId             IN VARCHAR2, 
    -- @param p_genAccuracyMetrics OUT NUMBER, 
    -- @param p_residuals          OUT NUMBER
    */
  PROCEDURE get_regress_test_result_option(
    p_workflowId         IN NUMBER, 
    p_node_type          IN VARCHAR2, 
    p_nodeId             IN VARCHAR2, 
    p_genAccuracyMetrics OUT NUMBER, 
    p_residuals          OUT NUMBER);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_build_type IN VARCHAR2, 
   -- @param p_maxNumPartitions OUT NUMBER, 
   -- @param p_pexp       IN OUT NOCOPY PEXPTYPES
   */
  PROCEDURE get_pexp_attributes(p_workflowId IN NUMBER, 
                                p_nodeId IN VARCHAR2,
                                p_build_type IN VARCHAR2,
                                p_maxNumPartitions OUT NUMBER,
                                p_pexp IN OUT NOCOPY PEXPTYPES);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeType IN VARCHAR2, 
   -- @param p_nodeId     IN VARCHAR2, 
   */
  FUNCTION is_generate_partition_results(p_workflowId IN NUMBER, 
                                p_nodeType IN VARCHAR2,
                                p_nodeId IN VARCHAR2) RETURN BOOLEAN;

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_modelId    IN VARCHAR2, 
   -- @param p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   */
  PROCEDURE delete_test(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2, 
    p_modelId    IN VARCHAR2, 
    p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_build_type IN VARCHAR2, 
   -- @param p_modelType  IN VARCHAR2, 
   -- @param p_modelId    IN VARCHAR2, 
   -- @param p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   */
  PROCEDURE delete_model(
    p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2, 
    p_modelType  IN VARCHAR2, 
    p_modelId    IN VARCHAR2, 
    p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS);

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
   * This function would extract the mining function from an extensible build node metadata
   -- @param p_workflowId IN NUMBER,   Workflow identifier
   -- @param p_build_type IN VARCHAR2, Build node type
   -- @param p_nodeId IN VARCHAR2,     Node identifier
   -- @param p_function OUT VARCHAR2,  Variable to store the mining function
   -- @param p_algorithm OUT VARCHAR2  Algorithm type
   */
  PROCEDURE get_extensible_mining_function(
    p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2, 
    p_nodeId IN VARCHAR2, 
    p_function OUT VARCHAR2);
  
  /**
   * This procedure is intended to extract model settings from an extensible build node metadata into the ODMR_OBJECT_VALUES
   * IN OUT parameter.
   -- @param p_workflowId IN NUMBER,                                      Workflow identifier
   -- @param p_build_type IN VARCHAR2,                                    Build node type
   -- @param p_nodeId IN NUMBER,                                          Node identifier
   -- @param p_modelId IN NUMBER,                                         Model identifier
   -- @param p_algorithm_setting_values IN OUT NOCOPY ODMR_OBJECT_VALUES  Output value array
   */
  PROCEDURE get_extensible_model_settings(
    p_workflowId IN NUMBER, 
    p_build_type IN VARCHAR2,
    p_nodeId IN NUMBER, 
    p_modelId IN NUMBER,
    p_algorithm_setting_values IN OUT NOCOPY ODMR_OBJECT_VALUES);

END;
/