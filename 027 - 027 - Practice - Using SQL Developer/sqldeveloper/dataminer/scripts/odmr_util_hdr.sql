CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_UTIL" 
AUTHID CURRENT_USER AS

   TYPE BINNING_GROUP IS RECORD (
      included_list           ODMR_OBJECT_NAMES,
      bin_number              NUMBER );

    TYPE BIN_NUMBERS_ARRAY IS TABLE OF BINNING_GROUP INDEX BY VARCHAR2(32);

    TYPE LOOKUPTYPE IS TABLE OF ODMR_INTERNAL_UTIL.TYPE_VCHAR_130 
                          INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  /***
   * Creates table from the user defined sql. <br/ >
   * This procedure is available for the client code.
   *
   -- @param p_result_table_name   name of the result table
   -- @param p_primary_keys        
   -- @param p_indices              
   -- @param p_attributes          list of attributes
   -- @param p_src_table           name of the src table or view
   */
  FUNCTION create_table_external(
    p_workflowId          IN NUMBER,
    p_nodeId              IN VARCHAR2,
    p_result_table_name   IN VARCHAR2,
    p_primary_keys        IN ODMR_OBJECT_NAMES,
    p_indices             IN ODMR_OBJECT_NAMES,
    p_attributes          IN ODMR_OBJECT_NAMES,
    p_col_types           IN ODMR_OBJECT_NAMES,
    p_src_table           IN VARCHAR2,
    p_parallel_table_hint IN VARCHAR2,
    p_table_compression   IN VARCHAR2 DEFAULT 'NONE',
    p_logging             IN VARCHAR2 DEFAULT 'NOLOGGING') RETURN NUMBER;

  /**
   * Creates view from the user defined specification 
   *
   -- @param p_workflowId        IN NUMBER,
   -- @param p_nodeId            IN VARCHAR2,
   -- @param p_result_view_name  IN VARCHAR2,
   -- @param p_attributes        IN ODMR_OBJECT_NAMES,
   -- @param p_src_table         IN VARCHAR2
   */
  PROCEDURE create_view_from_spec(
    p_workflowId          IN NUMBER,
    p_nodeId              IN VARCHAR2,
    p_result_view_name    IN VARCHAR2,
    p_attributes          IN ODMR_OBJECT_NAMES,
    p_src_table           IN VARCHAR2,
    p_parallel_query_hint IN VARCHAR2
    );

  /**
   * Creates view from the user defined specification 
   *
   -- @param p_workflowId        IN NUMBER,
   -- @param p_nodeId            IN VARCHAR2,
   -- @param p_result_view_name  IN VARCHAR2,
   -- @param p_attributes        IN ODMR_OBJECT_NAMES,
   -- @param p_src_table         IN ODMR_INTERNAL_UTIL
   */
  PROCEDURE create_view_from_spec(
    p_workflowId          IN NUMBER,
    p_nodeId              IN VARCHAR2,
    p_result_view_name    IN VARCHAR2,
    p_attributes          IN ODMR_OBJECT_NAMES,
    p_sql                 IN ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE,
    p_parallel_query_hint IN VARCHAR2
    );


  /**
   * Returns specification for the input sql.
   *
   -- @param p_input_sql    SQL expression to evaluate
   -- @param all            the rest are arrays of primitives describing he SQL
   */
  PROCEDURE DESCRIBE_SQL_EXPRESSION(
     p_input_sql  IN     CLOB,
     p_col_names  IN OUT ODMR_OBJECT_VALUES,
     p_col_types  IN OUT ODMR_OBJECT_NAMES,
     p_data_legth IN OUT ODMR_OBJECT_IDS,
     p_precision  IN OUT ODMR_OBJECT_IDS,
     p_scale      IN OUT ODMR_OBJECT_IDS );

--  FUNCTION GENERATE_DEFAULT_DATE_BINS(
--    p_input_sql              IN CLOB, -- input data
--    p_input_column_name      IN VARCHAR2,  -- input column to get bins
--    p_bin_count              IN NUMBER-- number of bins
--    ) RETURN VARCHAR2;
--
  
  /**
   * returns list of default bins for:TIMESTAMP WITH ZONE
   *
   -- @param p_input_sql              input data
   -- @param p_input_column_name      input column to bin
   -- @param p_bin_count              number of bins
   */
  FUNCTION GENERATE_DEFAULT_TS_TZ_BINS(
    p_input_sql               IN CLOB, -- input data
    p_input_column_name       IN VARCHAR2,  -- input column to bin
    p_bin_count               IN NUMBER,-- number of bins
    p_parallel_query_hint     IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
    p_parallel_insert_hint    IN VARCHAR2 DEFAULT ' ',
    p_parallel_table_hint     IN VARCHAR2 DEFAULT 'NOPARALLEL') RETURN VARCHAR2;

  /**
   * Returns list of default bins
   *
   -- @param p_input_sql              input data
   -- @param p_col_names              resulting bin names
   -- @param p_bin_num_values         resulting bin values
   -- @param p_bin_cat_values         resulting bin values
   -- @param p_bin_categories         resulting bin categories
   -- @param p_disinct_values         all available distinc values
   -- @param p_input_column_name      input column to get bins
   -- @param p_input_column_type      input column data type
   -- @param p_binning_type           EQWIDTH, QTILE, TOPN
   -- @param p_auto                   1 - auto, 0 - manual
   -- @param p_bin_count              number of bins
   */
  PROCEDURE GENERATE_DEFAULT_BINS(
    p_input_sql              IN CLOB, -- input data
    p_col_names              IN OUT ODMR_OBJECT_NAMES, -- resulting bin names
    p_bin_num_values         IN OUT ODMR_OBJECT_IDS, -- resulting bin values
    p_bin_cat_values         IN OUT ODMR_OBJECT_VALUES, -- resulting bin values
    p_bin_categories         IN OUT ODMR_OBJECT_VALUES, -- resulting bin categories, or for topN
    p_disinct_values         IN OUT ODMR_OBJECT_VALUES, -- all available distinc values
    p_input_column_name      IN VARCHAR2,  -- input column to get bins
    p_input_column_type      IN VARCHAR2,  -- input column data type
    p_binning_type           IN VARCHAR2,  -- EQWIDTH, QTILE, TOPN
    p_auto                   IN INTEGER,   -- 1 - auto, 0 - manual
    p_bin_count              IN NUMBER,    -- number of bins
    p_parallel_query_hint    IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
    p_parallel_insert_hint   IN VARCHAR2 DEFAULT ' ' );

  PROCEDURE GENERATE_DEFAULT_BINS_TOPN(
    p_input_sql              IN CLOB, -- input data
    p_col_names              IN OUT ODMR_OBJECT_NAMES, -- resulting bin names
    p_bin_cat_values         IN OUT ODMR_OBJECT_VALUES, -- resulting bin values
    p_bin_categories         IN OUT ODMR_OBJECT_VALUES, -- resulting bin categories, or for topN
    p_disinct_values         IN OUT ODMR_OBJECT_VALUES, -- all available distinct values
    p_frequencies            IN OUT ODMR_OBJECT_IDS, -- frequencies
    p_input_column_name      IN VARCHAR2,  -- input column to get bins
    p_bin_count              IN NUMBER,    -- number of bins
    p_parallel_query_hint    IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
    p_parallel_insert_hint   IN VARCHAR2 DEFAULT ' ' );
  
  /**
   * Code to be called from the client transformations node
   *
   -- @param p_input_sample_table   name of the input sample table
   -- @param  p_statistics_table    name of the existing stats table
   -- @param p_cat_bins             number of cat bins to use for histogram
   -- @param p_num_bins             number of num bins to use for histogram
   -- @param p_date_bins            number of num bins to use for histogram
   -- @param p_src_columns          list of src columns for which statsistics is missing
   -- @param p_src_col_types        list of src columns for which statsistics is missing
   -- @param p_out_atrs_topn        list of output names for topn
   -- @param p_src_atrs_topn        list of source columns for topn
   -- @param p_topn_bin_counts      topn bin number
   -- @param p_topn_other           topn "other" value
   -- @param p_out_atrs_topn_nc     list of output names for topn
   -- @param p_src_atrs_topn_nc     list of source columns for topn
   -- @param p_topn_bin_counts_nc topn bin number
   -- @param p_topn_other_nc      topn "other" value
   -- @param p_out_atrs_eqw       list of output names for eq.width
   -- @param p_src_atrs_eqw       list of source columns for eq.width
   -- @param p_src_atrs_eqw_types list of source columns types for eq.width
   -- @param p_bin_counts_eqw     eqw bin number
   -- @param p_bin_auto_eqw       BinGeneration auto
   -- @param p_bin_man_eqw        BinGeneration manual
   -- @param p_bin_num_seq_eqw    BinLabels num seq
   -- @param p_out_atrs_date_eqw  list of output names for eq.width
   -- @param p_src_atrs_date_eqw  list of source columns for eq.width
   -- @param p_bin_counts_date_eqw eqw bin number
   -- @param p_bin_auto_date_eqw  BinGeneration auto
   -- @param p_bin_man_date_eqw   BinGeneration manual
   -- @param p_bin_num_seq_date_eqw BinLabels num seq
   -- @param p_out_atrs_tz_eqw  list of output names for eq.width
   -- @param p_src_atrs_tz_eqw  list of source columns for eq.width
   -- @param p_bin_counts_tz_eqw eqw bin number
   -- @param p_bin_auto_tz_eqw  BinGeneration auto
   -- @param p_bin_man_tz_eqw   BinGeneration manual
   -- @param p_bin_num_seq_tz_eqw BinLabels num seq
   -- @param p_out_atrs_qtile     list of output names for qtile
   -- @param p_src_atrs_qtile     list of source columns for qtile
   -- @param p_bin_counts_qtile   qtile bin number
   -- @param p_bin_auto_qtile     BinGeneration auto
   -- @param p_bin_man_qtile      BinGeneration manual
   -- @param p_bin_num_seq_qtile  BinLabels num seq
   -- @param p_out_atrs_cus_date  list of output names for cust. date
   -- @param p_src_atrs_cus_date  list of source columns for cust. date
   -- @param p_bin_date_seq       BinLabels date seq
   -- @param p_cust_date_bin_names 
   -- @param p_cust_date_low_bnds 
   -- @param p_out_atrs_cus_ts_tz   list of output names for cust. timestamp with time zone
   -- @param p_src_atrs_cus_ts_tz   list of source columns for cust. timestamp with time zone
   -- @param p_bin_ts_tz_seq        BinLabels date seq
   -- @param p_cust_ts_tz_bin_names 
   -- @param p_cust_ts_tz_low_bnds  
   -- @param p_out_atrs_cusn      list of output names for cust. num
   -- @param p_src_atrs_cusn      list of source columns for cust. num
   -- @param p_bin_num_seq_cusn   BinLabels num seq
   -- @param p_num_bin_names_cusn  
   -- @param p_num_low_bnds_cusn  
   -- @param p_out_atrs_cusc      list of output names for cust. cat
   -- @param p_src_atrs_cusc      list of source columns for cust. cat
   -- @param p_cat_bin_names_cusc 
   -- @param p_is_others_cusc     
   -- @param p_bin_values_cusc    
   -- @param p_out_atrs_mvc       list of output names for cust. cat
   -- @param p_src_atrs_mvc       list of source columns for cust. cat
   -- @param p_src_atrs_types_mvc list of source types for cust. cat
   -- @param p_mv_cat_function    functions: Mode
   -- @param p_mv_cat_replace     replacement values
   -- @param p_out_atrs_mvn       list of output names for cust. cat
   -- @param p_src_atrs_mvn       list of source columns for cust. cat
   -- @param p_mv_num_function    functions: Mean, Max, Min
   -- @param p_mv_num_replace     replacement values
   -- @param p_out_atrs_mv_date     list of output names for cust. cat
   -- @param p_src_atrs_mv_date     list of source columns for cust. cat
   -- @param p_mv_date_function     functions: Mean, Max, Min
   -- @param p_mv_date_replace      replacement values
   -- @param p_out_atrs_mv_tz       list of output names for cust. cat
   -- @param p_src_atrs_mv_tz       list of source columns for cust. cat
   -- @param p_mv_tz_function       functions: Mean, Max, Min
   -- @param p_mv_tz_replace        replacement values
   -- @param p_meta_statistics_table   name of the stats table in the metadata
   -- @param p_out_atrs_outlier        list of output names for cust. cat
   -- @param p_src_atrs_outlier        list of source columns for cust. cat
   -- @param p_outlier_type            tandardDeviation, Value, Percent
   -- @param p_replace_with            EdgeValues or Nulls
   -- @param p_outlier_multiple_value  outlier multiple
   -- @param p_outlier_upper_value     outlier upper value
   -- @param p_outlier_lower_percent   outlier lower percent
   -- @param p_outlier_upper_percent   outlier upper percent
   -- @param p_out_atrs_norm      list of output names for Normalization
   -- @param p_src_atrs_norm      list of source columns for Normalization
   -- @param p_norm_type          MinMax, ZScore, LinearScale, Custom
   -- @param p_norm_custom_shift  custom shift
   -- @param p_norm_custom_scale  custom scale
   -- @param p_out_atrs_custom    list of output names for Custom
   -- @param p_src_atrs_custom    list of source columns for Custom
   -- @param p_cust_transforms    custom sql expresions
   */
  FUNCTION CLIENT_TRANSFORM(
    p_input_sample_table      IN VARCHAR2, -- name of the input sample table
    p_statistics_table        IN VARCHAR2, -- name of the existing stats table
    p_cat_bins                IN INTEGER, -- number of cat bins to use for histogram
    p_num_bins                IN INTEGER, -- number of num bins to use for histogram
    p_date_bins               IN INTEGER, -- number of num bins to use for histogram
    p_nulls_label             IN VARCHAR2, -- label to use for NULL values
    p_other_label             IN VARCHAR2,-- label to use for Other values
    -- missing statistics
    p_src_columns             IN ODMR_OBJECT_NAMES, -- list of src columns for which statsistics is missing
    p_src_col_types           IN ODMR_OBJECT_NAMES, -- list of src columns for which statsistics is missing
    -- topn
    p_out_atrs_topn           IN ODMR_OBJECT_NAMES, -- list of output names for topn
    p_src_atrs_topn           IN ODMR_OBJECT_NAMES, -- list of source columns for topn
    p_topn_bin_counts         IN ODMR_OBJECT_IDS,  -- topn bin number
    p_topn_other              IN ODMR_OBJECT_VALUES,  -- topn "other" value
    p_null_labels             IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls           IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    -- topn NC
    p_out_atrs_topn_nc        IN ODMR_OBJECT_NAMES, -- list of output names for topn
    p_src_atrs_topn_nc        IN ODMR_OBJECT_NAMES, -- list of source columns for topn
    p_topn_bin_counts_nc      IN ODMR_OBJECT_IDS,  -- topn bin number
    p_topn_other_nc           IN ODMR_OBJECT_VALUES,  -- topn "other" value
    p_null_labels_nc          IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls_nc        IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    -- eqw
    p_out_atrs_eqw            IN ODMR_OBJECT_NAMES, -- list of output names for eq.width
    p_src_atrs_eqw            IN ODMR_OBJECT_NAMES, -- list of source columns for eq.width
    p_src_atrs_eqw_types      IN ODMR_OBJECT_NAMES, -- list of source columns types for eq.width
    p_bin_counts_eqw          IN ODMR_OBJECT_IDS,  -- eqw bin number
    p_bin_auto_eqw            IN ODMR_OBJECT_IDS,  -- BinGeneration auto
    p_bin_man_eqw             IN ODMR_OBJECT_IDS,  -- BinGeneration manual
    p_bin_num_seq_eqw         IN ODMR_OBJECT_IDS,  -- BinLabels num seq
    p_null_labels_eqw         IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls_eqw       IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids_eqw        IN ODMR_OBJECT_IDS,   -- bin id's for NULL values
    p_null_bin_selections_eqw IN ODMR_OBJECT_NAMES,
    -- date eqw
    p_out_atrs_date_eqw       IN ODMR_OBJECT_NAMES, -- list of output names for eq.width
    p_src_atrs_date_eqw       IN ODMR_OBJECT_NAMES, -- list of source columns for eq.width
    p_bin_counts_date_eqw     IN ODMR_OBJECT_IDS,  -- eqw bin number
    p_bin_auto_date_eqw       IN ODMR_OBJECT_IDS,  -- BinGeneration auto
    p_bin_man_date_eqw        IN ODMR_OBJECT_IDS,  -- BinGeneration manual
    p_bin_num_seq_date_eqw    IN ODMR_OBJECT_IDS,  -- BinLabels num seq
    p_null_labels_date_eqw    IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls_date_eqw  IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids_date_eqw   IN ODMR_OBJECT_IDS,   -- bin id's for NULL values
    p_null_bin_selections_date_eqw IN ODMR_OBJECT_NAMES,
    -- TIMESTAMP WITH TIME ZONE   eqw
    p_out_atrs_tz_eqw         IN ODMR_OBJECT_NAMES, -- list of output names for eq.width
    p_src_atrs_tz_eqw         IN ODMR_OBJECT_NAMES, -- list of source columns for eq.width
    p_bin_counts_tz_eqw       IN ODMR_OBJECT_IDS,  -- eqw bin number
    p_bin_auto_tz_eqw         IN ODMR_OBJECT_IDS,  -- BinGeneration auto
    p_bin_man_tz_eqw          IN ODMR_OBJECT_IDS,  -- BinGeneration manual
    p_bin_num_seq_tz_eqw      IN ODMR_OBJECT_IDS,  -- BinLabels num seq
    p_null_labels_tz_eqw      IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls_tz_eqw    IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids_tz_eqw     IN ODMR_OBJECT_IDS,   -- bin id's for NULL values
    p_null_bin_selections_tz_eqw IN ODMR_OBJECT_NAMES,
    -- qtile
    p_out_atrs_qtile          IN ODMR_OBJECT_NAMES, -- list of output names for qtile
    p_src_atrs_qtile          IN ODMR_OBJECT_NAMES, -- list of source columns for qtile
    p_bin_counts_qtile        IN ODMR_OBJECT_IDS,  -- qtile bin number
    p_bin_auto_qtile          IN ODMR_OBJECT_IDS,  -- BinGeneration auto
    p_bin_man_qtile           IN ODMR_OBJECT_IDS,  -- BinGeneration manual
    p_bin_num_seq_qtile       IN ODMR_OBJECT_IDS,  -- BinLabels num seq
    p_null_labels_qtile       IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls_qtile     IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids_qtile       IN ODMR_OBJECT_IDS,   -- bin id's for NULL values
    -- cust. date
    p_out_atrs_cus_date       IN ODMR_OBJECT_NAMES, -- list of output names for cust. date
    p_src_atrs_cus_date       IN ODMR_OBJECT_NAMES, -- list of source columns for cust. date
    p_bin_date_seq            IN ODMR_OBJECT_IDS,  -- BinLabels date seq
    p_cust_date_bin_names     IN ODMR_OBJECT_VALUES, 
    p_cust_date_low_bnds      IN ODMR_OBJECT_VALUES,
    p_null_labels_cus_date    IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls_cus_date  IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids_cus_date   IN ODMR_OBJECT_IDS,   -- bin id's for NULL values
    -- cust. timestamp with time zone
    p_out_atrs_cus_ts_tz      IN ODMR_OBJECT_NAMES, -- list of output names for cust. timestamp with time zone
    p_src_atrs_cus_ts_tz      IN ODMR_OBJECT_NAMES, -- list of source columns for cust. timestamp with time zone
    p_bin_ts_tz_seq           IN ODMR_OBJECT_IDS,  -- BinLabels date seq
    p_cust_ts_tz_bin_names    IN ODMR_OBJECT_VALUES, 
    p_cust_ts_tz_low_bnds     IN ODMR_OBJECT_VALUES,
    p_null_labels_cus_ts_tz   IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls_cus_ts_tz IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids_cus_ts_tz  IN ODMR_OBJECT_IDS,   -- bin id's for NULL values
    -- cust n.
    p_out_atrs_cusn           IN ODMR_OBJECT_NAMES, -- list of output names for cust. num
    p_src_atrs_cusn           IN ODMR_OBJECT_NAMES, -- list of source columns for cust. num
    p_bin_num_seq_cusn        IN ODMR_OBJECT_IDS,  -- BinLabels num seq
    p_num_bin_names_cusn      IN ODMR_OBJECT_VALUES, 
    p_num_low_bnds_cusn       IN ODMR_OBJECT_IDS,
    p_null_labels_cusn        IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls_cusn      IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_nuls_bin_ids_cusn       IN ODMR_OBJECT_IDS,   -- bin id's for NULL values
    -- cust c.
    p_out_atrs_cusc           IN ODMR_OBJECT_NAMES, -- list of output names for cust. cat
    p_src_atrs_cusc           IN ODMR_OBJECT_NAMES, -- list of source columns for cust. cat
    p_cat_bin_names_cusc      IN ODMR_OBJECT_VALUES, 
    p_is_others_cusc          IN ODMR_OBJECT_IDS,
    p_bin_values_cusc         IN ODMR_OBJECT_VALUES,
    p_null_labels_cusc        IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls_cusc      IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    -- miss. val. cat
    p_out_atrs_mvc            IN ODMR_OBJECT_NAMES, -- list of output names for cust. cat
    p_src_atrs_mvc            IN ODMR_OBJECT_NAMES, -- list of source columns for cust. cat
    p_src_atrs_types_mvc      IN ODMR_OBJECT_NAMES, -- list of source types for cust. cat
    p_mv_cat_function         IN ODMR_OBJECT_VALUES,  -- functions: Mode
    p_mv_cat_replace          IN ODMR_OBJECT_VALUES,  -- replacement values
    -- miss. val. num
    p_out_atrs_mvn            IN ODMR_OBJECT_NAMES, -- list of output names for cust. cat
    p_src_atrs_mvn            IN ODMR_OBJECT_NAMES, -- list of source columns for cust. cat
    p_mv_num_function         IN ODMR_OBJECT_VALUES,  -- functions: Mean, Max, Min
    p_mv_num_replace          IN ODMR_OBJECT_IDS,  -- replacement values
    -- miss. val. timestamp with timezone
    p_out_atrs_mv_date        IN ODMR_OBJECT_NAMES, -- list of output names for cust. cat
    p_src_atrs_mv_date        IN ODMR_OBJECT_NAMES, -- list of source columns for cust. cat
    p_mv_date_function        IN ODMR_OBJECT_VALUES,  -- functions: Mean, Max, Min
    p_mv_date_replace         IN ODMR_OBJECT_VALUES,  -- replacement values
    -- miss. val. timestamp/date
    p_out_atrs_mv_tz          IN ODMR_OBJECT_NAMES, -- list of output names for cust. cat
    p_src_atrs_mv_tz          IN ODMR_OBJECT_NAMES, -- list of source columns for cust. cat
    p_mv_tz_function          IN ODMR_OBJECT_VALUES,  -- functions: Mean, Max, Min
    p_mv_tz_replace           IN ODMR_OBJECT_VALUES,  -- replacement values
    -- outlier
    p_meta_statistics_table   IN VARCHAR2, -- name of the stats table in the metadata
    p_out_atrs_outlier        IN ODMR_OBJECT_NAMES, -- list of output names for cust. cat
    p_src_atrs_outlier        IN ODMR_OBJECT_NAMES, -- list of source columns for cust. cat
    p_outlier_type            IN ODMR_OBJECT_VALUES, -- StandardDeviation, Value, Percent
    p_replace_with            IN ODMR_OBJECT_VALUES, -- EdgeValues or Nulls
    p_outlier_multiple_value  IN ODMR_OBJECT_IDS,  -- outlier multiple
    p_outlier_lower_value     IN ODMR_OBJECT_IDS,  -- outlier lower value
    p_outlier_upper_value     IN ODMR_OBJECT_IDS,  -- outlier upper value
    p_outlier_lower_percent   IN ODMR_OBJECT_IDS,  -- outlier lower percent
    p_outlier_upper_percent   IN ODMR_OBJECT_IDS,  -- outlier upper percent
    -- normalization
    p_out_atrs_norm           IN ODMR_OBJECT_NAMES,  -- list of output names for Normalization
    p_src_atrs_norm           IN ODMR_OBJECT_NAMES,  -- list of source columns for Normalization
    p_norm_type               IN ODMR_OBJECT_VALUES, -- MinMax, ZScore, LinearScale, Custom
    p_norm_custom_shift       IN ODMR_OBJECT_IDS,    -- custom shift
    p_norm_custom_scale       IN ODMR_OBJECT_IDS,     -- custom scale
    -- custom
    p_out_atrs_custom         IN ODMR_OBJECT_NAMES,  -- list of output names for Custom
    p_src_atrs_custom         IN ODMR_OBJECT_NAMES,  -- list of source columns for Custom
    p_cust_transforms         IN ODMR_OBJECT_VALUES, -- custom sql expresions
    p_parallel_query_hint     IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
    p_parallel_insert_hint    IN VARCHAR2 DEFAULT ' ',
    p_parallel_table_hint     IN VARCHAR2 DEFAULT 'NOPARALLEL',
    
    p_calc_percent_distinct   IN INTEGER DEFAULT 1, 
    p_calc_percent_null       IN INTEGER DEFAULT 1, 
    p_calc_max                IN INTEGER DEFAULT 1, 
    p_calc_min                IN INTEGER DEFAULT 1, 
    p_calc_avg                IN INTEGER DEFAULT 1, 
    p_calc_stddev             IN INTEGER DEFAULT 1, 
    p_calc_variance           IN INTEGER DEFAULT 0, 
    p_calc_kurtosis           IN INTEGER DEFAULT 0, 
    p_calc_median             IN INTEGER DEFAULT 1, 
    p_calc_skewness           IN INTEGER DEFAULT 1, 
    p_calc_mode               IN INTEGER DEFAULT 1, 
    p_calc_mode_all           IN INTEGER DEFAULT 0,
    p_calc_histogram          IN INTEGER DEFAULT 1
  ) RETURN VARCHAR2;

  /***
   * Determines whether the SQL is valid and if it is returns the type 
   * of the created column.
   *
   -- @param p_input_sql              IN CLOB,-- input data
   -- @param p_out_column_type        IN OUT VARCHAR2
  */
  PROCEDURE CLIENT_VALIDATE_SQL(
    p_input_sql              IN CLOB,-- input data
    p_out_column_type        IN OUT VARCHAR2 );

  /**
   -- @param p_string  VARCHAR2
   */
  FUNCTION get_varchar2_byte_length( p_string  VARCHAR2 ) RETURN INTEGER;
  
  /**
   -- @param p_clob CLOB
   */
  FUNCTION get_clob_byte_length( p_clob  CLOB ) RETURN INTEGER;

  /**
   * Creates table from the user defined sql.
   * This procedure is available for the client code.
   *
   -- @param p_result_table_name   name of the result table
   -- @param p_primary_keys        IN ODMR_OBJECT_NAMES,
   -- @param p_indices             IN ODMR_OBJECT_NAMES,
   -- @param p_attributes          list of attributes
   -- @param p_aliases             list of aliases ( can be null )
   -- @param p_src_table            name of the src table or view
  */
  FUNCTION create_table_external2(
    p_result_table_name   IN VARCHAR2,
    p_primary_keys        IN ODMR_OBJECT_NAMES,
    p_indices             IN ODMR_OBJECT_NAMES,
    p_attributes          IN ODMR_OBJECT_NAMES,
    p_aliases             IN ODMR_OBJECT_NAMES,
    p_col_types           IN ODMR_OBJECT_VALUES,
    p_src_table           IN VARCHAR2,
    p_in_memory           IN VARCHAR2 DEFAULT 'FALSE',
    p_compression         IN VARCHAR2 DEFAULT ' ',
    p_priority            IN VARCHAR2 DEFAULT ' ',
    p_table_compression   IN VARCHAR2 DEFAULT 'NONE',
    p_logging             IN VARCHAR2 DEFAULT 'NOLOGGING',
    p_parallel_table_hint IN VARCHAR2 DEFAULT 'NOPARALLEL') RETURN NUMBER;

  /**
   * Public method CREATE_EXPLORE_NODE_STATISTICS. <br />
   * Used in Code Generation. Persists the calculated statistics 
   * values into the statsistical table
   *
   -- @param p_input_view             _ input view or table 
   -- @param p_statistics_table_name  _ name of the resulting statistics table
   -- @param p_attributes             _ input columns
   -- @param p_attrDataTypes          _ type of input columns
   -- @param p_calc_percent_distinct  _ flag 
   -- @param p_calc_max               _ flag 
   -- @param p_calc_min               _ flag 
   -- @param p_calc_avg               _ flag 
   -- @param p_calc_stddev            _ flag 
   -- @param p_calc_variance          _ flag 
   -- @param p_calc_kurtosis          _ flag 
   -- @param p_calc_median            _ flag 
   -- @param p_calc_skewness          _ flag 
   -- @param p_calc_mode              _ flag 
   -- @param p_calc_mode_sampled      _ flag 
   -- @param p_calc_mode_all          _ flag
   */
  PROCEDURE CREATE_EXPLORE_NODE_STATISTICS(
    p_input_view              IN VARCHAR2,
    p_statistics_table_name   IN VARCHAR2,
    p_attributes              IN ODMR_OBJECT_NAMES,
    p_attrDataTypes           IN ODMR_OBJECT_NAMES,
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
    p_calc_mode_sampled       IN BOOLEAN, 
    p_calc_mode_all           IN BOOLEAN,
    p_parallel_query_hint     IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
    p_parallel_insert_hint    IN VARCHAR2 DEFAULT ' ',
    p_parallel_table_hint     IN VARCHAR2 DEFAULT 'NOPARALLEL',
    p_in_memory               IN BOOLEAN DEFAULT FALSE,
    p_compression             IN VARCHAR2  DEFAULT ' ',
    p_priority                IN VARCHAR2 DEFAULT ' ' );

  /**
   * Public method CREATE_HISTOGRAM_SAMPLE_DATA. <br />
   * Used in Code Generation. Creates sampled data for histogram
   *
   -- @param p_input_data             _ input view or table 
    */
  FUNCTION CREATE_HISTOGRAM_SAMPLE_DATA ( p_input_data            IN VARCHAR2,
                                          p_parallel_query_hint   IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
                                          p_parallel_insert_hint  IN VARCHAR2 DEFAULT ' ',
                                          p_parallel_table_hint   IN VARCHAR2 DEFAULT 'NOPARALLEL',
                                          p_in_memory             IN BOOLEAN DEFAULT FALSE,
                                          p_compression           IN VARCHAR2 DEFAULT NULL,
                                          p_priority              IN VARCHAR2 DEFAULT NULL
                                          )RETURN VARCHAR2;

  /**
   * Public method CREATE_SAMPLE_DATA. <br />
   * Used in Code Generation. Creates sampled data.
   *
   -- @param p_input_data             _ input view or table 
    */
  FUNCTION CREATE_SAMPLE_DATA(p_input_data            IN VARCHAR2,
                              p_useNumberOfRows       IN NUMBER,
                              p_numberOfRows          IN NUMBER,
                              p_usePercentOfTotal     IN NUMBER,
                              p_percentOfTotal        IN NUMBER,
                              p_useRandom             IN NUMBER,
                              p_seed                  IN NUMBER,
                              p_useStratified         IN NUMBER,
                              p_useTopN               IN NUMBER,
                              p_parallel_query_hint   IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
                              p_parallel_insert_hint  IN VARCHAR2 DEFAULT ' ',
                              p_parallel_table_hint   IN VARCHAR2 DEFAULT 'NOPARALLEL',
                              p_in_memory             IN BOOLEAN DEFAULT FALSE,
                              p_compression           IN VARCHAR2 DEFAULT ' ',
                              p_priority              IN VARCHAR2 DEFAULT ' '
                              ) RETURN VARCHAR2;

  /**
   * Public method CLIENT_CALCULATE_HISTOGRAMS. <br />
   * Used in Code Generation. Persists the histograms data into the
   * HISTOGRAMS column of the statsistical table
   * 
   -- @param p_input_table           IN VARCHAR2,
   -- @param  p_stats_table_name      IN VARCHAR2,
   -- @param  p_num_bins              IN INTEGER,
   -- @param  p_cat_bins              IN INTEGER,
   -- @param  p_date_bins             IN INTEGER,
   -- @param  p_grouping_column       IN VARCHAR2,
   -- @param  p_grouping_column_type  IN VARCHAR2,
   -- @param  p_columns               IN ODMR_OBJECT_NAMES,
   -- @param  p_column_data_types     IN ODMR_OBJECT_NAMES
  */
  PROCEDURE CLIENT_CALCULATE_HISTOGRAMS (
    p_input_table           IN VARCHAR2,
    p_stats_table_name      IN VARCHAR2,
    p_num_bins              IN INTEGER,
    p_cat_bins              IN INTEGER,
    p_date_bins             IN INTEGER,
    p_grouping_column       IN VARCHAR2,
    p_grouping_column_type  IN VARCHAR2,
    p_columns               IN ODMR_OBJECT_NAMES,
    p_column_data_types     IN ODMR_OBJECT_NAMES,
    p_nulls_label           IN VARCHAR2,
    p_other_label           IN VARCHAR2,
    p_sampled_mode          IN BOOLEAN DEFAULT TRUE,
    p_parallel_query_hint   IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
    p_parallel_insert_hint  IN VARCHAR2 DEFAULT ' ',
    p_parallel_table_hint   IN VARCHAR2 DEFAULT 'NOPARALLEL',
    p_in_memory             IN BOOLEAN DEFAULT FALSE,
    p_compression           IN VARCHAR2  DEFAULT ' ',
    p_priority              IN VARCHAR2 DEFAULT ' ' );

  /**
   * Returns list of requested bins for multiple columns
   * EQWIDTH only
   *
   -- @param p_input_sql              input data
   -- @param p_input_column_names     input columns to bins
   -- @param p_bin_counts             requested number of bins for each input column
   -- @param p_col_names              resulting bin names
   -- @param p_bin_num_values         resulting bin values
   -- @param p_bin_ids                resulting bin ids ( 1, 2, 3 ...)
   */
  PROCEDURE GENERATE_MULTI_EQW_BINS(
    p_input_sql              IN CLOB,                   -- input data
    p_input_column_names     IN ODMR_OBJECT_VALUES,     -- input columns to bins
    p_bin_counts             IN ODMR_OBJECT_IDS,        -- requested number of bins for each input column
    p_col_names              IN OUT ODMR_OBJECT_NAMES,  -- resulting bin names
    p_bin_num_values         IN OUT ODMR_OBJECT_IDS,    -- resulting bin values
    p_bin_ids                IN OUT ODMR_OBJECT_VALUES, -- resulting bin ids ( 1, 2, 3 ...)
    p_parallel_query_hint    IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */' );

  /**
   * Returns list of requested bins for multiple columns.
   * TOPN only
   *
   -- @param p_input_sql              input data
   -- @param p_input_column_names     input columns to bins
   -- @param p_bin_counts             numbers of bins
   -- @param p_col_names              resulting bin names
   -- @param p_bin_cat_values         resulting bin values
   -- @param p_bin_ids                resulting bin ids
   */
  PROCEDURE GENERATE_MULTI_TOPN_BINS(
    p_input_sql              IN CLOB,                   -- input data
    p_input_column_names     IN ODMR_OBJECT_VALUES,     -- input columns to bins
    p_bin_counts             IN ODMR_OBJECT_IDS,        -- numbers of bins
    p_col_names              IN OUT ODMR_OBJECT_NAMES,  -- resulting bin names
    p_bin_cat_values         IN OUT ODMR_OBJECT_VALUES, -- resulting bin values
    p_bin_ids                IN OUT ODMR_OBJECT_VALUES, -- resulting bin ids
    p_parallel_query_hint    IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
    p_parallel_insert_hint   IN VARCHAR2 DEFAULT ' ' );

  /**
   -- @param p_input_table_name       input data
   -- @param p_input_column_names     input columns to bins
   -- @param p_bin_counts             requested number of bins for each input column
   -- @param p_res_col_names          names of binned cols
   -- @param p_lower_bounds           output results: lower bounds
   -- @param p_upper_bounds           output results: upper bounds
   */
  PROCEDURE GENERATE_TS_TZ_BINS( 
    p_input_table_name     IN VARCHAR2,               -- input data
    p_input_column_names   IN ODMR_OBJECT_VALUES,     -- input columns to bins
    p_bin_counts           IN ODMR_OBJECT_IDS,        -- requested number of bins for each input column
    p_res_col_names        IN OUT ODMR_OBJECT_VALUES, -- names of binned cols
    p_lower_bounds         IN OUT ODMR_OBJECT_VALUES, -- output results: lower bounds
    p_upper_bounds         IN OUT ODMR_OBJECT_VALUES, -- output results: upper bounds
    p_parallel_query_hint  IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
    p_parallel_insert_hint IN VARCHAR2 DEFAULT ' ',
    p_parallel_table_hint  IN VARCHAR2 DEFAULT 'NOPARALLEL' );

  /**
   -- @param p_input_table_name       input data
   -- @param p_input_column_names     input columns to bins
   -- @param p_bin_counts             requested number of bins for each input column
   -- @param p_res_col_names          names of binned cols
   -- @param p_lower_bounds           output results: lower bounds
   -- @param p_upper_bounds           output results: upper bounds
   */
  PROCEDURE GENERATE_DATE_BINS( 
    p_input_table_name     IN VARCHAR2,               -- input data
    p_input_column_names   IN ODMR_OBJECT_VALUES,     -- input columns to bins
    p_bin_counts           IN ODMR_OBJECT_IDS,        -- requested number of bins for each input column
    p_res_col_names        IN OUT ODMR_OBJECT_VALUES, -- names of binned cols
    p_lower_bounds         IN OUT ODMR_OBJECT_VALUES, -- output results: lower bounds
    p_upper_bounds         IN OUT ODMR_OBJECT_VALUES, -- output results: upper bounds
    p_parallel_query_hint  IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
    p_parallel_insert_hint IN VARCHAR2 DEFAULT ' ',
    p_parallel_table_hint  IN VARCHAR2 DEFAULT 'NOPARALLEL' );

  /**
   * Returns list of requested bins for multiple columns
   * Binning types supported: TOPN, EQW 
   *
   -- @param p_input_sql              input data
   -- @param p_input_column_names     input columns to bin
   -- @param p_input_column_types     input columns types
   -- @param p_bin_counts             numbers of bins
   -- @param p_col_names              resulting bin names
   -- @param p_bin_num_values         resulting numeric bin values
   -- @param p_bin_cat_values         resulting categorical bin values
   -- @param p_bin_ids                resulting bin ids
   */
  PROCEDURE GENERATE_MULTI_BINS(
    p_input_sql              IN CLOB,                   -- input data
    p_input_column_names     IN ODMR_OBJECT_VALUES,     -- input columns to bins
    p_input_column_types     IN ODMR_OBJECT_VALUES,     -- input columns types
    p_bin_counts             IN ODMR_OBJECT_IDS,        -- numbers of bins
    p_col_names              IN OUT ODMR_OBJECT_NAMES,  -- resulting bin names
    p_bin_num_values         IN OUT ODMR_OBJECT_IDS,    -- resulting numeric bin values
    p_bin_cat_values         IN OUT ODMR_OBJECT_VALUES, -- resulting categorical bin values
    p_bin_ids                IN OUT ODMR_OBJECT_VALUES, -- resulting bin ids
    p_parallel_query_hint    IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
    p_parallel_insert_hint   IN VARCHAR2 DEFAULT ' ' );

  /**
   * Formats the stack to be displayed:
   *
   -- @param p_function_name IN VARCHAR2,
   -- @param p_sqlerr        IN VARCHAR2,
   -- @param p_error_stack   IN VARCHAR2
   */
  FUNCTION FORMAT_ERROR_STACK(
    p_function_name IN VARCHAR2,
    p_sqlerr        IN VARCHAR2,
    p_error_stack   IN VARCHAR2 ) RETURN VARCHAR2;

  /** Provide a list of fully qualified model names and returns a piped record result set of
    *   models that have a imbedded scoring cost matrix.
    *   The input consists of 2 collections of paired user and model names.
    *   If a model does not exist, it will not cause an exception.
    *
    -- @param p_users        A collection of user account names.
    -- @param p_model_names  A collection of modle names.
    -- @return ODMR_QUALIFIED_OBJECT_NAMES - A piped record containing fully qualified model names.
    */
  FUNCTION GET_MODELS_WITH_COST_MATRIX(
    p_users ODMR_OBJECT_NAMES,
    p_model_names ODMR_OBJECT_NAMES)
  RETURN ODMR_QUALIFIED_OBJECT_NAMES PIPELINED; 

  /*
   * Return 1 if ODMRSYS table space management is AUTO
   */
  FUNCTION is_auto_space_management RETURN NUMBER;

  /*
   * Return 1 if Binary XML storage type is detected 
   */
  FUNCTION is_binary_xml RETURN NUMBER;

  /*
   * Return 1 if extended data type is enabled
   */
  FUNCTION is_extended_type RETURN NUMBER;
  
  /*
   * Return 1 if expanded obj name is enabled
   */
  FUNCTION is_expanded_obj_name RETURN NUMBER;

  /*
  * Changes in Memeory settings for selected workflow nodes
  */
  PROCEDURE ALTER_IN_MEMORY_TABLES(
      p_workflowId IN NUMBER,
      p_nodeIds    IN ODMR_OBJECT_NAMES);
  
   /*
     * For Parallel Query Changes
     * Any persisted objects that are part of those changed nodes and are a factor in the workflow�s data linage ,
     * must be updated in an appropriate manner to either turn on or turn off the parallel settings, or to adjust
     * the degree of parallel setting.  This is a database operation so it may take some time to complete.
     * The operation is not undoable via the  IDE�s undoable mechanism, so the transaction must be complete and 
     * flushed from the undo buffer. Currently the only nodes that have objects that qualify are the Create Table,
     * SQL Query and Explore Data nodes.
     */
  PROCEDURE UPDATE_VIEWS_AND_TABLES(p_workflowId IN NUMBER, p_nodeIds IN OUT NOCOPY ODMR_OBJECT_NAMES);
  /*
  * Updates the View Objects if Any, for the SQL Node with the latest settings for Parallel Query
  */
  PROCEDURE UPDATE_CREATE_SQL_NODE( p_workflowId IN NUMBER,p_nodeId IN VARCHAR2);
  /*
  * Updates the View/Table Objects if Any, for the Create Table or View Node with the latest settings for Parallel Query
  */
  PROCEDURE UPDATE_CREATE_TABLE_NODE( p_workflowId IN NUMBER,p_nodeId IN VARCHAR2);
  /*
  * Updates the Table Objects if Any, for the Explore Data Node with the latest settings for Parallel Query
  */
  PROCEDURE UPDATE_PROFILE_NODE( p_workflowId IN NUMBER,p_nodeId IN VARCHAR2);
  /*
  * Updates the VIEW Objects if Any, for the GRAPH Data Node with the latest settings for Parallel Query
  */
  PROCEDURE UPDATE_GRAPH_NODE(	p_workflowId IN NUMBER,	p_nodeId IN VARCHAR2);

  FUNCTION GENERATE_DATA_GUIDE(P_DATA_GUIDE_TBL IN VARCHAR2, P_INPUT_TABLE IN VARCHAR2, P_JSON_COL IN VARCHAR2, P_MAX_NUM_DOCS IN NUMBER, P_MAX_NUM_VALUES_PER_DOC IN NUMBER) RETURN NUMBER;
  
  FUNCTION GENERATE_DATA_GUIDE2(P_DATA_GUIDE_TBL IN VARCHAR2, P_INPUT_SQL IN VARCHAR2, P_JSON_COL IN VARCHAR2, P_MAX_NUM_DOCS IN NUMBER, P_MAX_NUM_VALUES_PER_DOC IN NUMBER) RETURN NUMBER;

  FUNCTION PRETTY_JSON(P_JSON_SQL IN CLOB, P_JSON_COL IN VARCHAR2, P_COUNT IN NUMBER) RETURN CLOB;

END ODMR_UTIL;
/
