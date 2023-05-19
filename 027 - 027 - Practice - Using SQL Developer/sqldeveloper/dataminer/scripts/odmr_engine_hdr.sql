
  CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_ENGINE" 
AUTHID CURRENT_USER AS

  TYPE lookupType IS TABLE OF ODMR_INTERNAL_UTIL.TYPE_VCHAR_130 INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;
  SUBTYPE ODMR_LSTMT_REC_TYPE  IS ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE;

  TYPE COLUMN_SQL_DEFINITION IS RECORD (
    column_name       ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    sql_definition    ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE );
  TYPE SQL_DEFINITION_ARRAY IS TABLE OF COLUMN_SQL_DEFINITION INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  TYPE SIMPLE_STAT_OBJECT IS RECORD (
    attr_name         ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    attr_type         VARCHAR2(30),
    data_type         VARCHAR2(35),
    mining_type       VARCHAR2(30),
    data_length       NUMBER,
    null_percent      NUMBER,
    distinct_count    NUMBER,
    distinct_percent  NUMBER
    );
  TYPE STLOOKUPTYPE IS TABLE OF SIMPLE_STAT_OBJECT INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  TYPE MAP_OUT_TO_OTHER IS TABLE OF ODMR_INTERNAL_UTIL.TYPE_VCHAR_32K INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  TYPE MAP_BIN_ID_TO_NULL IS TABLE OF NUMBER INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  TYPE BIN_LABEL_ID IS RECORD (
    labels         ODMR_OBJECT_VALUES,
    bin_numbers    ODMR_OBJECT_IDS);
    
  TYPE BIN_LABEL_ID_MAP IS TABLE OF BIN_LABEL_ID INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  TYPE BINNED_COLUMN IS RECORD (
    out_column_name      ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,        -- name of the binned column
    src_column_name      ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,        -- name of the corresponding source column
    v_cut_points         ODMR_OBJECT_IDS,     -- cut points
    bin_categories     ODMR_OBJECT_VALUES  -- bin values
  );
  TYPE BINNED_COLUMNS IS TABLE OF BINNED_COLUMN INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  TYPE BINNED_TIMESTAMP IS RECORD (
    out_column_name      ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,        -- name of the binned column
    src_column_name      ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,        -- name of the corresponding source column
    v_cut_points         ODMR_OBJECT_VALUES,     -- cut points
    bin_categories       ODMR_OBJECT_VALUES  -- bin values
  );
  TYPE BINNED_TIMESTAMP_COLUMNS is table of BINNED_TIMESTAMP index by varchar2(130);

  TYPE TOPN_COLUMN IS RECORD (
    out_column_name      ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,        -- name of the binned column
    src_column_name      ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,        -- name of the corresponding source column
    is_other             ODMR_OBJECT_IDS,  -- is Other bin
    topn_category        ODMR_OBJECT_VALUES   -- bin values
  );
  TYPE TOPN_COLUMNS IS TABLE OF TOPN_COLUMN INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;
  
  TYPE ODMR_HISTOGRAMS_ARRAY IS TABLE OF ODMR_HISTOGRAMS INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;
  TYPE ODMR_HISTOGRAMS_ARRAY2 IS TABLE OF ODMR_HISTOGRAMS2 INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;
  TYPE ODMR_HISTOGRAMS_ARRAY_EX IS TABLE OF ODMR_HISTOGRAMS_EX INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;
  TYPE ODMR_HISTOGRAMS_ARRAY_EX2 IS TABLE OF ODMR_HISTOGRAMS_EX2 INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  TYPE COLUMNS_MAP IS TABLE OF ODMR_INTERNAL_UTIL.TYPE_VCHAR_130 INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  TYPE NAME_VALUE_OBJECT IS RECORD (
    label      ODMR_INTERNAL_UTIL.TYPE_VCHAR_32K,
    val        NUMBER,
    bin_num    INTEGER);

  TYPE NAME_VALUE_TABLE IS TABLE OF NAME_VALUE_OBJECT;

  TYPE HISTOGRAM_DEFINITION IS RECORD (
    frequencies_table  NAME_VALUE_TABLE,
    sql_definition     ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE );

  TYPE ASSOCIATIVE_NV_ARRAY IS TABLE OF HISTOGRAM_DEFINITION INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  c_other_value         CONSTANT VARCHAR2(400) := ODMR_MSG.TRANSLATION_PARAM_LOOKUP(ODMR_MSG.OTHER_LABEL);
  NULL_BIN_LABEL        CONSTANT VARCHAR2(400) := ODMR_MSG.TRANSLATION_PARAM_LOOKUP(ODMR_MSG.NULL_BIN_LABEL);
  OTHER_LABEL           CONSTANT VARCHAR2(400) := '<'||c_other_value||'>';

  SEPARATOR             CONSTANT VARCHAR2(10) := ' - < ';
  GT_OR_EQ              CONSTANT VARCHAR2(10) := ' >= ';
  LESS_THEN             CONSTANT VARCHAR2(10) := ' < ';
  GT_THEN               CONSTANT VARCHAR2(10) := ' > ';
  DBL_Q                 CONSTANT VARCHAR2(10) := '"';
  
  c_chunk               CONSTANT INTEGER := 100;
 
  ODMR_CASE_ID          CONSTANT VARCHAR2(30) := 'DMR$CASEID';

  c_start_prog          CONSTANT VARCHAR2(30) := 'ODMRSYS.START_PROG';
  c_end_prog            CONSTANT VARCHAR2(30) := 'ODMRSYS.CLEANUP_PROG';
  c_subflow_start_prog  CONSTANT VARCHAR2(30) := 'ODMRSYS.SUBFLOW_START_PROG';
  c_subflow_end_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.SUBFLOW_CLEANUP_PROG';

  c_datasource_prog     CONSTANT VARCHAR2(30) := 'ODMRSYS.DATASOURCE_PROG';
  c_createtable_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.CREATETABLE_PROG';
  c_updatetable_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.UPDATETABLE_PROG';
  c_dataprofile_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.DATAPROFILE_PROG';
  c_transform_prog      CONSTANT VARCHAR2(30) := 'ODMRSYS.TRANSFORMATIONS_PROG';
  c_aggregation_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.AGGREGATION_PROG';
  c_join_prog           CONSTANT VARCHAR2(30) := 'ODMRSYS.JOIN_PROG';
  c_text_prog           CONSTANT VARCHAR2(30) := 'ODMRSYS.BUILDTEXT_REF_PROG';
  c_buildtext_prog      CONSTANT VARCHAR2(30) := 'ODMRSYS.BUILDTEXT_PROG';
  c_applytext_prog      CONSTANT VARCHAR2(30) := 'ODMRSYS.APPLYTEXT_PROG';
  c_sample_prog         CONSTANT VARCHAR2(30) := 'ODMRSYS.SAMPLE_PROG';
  c_columnfilter_prog   CONSTANT VARCHAR2(30) := 'ODMRSYS.COLUMNFILTER_PROG';
  c_rowfilter_prog      CONSTANT VARCHAR2(30) := 'ODMRSYS.ROWFILTER_PROG';
  c_class_build_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.CLASS_BUILD_PROG';
  c_regress_build_prog  CONSTANT VARCHAR2(30) := 'ODMRSYS.REGRESS_BUILD_PROG';
  c_clust_build_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.CLUST_BUILD_PROG';
  c_feature_build_prog  CONSTANT VARCHAR2(30) := 'ODMRSYS.FEATURE_BUILD_PROG';
  c_anomaly_build_prog  CONSTANT VARCHAR2(30) := 'ODMRSYS.ANOMALY_BUILD_PROG';
  c_assoc_build_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.ASSOC_BUILD_PROG';
  c_model_prog          CONSTANT VARCHAR2(30) := 'ODMRSYS.MODEL_PROG';
  c_apply_prog          CONSTANT VARCHAR2(30) := 'ODMRSYS.APPLY_PROG';
  c_test_prog           CONSTANT VARCHAR2(30) := 'ODMRSYS.TEST_PROG';
  c_modeldetails_prog   CONSTANT VARCHAR2(30) := 'ODMRSYS.MODELDETAILS_PROG';
  c_testdetails_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.TESTDETAILS_PROG';
  c_filterdetails_prog  CONSTANT VARCHAR2(30) := 'ODMRSYS.FILTERDETAILS_PROG';
  c_dyn_predict_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.PREDICTION_PROG';
  c_dyn_cluster_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.CLUSTER_PROG';
  c_dyn_feature_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.FEATURE_PROG';
  c_dyn_anomaly_prog    CONSTANT VARCHAR2(30) := 'ODMRSYS.ANOMALY_PROG';
  c_sql_query_prog      CONSTANT VARCHAR2(30) := 'ODMRSYS.SQLQUERY_PROG';
  c_graph_prog          CONSTANT VARCHAR2(30) := 'ODMRSYS.GRAPH_PROG';
  c_json_query_prog     CONSTANT VARCHAR2(30) := 'ODMRSYS.JSONQUERY_PROG';
  c_efe_build_prog      CONSTANT VARCHAR2(30) := 'ODMRSYS.EFE_BUILD_PROG';  
  c_featurecompare_prog CONSTANT VARCHAR2(30) := 'ODMRSYS.FEATURECOMPARE_PROG';
  c_r_build_prog        CONSTANT VARCHAR2(30) := 'ODMRSYS.R_BUILD_PROG';
  
  c_timestamp_no_tz     CONSTANT VARCHAR2(30) := 'DD.MM.YYYY HH24:MI:SS';
  c_timestamp_no_tz_xml CONSTANT VARCHAR2(30) := 'YYYY-MM-DD HH24:MI:SS';
  c_timestamp_with_tz   CONSTANT VARCHAR2(30) := 'DD.MM.YYYY HH24:MI:SS TZH:TZM';
  c_timestamp_with_tz_xml CONSTANT VARCHAR2(30) := 'YYYY-MM-DD HH24:MI:SS TZH:TZM';
  c_to_timestamp_f      CONSTANT VARCHAR2(30) := 'TO_TIMESTAMP';
  c_to_timestamp_tz_f   CONSTANT VARCHAR2(30) := 'TO_TIMESTAMP_TZ';
  
  /**
   *
   -- @param p_node_type _
   */
  FUNCTION get_program_name(p_node_type IN VARCHAR2) RETURN VARCHAR2;

  /**
   * Check if generated cache table still exists
   -- @param p_workflowId Workflow ID
   -- @param p_nodeId     Node ID
   */
  FUNCTION check_cache_table(p_workflowId    IN NUMBER,
                             p_nodeId        IN VARCHAR2 ) RETURN BOOLEAN;

  /**
   *
   -- @param p_workflowId  _
   -- @param p_nodeId      _
   */
  FUNCTION create_cache_table(p_workflowId            IN NUMBER,
                              p_nodeId                IN VARCHAR2,
                              p_parallel_query_hint   IN VARCHAR2,
                              p_parallel_insert_hint  IN VARCHAR2,
                              p_parallel_table_hint   IN VARCHAR2
                              ) RETURN VARCHAR2;

  /**
   *
   -- @param p_workflowId    _
   -- @param p_nodeId        _
   -- @param p_inlcusive     _
   */
  FUNCTION create_sample_table( p_workflowId              IN NUMBER,
                                p_nodeId                  IN VARCHAR2,
                                p_parallel_query_hint     IN VARCHAR2,
                                p_parallel_insert_hint    IN VARCHAR2,
                                p_parallel_table_hint     IN VARCHAR2,
                                p_inlcusive               IN BOOLEAN DEFAULT TRUE,
                                p_in_memory               IN BOOLEAN,
                                p_compression             IN VARCHAR2,
                                p_priority                IN VARCHAR2
                                ) RETURN VARCHAR2;

  FUNCTION create_histogram_sample_table(
                                p_workflowId              IN NUMBER,
                                p_nodeId                  IN VARCHAR2,
                                p_existing_sample_table   IN VARCHAR2, 
                                p_parallel_query_hint     IN VARCHAR2,
                                p_parallel_insert_hint    IN VARCHAR2,
                                p_parallel_table_hint     IN VARCHAR2,
                                p_inlcusive               IN BOOLEAN DEFAULT TRUE,
                                p_in_memory               IN BOOLEAN,
                                p_compression             IN VARCHAR2,
                                p_priority                IN VARCHAR2
                                ) RETURN VARCHAR2;

  
  /**
  * For codegen only
  */
  FUNCTION create_histogram_sample_data(p_input_data            IN VARCHAR2,
                                        p_parallel_query_hint   IN VARCHAR2,
                                        p_parallel_insert_hint  IN VARCHAR2,
                                        p_parallel_table_hint   IN VARCHAR2,
                                        p_in_memory             IN BOOLEAN,
                                        p_compression           IN VARCHAR2,
                                        p_priority              IN VARCHAR2
                                        )RETURN VARCHAR2;
  
  /**
  * For codegen only
  */
  FUNCTION create_sample_data(p_input_data            IN VARCHAR2,
                              p_useNumberOfRows       IN NUMBER,
                              p_numberOfRows          IN NUMBER,
                              p_usePercentOfTotal     IN NUMBER,
                              p_percentOfTotal        IN NUMBER,
                              p_useRandom             IN NUMBER,
                              p_seed                  IN NUMBER,
                              p_useStratified         IN NUMBER,
                              p_useTopN               IN NUMBER,
                              p_parallel_query_hint   IN VARCHAR2,
                              p_parallel_insert_hint  IN VARCHAR2,
                              p_parallel_table_hint   IN VARCHAR2,
                              p_in_memory             IN BOOLEAN DEFAULT FALSE,
                              p_compression           IN VARCHAR2 DEFAULT ' ',
                              p_priority              IN VARCHAR2 DEFAULT ' '
                              ) RETURN VARCHAR2;

  /**
   *
   -- @param p_workflowId         _
   -- @param p_nodeId             _
   -- @param p_inlcusive          _
   -- @param p_input_data         _
   -- @param p_useNumberOfRows    _
   -- @param p_numberOfRows       _
   -- @param p_usePercentOfTotal  _
   -- @param p_percentOfTotal     _
   -- @param p_useStratified      _
   -- @param p_caseId             _
   -- @param p_targetAttr         _
   -- @param p_primary_set        _
   -- @param p_dataFormat         _
   -- @param p_useParallel        _
   */
  FUNCTION create_sample_table2(p_workflowId            IN NUMBER,
                                p_nodeId                IN VARCHAR2,
                                p_parallel_query_hint   IN VARCHAR2,
                                p_parallel_insert_hint  IN VARCHAR2,
                                p_parallel_table_hint   IN VARCHAR2,
                                p_inlcusive             IN BOOLEAN DEFAULT TRUE,
                                p_input_data            IN VARCHAR2 DEFAULT NULL,
                                p_useNumberOfRows       IN BOOLEAN DEFAULT TRUE,
                                p_numberOfRows          IN NUMBER DEFAULT 2000,
                                p_usePercentOfTotal     IN BOOLEAN DEFAULT FALSE,
                                p_percentOfTotal        IN NUMBER DEFAULT 0,
                                p_useStratified         IN NUMBER DEFAULT 0,
                                p_caseId                IN VARCHAR2 DEFAULT NULL,
                                p_targetAttr            IN VARCHAR2 DEFAULT NULL,
                                p_primary_set           IN BOOLEAN DEFAULT TRUE,
                                p_dataFormat            IN VARCHAR2 DEFAULT 'Table',
                                p_in_memory             IN BOOLEAN,
                                p_compression           IN VARCHAR2,
                                p_priority              IN VARCHAR2
                                ) RETURN VARCHAR2;

  /**
   *
   -- @param p_workflowId      _
   -- @param p_nodeId          _
   -- @param p_generate_cache  _
   -- @param p_cache_data OUT  _
   */
  PROCEDURE get_generate_cache_info(p_workflowId IN NUMBER, 
                                    p_nodeId IN VARCHAR2, 
                                    p_generate_cache OUT NUMBER,
                                    p_cache_data OUT VARCHAR2);

  /**
   -- @param p_workflowId    _
   -- @param p_nodeId        _
   -- @param p_input_sql     _
   */
  FUNCTION create_cache_table2(
      p_workflowId            IN NUMBER,
      p_nodeId                IN VARCHAR2,
      p_parallel_query_hint   IN VARCHAR2,
      p_parallel_insert_hint  IN VARCHAR2,
      p_parallel_table_hint   IN VARCHAR2,
      p_input_sql             IN OUT VARCHAR2
      ) RETURN VARCHAR2;

  /**
   *
   -- @param p_job_name   _
   -- @param p_parentId   _
   */
  PROCEDURE skip_children(p_job_name IN VARCHAR2, p_parentId IN VARCHAR2);

  /**
   *
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE START_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);

  /**
   *
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE CLEANUP_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);

  FUNCTION constant_percent(p_input_table         IN VARCHAR2,
                            p_attribute           IN VARCHAR2,
                            p_parallel_query_hint IN VARCHAR2) RETURN NUMBER;

  /**
   *
   -- @param p_workflowId                   _
   -- @param p_nodeId                       _
   -- @param p_input_table                  _
   -- @param p_gen_max_len                  _
   -- @param p_gen_null_percent             _
   -- @param p_gen_distinct_cnt             _
   -- @param p_gen_distinct_percent         _
   -- @param p_gen_space_cnt                _
   -- @param p_gen_constant_percent         _
   */
  FUNCTION create_simple_statistics_table (
    p_workflowId              IN NUMBER,
    p_nodeId                  IN VARCHAR2,
    p_input_table             IN VARCHAR2,
    p_parallel_query_hint     IN VARCHAR2,
    p_parallel_insert_hint    IN VARCHAR2,
    p_parallel_table_hint     IN VARCHAR2,
    p_gen_max_len             IN BOOLEAN DEFAULT FALSE,
    p_gen_null_percent        IN BOOLEAN DEFAULT TRUE,
    p_gen_distinct_cnt        IN BOOLEAN DEFAULT FALSE,
    p_gen_distinct_percent    IN BOOLEAN DEFAULT TRUE,
    p_gen_space_cnt           IN BOOLEAN DEFAULT FALSE,
    p_gen_constant_percent    IN BOOLEAN DEFAULT TRUE,
    p_in_memory               IN BOOLEAN,
    p_compression             IN VARCHAR2,
    p_priority                IN VARCHAR2
    ) RETURN VARCHAR2;

  /**
   * The input data either comes from supplied p_input_table or p_nodeId sql expression (if p_input_table = NULL) <br/>
   * The p_caseId and p_target statistics are computed based on the input data (no sample) <br/>
   * The other attribute statistics are computed based on the input data or sampled input data (if p_sample_stat = TRUE) <br/>
   -- @param p_workflowId                    p_workflowId  
   -- @param p_nodeId                        p_nodeId
   -- @param p_input_table                   p_input_table
   -- @param p_sample_stat                   p_sample_stat
   -- @param p_caseId                        p_caseId
   -- @param p_target                        p_target
   -- @param p_attributes                    p_attributes
   -- @param p_attrDataTypes                 p_attrDataTypes
   -- @param p_attrDataLengths               p_attrDataLengths
   -- @param p_attrMiningTypes               p_attrMiningTypes
   -- @param p_gen_max_len                   p_gen_max_len
   -- @param p_gen_null_percent              p_gen_null_percent
   -- @param p_gen_distinct_cnt              p_gen_distinct_cnt
   -- @param p_gen_distinct_percent          p_gen_distinct_percent
   -- @param p_gen_space_cnt                 p_gen_space_cnt
   -- @param p_gen_constant_percent          p_gen_constant_percent
   */
  FUNCTION create_simple_statistics_table(
    p_workflowId            IN NUMBER,
    p_nodeId                IN VARCHAR2,
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_input_table           IN VARCHAR2 DEFAULT NULL,
    p_sample_stat           IN BOOLEAN DEFAULT TRUE,
    p_caseId                IN VARCHAR2 DEFAULT NULL,
    p_target                IN VARCHAR2 DEFAULT NULL,
    p_attributes            IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attrDataTypes         IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attrDataLengths       IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_attrMiningTypes       IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_gen_max_len           IN BOOLEAN DEFAULT FALSE,
    p_gen_null_percent      IN BOOLEAN DEFAULT TRUE,
    p_gen_distinct_cnt      IN BOOLEAN DEFAULT FALSE,
    p_gen_distinct_percent  IN BOOLEAN DEFAULT TRUE,
    p_gen_space_cnt         IN BOOLEAN DEFAULT FALSE,
    p_gen_constant_percent  IN BOOLEAN DEFAULT TRUE,
    p_in_memory             IN BOOLEAN,
    p_compression           IN VARCHAR2,
    p_priority              IN VARCHAR2
    ) RETURN VARCHAR2;

  /**
   * Creates statistics_table table: <br/>
   * <pre>
   *      '(ATTR             VARCHAR2(35),
   *        DATA_TYPE         VARCHAR2(35),
   *        NULL_PERCENT      NUMBER,
   *        DISTINCT_CNT      NUMBER,
   *        DISTINCT_PERCENT  NUMBER,
   *        MODE_VALUE        NVARCHAR2(1000),
   *        AVG               NUMBER,
   *        AVG_DATE          DATE,
   *        AVG_TS_TZ         TIMESTAMP(6) WITH TIME ZONE,
   *        MEDIAN_VAL        NUMBER,
   *        MEDIAN_DATE       DATE,
   *        MEDIAN_TS_TZ      TIMESTAMP(6) WITH TIME ZONE,
   *        MIN               NVARCHAR2(1000),
   *        MAX               NVARCHAR2(1000),
   *        STD               NUMBER,
   *        VAR               NUMBER,
   *        SKEWNESS          NUMBER,
   *        KURTOSIS          NUMBER,
   *        HISTOGRAMS        ODMR_HISTOGRAMS)
   *      NESTED TABLE histograms STORE AS ');</pre>
   *
   * Populates all columns except for HISTOGRAMS based on either original data
   * if p_use_full is true or cached data.
   *
   -- @param p_workflowId    p_workflowId
   -- @param p_nodeId        p_nodeId
   -- @param p_input_table   p_input_table
   -- @param p_use_full      p_use_full
   -- @param p_attributes    p_attributes
   -- @param p_attrDataTypes p_attrDataTypes
   -- @param p_inclusive     p_inclusive
   */
  FUNCTION create_statistics_table(
    p_workflowId            IN NUMBER,
    p_nodeId                IN VARCHAR2,
    p_input_table           IN VARCHAR2,
    p_use_full              IN VARCHAR2,
    p_attributes            IN ODMR_OBJECT_NAMES,
    p_attrDataTypes         IN ODMR_OBJECT_NAMES,
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_inclusive             IN BOOLEAN DEFAULT TRUE
    ) RETURN VARCHAR2;

  /**
   * calculate_histograms, persists the histograms data into the
   * HISTOGRAMS column of the statsistical table
   *
   -- @param p_workflowId          _
   -- @param p_nodeId              _
   -- @param p_cache_table         _
   -- @param p_stats_table_name    _
   -- @param p_use_full            _
   -- @param p_num_bins            _
   -- @param p_cat_bins            _
   -- @param p_date_bins           _
   -- @param p_grouping_attr       _
   -- @param p_grouping_attr_type  _
   -- @param p_attributes          _
   -- @param p_attrDataTypes       _
   -- @param p_inclusive           _
   */

  PROCEDURE calculate_histograms (
    p_job_name              IN VARCHAR2,
    p_node_name             IN VARCHAR2,
    p_workflowId            IN NUMBER,
    p_nodeId                IN VARCHAR2,
    p_cache_table           IN VARCHAR2,
    p_stats_table_name      IN VARCHAR2,
    p_use_full              IN VARCHAR2,
    p_num_bins              IN INTEGER,
    p_cat_bins              IN INTEGER,
    p_date_bins             IN INTEGER,
    p_grouping_attr         IN VARCHAR2,
    p_grouping_attr_type    IN VARCHAR2,
    p_attributes            IN ODMR_OBJECT_NAMES,
    p_attrDataTypes         IN ODMR_OBJECT_NAMES,
    p_inclusive             IN BOOLEAN,
    p_grouping_attr_bins    IN INTEGER,
    p_sampled_mode          IN BOOLEAN,
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_nulls_label           IN VARCHAR2 DEFAULT NULL,
    p_other_label           IN VARCHAR2 DEFAULT NULL,
    p_in_memory             IN BOOLEAN DEFAULT FALSE,
    p_compression           IN VARCHAR2 DEFAULT ' ',
    p_priority              IN VARCHAR2 DEFAULT ' '  );
    
  /**
   *
   -- @param p_workflowId         _
   -- @param p_nodeId             _
   -- @param p_use_full           _
   -- @param p_num_bins           _
   -- @param p_cat_bins           _
   -- @param p_date_bins          _
   -- @param p_grouping_attr      _
   -- @param p_grouping_attr_type _
   -- @param p_attributes         _
   -- @param p_aliases            _
   -- @param p_attrDataTypes      _
   */
  PROCEDURE get_profile_sample_table_info (
    p_workflowId IN NUMBER,
    p_nodeId      IN VARCHAR2,
    p_use_full    OUT VARCHAR2,
    p_num_bins    OUT INTEGER,
    p_cat_bins    OUT INTEGER,
    p_date_bins   OUT INTEGER,
    p_grouping_attr OUT VARCHAR2,
    p_grouping_attr_type OUT VARCHAR2,
    p_attributes  IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_aliases  IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_attrDataTypes  IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId   _
   -- @param p_nodeId       _
   -- @param p_use_full     _
   -- @param p_table        _
   -- @param p_table_name   _
   -- @param p_attributes   _
   -- @param p_aliases      _
   -- @param p_types        _
   -- @param p_primary_keys _
   -- @param p_indices      _
   */
  PROCEDURE get_create_table_node_info (
    p_workflowId    IN NUMBER,
    p_nodeId        IN VARCHAR2,
    p_use_full      OUT VARCHAR2,
    p_table         OUT VARCHAR2,
    p_table_name    OUT VARCHAR2,
    p_logging       OUT VARCHAR2,
    p_compression   OUT VARCHAR2, 
    p_attributes    IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_aliases       IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_types         IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_primary_keys  IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_indices       IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_searchIndices IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId           _
   -- @param  p_nodeId              _
   -- @param  p_use_full            _
   -- @param  p_drop_existing       _
   -- @param  p_target_table_name   _
   -- @param  p_target_schema_name  _
   -- @param  p_target_attributes   _
   -- @param  p_source_attributes   _
   */
  PROCEDURE get_update_table_node_info (
    p_workflowId          IN NUMBER,
    p_nodeId              IN VARCHAR2,
    p_use_full            OUT VARCHAR2,
    p_drop_existing       OUT VARCHAR2,
    p_target_table_name   OUT VARCHAR2,
    p_target_schema_name  OUT VARCHAR2,
    p_target_attributes  IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_target_aliases     IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_source_attributes  IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   * Creates table from the user defined specification.
   *
   -- @param p_workflowId    p_workflowId
   -- @param p_nodeId        p_nodeId
   -- @param p_use_full      p_use_full
   -- @param p_table         p_table
   -- @param p_table_name    p_table_name
   -- @param p_attributes    p_attributes
   -- @param p_types         p_types
   -- @param p_primary_keys  p_primary_keys
   -- @param p_indices       p_indices
   */
  PROCEDURE create_table_from_spec(
    p_workflowId            IN NUMBER,
    p_nodeId                IN VARCHAR2,
    p_use_full              IN VARCHAR2,
    p_table                 IN VARCHAR2,
    p_table_name            IN VARCHAR2,
    p_attributes            IN ODMR_OBJECT_NAMES,
    p_types                 IN ODMR_OBJECT_NAMES,
    p_primary_keys          IN ODMR_OBJECT_NAMES,
    p_indices               IN ODMR_OBJECT_NAMES,
    p_searchIndices         IN ODMR_OBJECT_NAMES,
    p_parallel_query_hint   IN VARCHAR2,
    p_parallel_insert_hint  IN VARCHAR2,
    p_parallel_table_hint   IN VARCHAR2,
    p_in_memory             IN BOOLEAN,
    p_compression           IN VARCHAR2,
    p_priority              IN VARCHAR2,
    p_table_compression     IN VARCHAR2 DEFAULT 'NONE',
    p_logging               IN VARCHAR2 DEFAULT 'NOLOGGING');

  /**
   * Update target table with the source table
   *
   -- @param p_workflowId         p_workflowId
   -- @param p_nodeId             p_nodeId
   -- @param p_drop_existing      p_drop_existing
   -- @param p_target_table_name  p_target_table_name
   -- @param p_target_schema_name p_target_schema_name
   -- @param p_target_attributes  p_target_attributes
   -- @param p_source_attributes  p_source_attributes
   */
  PROCEDURE update_target_table(
    p_workflowId         IN NUMBER,
    p_nodeId             IN VARCHAR2,
    p_drop_existing      IN VARCHAR2,
    p_target_table_name  IN VARCHAR2,
    p_target_schema_name IN VARCHAR2,
    p_target_attributes  IN ODMR_OBJECT_NAMES,
    p_source_attributes  IN ODMR_OBJECT_NAMES,
    p_parallel_query_hint  IN VARCHAR2,
    p_parallel_insert_hint IN VARCHAR2 );

  /**
   * Validate that all required columns are in the list of target attributes
   *
   -- @param p_target_table_name  p_target_table_name
   -- @param p_target_schema_name p_target_schema_name
   -- @param p_target_attributes  p_target_attributes
   */
  FUNCTION validate_target_attrs(
    p_target_table_name  IN VARCHAR2,
    p_target_schema_name IN VARCHAR2,
    p_target_attributes  IN ODMR_OBJECT_NAMES) RETURN VARCHAR2;

  /**
   * Creates top N bin boundary table. <br />
   * Used by Transformation.
   *
   -- @param p_topn_categories_table  result bin boundary table
   */
  PROCEDURE create_topn_categories_table(
    p_topn_categories_table   IN VARCHAR2, -- result bin boundary table
    p_parallel_table_hint     IN VARCHAR2 );

  /**
   * Creates top N bin boundary table. <br />
   * Used by Transformation. <br />
   * NVARCHAR2 NCHAR only
   *
   -- @param p_topn_categories_table  result bin boundary table
   */
  PROCEDURE create_topn_cat_table_nc(
    p_topn_categories_table   IN VARCHAR2, -- result bin boundary table
    p_parallel_table_hint     IN VARCHAR2 );

   /**
   * Calculates top N bin boundary table. <br/>
   * Columns are grouped by the bin count and 'other' value and different source.<br/>
   * Example: OCCUPATION_BIN_: 10, 'Other' <br/>
   *          EDICATION_BIN:   10, 'Other' <br/>
   * Exception are columns with the same bin count, 'other' value and  source, they are duplicates. <br/>
   * Used by Transformation.
   *
   -- @param  p_input_table_name        input data
   -- @param  p_topn_categories_table  result bin boundary table
   -- @param  p_out_columns            list of output column names
   -- @param  p_src_columns            list of source column names
   -- @param  p_bin_counts             list of bins for each of categorical columns
   -- @param  p_other_values           list of 'Other' values
   */
  PROCEDURE insert_topn_categories(
    p_input_table_name       IN VARCHAR2,-- input data
    p_topn_categories_table  IN VARCHAR2, -- result bin boundary table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_bin_counts             IN ODMR_OBJECT_IDS,   -- list of bins for each of categorical columns
    p_other_values           IN ODMR_OBJECT_VALUES,  -- list of 'Other' values
    p_null_labels            IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls          IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2);

  /**
   * Calculates top N bin boundary table. <br/>
   * Columns are grouped by the bin count and 'other' value and different source. <br/>
   * Example: OCCUPATION_BIN_: 10, 'Other' <br/>
   *          EDICATION_BIN:   10, 'Other' <br/>
   * Exception are columns with the same bin count, 'other' value and  source, they are duplicates. <br/>
   * Used by Transformation for NCHAR and NVARCHAR2 only
   *
   -- @param p_input_table_name       input data
   -- @param p_topn_categories_table  result bin boundary table
   -- @param p_out_columns            list of output column names
   -- @param p_src_columns            list of source column names
   -- @param p_bin_counts             list of bins for each of categorical columns
   -- @param p_other_values           list of 'Other' values
   */
--  PROCEDURE insert_topn_categories_nc(
--    p_input_table_name       IN VARCHAR2,-- input data
--    p_topn_categories_table  IN VARCHAR2, -- result bin boundary table
--    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
--    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
--    p_bin_counts             IN ODMR_OBJECT_IDS,   -- list of bins for each of categorical columns
--    p_other_values           IN ODMR_OBJECT_VALUES, -- list of 'Other' values
--    p_parallel_insert_hint   IN VARCHAR2,
--    p_parallel_query_hint    IN VARCHAR2);

  /**
   * Creates numeric bin boundary table. <br />
   * Used by Transformation.
   *
   -- @param p_bin_boundary_table _
   */
  PROCEDURE create_bin_boundary_table(
    p_bin_boundary_table  IN VARCHAR2, -- result bin boundary table
    p_parallel_query_hint IN VARCHAR2);

  /**
   * Creates DATE/TIMESTAMP bin boundary table. <br />
   * Used by Transformation.
   *
   -- @param p_bin_boundary_table _
   */
  PROCEDURE create_date_bin_boundary_table(
    p_bin_boundary_table  IN VARCHAR2, -- result bin boundary table
    p_parallel_query_hint IN VARCHAR2);
  
  /**
   * Creates TIMESTAMP WITH TIME ZONE bin boundary table. <br />
   * Used by Transformation.
   *
   -- @param p_bin_boundary_table _
   */
  PROCEDURE create_tz_bin_boundary_table(
    p_bin_boundary_table  IN VARCHAR2, -- result bin boundary table
    p_parallel_query_hint IN VARCHAR2);

  /**
   * Populates bin boundary table. <br/>
   * Groups columns having the same number of bins, range or numeric, value, auto or manual <br/>
   * Used by Transformation. <br/>
   *
   -- @param p_input_table_name      input data
   -- @param  p_bin_boundary_table   result bin boundary table
   -- @param  p_out_columns          list of output column names
   -- @param  p_src_columns          list of source column names
   -- @param  p_src_col_types        list of source column types
   -- @param  p_bin_counts           list of bins for each of columns
   -- @param  p_bin_auto             auto bin generation
   -- @param  p_bin_man              manual bin generation
   -- @param  p_bin_num_seq          bin labels - number sequence
   */
  PROCEDURE insert_eqw_bins(
    p_input_table_name       IN VARCHAR2,
    p_bin_boundary_table     IN VARCHAR2,
    p_out_columns            IN ODMR_OBJECT_NAMES,
    p_src_columns            IN ODMR_OBJECT_NAMES,
    p_src_col_types          IN ODMR_OBJECT_NAMES,
    p_bin_counts             IN ODMR_OBJECT_IDS,
    p_bin_auto               IN ODMR_OBJECT_IDS,
    p_bin_man                IN ODMR_OBJECT_IDS,
    p_bin_num_seq            IN ODMR_OBJECT_IDS, -- bin labels - number sequence
    p_null_labels            IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls          IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2);

  /**
   * Populates bin boundary table. <br/>
   * Groups columns having the same number of bins, range or numeric, value, auto or manual <br/>
   * Used by Transformation.<br/>
   *
   -- @param p_input_table_name       input data
   -- @param p_bin_boundary_table     result bin boundary table
   -- @param p_out_columns            list of output column names
   -- @param p_src_columns            list of source column names
   -- @param p_bin_counts             list of bin counts for each of columns
   -- @param p_bin_auto               auto bin generation
   -- @param p_bin_man                manual bin generation
   -- @param p_bin_num_seq            bin labels - number sequence
   */
  PROCEDURE insert_date_bins(
    p_input_table_name       IN VARCHAR2,-- input data
    p_bin_boundary_table     IN VARCHAR2, -- result bin boundary table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_bin_counts             IN ODMR_OBJECT_IDS,  -- list of bin counts for each of columns
    p_bin_auto               IN ODMR_OBJECT_IDS, -- auto bin generation
    p_bin_man                IN ODMR_OBJECT_IDS, -- manual bin generation
    p_bin_num_seq            IN ODMR_OBJECT_IDS, -- bin labels - number sequence
    p_null_labels            IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls          IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2);

  /**
   * Populates bin boundary table. FOR TIMESTAMP WITH TIME ZONE ONLY <br />
   * Groups columns having the same number of bins, range or numeric, value, auto or manual<br />
   * Used by Transformation.<br />
   *
   -- @param p_input_table_name       input data
   -- @param p_bin_boundary_table     result bin boundary table
   -- @param p_out_columns            list of output column names
   -- @param p_src_columns            list of source column names
   -- @param p_bin_counts             list of bin counts for each of columns
   -- @param p_bin_auto               auto bin generation
   -- @param p_bin_man                manual bin generation
   -- @param p_bin_num_seq            bin labels - number sequence
   */
  PROCEDURE insert_tz_bins(
    p_input_table_name       IN VARCHAR2,-- input data
    p_bin_boundary_table     IN VARCHAR2, -- result bin boundary table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_bin_counts             IN ODMR_OBJECT_IDS,  -- list of bin counts for each of columns
    p_bin_auto               IN ODMR_OBJECT_IDS, -- auto bin generation
    p_bin_man                IN ODMR_OBJECT_IDS, -- manual bin generation
    p_bin_num_seq            IN ODMR_OBJECT_IDS, -- bin labels - number sequence
    p_null_labels            IN ODMR_OBJECT_VALUES, -- list of values to be used instead of 'Null bin' label
    p_include_nulls          IN ODMR_OBJECT_NAMES,  -- 'true' or 'flase' list: to use Null bin or not
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2);

  /**
   -- @param p_workflowId                  _
   -- @param p_stats_table_name            _
   -- @param p_input_table                 _
   -- @param p_topn_bin_boundary_table     _
   -- @param p_topn_bin_boundary_table_nc  _
   -- @param p_low_count_boundary_table    _
   -- @param p_eqw_bin_boundary_table      _
   -- @param p_date_bin_boundary_table     _
   -- @param p_tz_bin_boundary_table       _
   -- @param p_attributes                  _
   -- @param p_attrDataTypes               _
   -- @param p_grouping_attr               _
   -- @param p_grouping_attr_type          _
   -- @param p_num_bins                    _
   -- @param p_cat_bins                    _
   -- @param p_date_bins     
   */
  FUNCTION prepare_histograms (
    p_job_name                  IN VARCHAR2,
    p_node_name                 IN VARCHAR2,
    p_workflowId                IN NUMBER,
    p_nodeId                    IN VARCHAR2,
    p_stats_table_name          IN VARCHAR2,
    p_input_table               IN VARCHAR2,
    p_topn_bin_boundary_table   IN VARCHAR2,
    p_topn_bin_boundary_table_nc  IN VARCHAR2,
    p_low_count_boundary_table  IN VARCHAR2,
    p_eqw_bin_boundary_table    IN VARCHAR2,
    p_date_bin_boundary_table   IN VARCHAR2,
    p_tz_bin_boundary_table     IN VARCHAR2,
    p_attributes                IN ODMR_OBJECT_NAMES,
    p_attrDataTypes             IN ODMR_OBJECT_NAMES,
    p_grouping_attr             IN VARCHAR2,
    p_grouping_attr_type        IN VARCHAR2,
    p_num_bins                  IN INTEGER,
    p_cat_bins                  IN INTEGER,
    p_date_bins                 IN INTEGER,
    p_grouping_attr_bins        IN INTEGER,
    p_sampled_mode              IN BOOLEAN,
    p_nulls_label               IN VARCHAR2,
    p_other_label               IN VARCHAR2,
    p_parallel_query_hint       IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
    p_parallel_insert_hint      IN VARCHAR2 DEFAULT ' ',
    p_parallel_table_hint       IN VARCHAR2 DEFAULT 'NOPARALLEL',
    p_in_memory                 IN BOOLEAN,
    p_compression               IN VARCHAR2,
    p_priority                  IN VARCHAR2 
    ) RETURN VARCHAR2;

  /**
   * Builds SQL stmt for categorical and numeric binning. <br />
   * Creates table of binned data, calculates its statsistics and add them to statistical table.<br />
   * Used by Transformation.
   *
   -- @param p_input_table                  actual data
   -- @param  p_all_xformed_attrs           list of all transformed columns
   -- @param  p_topn_bin_boundary_table     previously created topN categories
   -- @param  p_topn_bin_boundary_table_nc  previously created topN categories NCHAR, NVARCHAR2 only
   -- @param  p_eqw_bin_boundary_table      previously created numeric bin boundaries
   -- @param  p_date_bin_boundary_table     previously created DATE bin boundaries
   -- @param  p_tz_bin_boundary_table       previously created TIMESTAMP WITH TIME ZONE bin boundaries
   -- @param  p_stats_table_name            name of the stats table - used only if p_grouping_attr is NULL
   -- @param  p_other_values                list of 'Other' values
   -- @param  p_sql_definitions             sql definition for each transformed column
   -- @param  p_workflow_id                 _
   -- @param  p_chain_step                  _
   */
  FUNCTION prepare_binning_sql (
    p_input_table             IN VARCHAR2, -- actual data
    p_all_xformed_attrs       IN ODMR_OBJECT_NAMES, -- list of all transformed columns
    p_topn_bin_boundary_table IN VARCHAR2, -- previously created topN categories
    p_topn_bin_boundary_table_nc IN VARCHAR2, -- previously created topN categories NCHAR, NVARCHAR2 only
    p_eqw_bin_boundary_table  IN VARCHAR2, -- previously created numeric bin boundaries
    p_date_bin_boundary_table IN VARCHAR2, -- previously created DATE bin boundaries
    p_tz_bin_boundary_table   IN VARCHAR2,   -- previously created TIMESTAMP WITH TIME ZONE bin boundaries
    p_stats_table_name        IN VARCHAR2, -- name of the stats table - used only if p_grouping_attr is NULL
    p_other_values            IN map_out_to_other, -- list of 'Other' values
    p_null_labels             IN map_out_to_other, -- list of values to be used instead of 'Null bin' label
    p_include_nulls           IN map_out_to_other,  -- 'true' or 'flase' list: to use Null bin or not
    p_null_bin_assignment     IN MAP_BIN_ID_TO_NULL,
    p_sql_definitions         IN out sql_definition_array,   -- sql definition for each transformed column
    p_parallel_query_hint     IN VARCHAR2,
    p_parallel_insert_hint    IN VARCHAR2,
    p_parallel_table_hint     IN VARCHAR2,
    p_in_memory               IN BOOLEAN,
    p_compression             IN VARCHAR2,
    p_priority                IN VARCHAR2,
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
    p_workflow_id             IN NUMBER DEFAULT NULL,
    p_chain_step              IN VARCHAR2 DEFAULT NULL)
  RETURN VARCHAR2;

  /**
   * Performs qtile binning with DBMS_DATA_MINING_TRANSFORM and populates stats
   *
   -- @param p_input_table_name   input data
   -- @param p_stats_table_name   name of the stats table
   -- @param p_out_columns        list of output column names
   -- @param p_src_columns        list of source column names
   -- @param p_bin_counts         list of bins for each of columns
   -- @param p_bin_auto           auto bin generation
   -- @param p_bin_man            manual bin generation
   -- @param p_bin_num_seq        bin labels - number sequence
   -- @param p_sql_definitions    _
   -- @param p_workflow_id        _
   -- @param p_chain_step         _
   */
  PROCEDURE xform_quantile_binning(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_bin_counts             IN ODMR_OBJECT_IDS,  -- list of bins for each of columns
    p_bin_auto               IN ODMR_OBJECT_IDS, -- auto bin generation
    p_bin_man                IN ODMR_OBJECT_IDS, -- manual bin generation
    p_bin_num_seq            IN ODMR_OBJECT_IDS, -- bin labels - number sequence
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_null_labels            IN map_out_to_other, -- list of values to be used instead of 'Null bin' label
    p_include_nulls          IN map_out_to_other,  -- 'true' or 'flase' list: to use Null bin or not
    p_null_bin_assignment    IN MAP_BIN_ID_TO_NULL, -- bin id's of NULL values
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
    p_calc_histogram         IN BOOLEAN,
    p_workflow_id            in number default null,
    p_chain_step             in varchar2 default null);

  /**
   * Performs custom mumeical binning and populates stats
   *
   -- @param p_input_table_name       input data
   -- @param p_stats_table_name       name of the stats table
   -- @param p_out_columns            list of output column names
   -- @param p_src_columns            list of source column names
   -- @param p_bin_num_seq            _
   -- @param p_cust_num_bin_names     list of bin names
   -- @param p_cust_num_low_bnds      list of lower bounds
   -- @param p_sql_definitions        _
   -- @param p_workflow_id            _
   */
  PROCEDURE xform_cust_num_binning(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_bin_num_seq            IN ODMR_OBJECT_IDS,
    p_cust_num_bin_names     IN ODMR_OBJECT_VALUES, -- list of bin names
    p_cust_num_low_bnds      IN ODMR_OBJECT_IDS,  -- list of lower bounds
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_null_labels            IN map_out_to_other, -- list of values to be used instead of 'Null bin' label
    p_include_nulls          IN map_out_to_other,  -- 'true' or 'flase' list: to use Null bin or not
    p_null_bin_assignment    IN MAP_BIN_ID_TO_NULL,
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
    p_calc_histogram         IN BOOLEAN,
    p_workflow_id            IN NUMBER DEFAULT NULL);

  /**
   * Performs custom DATE/TIMESTAMP/TIMESTAMP WITH LOCAL TIME ZONE binning and populates stats
   *
   -- @param p_input_table_name       input data
   -- @param p_stats_table_name       name of the stats table
   -- @param p_out_columns            list of output column names
   -- @param p_src_columns            list of source column names
   -- @param p_bin_date_seq           _
   -- @param p_cust_date_bin_names    list of bin names
   -- @param p_cust_date_low_bnds     list of lower bounds
   -- @param p_sql_definitions        _
   -- @param p_workflow_id            _
   */
  PROCEDURE xform_cust_date_binning(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_bin_date_seq           IN ODMR_OBJECT_IDS,
    p_cust_date_bin_names    IN ODMR_OBJECT_VALUES, -- list of bin names
    p_cust_date_low_bnds     IN ODMR_OBJECT_VALUES,  -- list of lower bounds,
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_null_labels            IN map_out_to_other, -- list of values to be used instead of 'Null bin' label
    p_include_nulls          IN map_out_to_other,  -- 'true' or 'flase' list: to use Null bin or not
    p_null_bin_assignment    IN MAP_BIN_ID_TO_NULL, -- bin id's of NULL values
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
    p_calc_histogram         IN BOOLEAN,
    p_workflow_id            IN NUMBER DEFAULT NULL);

  /**
   * Performs custom TIMESTAMP WITH TIME ZONE binning and populates stats
   *
   -- @param p_input_table_name       input data
   -- @param p_stats_table_name       name of the stats table
   -- @param p_out_columns            list of output column names
   -- @param p_src_columns            list of source column names
   -- @param p_bin_date_seq           _
   -- @param p_cust_date_bin_names    list of bin names
   -- @param p_cust_date_low_bnds     list of lower bounds,
   -- @param p_sql_definitions        _
   -- @param p_workflow_id            _
   */
  PROCEDURE xform_cust_ts_tz_binning(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_bin_date_seq           IN ODMR_OBJECT_IDS,
    p_cust_date_bin_names    IN ODMR_OBJECT_VALUES, -- list of bin names
    p_cust_date_low_bnds     IN ODMR_OBJECT_VALUES,  -- list of lower bounds,
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_null_labels            IN map_out_to_other, -- list of values to be used instead of 'Null bin' label
    p_include_nulls          IN map_out_to_other,  -- 'true' or 'flase' list: to use Null bin or not
    p_null_bin_assignment    IN MAP_BIN_ID_TO_NULL, -- bin id's of NULL values
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
    p_calc_histogram         IN BOOLEAN,
    p_workflow_id            IN NUMBER DEFAULT NULL);

  /**
   * Performs custom categorical binning and populates stats
   *
   -- @param p_input_table_name       input data
   -- @param p_stats_table_name       name of the stats table
   -- @param p_out_columns            list of output column names
   -- @param p_src_columns            list of source column names
   -- @param p_cust_cat_bin_names     list of bin names
   -- @param p_is_others              list flags where other or not
   -- @param p_bin_values             list of bin_values
   -- @param p_sql_definitions        _
   -- @param p_workflow_id            _
   */
  PROCEDURE xform_cust_cat_binning(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_cust_cat_bin_names     IN ODMR_OBJECT_VALUES,  -- list of bin names
    p_is_others              IN ODMR_OBJECT_IDS,     -- list flags where other or not
    p_bin_values             IN ODMR_OBJECT_VALUES,  -- list of bin_values
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_null_labels            IN map_out_to_other, -- list of values to be used instead of 'Null bin' label
    p_include_nulls          IN map_out_to_other,  -- 'true' or 'flase' list: to use Null bin or not
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
    p_calc_histogram         IN BOOLEAN,
    p_workflow_id            IN NUMBER DEFAULT NULL);

  /**
   * Performs missing values treatment of categoric columns and populates stats.
   *
   -- @param p_input_table_name  input data
   -- @param p_stats_table_name  name of the stats table
   -- @param p_out_columns       list of output column names
   -- @param p_src_columns       list of source column names
   -- @param p_mv_cat_funtion    Mode (Min, Max etc)
   -- @param p_mv_cat_replace    categorical replacement value
   -- @param p_cat_bins          number of bins to produce histogram
   -- @param p_sql_definitions   _
   -- @param p_workflow_id       Generate For Apply
   -- @param p_chain_step        Generate For Apply
   */
  PROCEDURE xform_missing_values_cat(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_mv_cat_funtion         IN ODMR_OBJECT_VALUES, -- Min, Max etc
    p_mv_cat_replace         IN ODMR_OBJECT_VALUES,  -- cat. replacement value
    p_cat_bins               IN NUMBER, -- number of bins to produce histogram
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2,
    p_parallel_table_hint    IN VARCHAR2,
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
    p_calc_histogram         IN BOOLEAN,
    p_workflow_id            IN NUMBER DEFAULT NULL,   -- Generate For Apply
    p_chain_step             IN VARCHAR2 DEFAULT NULL, -- Generate For Apply
    p_other_label            IN VARCHAR2 DEFAULT NULL );

  /**
   * Performs missing values treatment of categoric columns and populates stats
   * NVARCHAR2 and NCHAR only
   *
   -- @param p_input_table_name  input data
   -- @param p_stats_table_name  name of the stats table
   -- @param p_out_columns       list of output column names
   -- @param p_src_columns       list of source column names
   -- @param p_mv_cat_funtion    Mode (Min, Max etc)
   -- @param p_mv_cat_replace    categorical replacement value
   -- @param p_cat_bins          number of bins to produce histogram
   -- @param p_sql_definitions   _
   -- @param p_workflow_id       Generate For Apply
   -- @param p_chain_step        Generate For Apply
   */
  PROCEDURE xform_missing_values_cat_nc(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_mv_cat_funtion         IN ODMR_OBJECT_VALUES, -- Mode
    p_mv_cat_replace         IN ODMR_OBJECT_VALUES,  -- categorical replacement value
    p_cat_bins               IN NUMBER, -- number of bins to produce histogram
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2,
    p_parallel_table_hint    IN VARCHAR2,
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
    p_calc_histogram         IN BOOLEAN,
    p_workflow_id            IN NUMBER DEFAULT NULL,   -- Generate For Apply
    p_chain_step             IN VARCHAR2 DEFAULT NULL, -- Generate For Apply
    p_other_label            IN VARCHAR2 DEFAULT NULL );
    
  /**
   * Performs missing values treatment of numeric columns and populates stats
   *
   -- @param p_input_table_name  input data
   -- @param p_stats_table_name  name of the stats table
   -- @param p_out_columns       list of output column names
   -- @param p_src_columns       list of source column names
   -- @param p_mv_num_funtion    Min, Max etc
   -- @param p_mv_num_replace    num replacement value
   -- @param p_num_bins          number of bins to produce histogram
   -- @param p_sql_definitions   
   -- @param p_workflow_id       Generate For Apply
   -- @param p_chain_step        Generate For Apply
   */
  PROCEDURE xform_missing_values_num(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_mv_num_funtion         IN ODMR_OBJECT_VALUES, -- Min, Max etc
    p_mv_num_replace         IN ODMR_OBJECT_IDS,  -- num replacement value
    p_num_bins               IN NUMBER, -- number of bins to produce histogram
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2,
    p_parallel_table_hint    IN VARCHAR2,
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
    p_calc_histogram         IN BOOLEAN,
    p_workflow_id            in number default null,
    p_chain_step             in varchar2 default null);

  /**
   * Performs missing values treatment of DATE,TIMESTAMP columns and populates stats
   *
   -- @param p_input_table_name  input data
   -- @param p_stats_table_name  name of the stats table
   -- @param p_out_columns       list of output column names
   -- @param p_src_columns       list of source column names
   -- @param p_mv_num_funtion    Min, Max etc
   -- @param p_mv_date_replace   date replacement value
   -- @param p_date_bins         number of bins to produce histogram
   -- @param p_sql_definitions   _
   -- @param p_workflow_id       Generate For Apply
   -- @param p_chain_step        Generate For Apply
   */
  PROCEDURE xform_missing_values_date(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_mv_num_funtion         IN ODMR_OBJECT_VALUES, -- Min, Max etc
    p_mv_date_replace        IN ODMR_OBJECT_VALUES,  -- date replacement value
    p_date_bins              IN NUMBER, -- number of bins to produce histogram
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2,
    p_parallel_table_hint    IN VARCHAR2,
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
    p_calc_histogram         IN BOOLEAN, 
    p_workflow_id            in number default null,   -- Generate For Apply
    p_chain_step             in varchar2 default null -- Generate For Apply
    );
    
  /**
   * Performs missing values treatment of TIMESTAMP WITH TIME ZONE columns and populates stats
   *
   -- @param p_input_table_name  input data
   -- @param p_stats_table_name  name of the stats table
   -- @param p_out_columns       list of output column names
   -- @param p_src_columns       list of source column names
   -- @param p_mv_num_funtion    Min, Max etc
   -- @param p_mv_date_replace   date replacement value
   -- @param p_date_bins         number of bins to produce histogram
   -- @param p_sql_definitions   _
   -- @param p_workflow_id       Generate For Apply
   -- @param p_chain_step        Generate For Apply
   */
  PROCEDURE xform_missing_values_tz(
    p_input_table_name       IN VARCHAR2,
    p_stats_table_name       IN VARCHAR2, 
    p_out_columns            IN ODMR_OBJECT_NAMES, 
    p_src_columns            IN ODMR_OBJECT_NAMES, 
    p_mv_num_funtion         IN ODMR_OBJECT_VALUES, 
    p_mv_date_replace        IN ODMR_OBJECT_VALUES,  
    p_date_bins              IN NUMBER, 
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2,
    p_parallel_table_hint    IN VARCHAR2,
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
    p_calc_histogram         IN BOOLEAN,
    p_workflow_id            in number default null,   
    p_chain_step             in varchar2 default null  
    );
  
  /**
   * Performs outlier treatment of numeric columns and populates stats
   *
   -- @param p_input_table_name       input data
   -- @param p_stats_table_name       name of the stats table
   -- @param p_meta_stats_table_name  name of the stats table in the metadata (because of single column refresh this table maybe different from p_stats_table_name)
   -- @param p_out_columns            list of output column names
   -- @param p_src_columns            list of source column names
   -- @param p_outlier_type           StandardDeviation, Value, Percent
   -- @param p_replace_with           EdgeValues or Nulls
   -- @param p_outlier_multiple_value outlier multiple
   -- @param p_outlier_lower_value    outlier lower value 
   -- @param p_outlier_upper_value    outlier upper value
   -- @param p_outlier_lower_percent  outlier lower percent
   -- @param p_outlier_upper_percent  outlier lower percent
   -- @param p_num_bins               number of bins to produce histogram
   -- @param p_sql_definitions        _
   -- @param p_workflow_id            _
   -- @param p_chain_step             _
   */
  PROCEDURE xform_outlier(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_meta_stats_table_name  IN VARCHAR2, -- name of the stats table in the metadata (because of single
    --                                       column refresh this table maybe different from p_stats_table_name)
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_outlier_type           IN ODMR_OBJECT_VALUES, -- StandardDeviation, Value, Percent
    p_replace_with           IN ODMR_OBJECT_VALUES, -- EdgeValues or Nulls
    p_outlier_multiple_value IN ODMR_OBJECT_IDS,  -- outlier multiple
    p_outlier_lower_value    IN ODMR_OBJECT_IDS,  -- outlier lower value
    p_outlier_upper_value    IN ODMR_OBJECT_IDS,  -- outlier upper value
    p_outlier_lower_percent  IN ODMR_OBJECT_IDS, -- outlier lower percent
    p_outlier_upper_percent  IN ODMR_OBJECT_IDS, -- outlier lower percent
    p_num_bins               IN NUMBER, -- number of bins to produce histogram
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2,
    p_parallel_table_hint    IN VARCHAR2,
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
    p_calc_histogram         IN BOOLEAN,
    p_workflow_id            IN NUMBER DEFAULT NULL,
    p_chain_step             IN VARCHAR2 DEFAULT NULL,
    p_nulls_label            IN VARCHAR2 DEFAULT NULL);

  /**
   * Performs normalization of numeric columns and populates stats
   * 
   -- @param p_input_table_name   input data
   -- @param p_stats_table_name   name of the stats table
   -- @param p_out_columns        list of output column names
   -- @param p_src_columns        list of source column names
   -- @param p_norm_type          MinMax, ZScore, LinearScale
   -- @param p_norm_custom_shift  _
   -- @param p_norm_custom_scale  _
   -- @param p_num_bins           number of bins to produce histogram
   -- @param p_sql_definitions    _
   -- @param p_workflow_id        Generate For Apply
   -- @param p_chain_step         Generate For Apply
   */
  PROCEDURE xform_normalization(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_norm_type              IN ODMR_OBJECT_VALUES, -- MinMax, ZScore, LinearScale
    p_norm_custom_shift      IN ODMR_OBJECT_IDS,
    p_norm_custom_scale      IN ODMR_OBJECT_IDS,
    p_num_bins               IN NUMBER, -- number of bins to produce histogram
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2,
    p_parallel_table_hint    IN VARCHAR2,
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
    p_calc_histogram         IN BOOLEAN,
    p_workflow_id            IN NUMBER DEFAULT NULL,   -- Generate For Apply
    p_chain_step             IN VARCHAR2 DEFAULT NULL, -- Generate For Apply
    p_nulls_label            IN VARCHAR2 DEFAULT NULL);
    
  /**
   * Performs custom transformation and populates stats
   *
   -- @param p_input_table_name       input data
   -- @param p_stats_table_name       name of the stats table
   -- @param p_out_columns            list of output column names
   -- @param p_out_column_types       _
   -- @param p_src_columns            list of source column names
   -- @param p_custom_xforms          list of custom transformations
   -- @param p_num_bins               number of bins to produce histogram
   -- @param p_cat_bins               number of bins to produce histogram
   -- @param p_date_bins              number of bins to produce histogram
   -- @param p_sql_definitions        _
   -- @param p_workflow_id            _
   */ 
  PROCEDURE xform_custom(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_out_columns            IN ODMR_OBJECT_NAMES, -- list of output column names
    p_out_column_types       IN OUT ODMR_OBJECT_NAMES,
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
    p_custom_xforms          IN ODMR_OBJECT_VALUES, -- list of custom transformations
    p_num_bins               IN NUMBER, -- number of bins to produce histogram
    p_cat_bins               IN NUMBER, -- number of bins to produce histogram
    p_date_bins              IN NUMBER, -- number of bins to produce histogram
    p_sql_definitions        IN OUT SQL_DEFINITION_ARRAY,
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2,
    p_parallel_table_hint    IN VARCHAR2,
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
    p_calc_histogram         IN BOOLEAN,
    p_workflow_id            IN NUMBER DEFAULT NULL);


  /**
   -- @param p_datatype _
   */
  FUNCTION ISTIMESTAMP (p_datatype IN VARCHAR2) RETURN BOOLEAN;
  /**
   -- @param p_datatype _
   */
  FUNCTION ISTIMESTAMP_WITH_TIME_ZONE (p_datatype IN VARCHAR2) RETURN BOOLEAN;
  /**
   -- @param p_datatype _
   */
  FUNCTION ISTIMESTAMP_WITH_LOCAL_TZ (p_datatype IN VARCHAR2) RETURN BOOLEAN;
  /**
   * Populates bin boundary table TIMESTAMP WITH TIME ZONE.
   *
   -- @param p_input_table_name       input data
   -- @param p_bin_boundary_table     result bin boundary table
   -- @param p_src_column             column to bin
   -- @param p_bin_count              bin counts for the column
   */
  PROCEDURE INSERT_BIN_TIMESTAMP_EQWIDTH(
    p_input_table_name       IN VARCHAR2,-- input data
    p_bin_boundary_table     IN VARCHAR2, -- result bin boundary table
    p_src_column             IN VARCHAR2, -- column to bin
    p_bin_count              IN NUMBER,   -- bin counts for the column
    p_parallel_query_hint    IN VARCHAR2,
    p_parallel_insert_hint   IN VARCHAR2,
    p_parallel_table_hint    IN VARCHAR2 );

  /**
   * If statistsics has beem run but new columns were added to the data source
   * this functions will calculate their stats. Used from the client.
   *
   -- @param p_input_table_name       input data
   -- @param p_stats_table_name       name of the stats table
   -- @param p_src_columns            list of source column names for which we need to add stats
   -- @param p_src_column_types       _                           
   -- @param p_num_bins               number of bins to produce histogram
   -- @param p_cat_bins               number of bins to produce histogram
   -- @param p_date_bins              number of bins to produce histogram
   */
  PROCEDURE add_src_columns_to_stats_table(
    p_input_table_name       IN VARCHAR2,-- input data
    p_stats_table_name       IN VARCHAR2, -- name of the stats table
    p_src_columns            IN ODMR_OBJECT_NAMES, -- list of source column names
                                      -- for which we need to add stats
    p_src_column_types       IN ODMR_OBJECT_NAMES,
    p_num_bins               IN NUMBER, -- number of bins to produce histogram
    p_cat_bins               IN NUMBER, -- number of bins to produce histogram
    p_date_bins              IN NUMBER, -- number of bins to produce histogram
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

  ------------------------------------------------------------------------------
  -- create_profile_stas_table_srv: server function
  -- Calculating statistics for Explore Data Node
  -- creates SQL of the following type:
  --  WITH view_name as ( list_of_stats: COUNT(*), COUNT (column), COUNT (DISTINCT column) etc )
  --  UNION ALL of All columns with stats taken from above view.
  -- See: https://stbeehive.oracle.com/teamcollab/wiki/Data+Miner:Explore+Data+Node+Performance
  ------------------------------------------------------------------------------

  PROCEDURE create_profile_stas_table_srv(
    p_job_name                IN VARCHAR2,
    p_node_name               IN VARCHAR2,
    p_workflowId              IN NUMBER,
    p_nodeId                  IN VARCHAR2,
    p_cache_table             IN VARCHAR2,
    p_statistics_table        IN VARCHAR2,
    p_use_full                IN VARCHAR2,
    p_attributes              IN ODMR_OBJECT_NAMES,
    p_attrDataTypes           IN ODMR_OBJECT_NAMES,
    p_parallel_query_hint     IN VARCHAR2,
    p_parallel_insert_hint    IN VARCHAR2,
    p_parallel_table_hint     IN VARCHAR2,
    p_in_memory               IN BOOLEAN,
    p_compression             IN VARCHAR2,
    p_priority                IN VARCHAR2,
    p_inclusive               IN BOOLEAN,
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

  ------------------------------------------------------------------------------
  -- create_profile_stas_table_clnt: Client function
  -- Calculating statistics for Explore Data Node
  -- creates SQL of the following type:
  --  WITH view_name as ( list_of_stats: COUNT(*), COUNT (column), COUNT (DISTINCT column) etc )
  --  UNION ALL of All columns with stats taken from above view.
  -- See: https://stbeehive.oracle.com/teamcollab/wiki/Data+Miner:Explore+Data+Node+Performance
  ------------------------------------------------------------------------------
  PROCEDURE create_profile_stas_table_clnt(
    p_job_name                IN VARCHAR2,
    p_node_name               IN VARCHAR2,
    p_workflowId              IN NUMBER,
    p_nodeId                  IN VARCHAR2,
    p_cache_table             IN VARCHAR2,
    p_statistics_table        IN VARCHAR2,
    p_use_full                IN VARCHAR2,
    p_attributes              IN ODMR_OBJECT_NAMES,
    p_attrDataTypes           IN ODMR_OBJECT_NAMES,
    p_parallel_query_hint     IN VARCHAR2,
    p_parallel_insert_hint    IN VARCHAR2,
    p_parallel_table_hint     IN VARCHAR2,
    p_in_memory               IN BOOLEAN,
    p_compression             IN VARCHAR2,
    p_priority                IN VARCHAR2,
    p_inclusive               IN BOOLEAN,
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
    p_calc_mode_all           IN BOOLEAN);

  /**
   *
   * Return the name of the Stats table for a Data Profile node.
   -- @param p_workflowId   Workflow ID
   -- @param p_nodeId       Node ID
   -- @param p_stats_table  Where to store the result (Table Name)
   */
  PROCEDURE get_profile_stats_table (
    p_workflowId  IN NUMBER,
    p_nodeId      IN VARCHAR2,
    p_stats_table OUT VARCHAR2);

  /**
   * Add double quotes if needed
   -- @param p_column_name Column to add quotes
   */
  FUNCTION add_quotes_if_none (p_column_name IN VARCHAR2)
    RETURN VARCHAR2;

  /**
   * Add single quotes if needed
   -- @param p_column_name Column to add quotes
   */
  FUNCTION add_single_quotes_if_none (p_column_name IN VARCHAR2) 
    RETURN VARCHAR2;

  /**
   * Support for graph node: binning multiple columns
   *
   -- @param p_input_sql     _
   -- @param p_attributes    _
   -- @param p_attrDataTypes _
   -- @param p_num_bins      _
   -- @param p_col_names     _
   -- @param p_bin_values    _
   -- @param p_cut_points    _
   */
  PROCEDURE BIN_MULTIPLE_COLUMNS (
    p_input_sql             IN CLOB,
    p_attributes            IN ODMR_OBJECT_NAMES,
    p_attrDataTypes         IN ODMR_OBJECT_NAMES,
    p_num_bins              IN ODMR_OBJECT_IDS,
    p_col_names             IN OUT ODMR_OBJECT_NAMES, 
    p_bin_values            IN OUT ODMR_OBJECT_VALUES, 
    p_cut_points            IN OUT ODMR_OBJECT_VALUES,
    p_nulls_label           IN VARCHAR2,
    p_other_label           IN VARCHAR2,
    p_parallel_query_hint   IN VARCHAR2 DEFAULT '/* + NO_PARALLEL */',
    p_parallel_insert_hint  IN VARCHAR2 DEFAULT ' ',
    p_parallel_table_hint   IN VARCHAR2 DEFAULT 'NOPARALLEL',
    p_in_memory             IN BOOLEAN DEFAULT FALSE,
    p_compression           IN VARCHAR2  DEFAULT ' ',
    p_priority              IN VARCHAR2 DEFAULT ' ' );
 
  PROCEDURE add_xformed_cols_stats(
    p_node_name               IN VARCHAR2,
    p_workflowId              IN NUMBER,
    p_nodeId                  IN VARCHAR2,
    p_binned_table            IN VARCHAR2,
    p_statistics_table        IN VARCHAR2,
    p_parallel_query_hint     IN VARCHAR2,
    p_parallel_insert_hint    IN VARCHAR2,
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
    p_calc_mode_all           IN BOOLEAN );

END;
/
