CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_ENGINE_TRANSFORMS_SEC" 
AS
/*
  PROCEDURE delete_sql_expression(
    p_workflowId IN NUMBER,
    p_nodeId IN VARCHAR2);
*/
  
   /**
   -- Gets the column filter settings fot the node
   -- @param p_workflowId IN NUMBER,
   -- @param p_nodeId IN VARCHAR2,
   -- @param p_nullsPercent OUT NUMBER,
   -- @param p_uniquePercent OUT NUMBER,
   -- @param p_constantPercent OUT NUMBER,
   -- @param p_cutOff OUT NUMBER,
   -- @param p_topN OUT NUMBER,
   -- @param p_samplingType OUT VARCHAR2,
   -- @param p_numberOfRows OUT NUMBER,
   -- @param p_useSampling OUT BOOLEAN,
   -- @param p_targetAttr      Target Attribute Name
   -- @param p_targetAttrType  Target Attribute Type
   -- @param p_generate_ai OUT NUMBER,
   -- @param p_dataQualityOutput OUT VARCHAR2,
   -- @param p_attrImportanceOutput OUT VARCHAR2
   -- @param p_stratifiedCutOff OUT NUMBER
   -- @param p_generate_ad OUT BOOLEAN
   -- @param p_attrDependencyOutput OUT VARCHAR2
   */
  PROCEDURE get_column_filter_settings(
    p_workflowId IN NUMBER,
    p_nodeId IN VARCHAR2,
    p_nullsPercent OUT NUMBER,
    p_uniquePercent OUT NUMBER,
    p_constantPercent OUT NUMBER,
    p_cutOff OUT NUMBER,
    p_topN OUT NUMBER,
    p_samplingType OUT VARCHAR2,
    p_numberOfRows OUT NUMBER,
    p_useSampling OUT BOOLEAN,
    p_targetAttr OUT VARCHAR2,
    p_targetAttrType OUT VARCHAR2,
    p_generate_ai OUT NUMBER,
    p_dataQualityOutput OUT VARCHAR2,
    p_attrImportanceOutput OUT VARCHAR2,
    p_stratifiedCutOff OUT NUMBER,
    p_generate_ad OUT BOOLEAN,
    p_attrDependencyOutput OUT VARCHAR2);
    
  /**
   -- @param p_workflowId IN NUMBER,
   -- @param p_nodeId IN VARCHAR2,
   -- @param p_automaticFilterEnable OUT VARCHAR2,
   -- @param p_attributes IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_automaticFilterings IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_outputs IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_column_filter_attributes(p_workflowId IN NUMBER,
                                         p_nodeId IN VARCHAR2,
                                         p_automaticFilterEnable OUT VARCHAR2,
                                         p_attributes IN OUT NOCOPY ODMR_OBJECT_NAMES,
                                         p_automaticFilterings IN OUT NOCOPY ODMR_OBJECT_NAMES,
                                         p_outputs IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId IN NUMBER,
   -- @param p_nodeId IN VARCHAR2,
   -- @param p_dataQualityOutput IN VARCHAR2,
   -- @param p_generate_ai IN NUMBER,
   -- @param p_attrImportanceOutput IN VARCHAR2,
   -- @param p_generate_ad IN BOOLEAN,
   -- @param p_attrDependencyOutput IN VARCHAR2,
   -- @param p_results IN OUT NOCOPY ODMR_ENGINE_TRANSFORMS.FRLOOKUPTYPE
   */
  PROCEDURE update_column_filter_results(
    p_workflowId IN NUMBER,
    p_nodeId IN VARCHAR2,
    p_dataQualityOutput IN VARCHAR2,
    p_generate_ai IN NUMBER,
    p_attrImportanceOutput IN VARCHAR2,
    p_generate_ad IN BOOLEAN,
    p_attrDependencyOutput IN VARCHAR2,
    p_results IN OUT NOCOPY ODMR_ENGINE_TRANSFORMS.FRLOOKUPTYPE);

  /**
   -- @param p_workflowId IN NUMBER,
   -- @param p_nodeId IN VARCHAR2,
   -- @param p_statisticTable OUT VARCHAR2,
   -- @param p_numberOfRows OUT NUMBER,
   -- @param p_percentOfTotal OUT NUMBER,
   -- @param p_randomSeed OUT NUMBER,
   -- @param p_targetAttr OUT VARCHAR2,
   -- @param p_targetDataType OUT VARCHAR2,
   -- @param p_stratifiedType OUT VARCHAR2,
   -- @param p_stratifiedSeed OUT NUMBER,
   -- @param p_caseId OUT VARCHAR2,
   -- @param p_caseIdDataType OUT VARCHAR2,
   -- @param p_targetValues IN OUT NOCOPY ODMR_OBJECT_VALUES,
   -- @param p_valueCounts IN OUT NOCOPY ODMR_OBJECT_IDS
   */
  PROCEDURE get_sample_settings(
    p_workflowId IN NUMBER,
    p_nodeId IN VARCHAR2,
    p_statisticTable OUT VARCHAR2,
    p_numberOfRows OUT NUMBER,
    p_percentOfTotal OUT NUMBER,
    p_randomSeed OUT NUMBER,
    p_targetAttr OUT VARCHAR2,
    p_targetDataType OUT VARCHAR2,
    p_stratifiedType OUT VARCHAR2,
    p_stratifiedSeed OUT NUMBER,
    p_caseId OUT VARCHAR2,
    p_caseIdDataType OUT VARCHAR2,
    p_targetValues IN OUT NOCOPY ODMR_OBJECT_VALUES,
    p_valueCounts IN OUT NOCOPY ODMR_OBJECT_IDS);

  /**
   -- @param p_workflowId   IN NUMBER,
   -- @param p_nodeId       IN VARCHAR2,
   -- @param p_column       IN VARCHAR2,
   -- @param p_stats_table  IN VARCHAR2,
   -- @param p_sql_lstmt    IN OUT NOCOPY ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE
   */
  PROCEDURE update_sample_data(p_workflowId   IN NUMBER,
                               p_nodeId       IN VARCHAR2,
                               p_column       IN VARCHAR2,
                               p_stats_table  IN VARCHAR2,
                               p_sql_lstmt    IN OUT NOCOPY ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE);

  /**
   -- @param p_workflowId  IN NUMBER,
   -- @param p_nodeId      IN VARCHAR2,
   -- @param p_db_objects  IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   */
  PROCEDURE delete(
    p_workflowId  IN NUMBER,
    p_nodeId      IN VARCHAR2,
    p_db_objects  IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS);

  /**
   -- @param p_workflowId  IN NUMBER,
   -- @param p_nodeId      IN VARCHAR2,
   -- @param p_use_full    OUT VARCHAR2,
   -- @param p_num_bins    OUT INTEGER,
   -- @param p_cat_bins    OUT INTEGER,
   -- @param p_date_bins   OUT INTEGER,
   -- @param p_attributes  IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_attr_types  IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_xform_sample_table_info(
    p_workflowId  IN NUMBER,
    p_nodeId      IN VARCHAR2,
    p_use_full    OUT VARCHAR2,
    p_num_bins    OUT INTEGER,
    p_cat_bins    OUT INTEGER,
    p_date_bins   OUT INTEGER,
    p_attributes  IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attr_types  IN OUT NOCOPY ODMR_OBJECT_NAMES);

--  PROCEDURE get_xform_output_attrs(
--    p_workflowId      IN NUMBER,
--    p_nodeId          IN VARCHAR2,
--    p_out_names       IN OUT NOCOPY ODMR_OBJECT_NAMES,
--    p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES,
--    p_attr_types      IN OUT NOCOPY ODMR_OBJECT_NAMES,
--    p_topn_bin_count  IN OUT NOCOPY ODMR_OBJECT_IDS,
--    p_topn_other      IN OUT NOCOPY ODMR_OBJECT_NAMES,
--    p_eqw_bin_count   IN OUT NOCOPY ODMR_OBJECT_IDS,
--    p_eqw_bin_auto    IN OUT NOCOPY ODMR_OBJECT_NAMES,
--    p_eqw_bin_man     IN OUT NOCOPY ODMR_OBJECT_NAMES,
--    p_eqw_bin_range   IN OUT NOCOPY ODMR_OBJECT_NAMES,
--    p_eqw_bin_num_seq IN OUT NOCOPY ODMR_OBJECT_NAMES,
--    p_qtile_bin_count   IN OUT NOCOPY ODMR_OBJECT_IDS,
--    p_qtile_bin_auto    IN OUT NOCOPY ODMR_OBJECT_NAMES,
--    p_qtile_bin_man     IN OUT NOCOPY ODMR_OBJECT_NAMES,
--    p_qtile_bin_range   IN OUT NOCOPY ODMR_OBJECT_NAMES,
--    p_qtile_bin_num_seq IN OUT NOCOPY ODMR_OBJECT_NAMES
--    );

  /**
   -- @param p_workflowId      IN NUMBER,
   -- @param p_nodeId          IN VARCHAR2,
   -- @param p_out_names       IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_attr_types      IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_topn_bin_count  IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_topn_other      IN OUT NOCOPY ODMR_OBJECT_VALUES
   */
  PROCEDURE get_topn_xform_columns(
    p_workflowId      IN NUMBER,
    p_nodeId          IN VARCHAR2,
    p_out_names       IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attr_types      IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_topn_bin_count  IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_topn_other      IN OUT NOCOPY ODMR_OBJECT_VALUES);

  /**
   * Columns to be binned with eq.width
   -- @param p_workflowId      IN NUMBER,
   -- @param p_nodeId          IN VARCHAR2,
   -- @param p_out_names       IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_attr_types      IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_eqw_bin_count   IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_eqw_bin_auto    IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_eqw_bin_man     IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_eqw_bin_num_seq IN OUT NOCOPY ODMR_OBJECT_IDS
   */
  PROCEDURE get_eqw_xform_columns(
    p_workflowId      IN NUMBER,
    p_nodeId          IN VARCHAR2,
    p_out_names       IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attr_types      IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_eqw_bin_count   IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_eqw_bin_auto    IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_eqw_bin_man     IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_eqw_bin_num_seq IN OUT NOCOPY ODMR_OBJECT_IDS);

  /**
   * Timestamp with TimeZone columns to be binned with eq.width
   *
   -- @param p_workflowId      IN NUMBER, 
   -- @param p_nodeId          IN VARCHAR2, 
   -- @param p_out_names       IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attr_types      IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_eqw_bin_count   IN OUT NOCOPY ODMR_OBJECT_IDS, 
   -- @param p_eqw_bin_auto    IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_eqw_bin_man     IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_eqw_bin_num_seq in out nocopy odmr_object_ids 
   */
  PROCEDURE get_ts_tz_xform_columns(
    p_workflowId      IN NUMBER, 
    p_nodeId          IN VARCHAR2, 
    p_out_names       IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attr_types      IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_eqw_bin_count   IN OUT NOCOPY ODMR_OBJECT_IDS, 
    p_eqw_bin_auto    IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_eqw_bin_man     IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_eqw_bin_num_seq in out nocopy odmr_object_ids );

  /**
   * Persist in the form of the custom numeric binning
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_name            IN VARCHAR2, 
   -- @param p_cust_num_bin_names  in odmr_object_values, 
   -- @param p_cust_num_low_bnds   IN ODMR_OBJECT_VALUES
   */
  PROCEDURE set_cust_ts_tz_xform_cols(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_name            IN VARCHAR2, 
    p_cust_num_bin_names  in odmr_object_values, 
    p_cust_num_low_bnds   IN ODMR_OBJECT_VALUES);

  /**
   * Persist in the form of the custom numeric binning
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_name            IN VARCHAR2, 
   -- @param p_cust_num_bin_names  in odmr_object_values, 
   -- @param p_cust_num_low_bnds   IN ODMR_OBJECT_VALUES 
   */
  PROCEDURE set_cust_date_xform_cols(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_name            IN VARCHAR2, 
    p_cust_num_bin_names  in odmr_object_values, 
    p_cust_num_low_bnds   IN ODMR_OBJECT_VALUES );

  /**
   * DATE columns to be binned with eq.width
   *
   -- @param p_workflowId      IN NUMBER, 
   -- @param p_nodeId          IN VARCHAR2, 
   -- @param p_out_names       IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attr_types      IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_eqw_bin_count   IN OUT NOCOPY ODMR_OBJECT_IDS, 
   -- @param p_eqw_bin_auto    IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_eqw_bin_man     IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_eqw_bin_num_seq IN OUT NOCOPY ODMR_OBJECT_IDS 
   */
  PROCEDURE get_date_xform_columns(
    p_workflowId      IN NUMBER, 
    p_nodeId          IN VARCHAR2, 
    p_out_names       IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attr_types      IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_eqw_bin_count   IN OUT NOCOPY ODMR_OBJECT_IDS, 
    p_eqw_bin_auto    IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_eqw_bin_man     IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_eqw_bin_num_seq IN OUT NOCOPY ODMR_OBJECT_IDS );

  /**
   * Columns to be binned with quantile
   *
   -- @param p_workflowId        IN NUMBER,
   -- @param p_nodeId            IN VARCHAR2,
   -- @param p_out_names         IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_source_columns    IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_attr_types        IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_qtile_bin_count   IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_qtile_bin_auto    IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_qtile_bin_man     IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_qtile_bin_num_seq IN OUT NOCOPY ODMR_OBJECT_IDS
   */
  PROCEDURE get_qtile_xform_columns(
    p_workflowId        IN NUMBER,
    p_nodeId            IN VARCHAR2,
    p_out_names         IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_source_columns    IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attr_types        IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_qtile_bin_count   IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_qtile_bin_auto    IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_qtile_bin_man     IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_qtile_bin_num_seq IN OUT NOCOPY ODMR_OBJECT_IDS);

  /**
   -- @param p_workflowId  IN NUMBER,
   -- @param p_nodeId      IN VARCHAR2,
   -- @param p_stats_table IN VARCHAR2
   */
  FUNCTION update_xform_statistics_data(
    p_workflowId  IN NUMBER,
    p_nodeId      IN VARCHAR2,
    p_stats_table IN VARCHAR2) RETURN VARCHAR2;

 /**
   -- @param p_workflowId  IN NUMBER,
   -- @param p_nodeId      IN VARCHAR2,
   -- @param p_stats_table IN VARCHAR2
   */
 FUNCTION update_distinct_targets_data(
    p_workflowId IN NUMBER, 
    p_nodeId IN VARCHAR2, 
    p_stats_table IN VARCHAR2) RETURN VARCHAR2;

  /**
   * Target columns for dynamic prediction
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_names           IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_attr_types          IN OUT NOCOPY ODMR_OBJECT_VALUES
   */
  PROCEDURE get_dyn_pred_target_cols(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_names           IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attr_types          IN OUT NOCOPY ODMR_OBJECT_VALUES);

  /**
   * Columns to be binned with custom numeric binning
   *
   -- @param p_workflowId          IN NUMBER,
   -- @param p_nodeId              IN VARCHAR2,
   -- @param p_out_names           IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_source_columns      IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_attr_types          IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_cust_num_bin_num_seq IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_cust_num_bin_names  IN OUT NOCOPY ODMR_OBJECT_VALUES,
   -- @param p_cust_num_low_bnds   IN OUT NOCOPY ODMR_OBJECT_IDS
   */
  PROCEDURE get_cust_num_xform_cols(
    p_workflowId          IN NUMBER,
    p_nodeId              IN VARCHAR2,
    p_out_names           IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_source_columns      IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attr_types          IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_cust_num_bin_num_seq IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_cust_num_bin_names  IN OUT NOCOPY ODMR_OBJECT_VALUES,
    p_cust_num_low_bnds   IN OUT NOCOPY ODMR_OBJECT_IDS );

  /**
   * Persist in the form of the custom numeric binning
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_name            IN VARCHAR2, 
   -- @param p_cust_num_bin_names  IN ODMR_OBJECT_VALUES, 
   -- @param p_cust_num_low_bnds   IN ODMR_OBJECT_IDS,
   -- @param p_binning_type        IN VARCHAR2
   */
  PROCEDURE set_cust_num_xform_cols(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_name            IN VARCHAR2, 
    p_cust_num_bin_names  IN ODMR_OBJECT_VALUES, 
    p_cust_num_low_bnds   IN ODMR_OBJECT_IDS,
    p_binning_type        IN VARCHAR2);

  /**
   * Columns to be binned with custom DATE binning
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_names           IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_source_columns      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attr_types          IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_cust_date_num_seq   IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_cust_date_bin_names IN OUT NOCOPY ODMR_OBJECT_VALUES, 
   -- @param p_cust_date_low_bnds  IN OUT NOCOPY ODMR_OBJECT_VALUES
   */
  PROCEDURE get_cust_date_xform_cols(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_names           IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_source_columns      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attr_types          IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_cust_date_num_seq   IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_cust_date_bin_names IN OUT NOCOPY ODMR_OBJECT_VALUES, 
    p_cust_date_low_bnds  IN OUT NOCOPY ODMR_OBJECT_VALUES );

  /**
   * Columns to be binned with custom TIMESTAMP WITH TIME ZONE binning
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_names           IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_source_columns      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attr_types          IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_cust_date_num_seq   IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_cust_date_bin_names IN OUT NOCOPY ODMR_OBJECT_VALUES, 
   -- @param p_cust_date_low_bnds  IN OUT NOCOPY ODMR_OBJECT_VALUES
   */
  PROCEDURE get_cust_ts_tz_xform_cols(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_names           IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_source_columns      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attr_types          IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_cust_date_num_seq   IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_cust_date_bin_names IN OUT NOCOPY ODMR_OBJECT_VALUES, 
    p_cust_date_low_bnds  IN OUT NOCOPY ODMR_OBJECT_VALUES );

  /**
   * Persist in the form of the custom numeric binning
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_name            IN VARCHAR2, 
   -- @param p_cust_cat_bin_names  IN ODMR_OBJECT_VALUES, 
   -- @param p_cust_cat_bin_values IN ODMR_OBJECT_VALUES,
   -- @param p_is_other            IN ODMR_OBJECT_IDS
   */
  PROCEDURE set_cust_cat_xform_cols(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_name            IN VARCHAR2, 
    p_cust_cat_bin_names  IN ODMR_OBJECT_VALUES, 
    p_cust_cat_bin_values IN ODMR_OBJECT_VALUES,
    p_is_other            IN ODMR_OBJECT_IDS);

  /**
   * Columns to be binned with custom categorical binning
   *
   -- @param p_workflowId          IN NUMBER,
   -- @param p_nodeId              IN VARCHAR2,
   -- @param p_out_names           IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_source_columns      IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_attr_types          IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_bin_names           IN OUT NOCOPY ODMR_OBJECT_VALUES,
   -- @param p_is_others           IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_bin_values          IN OUT NOCOPY ODMR_OBJECT_VALUES 
   */
  PROCEDURE get_cust_cat_xform_cols(
    p_workflowId          IN NUMBER,
    p_nodeId              IN VARCHAR2,
    p_out_names           IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_source_columns      IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attr_types          IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_bin_names           IN OUT NOCOPY ODMR_OBJECT_VALUES,
    p_is_others           IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_bin_values          IN OUT NOCOPY ODMR_OBJECT_VALUES );

  /**
   * sets 'Modified' to false - indicating that attribute's processing is completed
   *
   -- @param p_workflowId IN NUMBER,
   -- @param p_nodeId     IN VARCHAR2,
   -- @param p_attributes IN ODMR_OBJECT_NAMES
   */
  PROCEDURE clear_modified_flag (
    p_workflowId IN NUMBER,
    p_nodeId     IN VARCHAR2,
    p_attributes IN ODMR_OBJECT_NAMES);

  PROCEDURE clear_modified_flag_2 (
    p_workflowId IN NUMBER,
    p_nodeId     IN VARCHAR2,
    p_attributes IN ODMR_OBJECT_NAMES);

  /**
   * sets 'Modified' to false - indicating that attribute's processing is completed
   *
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2,
   -- @param p_attribute  IN VARCHAR2
   */
  PROCEDURE clear_column_modified_flag (p_workflowId IN NUMBER, 
                                 p_nodeId     IN VARCHAR2,
                                 p_attribute  IN VARCHAR2);

  /**
   * returns the list of source columns which have flag 'Output' true
   * 
   -- @param p_workflowId  IN NUMBER, 
   -- @param p_nodeId      IN VARCHAR2, 
   -- @param p_attributes  IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_output_columns_src(
    p_workflowId  IN NUMBER, 
    p_nodeId      IN VARCHAR2, 
    p_attributes  IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   * returns the list of transformed columns which have flag 'Output' true
   *
   -- @param p_workflowId  IN NUMBER, 
   -- @param p_nodeId      IN VARCHAR2, 
   -- @param p_attributes  IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_output_columns_xformed(
    p_workflowId  IN NUMBER, 
    p_nodeId      IN VARCHAR2, 
    p_attributes  IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   * Used by Generate For Apply
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_name            IN VARCHAR2, 
   -- @param p_value               IN VARCHAR2,
   -- @param p_function            IN VARCHAR2
   */
  PROCEDURE set_mv_cat_columns(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_name            IN VARCHAR2, 
    p_value               IN VARCHAR2,
    p_function            IN VARCHAR2);

  /**
   * Columns to be treated with missing values
   *
   -- @param p_workflowId        IN NUMBER, 
   -- @param p_nodeId            IN VARCHAR2, 
   -- @param p_out_names         IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_source_columns    IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attr_types        IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_mv_cat_function   Statistics or Value
   -- @param p_mv_cat_replace    Mode or some value
   */
  PROCEDURE get_mv_cat_columns(
    p_workflowId        IN NUMBER, 
    p_nodeId            IN VARCHAR2, 
    p_out_names         IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_source_columns    IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attr_types        IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_mv_cat_function   IN OUT NOCOPY ODMR_OBJECT_VALUES, -- Statistics or Value
    p_mv_cat_replace    IN OUT NOCOPY ODMR_OBJECT_VALUES); -- Mode or some value

  /*
   * Columns to be treated with missing values
   *
   -- @param p_workflowId        IN NUMBER, 
   -- @param p_nodeId            IN VARCHAR2, 
   -- @param p_out_names         IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_source_columns    IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attr_types        IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_mv_num_function   Statistics or Value
   -- @param p_mv_num_replace    Min, Max, etc,  or some value
   */
  PROCEDURE get_mv_num_columns(
    p_workflowId        IN NUMBER, 
    p_nodeId            IN VARCHAR2, 
    p_out_names         IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_source_columns    IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attr_types        IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_mv_num_function   IN OUT NOCOPY ODMR_OBJECT_VALUES, -- Statistics or Value
    p_mv_num_replace    IN OUT NOCOPY ODMR_OBJECT_IDS); -- Min, Max, etc,  or some value

  /**
   * Used by Generate For Apply
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_name            IN VARCHAR2, 
   -- @param p_value               IN NUMBER,
   -- @param p_function            IN VARCHAR2
   */
  PROCEDURE set_mv_num_columns(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_name            IN VARCHAR2, 
    p_value               IN NUMBER,
    p_function            IN VARCHAR2);

  /**
   * Used by Generate For Apply
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_name            IN VARCHAR2, 
   -- @param p_value               IN VARCHAR2,
   -- @param p_function            IN VARCHAR2
   */
  PROCEDURE set_mv_date_columns(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_name            IN VARCHAR2, 
    p_value               IN VARCHAR2,
    p_function            IN VARCHAR2);

  /**
   * Date columns to be treated with missing values
   *
   -- @param p_workflowId         IN NUMBER, 
   -- @param p_nodeId             IN VARCHAR2, 
   -- @param p_out_names          IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_source_columns     IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attr_types         in out nocopy odmr_object_names,
   -- @param p_mv_date_function   Statistics or Value
   -- @param p_mv_date_replace    in out nocopy odmr_object_values,
   */
  PROCEDURE get_mv_date_columns(
    p_workflowId        IN NUMBER, 
    p_nodeId            IN VARCHAR2, 
    p_out_names         IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_source_columns    IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attr_types        in out nocopy odmr_object_names,
    p_mv_date_function   IN OUT NOCOPY ODMR_OBJECT_VALUES, -- Statistics or Value
    p_mv_date_replace   in out nocopy odmr_object_values);

  /**
   * Used by Generate For Apply
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_name            IN VARCHAR2, 
   -- @param p_out_type            StDev or Percent
   -- @param p_sigma               IN NUMBER,
   -- @param p_lower_percent       IN NUMBER,
   -- @param p_upper_percent       IN NUMBER,
   -- @param p_lower               IN NUMBER,
   -- @param p_upper               IN NUMBER,
   -- @param p_replace_with        Edges or Nulls
   */
  PROCEDURE set_outlier_columns(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_name            IN VARCHAR2, 
    p_out_type            IN VARCHAR2,     -- StDev or Percent
    p_sigma               IN NUMBER,
    p_lower_percent       IN NUMBER,
    p_upper_percent       IN NUMBER,
    p_lower               IN NUMBER,
    p_upper               IN NUMBER,
    p_replace_with        IN VARCHAR2    
  );

  /**
   * Columns to be treated with outlier transfromation
   *
   -- @param p_workflowId              IN NUMBER, 
   -- @param p_nodeId                  IN VARCHAR2, 
   -- @param p_out_names               IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_source_columns          IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attr_types              IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_outlier_type            StandardDeviation, Value, Percent
   -- @param p_replace_with            IN OUT NOCOPY ODMR_OBJECT_VALUES,
   -- @param p_outlier_multiple_value  IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_outlier_lower_value     IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_outlier_upper_value     IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_outlier_lower_percent   IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_outlier_upper_percent   IN OUT NOCOPY ODMR_OBJECT_IDS
   */
  PROCEDURE get_outlier_columns(
    p_workflowId              IN NUMBER, 
    p_nodeId                  IN VARCHAR2, 
    p_out_names               IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_source_columns          IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attr_types              IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_outlier_type            IN OUT NOCOPY ODMR_OBJECT_VALUES, -- StandardDeviation, Value, Percent
    p_replace_with            IN OUT NOCOPY ODMR_OBJECT_VALUES,
    p_outlier_multiple_value  IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_outlier_lower_value     IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_outlier_upper_value     IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_outlier_lower_percent   IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_outlier_upper_percent   IN OUT NOCOPY ODMR_OBJECT_IDS );

  /**
   * Used by Generate For Apply
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_name            IN VARCHAR2, 
   -- @param p_norm_type           MinMax, ZScore, LinearScale
   -- @param p_shift               IN NUMBER,
   -- @param p_scale               IN NUMBER
   */
  PROCEDURE set_norm_columns(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_name            IN VARCHAR2, 
    p_norm_type           IN VARCHAR2,     -- MinMax, ZScore, LinearScale
    p_shift               IN NUMBER,
    p_scale               IN NUMBER);

  /**
   * Columns to be normalized
   *
   -- @param p_workflowId              IN NUMBER, 
   -- @param p_nodeId                  IN VARCHAR2, 
   -- @param p_out_names               IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_source_columns          IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attr_types              IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_norm_type               MinMax, ZScore, LinearScale
   -- @param p_norm_custom_shift       IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_norm_custom_scale       IN OUT NOCOPY ODMR_OBJECT_IDS
   */
  PROCEDURE get_norm_columns(
    p_workflowId              IN NUMBER, 
    p_nodeId                  IN VARCHAR2, 
    p_out_names               IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_source_columns          IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attr_types              IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_norm_type               IN OUT NOCOPY ODMR_OBJECT_VALUES, -- MinMax, ZScore, LinearScale
    p_norm_custom_shift       IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_norm_custom_scale       IN OUT NOCOPY ODMR_OBJECT_IDS );

  /**
   -- @param p_workflowId  IN NUMBER, 
   -- @param p_nodeId      IN VARCHAR2
   */
  FUNCTION get_xform_statistics_data(
    p_workflowId  IN NUMBER, 
    p_nodeId      IN VARCHAR2)
    RETURN VARCHAR2;

  /**
   * Columns to be treated with custom transformation
   *
   -- @param p_workflowId          IN NUMBER, 
   -- @param p_nodeId              IN VARCHAR2, 
   -- @param p_out_names           IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_source_columns      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attr_types          IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_cust_transforms     IN OUT NOCOPY ODMR_OBJECT_VALUES
   */
  PROCEDURE get_custom_xform_cols(
    p_workflowId          IN NUMBER, 
    p_nodeId              IN VARCHAR2, 
    p_out_names           IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_source_columns      IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attr_types          IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_cust_transforms     IN OUT NOCOPY ODMR_OBJECT_VALUES);

  /**
   * Returns True if  AutoSpec is 'Yes'
   *
   -- @param p_workflowId IN NUMBER
   -- @param p_nodeId     IN VARCHAR2
   */
  FUNCTION is_auto_spec(p_workflowId IN NUMBER, p_nodeId IN VARCHAR2) 
    RETURN BOOLEAN;

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId IN VARCHAR2,
   -- @param p_attributes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrDataTypes IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_attrMiningTypes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrInputTypes IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_dynamic_input_attributes(
                         p_workflowId IN NUMBER, 
                         p_nodeId IN VARCHAR2,
                         p_attributes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
                         p_attrDataTypes IN OUT NOCOPY ODMR_OBJECT_NAMES,
                         p_attrMiningTypes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
                         p_attrInputTypes IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId IN VARCHAR2,
   -- @param p_attributes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrDataTypes IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_attrMiningTypes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrInputTypes IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_dynamic_target_attributes(p_workflowId IN NUMBER, 
                                         p_nodeId IN VARCHAR2,
                                         p_attributes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
                                         p_attrDataTypes IN OUT NOCOPY ODMR_OBJECT_NAMES,
                                         p_attrMiningTypes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
                                         p_attrInputTypes IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_attribute  IN VARCHAR2, 
   -- @param p_status     IN VARCHAR2, 
   -- @param p_commit     IN BOOLEAN
   */
  PROCEDURE update_dyn_attribute_status(  p_workflowId IN NUMBER, 
                                          p_nodeId IN VARCHAR2, 
                                          p_attribute IN VARCHAR2, 
                                          p_status IN VARCHAR2);

  /**
   * Persist the mining usage for the dynamic node
   *
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId IN VARCHAR2,
   -- @param p_mod_input_attrs IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_mod_input_types IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_mod_mining_attrs IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_mod_mining_types IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_commit IN BOOLEAN
   */
  PROCEDURE update_dyn_attr_usages( p_workflowId IN NUMBER, 
                                    p_nodeId IN VARCHAR2,
                                    p_mod_input_attrs IN OUT NOCOPY ODMR_OBJECT_NAMES, 
                                    p_mod_input_types IN OUT NOCOPY ODMR_OBJECT_NAMES,
                                    p_mod_mining_attrs IN OUT NOCOPY ODMR_OBJECT_NAMES, 
                                    p_mod_mining_types IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId IN VARCHAR2,
   -- @param p_attributes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_attrDataTypes IN OUT NOCOPY ODMR_OBJECT_NAMES);
   */
  PROCEDURE get_dynamic_case_attributes(p_workflowId IN NUMBER, 
                                         p_nodeId IN VARCHAR2,
                                         p_attributes IN OUT NOCOPY ODMR_OBJECT_NAMES, 
                                         p_attrDataTypes IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId IN VARCHAR2,
   -- @param p_attributes IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_dynamic_pexp_attributes(p_workflowId IN NUMBER, 
                                         p_nodeId IN VARCHAR2,
                                         p_attributes IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId IN VARCHAR2,
   -- @param p_input_data IN OUT NOCOPY ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE
   */
 PROCEDURE get_client_sql_expression (p_workflowId IN NUMBER, 
                                      p_nodeId IN VARCHAR2,
                                      p_input_data IN OUT NOCOPY ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId IN VARCHAR2,
   -- @param p_input_data IN OUT NOCOPY ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE
   */
 PROCEDURE get_sql_expression (p_workflowId IN NUMBER, 
                               p_nodeId IN VARCHAR2,
                               p_input_data IN OUT NOCOPY ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE);

  /**
   -- @param p_workflowId           IN NUMBER,
   -- @param p_nodeId               IN NUMBER,
   -- @param p_pred_sql_expression  IN OUT NOCOPY ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE,
   -- @param p_commit               IN BOOLEAN
   */
  PROCEDURE update_pred_sql_expression(
                                   p_workflowId           IN NUMBER,
                                   p_nodeId               IN NUMBER,
                                   p_pred_sql_expression  IN OUT NOCOPY ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE);

  /**
   -- @param p_workflowId      IN NUMBER,
   -- @param p_nodeId          IN VARCHAR2,
   -- @param p_has_with_clause OUT NUMBER,
   -- @param p_gen_view        OUT NUMBER,
   -- @param p_view_name       OUT VARCHAR2,
   -- @param p_attributes      IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_types           IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_sql_expression  IN OUT NOCOPY ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE
   */
  PROCEDURE get_query_node_settings(p_workflowId      IN NUMBER,
                                    p_nodeId          IN VARCHAR2,
                                    p_has_with_clause OUT NUMBER,
                                    p_gen_view        OUT NUMBER,
                                    p_view_name       OUT VARCHAR2,
                                    p_attributes      IN OUT NOCOPY ODMR_OBJECT_NAMES,
                                    p_types           IN OUT NOCOPY ODMR_OBJECT_NAMES,
                                    p_sql_expression  IN OUT NOCOPY ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE);

  PROCEDURE update_attr_usages(p_workflowId       IN NUMBER, 
                               p_nodeId           IN VARCHAR2,
                               p_statisticTable   IN VARCHAR2,
                               p_input_attrs      IN ODMR_OBJECT_NAMES,
                               p_input_types      IN ODMR_OBJECT_NAMES,
                               p_du_results       IN ODMR_ENGINE_MINING.DU_RESULTS,
                               p_oldStatsTables   IN OUT NOCOPY ODMR_INTERNAL_UTIL.TABLE_ARRAY);

                                    
  /**
   -- p_workflowId      IN NUMBER
   -- p_nodeId          IN VARCHAR2
   -- p_view_name       IN OUT VARCHAR2
   -- p_sample_table    IN OUT VARCHAR2
   -- p_view_dirty      IN OUT NUMBER
   -- p_sample_dirty    IN OUT NUMBER
   -- p_attributes      IN OUT NOCOPY ODMR_OBJECT_NAMES
   -- p_types           IN OUT NOCOPY ODMR_OBJECT_NAMES
   -- p_use_full        IN OUT VARCHAR2
   -- p_numberOfRows    IN OUT NUMBER
   -- p_percentOfTotal  IN OUT NUMBER
  */  
  PROCEDURE get_graph_node_settings(p_workflowId      IN NUMBER,
                                    p_nodeId          IN VARCHAR2,
                                    p_view_name       OUT VARCHAR2,
                                    p_sample_table    OUT VARCHAR2,
                                    p_view_dirty      OUT NUMBER,
                                    p_sample_dirty    OUT NUMBER,
                                    p_attributes      IN OUT NOCOPY ODMR_OBJECT_NAMES,
                                    p_types           IN OUT NOCOPY ODMR_OBJECT_NAMES,
                                    p_use_full        OUT VARCHAR2,
                                    p_numberOfRows    OUT NUMBER,
                                    p_percentOfTotal  OUT NUMBER);


  /**
   -- p_workflowId      IN NUMBER
   -- p_nodeId          IN VARCHAR2
   -- p_view_name       IN OUT VARCHAR2
   -- p_sample_table    IN OUT VARCHAR2
   -- p_view_dirty      IN OUT NUMBER
   -- p_sample_dirty    IN OUT NUMBER
   -- p_use_full        IN OUT VARCHAR2
   -- p_numberOfRows    IN OUT NUMBER
   -- p_percentOfTotal  IN OUT NUMBER
  */
  PROCEDURE init_graph_node_settings(p_workflowId      IN NUMBER,
                                     p_nodeId          IN VARCHAR2,
                                     p_view_name       IN OUT VARCHAR2,
                                     p_sample_table    IN OUT VARCHAR2,
                                     p_view_dirty      IN OUT NUMBER,
                                     p_sample_dirty    IN OUT NUMBER,
                                     p_use_full        IN OUT VARCHAR2,
                                     p_numberOfRows    IN OUT NUMBER,
                                     p_percentOfTotal  IN OUT NUMBER);

  /**
   -- @param p_workflowId      IN NUMBER
   -- @param p_chain_step      IN VARCHAR2 
   -- @param p_view_name       IN VARCHAR2 
   -- @param p_sample_table    IN VARCHAR2
   -- @param p_view_dirty      IN NUMBER 
   -- @param p_sample_dirty    IN NUMBER
   -- @param p_use_full        IN VARCHAR2
   -- @param p_numberOfRows    IN NUMBER
   -- @param p_percentOfTotal  IN NUMBER
   -- @param p_commit          IN BOOLEAN
   */
  PROCEDURE update_graph_node_settings (p_workflowId      IN NUMBER, 
                                        p_chain_step      IN VARCHAR2, 
                                        p_view_name       IN VARCHAR2, 
                                        p_sample_table    IN VARCHAR2, 
                                        p_view_dirty      IN NUMBER, 
                                        p_sample_dirty    IN NUMBER, 
                                        p_use_full        IN VARCHAR2,
                                        p_numberOfRows    IN NUMBER,
                                        p_percentOfTotal  IN NUMBER,
                                        p_commit          IN BOOLEAN);

  /**
   -- @param p_workflowId      IN NUMBER
   -- @param p_nodeId          IN VARCHAR2 
   -- @param p_dataGuide       IN OUT NOCOPY ODMR_INTERNAL_UTIL.DATAGUIDETYPE 
   */
  FUNCTION validateJSONQuery (p_workflowId   IN NUMBER, 
                              p_nodeId       IN VARCHAR2,
                              p_dataGuide    IN OUT NOCOPY ODMR_INTERNAL_UTIL.DATAGUIDETYPE) RETURN BOOLEAN;

  PROCEDURE get_transform_nulls_num(
    p_workflowId      IN NUMBER, 
    p_nodeId          IN VARCHAR2, 
    p_binning_type    IN VARCHAR2, -- Quantile, CustomNumeric, CustomDate, CustomTimestamp, EqualWidth, DateEqualWidth, TimestampEqualWidth
    p_out_names       IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attr_types      IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_labels          IN OUT NOCOPY ODMR_OBJECT_VALUES,
    p_include_nulls   IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_null_bin_ids    IN OUT NOCOPY ODMR_OBJECT_IDS, 
    p_null_bin_selections IN OUT NOCOPY ODMR_OBJECT_NAMES);

  PROCEDURE get_transform_nulls_cat(
    p_workflowId      IN NUMBER, 
    p_nodeId          IN VARCHAR2, 
    p_binning_type    IN VARCHAR2, --CustomCategorical, TopN
    p_out_names       IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_attr_types      IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_labels          IN OUT NOCOPY ODMR_OBJECT_VALUES,
    p_include_nulls   IN OUT NOCOPY ODMR_OBJECT_NAMES);

END ODMR_ENGINE_TRANSFORMS_SEC;
/
