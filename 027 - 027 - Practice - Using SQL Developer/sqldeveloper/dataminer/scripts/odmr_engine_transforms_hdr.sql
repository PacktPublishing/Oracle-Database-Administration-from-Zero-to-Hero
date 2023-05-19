CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_ENGINE_TRANSFORMS" 
AUTHID CURRENT_USER AS

  TYPE FILTER_STAT_OBJECT IS RECORD (
    attr_name               ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    attr_type               VARCHAR2(30),
    null_percent            NUMBER,
    constant_percent        NUMBER,
    distinct_percent        NUMBER,
    importance              NUMBER,
    rank                    NUMBER
    );
  TYPE FTLOOKUPTYPE IS TABLE OF FILTER_STAT_OBJECT INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  TYPE FILTER_RESULT_OBJECT IS RECORD (
    attr_name               ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    include                 BOOLEAN, -- output this attribute?
    null_percent_valid      BOOLEAN, -- filter test is passed?
    constant_percent_valid  BOOLEAN,
    distinct_percent_valid  BOOLEAN,
    importance_valid        BOOLEAN,
    rank_valid              BOOLEAN
    );
  TYPE FRLOOKUPTYPE IS TABLE OF FILTER_RESULT_OBJECT INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  TYPE NAME_TYPE_ENTRY IS RECORD (
    name         ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    type         ODMR_INTERNAL_UTIL.TYPE_VCHAR_130);

  TYPE NAME_TYPE_ARRAY IS TABLE OF NAME_TYPE_ENTRY INDEX BY VARCHAR2(130);

--  PROCEDURE TRANSFORM_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
--  PROCEDURE AGGREGATION_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   IN VARCHAR2
   -- @param p_chain_step IN VARCHAR2
   */
  PROCEDURE JOIN_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE SPLIT_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE SAMPLE_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE COLUMNFILTER_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE ROWFILTER_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE TRANSFORMATIONS_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE SQLQUERY_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE GRAPH_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);

  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE JSONQUERY_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE FEATURECOMPARE_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   * Prepares equal width bin boundary table <br/>
   * Used by Transformation.
   *
   -- @param p_workflow_id         IN NUMBER,
   -- @param p_chain_step          IN VARCHAR2,
   -- @param p_input_sample_table  IN VARCHAR2,
   -- @param p_all_xformed_attrs   IN OUT NAME_TYPE_ARRAY,
   -- @param p_unique_xformed_names IN OUT ODMR_OBJECT_NAMES
   */
  FUNCTION prepare_eqw_xform(
    p_workflow_id           IN NUMBER,
    p_chain_step            IN VARCHAR2,
    p_input_sample_table    IN VARCHAR2,
    p_all_xformed_attrs     IN OUT NAME_TYPE_ARRAY,
    p_unique_xformed_names  IN OUT ODMR_OBJECT_NAMES,
    p_null_labels_map       IN OUT ODMR_ENGINE.MAP_OUT_TO_OTHER, -- list of values to be used instead of 'Null bin' label
    p_include_nulls_map     IN OUT ODMR_ENGINE.MAP_OUT_TO_OTHER,  -- 'true' or 'flase' list: to use Null bin or not
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_null_bin_assignment_map IN OUT ODMR_ENGINE.MAP_BIN_ID_TO_NULL
    ) RETURN VARCHAR2;

  /**
   * Prepares equal width bin boundary table for DATE types <br/>
   * Used by Transformation.
   *
   -- @param p_workflow_id         IN NUMBER,
   -- @param p_chain_step          IN VARCHAR2,
   -- @param p_input_sample_table  IN VARCHAR2,
   -- @param p_src_attributes      IN ODMR_OBJECT_NAMES,
   -- @param p_src_attr_data_types IN ODMR_OBJECT_NAMES,
   -- @param p_all_xformed_attrs   IN OUT NAME_TYPE_ARRAY,
   -- @param p_unique_xformed_names IN OUT ODMR_OBJECT_NAMES
   */
  FUNCTION prepare_date_xform(
    p_workflow_id           IN NUMBER,
    p_chain_step            IN VARCHAR2,
    p_input_sample_table    IN VARCHAR2,
    p_src_attributes        IN ODMR_OBJECT_NAMES,
    p_src_attr_data_types   IN ODMR_OBJECT_NAMES,
    p_all_xformed_attrs     IN OUT NAME_TYPE_ARRAY,
    p_unique_xformed_names  IN OUT ODMR_OBJECT_NAMES,
    p_null_labels_map       IN OUT ODMR_ENGINE.MAP_OUT_TO_OTHER, -- list of values to be used instead of 'Null bin' label
    p_include_nulls_map     IN OUT ODMR_ENGINE.MAP_OUT_TO_OTHER,  -- 'true' or 'flase' list: to use Null bin or not
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_null_bin_assignment_map IN OUT ODMR_ENGINE.MAP_BIN_ID_TO_NULL
    ) RETURN VARCHAR2;

  /**
   * Prepares equal width bin boundary table for TIMESTAMP WITH TIME ZONE type <br/>
   * Used by Transformation.
   * 
   -- @param p_workflow_id         IN NUMBER,
   -- @param p_chain_step          IN VARCHAR2,
   -- @param p_input_sample_table  IN VARCHAR2,
   -- @param p_src_attributes      IN ODMR_OBJECT_NAMES,
   -- @param p_src_attr_data_types IN ODMR_OBJECT_NAMES,
   -- @param p_all_xformed_attrs   IN OUT NAME_TYPE_ARRAY,
   -- @param p_unique_xformed_names IN OUT ODMR_OBJECT_NAMES
   */
  FUNCTION prepare_tz_xform(
    p_workflow_id           IN NUMBER,
    p_chain_step            IN VARCHAR2,
    p_input_sample_table    IN VARCHAR2,
    p_src_attributes        IN ODMR_OBJECT_NAMES,
    p_src_attr_data_types   IN ODMR_OBJECT_NAMES,
    p_all_xformed_attrs     IN OUT NAME_TYPE_ARRAY,
    p_unique_xformed_names  IN OUT ODMR_OBJECT_NAMES,
    p_null_labels_map       IN OUT ODMR_ENGINE.MAP_OUT_TO_OTHER, -- list of values to be used instead of 'Null bin' label
    p_include_nulls_map     IN OUT ODMR_ENGINE.MAP_OUT_TO_OTHER,  -- 'true' or 'flase' list: to use Null bin or not
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_null_bin_assignment_map IN OUT ODMR_ENGINE.MAP_BIN_ID_TO_NULL
    ) RETURN VARCHAR2;

  /**
   * prepares qtile bin boundary table <br/>
   * Used by Transformation.
   *
   -- @param p_workflow_id          IN NUMBER,
   -- @param p_chain_step           IN VARCHAR2,
   -- @param p_input_sample_table   IN VARCHAR2,
   -- @param p_stats_table          IN VARCHAR2,
   -- @param p_all_xformed_attrs    IN OUT NAME_TYPE_ARRAY,
   -- @param p_unique_xformed_names combined list of all transformed column types
   -- @param p_prepare_binning_sql  IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY
   */
  PROCEDURE xform_quantile_binning(
    p_workflow_id           IN NUMBER,
    p_chain_step            IN VARCHAR2,
    p_input_sample_table    IN VARCHAR2,
    p_stats_table           IN VARCHAR2,
    p_all_xformed_attrs     IN OUT NAME_TYPE_ARRAY, -- combined list of all transformed column types
    p_unique_xformed_names  IN OUT ODMR_OBJECT_NAMES,
    p_prepare_binning_sql   IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY,
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_in_memory             IN BOOLEAN,
    p_compression           IN VARCHAR2,
    p_priority              IN VARCHAR2,
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN);

  /**
   * Custom numeric binning <br/>
   * Used by Transformation.
   * 
   -- @param p_workflow_id          IN NUMBER,
   -- @param p_chain_step           IN VARCHAR2,
   -- @param p_input_sample_table   IN VARCHAR2,
   -- @param p_stats_table          IN VARCHAR2,
   -- @param p_all_xformed_attrs    IN OUT NAME_TYPE_ARRAY,
   -- @param p_unique_xformed_names combined list of all transformed column types
   -- @param p_prepare_binning_sql  IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY
   */
  PROCEDURE xform_cust_num_binning(
    p_workflow_id            IN NUMBER,
    p_chain_step             IN VARCHAR2,
    p_input_sample_table     IN VARCHAR2,
    p_stats_table            IN VARCHAR2,
    p_all_xformed_attrs      IN OUT NAME_TYPE_ARRAY,
    p_unique_xformed_names   IN OUT ODMR_OBJECT_NAMES,  -- combined list of all transformed column types
    p_prepare_binning_sql    IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY,
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2,
    p_parallel_table_hint    IN VARCHAR2,
    p_in_memory              IN BOOLEAN,
    p_compression            IN VARCHAR2,
    p_priority               IN VARCHAR2,
    p_calc_percent_distinct  IN BOOLEAN, 
    p_calc_percent_null      IN BOOLEAN, 
    p_calc_max               IN BOOLEAN, 
    p_calc_min               IN BOOLEAN, 
    p_calc_avg               IN BOOLEAN, 
    p_calc_stddev            IN BOOLEAN, 
    p_calc_variance          IN BOOLEAN, 
    p_calc_kurtosis          IN BOOLEAN, 
    p_calc_median            IN BOOLEAN, 
    p_calc_skewness          IN BOOLEAN, 
    p_calc_mode              IN BOOLEAN, 
    p_calc_mode_all          IN BOOLEAN,
    p_calc_histogram         IN BOOLEAN);

  /**
   * Custom DATE/TIMESTAMP/TIMESTAMP WITH LOCAL TIME ZONE binning <br/>
   * Used by Transformation.
   *
   -- @param p_workflow_id          IN NUMBER,
   -- @param p_chain_step           IN VARCHAR2,
   -- @param p_input_sample_table   IN VARCHAR2,
   -- @param p_stats_table          IN VARCHAR2,
   -- @param p_all_xformed_attrs    IN OUT NAME_TYPE_ARRAY,
   -- @param p_unique_xformed_names combined list of all transformed column types
   -- @param p_prepare_binning_sql  IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY
   */
  PROCEDURE xform_cust_date_binning(
    p_workflow_id            IN NUMBER,
    p_chain_step             IN VARCHAR2,
    p_input_sample_table     IN VARCHAR2,
    p_stats_table            IN VARCHAR2,
    p_all_xformed_attrs      IN OUT NAME_TYPE_ARRAY,
    p_unique_xformed_names   IN OUT ODMR_OBJECT_NAMES,  -- combined list of all transformed column types
    p_prepare_binning_sql    IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY,
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2,
    p_parallel_table_hint    IN VARCHAR2,
    p_in_memory              IN BOOLEAN DEFAULT FALSE,
    p_compression            IN VARCHAR2 DEFAULT '',
    p_priority               IN VARCHAR2 DEFAULT '',
    p_calc_percent_distinct  IN BOOLEAN, 
    p_calc_percent_null      IN BOOLEAN, 
    p_calc_max               IN BOOLEAN, 
    p_calc_min               IN BOOLEAN, 
    p_calc_avg               IN BOOLEAN, 
    p_calc_stddev            IN BOOLEAN, 
    p_calc_variance          IN BOOLEAN, 
    p_calc_kurtosis          IN BOOLEAN, 
    p_calc_median            IN BOOLEAN, 
    p_calc_skewness          IN BOOLEAN, 
    p_calc_mode              IN BOOLEAN, 
    p_calc_mode_all          IN BOOLEAN,
    p_calc_histogram         IN BOOLEAN);

  /**
   * Custom TIMESTAMP WITH  TIME ZONE binning <br/>
   * Used by Transformation.
   *
   -- @param p_workflow_id          IN NUMBER,
   -- @param p_chain_step           IN VARCHAR2,
   -- @param p_input_sample_table   IN VARCHAR2,
   -- @param p_stats_table          IN VARCHAR2,
   -- @param p_all_xformed_attrs    IN OUT NAME_TYPE_ARRAY,
   -- @param p_unique_xformed_names Combined list of all transformed column types
   -- @param p_prepare_binning_sql  IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY
   */
  PROCEDURE xform_cust_ts_tz_binning(
    p_workflow_id           IN NUMBER,
    p_chain_step            IN VARCHAR2,
    p_input_sample_table    IN VARCHAR2,
    p_stats_table           IN VARCHAR2,
    p_all_xformed_attrs     IN OUT NAME_TYPE_ARRAY,
    p_unique_xformed_names  IN OUT ODMR_OBJECT_NAMES,
    p_prepare_binning_sql   IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY,
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_in_memory             IN BOOLEAN DEFAULT FALSE,
    p_compression           IN VARCHAR2 DEFAULT '',
    p_priority              IN VARCHAR2 DEFAULT '',
    p_calc_percent_distinct  IN BOOLEAN, 
    p_calc_percent_null      IN BOOLEAN, 
    p_calc_max               IN BOOLEAN, 
    p_calc_min               IN BOOLEAN, 
    p_calc_avg               IN BOOLEAN, 
    p_calc_stddev            IN BOOLEAN, 
    p_calc_variance          IN BOOLEAN, 
    p_calc_kurtosis          IN BOOLEAN, 
    p_calc_median            IN BOOLEAN, 
    p_calc_skewness          IN BOOLEAN, 
    p_calc_mode              IN BOOLEAN, 
    p_calc_mode_all          IN BOOLEAN,
    p_calc_histogram         IN BOOLEAN);

  /**
   * Custom categoric binning <br/>
   * Used by Transformation.
   *
   -- @param p_workflow_id          IN NUMBER,
   -- @param p_chain_step           IN VARCHAR2,
   -- @param p_input_sample_table   IN VARCHAR2,
   -- @param p_stats_table          IN VARCHAR2,
   -- @param p_all_xformed_attrs    IN OUT NAME_TYPE_ARRAY,
   -- @param p_unique_xformed_names combined list of all transformed column types
   -- @param p_prepare_binning_sql  IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY
   */
  PROCEDURE xform_cust_cat_binning(
    p_workflow_id           IN NUMBER,
    p_chain_step            IN VARCHAR2,
    p_input_sample_table    IN VARCHAR2,
    p_stats_table           IN VARCHAR2,
    p_all_xformed_attrs     IN OUT NAME_TYPE_ARRAY,
    p_unique_xformed_names  IN OUT ODMR_OBJECT_NAMES,  -- combined list of all transformed column types
    p_prepare_binning_sql   IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY,
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_in_memory             IN BOOLEAN,
    p_compression           IN VARCHAR2,
    p_priority              IN VARCHAR2,
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN);

  /**
   * Performs missing values transformation for categorical columns
   * Used by Transformation.
   *
   -- @param p_workflow_id          IN NUMBER,
   -- @param p_chain_step           IN VARCHAR2,
   -- @param p_input_sample_table   IN VARCHAR2,
   -- @param p_stats_table          IN VARCHAR2,
   -- @param p_all_xformed_attrs    combined list of all transformed column types
   -- @param p_cat_bins             number of bins to produce histogram
   -- @param p_unique_xformed_names IN OUT ODMR_OBJECT_NAMES,
   -- @param p_prepare_binning_sql  IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY
   */
  PROCEDURE xform_missing_values_cat(
    p_workflow_id           IN NUMBER,
    p_chain_step            IN VARCHAR2,
    p_input_sample_table    IN VARCHAR2,
    p_stats_table           IN VARCHAR2,
    p_all_xformed_attrs     IN OUT NAME_TYPE_ARRAY, -- combined list of all transformed column types
    p_cat_bins              IN NUMBER, -- number of bins to produce histogram
    p_unique_xformed_names  IN OUT ODMR_OBJECT_NAMES,
    p_prepare_binning_sql   IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY,  -- resulting SQL expressions
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN,
    p_other_label           IN VARCHAR2);

  /**
   * Performs missing values transformation for numeric columns <br/>
   * Used by Transformation.
   *
   -- @param p_workflow_id          IN NUMBER,
   -- @param p_chain_step           IN VARCHAR2,
   -- @param p_input_sample_table   IN VARCHAR2,
   -- @param p_stats_table          IN VARCHAR2,
   -- @param p_all_xformed_attrs    combined list of all transformed column types
   -- @param p_num_bins             INTEGER,
   -- @param p_unique_xformed_names IN OUT ODMR_OBJECT_NAMES,
   -- @param p_prepare_binning_sql  IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY
   */
  PROCEDURE xform_missing_values_num(
    p_workflow_id           IN NUMBER,
    p_chain_step            IN VARCHAR2,
    p_input_sample_table    IN VARCHAR2,
    p_stats_table           IN VARCHAR2,
    p_all_xformed_attrs     IN OUT NAME_TYPE_ARRAY, -- combined list of all transformed column types
    p_num_bins              INTEGER,
    p_unique_xformed_names  IN OUT ODMR_OBJECT_NAMES,
    p_prepare_binning_sql   IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY, -- resulting SQL expressions
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN);

  /**
   * Performs missing values transformation for date columns <br/>
   * Used by Transformation.
   *
   -- @param p_workflow_id          IN NUMBER,
   -- @param p_chain_step           IN VARCHAR2,
   -- @param p_input_sample_table   IN VARCHAR2,
   -- @param p_stats_table          IN VARCHAR2,
   -- @param p_all_xformed_attrs    combined list of all transformed column types
   -- @param p_date_bins            INTEGER,
   -- @param p_unique_xformed_names IN OUT ODMR_OBJECT_NAMES,
   -- @param p_prepare_binning_sql  resulting SQL expressions
   */
  PROCEDURE xform_missing_values_date(
    p_workflow_id           IN NUMBER,
    p_chain_step            IN VARCHAR2,
    p_input_sample_table    IN VARCHAR2,
    p_stats_table           IN VARCHAR2,
    p_all_xformed_attrs     IN OUT NAME_TYPE_ARRAY, -- combined list of all transformed column types
    p_date_bins             INTEGER,
    p_unique_xformed_names  IN OUT ODMR_OBJECT_NAMES,
    p_prepare_binning_sql   IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY, -- resulting SQL expressions
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN);

  /**
   * Performs outlier transformation for numeric columns <br/>
   * Used by Transformation.
   *
   -- @param p_workflow_id          IN NUMBER,
   -- @param p_chain_step           IN VARCHAR2,
   -- @param p_input_sample_table   IN VARCHAR2,
   -- @param p_stats_table          IN VARCHAR2,
   -- @param p_all_xformed_attrs    combined list of all transformed column types
   -- @param p_num_bins             INTEGER,
   -- @param p_unique_xformed_names IN OUT ODMR_OBJECT_NAMES,
   -- @param p_prepare_binning_sql  IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY
   */
  PROCEDURE xform_outlier(
    p_workflow_id           IN NUMBER,
    p_chain_step            IN VARCHAR2,
    p_input_sample_table    IN VARCHAR2,
    p_stats_table           IN VARCHAR2,
    p_all_xformed_attrs     IN OUT NAME_TYPE_ARRAY, -- combined list of all transformed column types
    p_num_bins              IN INTEGER,
    p_unique_xformed_names  IN OUT ODMR_OBJECT_NAMES,
    p_prepare_binning_sql   IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY, -- resulting SQL expressions
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN,
    p_nulls_label           IN VARCHAR2);

  /**
   * Performs normalization for numeric columns <br/>
   * Used by Transformation.
   *
   -- @param p_workflow_id           IN NUMBER,
   -- @param  p_chain_step           IN VARCHAR2,
   -- @param  p_input_sample_table   IN VARCHAR2,
   -- @param  p_stats_table          IN VARCHAR2,
   -- @param  p_all_xformed_attrs    combined list of all transformed column types
   -- @param  p_num_bins             IN INTEGER,
   -- @param  p_unique_xformed_names IN OUT ODMR_OBJECT_NAMES,
   -- @param  p_prepare_binning_sql  resulting SQL expressions
   */
  PROCEDURE xform_normalization(
    p_workflow_id           IN NUMBER,
    p_chain_step            IN VARCHAR2,
    p_input_sample_table    IN VARCHAR2,
    p_stats_table           IN VARCHAR2,
    p_all_xformed_attrs     IN OUT NAME_TYPE_ARRAY, -- combined list of all transformed column types
    p_num_bins              IN INTEGER,
    p_unique_xformed_names  IN OUT ODMR_OBJECT_NAMES,
    p_prepare_binning_sql   IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY, -- resulting SQL expressions
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN,
    p_nulls_label           IN VARCHAR2);

  /**
   * Performs custom transformation <br/>
   * Used by Transformation.
   *
   -- @param p_workflow_id          IN NUMBER,
   -- @param  p_chain_step           IN VARCHAR2,
   -- @param  p_input_sample_table   IN VARCHAR2,
   -- @param  p_stats_table          IN VARCHAR2,
   -- @param  p_all_xformed_attrs    IN OUT NAME_TYPE_ARRAY, -- combined list of all transformed column types
   -- @param  p_num_bins             IN INTEGER,
   -- @param  p_cat_bins             IN INTEGER,
   -- @param  p_date_bins            IN INTEGER,
   -- @param  p_unique_xformed_names IN OUT ODMR_OBJECT_NAMES,
   -- @param  p_prepare_binning_sql  IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY ); -- resulting SQL expressions
   */
  PROCEDURE xform_custom(
    p_workflow_id           IN NUMBER,
    p_chain_step            IN VARCHAR2,
    p_input_sample_table    IN VARCHAR2,
    p_stats_table           IN VARCHAR2,
    p_all_xformed_attrs     IN OUT NAME_TYPE_ARRAY, -- combined list of all transformed column types
    p_num_bins              IN INTEGER,
    p_cat_bins              IN INTEGER,
    p_date_bins             IN INTEGER,
    p_unique_xformed_names  IN OUT ODMR_OBJECT_NAMES,
    p_prepare_binning_sql   IN OUT ODMR_ENGINE.SQL_DEFINITION_ARRAY, -- resulting SQL expressions
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN);

  /**
   * CLIENT_TOPN code to be called from the client transformations node
   *
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_topn_bin_counts     topn bin number
   -- @param p_topn_other          topn "other" value
   */
  PROCEDURE CLIENT_TOPN(
    p_input_sample_table    IN VARCHAR2, -- name of the input sample table
    p_stats_table           IN VARCHAR2, -- name of the statistics table
    p_out_atrs              IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs              IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_topn_bin_counts       IN ODMR_OBJECT_IDS,  -- topn bin number
    p_topn_other            IN ODMR_OBJECT_VALUES,  -- topn "other" value
    p_null_labels           IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls         IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_in_memory             IN BOOLEAN DEFAULT FALSE,
    p_compression           IN VARCHAR2 DEFAULT '',
    p_priority              IN VARCHAR2 DEFAULT '',
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN);

  /**
   * CLIENT_TOPN_NC code to be called from the client transformations node for NVARCHAR2, NCHAR only
   *
   -- @param p_input_sample_table name of the input sample table
   -- @param  p_stats_table       name of the statistics table
   -- @param  p_out_atrs          list of output names for transformed columns
   -- @param  p_src_atrs          list of source columns for transformed columns
   -- @param p_topn_bin_counts    topn bin number
   -- @param p_topn_other         topn "other" value
   */
  PROCEDURE CLIENT_TOPN_NC(
    p_input_sample_table    IN VARCHAR2, -- name of the input sample table
    p_stats_table           IN VARCHAR2, -- name of the statistics table
    p_out_atrs              IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs              IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_topn_bin_counts       IN ODMR_OBJECT_IDS,  -- topn bin number
    p_topn_other            IN ODMR_OBJECT_VALUES,  -- topn "other" value
    p_null_labels           IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls         IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_in_memory             IN BOOLEAN DEFAULT FALSE,
    p_compression           IN VARCHAR2 DEFAULT '',
    p_priority              IN VARCHAR2 DEFAULT '',
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN);

  /**
   * CLIENT_EQ_WIDTH code to be called from the client transformations node
   *
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_src_atrs_types      list of source column types for transformed columns
   -- @param p_bin_counts          topn bin number
   -- @param p_bin_auto            BinGeneration auto
   -- @param p_bin_man             BinGeneration manual
   -- @param p_bin_num_seq         BinLabels num seq
   */
  PROCEDURE CLIENT_EQ_WIDTH(
    p_input_sample_table    IN VARCHAR2, -- name of the input sample table
    p_stats_table           IN VARCHAR2, -- name of the statistics table
    p_out_atrs              IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs              IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_src_atrs_types        IN ODMR_OBJECT_NAMES, -- list of source column types for transformed columns
    p_bin_counts            IN ODMR_OBJECT_IDS,  -- topn bin number
    p_bin_auto              IN ODMR_OBJECT_IDS,  -- BinGeneration auto
    p_bin_man               IN ODMR_OBJECT_IDS,  -- BinGeneration manual
    p_bin_num_seq           IN ODMR_OBJECT_IDS,  -- BinLabels num seq
    p_null_labels           IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls         IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids          IN ODMR_OBJECT_IDS,
    p_null_bin_selections   IN ODMR_OBJECT_NAMES,
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_in_memory             IN BOOLEAN DEFAULT FALSE,
    p_compression           IN VARCHAR2 DEFAULT '',
    p_priority              IN VARCHAR2 DEFAULT '',
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN );

  /**
   * CLIENT_DATE_EQ_WIDTH code to be called from the client transformations node
   *
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_bin_counts          topn bin number
   -- @param p_bin_auto            BinGeneration auto
   -- @param p_bin_man             BinGeneration manual
   -- @param p_bin_num_seq         BinLabels num seq
   */
  PROCEDURE CLIENT_DATE_EQ_WIDTH(
    p_input_sample_table    IN VARCHAR2, -- name of the input sample table
    p_stats_table           IN VARCHAR2, -- name of the statistics table
    p_out_atrs              IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs              IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_bin_counts            IN ODMR_OBJECT_IDS,  -- topn bin number
    p_bin_auto              IN ODMR_OBJECT_IDS,  -- BinGeneration auto
    p_bin_man               IN ODMR_OBJECT_IDS,  -- BinGeneration manual
    p_bin_num_seq           IN ODMR_OBJECT_IDS,  -- BinLabels num seq
    p_null_labels           IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls         IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids          IN ODMR_OBJECT_IDS,
    p_null_bin_selections   IN ODMR_OBJECT_NAMES,
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_in_memory             IN BOOLEAN DEFAULT FALSE,
    p_compression           IN VARCHAR2 DEFAULT '',
    p_priority              IN VARCHAR2 DEFAULT '',
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN );

  /**
   * CLIENT_TZ_EQ_WIDTH code to be called from the client transformations node
   * to transform (binning) of the TIMESTAMP WITH THE TIME ZONE columns*
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_bin_counts          bin number
   -- @param p_bin_auto            BinGeneration auto
   -- @param p_bin_man             BinGeneration manual
   -- @param p_bin_num_seq         BinLabels num seq
   */
  PROCEDURE CLIENT_TZ_EQ_WIDTH(
    p_input_sample_table    IN VARCHAR2, -- name of the input sample table
    p_stats_table           IN VARCHAR2, -- name of the statistics table
    p_out_atrs              IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs              IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_bin_counts            IN ODMR_OBJECT_IDS,  --  bin number
    p_bin_auto              IN ODMR_OBJECT_IDS,  -- BinGeneration auto
    p_bin_man               IN ODMR_OBJECT_IDS,  -- BinGeneration manual
    p_bin_num_seq           IN ODMR_OBJECT_IDS,  -- BinLabels num seq
    p_null_labels           IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls         IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids          IN ODMR_OBJECT_IDS,
    p_null_bin_selections   IN ODMR_OBJECT_NAMES,
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_in_memory             IN BOOLEAN DEFAULT FALSE,
    p_compression           IN VARCHAR2 DEFAULT '',
    p_priority              IN VARCHAR2 DEFAULT '',
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN );

  /**
   * CLIENT_QTILE code to be called from the client transformations node
   *
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_bin_counts          topn bin number
   -- @param p_bin_auto            BinGeneration auto
   -- @param p_bin_man             BinGeneration manual
   -- @param p_bin_num_seq         BinLabels num seq
   */
  PROCEDURE CLIENT_QTILE(
    p_input_sample_table    IN VARCHAR2, -- name of the input sample table
    p_stats_table           IN VARCHAR2, -- name of the statistics table
    p_out_atrs              IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs              IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_bin_counts            IN ODMR_OBJECT_IDS,  -- topn bin number
    p_bin_auto              IN ODMR_OBJECT_IDS,  -- BinGeneration auto
    p_bin_man               IN ODMR_OBJECT_IDS,  -- BinGeneration manual
    p_bin_num_seq           IN ODMR_OBJECT_IDS,  -- BinLabels num seq
    p_null_labels           IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls         IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids          IN ODMR_OBJECT_IDS,
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_in_memory             IN BOOLEAN DEFAULT FALSE,
    p_compression           IN VARCHAR2 DEFAULT '',
    p_priority              IN VARCHAR2 DEFAULT '',
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN);


  /**
   * CLIENT_CUSTOM_DATE code to be called from the client transformations node
   * deals with DATE/TIMESTAMP/TIMESTAMP WITH LOCAL TIME ZONE types
   *
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_bin_date_seq        BinLabels date seq
   -- @param p_cust_date_bin_names ODMR_OBJECT_VALUES,
   -- @param p_cust_date_low_bnds  ODMR_OBJECT_VALUES
   */
  PROCEDURE CLIENT_CUSTOM_DATE(
    p_input_sample_table      IN VARCHAR2, -- name of the input sample table
    p_stats_table             IN VARCHAR2, -- name of the statistics table
    p_out_atrs                IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs                IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_bin_date_seq            IN ODMR_OBJECT_IDS,  -- BinLabels date seq
    p_cust_date_bin_names     IN ODMR_OBJECT_VALUES,
    p_cust_date_low_bnds      IN ODMR_OBJECT_VALUES,
    p_null_labels             IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls           IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids            IN ODMR_OBJECT_IDS,
    p_parallel_query_hint     IN VARCHAR2,
    p_parallel_insert_hint    IN VARCHAR2,
    p_parallel_table_hint     IN VARCHAR2,
    p_in_memory               IN BOOLEAN DEFAULT FALSE,
    p_compression             IN VARCHAR2 DEFAULT '',
    p_priority                IN VARCHAR2 DEFAULT '',
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
    p_calc_histogram          IN BOOLEAN);

  /**
   * CLIENT_CUSTOM_TS_TZ code to be called from the client transformations node
   * deals with TIMESTAMP WITH TIME ZONE types
   *
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_bin_seq             BinLabels date seq
   -- @param p_bin_names           ODMR_OBJECT_VALUES,
   -- @param p_low_bnds            ODMR_OBJECT_VALUES
   */
  PROCEDURE CLIENT_CUSTOM_TS_TZ(
    p_input_sample_table      IN VARCHAR2, -- name of the input sample table
    p_stats_table             IN VARCHAR2, -- name of the statistics table
    p_out_atrs                IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs                IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_bin_seq                 IN ODMR_OBJECT_IDS,  -- BinLabels date seq
    p_bin_names               IN ODMR_OBJECT_VALUES,
    p_low_bnds                IN ODMR_OBJECT_VALUES,
    p_null_labels             IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls           IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids            IN ODMR_OBJECT_IDS,
    p_parallel_query_hint     IN VARCHAR2,
    p_parallel_insert_hint    IN VARCHAR2,
    p_parallel_table_hint     IN VARCHAR2,
    p_in_memory               IN BOOLEAN DEFAULT FALSE,
    p_compression             IN VARCHAR2 DEFAULT '',
    p_priority                IN VARCHAR2 DEFAULT '',
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
    p_calc_histogram          IN BOOLEAN);

  /**
   * CLIENT_CUSTOM_NUMERIC code to be called from the client transformations node
   *
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_bin_num_seq         BinLabels num seq
   -- @param p_cust_num_bin_names  ODMR_OBJECT_VALUES,
   -- @param p_cust_num_low_bnds   ODMR_OBJECT_IDS
   */
  PROCEDURE CLIENT_CUSTOM_NUMERIC(
    p_input_sample_table     IN VARCHAR2, -- name of the input sample table
    p_stats_table            IN VARCHAR2, -- name of the statistics table
    p_out_atrs               IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs               IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_bin_num_seq            IN ODMR_OBJECT_IDS,  -- BinLabels num seq
    p_cust_num_bin_names     IN ODMR_OBJECT_VALUES,
    p_cust_num_low_bnds      IN ODMR_OBJECT_IDS,
    p_null_labels            IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls          IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids           IN ODMR_OBJECT_IDS,
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2,
    p_parallel_table_hint    IN VARCHAR2,
    p_in_memory              IN BOOLEAN DEFAULT FALSE,
    p_compression            IN VARCHAR2 DEFAULT '',
    p_priority               IN VARCHAR2 DEFAULT '',
    p_calc_percent_distinct  IN BOOLEAN, 
    p_calc_percent_null      IN BOOLEAN, 
    p_calc_max               IN BOOLEAN, 
    p_calc_min               IN BOOLEAN, 
    p_calc_avg               IN BOOLEAN, 
    p_calc_stddev            IN BOOLEAN, 
    p_calc_variance          IN BOOLEAN, 
    p_calc_kurtosis          IN BOOLEAN, 
    p_calc_median            IN BOOLEAN, 
    p_calc_skewness          IN BOOLEAN, 
    p_calc_mode              IN BOOLEAN, 
    p_calc_mode_all          IN BOOLEAN,
    p_calc_histogram         IN BOOLEAN);

  /**
   * CLIENT_CUSTOM_CATEGORIC code to be called from the client transformations node
   *
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_cust_cat_bin_names  ODMR_OBJECT_VALUES,
   -- @param p_is_others           ODMR_OBJECT_IDS,
   -- @param p_bin_values          ODMR_OBJECT_VALUES 
   */
  PROCEDURE CLIENT_CUSTOM_CATEGORIC(
    p_input_sample_table      IN VARCHAR2, -- name of the input sample table
    p_stats_table             IN VARCHAR2, -- name of the statistics table
    p_out_atrs                IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs                IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_cust_cat_bin_names      IN ODMR_OBJECT_VALUES,
    p_is_others               IN ODMR_OBJECT_IDS,
    p_bin_values              IN ODMR_OBJECT_VALUES,
    p_null_labels             IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls           IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_parallel_query_hint     IN VARCHAR2,
    p_parallel_insert_hint    IN VARCHAR2,
    p_parallel_table_hint     IN VARCHAR2,
    p_in_memory               IN BOOLEAN DEFAULT FALSE,
    p_compression             IN VARCHAR2 DEFAULT '',
    p_priority                IN VARCHAR2 DEFAULT '',
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
    p_calc_histogram          IN BOOLEAN);

  /**
   * CLIENT_MV_NUM code to be called from the client transformations node
   * to perform missing values treatment of numeric columns
   *
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_mv_num_function     functions: Mean, Max, Min
   -- @param p_mv_num_replace      replacement values
   -- @param p_num_bins            number of bins to use for histogram
   */
  PROCEDURE CLIENT_MV_NUM(
    p_input_sample_table    IN VARCHAR2, -- name of the input sample table
    p_stats_table           IN VARCHAR2, -- name of the statistics table
    p_out_atrs              IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs              IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_mv_num_function       IN ODMR_OBJECT_VALUES,  -- functions: Mean, Max, Min
    p_mv_num_replace        IN ODMR_OBJECT_IDS,  -- replacement values
    p_num_bins              IN INTEGER, -- number of bins to use for histogram
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN );
    
  /**
   * CLIENT_MV_CAT code to be called from the client transformations node
   * to perform missing values treatment of categoric columns
   *
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_src_atrs_types_mvc  list of source types for cust. cat
   -- @param p_mv_cat_function     functions: Mode
   -- @param p_mv_cat_replace      replacement values
   -- @param p_cat_bins            number of bins to produce histogram
   */
  PROCEDURE CLIENT_MV_CAT(
    p_input_sample_table    IN VARCHAR2, -- name of the input sample table
    p_stats_table           IN VARCHAR2, -- name of the statistics table
    p_out_atrs              IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs              IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_src_atrs_types_mvc    IN ODMR_OBJECT_NAMES, -- list of source types for cust. cat
    p_mv_cat_function       IN ODMR_OBJECT_VALUES,  -- functions: Mode
    p_mv_cat_replace        IN ODMR_OBJECT_VALUES, -- replacement values
    p_cat_bins              IN NUMBER, -- number of bins to produce histogram
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN,
    p_other_label           IN VARCHAR2);

  /**
   * CLIENT_MV_DATE code to be called from the client transformations node
   * to perform missing values treatment of DATE/TIMESTAMP
   *
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_mv_cat_function     functions: Mode
   -- @param p_mv_cat_replace      replacement values
   -- @param p_cat_bins            number of bins to produce histogram
   */
  PROCEDURE CLIENT_MV_DATE(
    p_input_sample_table    IN VARCHAR2, -- name of the input sample table
    p_stats_table           IN VARCHAR2, -- name of the statistics table
    p_out_atrs              IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs              IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_mv_cat_function       IN ODMR_OBJECT_VALUES,  -- functions: Mode
    p_mv_cat_replace        IN ODMR_OBJECT_VALUES, -- replacement values
    p_cat_bins              IN NUMBER, -- number of bins to produce histogram
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN);

  /**
   * CLIENT_MV_TZ code to be called from the client transformations node
   *       to perform missing values treatment of TIMESTAMP WITH LOCAL TIME ZONE
   *
   -- @param p_input_sample_table  name of the input sample table
   -- @param p_stats_table         name of the statistics table
   -- @param p_out_atrs            list of output names for transformed columns
   -- @param p_src_atrs            list of source columns for transformed columns
   -- @param p_mv_cat_function     functions: Mode
   -- @param p_mv_cat_replace      replacement values
   -- @param p_cat_bins            number of bins to produce histogram
   */
  PROCEDURE CLIENT_MV_TZ(
    p_input_sample_table    IN VARCHAR2, -- name of the input sample table
    p_stats_table           IN VARCHAR2, -- name of the statistics table
    p_out_atrs              IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs              IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_mv_cat_function       IN ODMR_OBJECT_VALUES,  -- functions: Mode
    p_mv_cat_replace        IN ODMR_OBJECT_VALUES, -- replacement values
    p_cat_bins              IN NUMBER, -- number of bins to produce histogram
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_calc_percent_distinct IN BOOLEAN, 
    p_calc_percent_null     IN BOOLEAN, 
    p_calc_max              IN BOOLEAN, 
    p_calc_min              IN BOOLEAN, 
    p_calc_avg              IN BOOLEAN, 
    p_calc_stddev           IN BOOLEAN, 
    p_calc_variance         IN BOOLEAN, 
    p_calc_kurtosis         IN BOOLEAN, 
    p_calc_median           IN BOOLEAN, 
    p_calc_skewness         IN BOOLEAN, 
    p_calc_mode             IN BOOLEAN, 
    p_calc_mode_all         IN BOOLEAN,
    p_calc_histogram        IN BOOLEAN);

  /**
   * CLIENT_OUTLIER code to be called from the client transformations node
   *               to perform outlier treatment of numeric columns
   *
   -- @param p_input_sample_table      name of the input sample table
   -- @param p_stats_table             name of the statistics table
   -- @param p_meta_stats_table_name   VARCHAR2,
   -- @param p_out_atrs                list of output names for transformed columns
   -- @param p_src_atrs                list of source columns for transformed columns
   -- @param p_outlier_type            StandardDeviation, Value, Percent
   -- @param p_replace_with            EdgeValues or Nulls
   -- @param p_outlier_multiple_value  outlier multiple
   -- @param p_outlier_lower_value     outlier lower value
   -- @param p_outlier_upper_value     outlier upper value
   -- @param p_outlier_lower_percent   outlier lower percent
   -- @param p_outlier_upper_percent   outlier upper percent
   -- @param p_num_bins                number of bins to use for histogram
   */
  PROCEDURE CLIENT_OUTLIER(
    p_input_sample_table      IN VARCHAR2, -- name of the input sample table
    p_stats_table             IN VARCHAR2, -- name of the statistics table
    p_meta_stats_table_name   IN VARCHAR2,
    p_out_atrs                IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs                IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_outlier_type            IN ODMR_OBJECT_VALUES, -- StandardDeviation, Value, Percent
    p_replace_with            IN ODMR_OBJECT_VALUES, -- EdgeValues or Nulls
    p_outlier_multiple_value  IN ODMR_OBJECT_IDS,  -- outlier multiple
    p_outlier_lower_value     IN ODMR_OBJECT_IDS,  -- outlier lower value
    p_outlier_upper_value     IN ODMR_OBJECT_IDS,  -- outlier upper value
    p_outlier_lower_percent   IN ODMR_OBJECT_IDS,  -- outlier lower percent
    p_outlier_upper_percent   IN ODMR_OBJECT_IDS,  -- outlier upper percent
    p_num_bins                IN INTEGER, -- number of bins to use for histogram
    p_parallel_query_hint     IN VARCHAR2,
    p_parallel_insert_hint    IN VARCHAR2,
    p_parallel_table_hint     IN VARCHAR2,
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
    p_nulls_label             IN VARCHAR2);

  /**
   * CLIENT_NORMALIZATION code to be called from the client transformations node
   *               to perform normalization of numeric columns
   *
   -- @param p_input_sample_table      name of the input sample table
   -- @param p_stats_table             name of the statistics table
   -- @param p_out_atrs                list of output names for transformed columns
   -- @param p_src_atrs                list of source columns for transformed columns
   -- @param p_norm_type               MinMax, ZScore, LinearScale, Custom
   -- @param p_norm_custom_shift       custom shift
   -- @param p_norm_custom_scale       custom scale
   -- @param p_num_bins                number of bins to use for histogram
   */
  PROCEDURE CLIENT_NORMALIZATION(
    p_input_sample_table      IN VARCHAR2, -- name of the input sample table
    p_stats_table             IN VARCHAR2, -- name of the statistics table
    p_out_atrs                IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs                IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_norm_type               IN ODMR_OBJECT_VALUES, -- MinMax, ZScore, LinearScale, Custom
    p_norm_custom_shift       IN ODMR_OBJECT_IDS,  -- custom shift
    p_norm_custom_scale       IN ODMR_OBJECT_IDS,  -- custom scale
    p_num_bins                IN INTEGER, -- number of bins to use for histogram
    p_parallel_query_hint     IN VARCHAR2,
    p_parallel_insert_hint    IN VARCHAR2,
    p_parallel_table_hint     IN VARCHAR2,
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
    p_nulls_label             IN VARCHAR2);

  /**
   * CLIENT_CUSTOM code to be called from the client transformations node
   *               to perform custom transformation
   *
   -- @param p_input_sample_table      name of the input sample table
   -- @param p_stats_table             name of the statistics table
   -- @param p_out_atrs                list of output names for transformed columns
   -- @param p_src_atrs                list of source columns for transformed columns
   -- @param p_cust_transforms         ODMR_OBJECT_VALUES,
   -- @param p_num_bins                number of bins to use for histogram
   -- @param p_cat_bins                number of bins to produce histogram
   -- @param p_date_bins               number of bins to produce histogram
   */
  PROCEDURE CLIENT_CUSTOM(
    p_input_sample_table      IN VARCHAR2, -- name of the input sample table
    p_stats_table             IN VARCHAR2, -- name of the statistics table
    p_out_atrs                IN ODMR_OBJECT_NAMES, -- list of output names for transformed columns
    p_src_atrs                IN ODMR_OBJECT_NAMES, -- list of source columns for transformed columns
    p_cust_transforms         IN ODMR_OBJECT_VALUES, -- MinMax, ZScore, LinearScale, Custom
    p_num_bins                IN INTEGER, -- number of bins to use for histogram
    p_cat_bins                IN INTEGER, -- number of bins to produce histogram
    p_date_bins               IN INTEGER, -- number of bins to produce histogram
    p_parallel_query_hint     IN VARCHAR2,
    p_parallel_insert_hint    IN VARCHAR2,
    p_parallel_table_hint     IN VARCHAR2,
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
    p_calc_histogram          IN BOOLEAN);

END;
/
