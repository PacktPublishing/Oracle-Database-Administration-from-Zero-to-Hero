CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_INTERNAL_UTIL" 
AUTHID CURRENT_USER AS

  c_nest_num_name                CONSTANT VARCHAR2(30) := 'DM_NESTED_NUMERICALS';
  c_nest_cat_name                CONSTANT VARCHAR2(30) := 'DM_NESTED_CATEGORICALS';
  c_nest_num_ctyp                CONSTANT NUMBER := 100001;
  c_nest_cat_ctyp                CONSTANT NUMBER := 100002;

  -- Large Object Name Project
  SUBTYPE   TYPE_VCHAR_35     IS   VARCHAR2(35);
  SUBTYPE   TYPE_VCHAR_128    IS   VARCHAR2(128);
  SUBTYPE   TYPE_VCHAR_130    IS   VARCHAR2(130);
  SUBTYPE   TYPE_VCHAR_261    IS   VARCHAR2(261);
  SUBTYPE   TYPE_VCHAR_32K    IS   VARCHAR2(32767);
  SUBTYPE   TYPE_VCHAR_4K     IS   VARCHAR2(4000);
  
  -- CANONical identifier MAXimum LENgth (in bytes)
  -----------------------------------------------------------------------------
  -- This constant contains the list of string column types that are supported
  -- in this package.
  c_canon_maxlen                 CONSTANT BINARY_INTEGER := 30;

  SUBTYPE
    CIDEN_VCHAR_TYPE               IS VARCHAR2(30);

  TYPE
    CIDEN_ITAB_TYPE                IS TABLE OF CIDEN_VCHAR_TYPE
                                      INDEX BY BINARY_INTEGER;

  TYPE
    CIDEN_ATAB_TYPE                IS TABLE OF BINARY_INTEGER
                                      INDEX BY CIDEN_VCHAR_TYPE;
  TYPE
    NUM_NTAB_TYPE                  IS TABLE OF NUMBER;

  -----------------------------------------------------------------------------
  -- IDENtifier collection types
  -----------------------------------------------------------------------------
  SUBTYPE
    IDEN_VARR_TYPE                 IS DBMS_DATA_MINING_TRANSFORM.COLUMN_LIST;

  TYPE
    LSTMT_REC_TYPE                IS RECORD (
      lstmt                          dbms_sql.VARCHAR2A,
      lb                             BINARY_INTEGER DEFAULT 1,
      ub                             BINARY_INTEGER DEFAULT 0);
  --SUBTYPE
  --  LSTMT_REC_TYPE                 IS dbms_data_mining_transform.EXPRESSION_REC;

  TYPE TABLE_ARRAY                IS TABLE OF TYPE_VCHAR_130;

  c_adt_ctyp                       CONSTANT NUMBER := 109;

  SUBTYPE
    STMT_VCHAR_TYPE                IS VARCHAR2(32767);

  -----------------------------------------------------------------------------
  -- Data Guide type
  -----------------------------------------------------------------------------
  TYPE DATAGUIDETYPE IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(4000);

  /**
   -- @param p_col       VARCHAR2,
   -- @param p_data_tref VARCHAR2
   */
  FUNCTION nest_ctyp(
    p_col                          VARCHAR2,
    p_data_tref                    VARCHAR2)
  RETURN NUMBER;

  /**
   -- @param p_col                          VARCHAR2,
   -- @param p_type                         VARCHAR2,
   -- @param p_data_tref                    VARCHAR2
   */
  FUNCTION nest_check(
    p_col                          VARCHAR2,
    p_type                         VARCHAR2,
    p_data_tref                    VARCHAR2)
  RETURN BOOLEAN;

  /**
   -- @param p_sql_stmt      IN OUT  VARCHAR2,
   -- @param p_column_ids    IN    ODMR_OBJECT_IDS
   */
  PROCEDURE create_in_condition(
    p_sql_stmt      IN OUT  VARCHAR2,
    p_column_ids    IN    ODMR_OBJECT_IDS );

  /**
   -- @param v_transform_list IN DM_TRANSFORMS
   */
  --PROCEDURE print_dm_transfrorm( v_transform_list IN DM_TRANSFORMS );
  
  PROCEDURE print_debug_message(
    p_message       IN VARCHAR2,
    p_detail        IN OUT LSTMT_REC_TYPE,
    p_workflow_name IN VARCHAR2 DEFAULT 'Unknown',
    p_workflowId    IN NUMBER DEFAULT NULL,
    p_nodeId        IN VARCHAR2 DEFAULT NULL,
    p_subnode_id    IN NUMBER DEFAULT NULL);

  PROCEDURE print_debug_message(
    p_message       IN VARCHAR2,
    p_detail        IN VARCHAR2,
    p_workflow_name IN VARCHAR2 DEFAULT 'Unknown',
    p_workflowId    IN NUMBER DEFAULT NULL,
    p_nodeId        IN VARCHAR2 DEFAULT NULL,
    p_subnode_id    IN NUMBER DEFAULT NULL);

  PROCEDURE copy_table_for_debugging(
          p_table_name IN VARCHAR2, 
          p_comment IN VARCHAR2 DEFAULT NULL);

  FUNCTION remove_double_quotes_if_any (p_value IN VARCHAR2) RETURN VARCHAR2;    
  FUNCTION remove_double_quotes_if_any (p_value IN CLOB) RETURN CLOB;

  /**
   * prints TRANSFORM_LIST
   *
   -- @param  v_transform_list IN dbms_data_mining_transform.TRANSFORM_LIST
   */
  --PROCEDURE print_transfrorm_list( v_transform_list IN dbms_data_mining_transform.TRANSFORM_LIST );

  /**
   * uniquie name (from prvtdmj)
   *
   -- @param p_prefix               VARCHAR2 DEFAULT 'ODMR$',
   -- @param p_is25bytes            BOOLEAN DEFAULT FALSE
   */
  FUNCTION unique_object_name(
    p_prefix               VARCHAR2 DEFAULT 'ODMR$',
    p_is25bytes            BOOLEAN DEFAULT FALSE)
  RETURN VARCHAR2;

  /**
   -- @param p_table_name  IN VARCHAR2,
   -- @param p_src_schema  IN VARCHAR2,
   -- @param p_src_table   IN VARCHAR2,
   -- @param p_text_column IN VARCHAR2,
   -- @param p_explain_out IN VARCHAR2,
   -- @param p_case_id     IN VARCHAR2
   */
  PROCEDURE create_nested_text_table (
    p_table_name  IN VARCHAR2,
    p_src_schema  IN VARCHAR2,
    p_src_table   IN VARCHAR2,
    p_text_column IN VARCHAR2,
    p_explain_out IN VARCHAR2,
    p_case_id     IN VARCHAR2);

  /**
   -- @param p_table_name VARCHAR2
   */
  FUNCTION is_table_present( p_table_name  VARCHAR2 ) RETURN BOOLEAN;
  
  /**
   -- @param p_table_name VARCHAR2
   */
  FUNCTION get_table_row_count( p_table_name  VARCHAR2 ) RETURN NUMBER;  
  
  /**
   -- @param p_index_name VARCHAR2
   */
  FUNCTION is_index_present( p_index_name  VARCHAR2 ) RETURN BOOLEAN;
  
   /**
   -- @param p_key_name VARCHAR2
   */
  FUNCTION is_key_present( p_key_name  VARCHAR2 ) RETURN BOOLEAN;

  /**
   -- @param p_object_name  VARCHAR2
   */
  PROCEDURE clean_table_or_view( p_object_name  VARCHAR2 );

  /**
   -- @param r_lstmt  IN OUT NOCOPY LSTMT_REC_TYPE
   */
  PROCEDURE ls_clear(
    r_lstmt                        IN OUT NOCOPY LSTMT_REC_TYPE);

  /**
   -- @param r_lstmt  IN OUT NOCOPY LSTMT_REC_TYPE
   -- @param p_txt    VARCHAR2
   */
  PROCEDURE ls_append(
    r_lstmt                        IN OUT NOCOPY LSTMT_REC_TYPE,
    p_txt                          VARCHAR2);

  /**
   -- @param r_lstmt  IN OUT NOCOPY LSTMT_REC_TYPE
   -- @param p_txt    LSTMT_REC_TYPE
   */
  PROCEDURE ls_append(
    r_lstmt                        IN OUT NOCOPY LSTMT_REC_TYPE,
    p_txt                          LSTMT_REC_TYPE);

  /**
   * supports multibyte character set (jd 12/04-2010)
   -- @param r_lstmt    IN OUT NOCOPY LSTMT_REC_TYPE,
   -- @param p_txt      CLOB
   */
  PROCEDURE ls_append(
    r_lstmt                        IN OUT NOCOPY LSTMT_REC_TYPE,
    p_txt                          CLOB);

 /**
  * Replaces the specified from_string to to_string. <br/ >
  * Assumes long statement has not packed the query, like splitting the
  * table name across multiple array elements.
  * 
  -- @param r_lstmt             long statement
  -- @param p_from_token        from string token
  -- @param p_to_token          to string token
  -- @return Modified long statement.
  *
  */
 PROCEDURE ls_replace(
    r_lstmt                        IN OUT NOCOPY LSTMT_REC_TYPE,
    p_from_token                   VARCHAR2,
    p_to_token                     VARCHAR2,
    p_only_first                   BOOLEAN DEFAULT FALSE);

 /**
  * Replaces the specified from_string to to_string. <br/ >
  * THIS FUNCTION SHOULD BE USED INSTEAD OF ls_replace
  * REGEXP_REPLACE
  * 
  -- @param r_lstmt             long statement
  -- @param p_from_token        from string token
  -- @param p_to_token          to string token
  -- @return result
  *
  */
  FUNCTION ls_replace2(
    r_lstmt                        LSTMT_REC_TYPE,
    p_from_token                   VARCHAR2,
    p_to_token                     CLOB,
    p_only_first                   BOOLEAN DEFAULT FALSE) RETURN LSTMT_REC_TYPE;

  FUNCTION ls_replace2(
    r_lstmt                        LSTMT_REC_TYPE,
    p_from_token                   VARCHAR2,
    p_to_token                     VARCHAR2,
    p_only_first                   BOOLEAN DEFAULT FALSE) RETURN LSTMT_REC_TYPE;

  /**
   * Describes long query statement.
   -- @param p_lstmt       long statement
   -- @param p_lf_flag     dbms_sql.parse line feed flag
   -- @param p_lang_flag   dbms_sql.parse language flag
   -- @return r_desc_itab  - describe table
   */
  PROCEDURE ls_desc(
    p_lstmt                        LSTMT_REC_TYPE,
    r_desc_itab                    OUT NOCOPY dbms_sql.DESC_TAB2,
    p_lf_flag                      BOOLEAN DEFAULT FALSE,
    p_lang_flag                    NUMBER DEFAULT dbms_sql.native);

  /**
   * Converts long statement to text.
   *
   -- @param p_lstmt long statement
   -- @return  Long statement converted to text.
   -- @throws  VALUE_ERROR: long statment too long
   */
  FUNCTION ls_text(
    p_lstmt             IN OUT NOCOPY LSTMT_REC_TYPE)
  RETURN VARCHAR2;

  /**
   -- @param p_lstmt             IN OUT NOCOPY LSTMT_REC_TYPE
   */
  FUNCTION ls_CLOB(
    p_lstmt             IN OUT NOCOPY LSTMT_REC_TYPE)
  RETURN CLOB;

  /**
   -- @param p_cur                          NUMBER,
   -- @param p_lstmt                        LSTMT_REC_TYPE,
   -- @param p_lf_flag                      BOOLEAN DEFAULT FALSE,
   -- @param p_lang_flag                    NUMBER DEFAULT dbms_sql.native
   */
  PROCEDURE ls_parse(
    p_cur                          NUMBER,
    p_lstmt                        LSTMT_REC_TYPE,
    p_lf_flag                      BOOLEAN DEFAULT FALSE,
    p_lang_flag                    NUMBER DEFAULT dbms_sql.native);

  /**
   -- @param p_data_tref                    VARCHAR2,
   -- @param r_desc_itab                    OUT dbms_sql.DESC_TAB2
   */
  PROCEDURE tref_desc(
    p_data_tref                    VARCHAR2,
    r_desc_itab                    OUT dbms_sql.DESC_TAB2);

  /**
   -- @param tempTables         IN OUT NOCOPY TABLE_ARRAY,
   -- @param temp_table         IN VARCHAR2
   */
  FUNCTION add_temp_table(
    tempTables         IN OUT NOCOPY TABLE_ARRAY,
    temp_table         IN VARCHAR2) RETURN VARCHAR2;

  /**
   -- @param tempTables         IN OUT NOCOPY TABLE_ARRAY
   */
  PROCEDURE clean_tables_or_views(
    tempTables         IN OUT NOCOPY TABLE_ARRAY);

  /**
   * removes text column
   *
   -- @param p_schema_name     IN     VARCHAR2,
   -- @param p_table_name      IN     VARCHAR2,
   -- @param p_text_column     IN     VARCHAR2
   */
  FUNCTION replace_text_with_nested(
    p_schema_name     IN     VARCHAR2,
    p_table_name      IN     VARCHAR2,
    p_text_column     IN     VARCHAR2)
  RETURN DBMS_DATA_MINING_TRANSFORM.COLUMN_LIST;

  /**
   -- @param query IN OUT NOCOPY LSTMT_REC_TYPE
   */
  PROCEDURE create_table_from_query(query IN OUT NOCOPY LSTMT_REC_TYPE);

  /**
   -- @param r_xform_lstmt     IN OUT NOCOPY LSTMT_REC_TYPE,
   -- @param p_expr_pat        IN VARCHAR2,
   -- @param p_col             IN VARCHAR2,
   -- @param p_col_pat         IN VARCHAR2 DEFAULT ':col',
   -- @param p_xform_settings  IN ODMR_TRANSFORM_SETTINGS DEFAULT NULL
   */
  PROCEDURE ls_append_expr(
    r_xform_lstmt     IN OUT NOCOPY LSTMT_REC_TYPE,
    p_expr_pat        IN VARCHAR2,
    p_col             IN VARCHAR2,
    p_col_pat         IN VARCHAR2 DEFAULT ':col',
    p_xform_settings  IN ODMR_TRANSFORM_SETTINGS DEFAULT NULL);

  /**
   -- @param r_lstmt                        IN OUT NOCOPY LSTMT_REC_TYPE,
   -- @param p_txt                          VARCHAR2
   */
  PROCEDURE ls_prepend(
    r_lstmt                        IN OUT NOCOPY LSTMT_REC_TYPE,
    p_txt                          VARCHAR2);
  
  /**
   -- @param r_lstmt                        IN OUT NOCOPY LSTMT_REC_TYPE,
   -- @param p_txt                          LSTMT_REC_TYPE
   */
  PROCEDURE ls_prepend(
    r_lstmt                        IN OUT NOCOPY LSTMT_REC_TYPE,
    p_txt                          LSTMT_REC_TYPE);

  /**
   *  This procedure coverts input schema object name to upper
   *  case if necessary, and strip quotation marks.
   -- @param p_in_name VARCHAR2
   */
  FUNCTION upcase ( p_in_name  VARCHAR2)
  RETURN TYPE_VCHAR_130;

  /**
   -- @param p_val VARCHAR2
   */
  FUNCTION to_literal(p_val VARCHAR2)
  RETURN VARCHAR2;

  /**
   -- @param p_val VARCHAR2
   */
  FUNCTION to_xpath_literal(p_val VARCHAR2)
  RETURN VARCHAR2;

  /**
   -- @param p_model_schema    IN VARCHAR2, 
   -- @param p_model_name      IN VARCHAR2, 
   -- @param p_model_algorithm IN VARCHAR2, 
   -- @param p_target          IN VARCHAR2
   */
  FUNCTION model_exists(
    p_model_schema    IN VARCHAR2, 
    p_model_name      IN VARCHAR2, 
    p_model_algorithm IN VARCHAR2, 
    p_target          IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION parser_exists RETURN BOOLEAN;

  /**
   * Check if the table exists in the DB
   -- @param p_schema_name IN VARCHAR2, 
   -- @param p_table_name  IN VARCHAR2
   */
  FUNCTION db_table_exists(
    p_schema_name IN VARCHAR2, 
    p_table_name IN VARCHAR2) RETURN BOOLEAN;

  /**
   -- @param p_schema_name IN VARCHAR2, 
   -- @param p_table_name  IN VARCHAR2
   */
  FUNCTION db_table_empty_no_ucase(
    p_schema_name IN VARCHAR2, 
    p_table_name  IN VARCHAR2) RETURN BOOLEAN;
  
  /**
   -- @param p_schema_name IN VARCHAR2, 
   -- @param p_table_name  IN VARCHAR2
   */
  FUNCTION db_table_empty(
    p_schema_name IN VARCHAR2, 
    p_table_name IN VARCHAR2) RETURN BOOLEAN;

  /**
   -- @param p_input_sql IN OUT NOCOPY LSTMT_REC_TYPE
   */
  FUNCTION db_table_empty(p_input_sql IN OUT NOCOPY LSTMT_REC_TYPE) RETURN BOOLEAN;

  /**
   * Tests to see if the table/view is granted either directly to the current user or to PUBLIC.
   * If this is not the case, then CREATE VIEW will fail due to lack of privileges. <br/>
   * 
   -- @param p_schema_name IN VARCHAR2, 
   -- @param p_table_name  IN VARCHAR2
   */
  FUNCTION db_table_granted_directly (
    p_schema_name IN VARCHAR2, 
    p_table_name IN VARCHAR2) RETURN BOOLEAN;

  /**
   -- @param p_lock_name IN VARCHAR2, 
   -- @param p_wait IN NUMBER DEFAULT SYS.DBMS_LOCK.MAXWAIT
   */
  --PROCEDURE request_lock (
  --  p_lock_name IN VARCHAR2, 
  --  p_wait IN NUMBER DEFAULT SYS.DBMS_LOCK.MAXWAIT);

  /**
   -- @param p_job_name IN VARCHAR2, 
   -- @param p_chain_step IN VARCHAR2, 
   -- @param p_wait IN NUMBER DEFAULT SYS.DBMS_LOCK.MAXWAIT
   */
  FUNCTION request_lock (
    p_job_name IN VARCHAR2, 
    p_chain_step IN VARCHAR2, 
    p_wait IN NUMBER DEFAULT SYS.DBMS_LOCK.MAXWAIT) RETURN VARCHAR2;

  /**
   * wrapper to release a lock
   *
   -- @param p_lock_name IN VARCHAR2
   */
  PROCEDURE release_lock(p_lock_name IN VARCHAR2);

  TYPE MSG_PARAMS is TABLE OF NVARCHAR2(4000);

  SUBTYPE STACK_TRACE is VARCHAR2(32767);

  /**
   -- @param p_error_code    IN NUMBER,
   -- @param p_params        IN MSG_PARAMS,
   -- @param p_stack_trace   IN STACK_TRACE DEFAULT ''
   */
  PROCEDURE RAISE_ERR(
    p_error_code    IN NUMBER,
    p_params        IN MSG_PARAMS,
    p_stack_trace   IN STACK_TRACE DEFAULT '' );

  /**
   * Write a message on the DBMS_OUTPUT.PUT_LINE
   -- @param p_message IN VARCHAR2
   */
  PROCEDURE DEBUG_MSG( p_message IN VARCHAR2 );

  /**
   -- @param p_projectId       IN NUMBER,
   -- @param p_project_name    IN VARCHAR2,
   -- @param p_job             IN VARCHAR2,
   -- @param p_workflowId      IN NUMBER,
   -- @param p_workflow_name   IN NUMBER,
   -- @param p_nodeId          IN VARCHAR2,
   -- @param p_node_name       IN VARCHAR2 DEFAULT NULL,
   -- @param p_subnode_id      IN VARCHAR2 DEFAULT NULL,
   -- @param p_subnode_name    IN VARCHAR2 DEFAULT NULL,
   -- @param p_message_type    IN VARCHAR2,
   -- @param p_message_subtype IN VARCHAR2,
   -- @param p_message_task    IN VARCHAR2,
   -- @param p_duration        IN INTERVAL DAY TO SECOND DEFAULT NULL,
   -- @param p_message_code    IN NUMBER DEFAULT NULL,
   -- @param p_params          IN MSG_PARAMS DEFAULT NULL,
   -- @param p_message_details IN VARCHAR2 DEFAULT NULL
   */
  PROCEDURE EVENT_LOG(p_projectId       IN NUMBER DEFAULT NULL,
                      p_project_name    IN VARCHAR2 DEFAULT NULL,
                      p_job             IN VARCHAR2 DEFAULT NULL,
                      p_workflowId      IN NUMBER DEFAULT NULL,
                      p_workflow_name   IN VARCHAR2 DEFAULT NULL,
                      p_nodeId          IN VARCHAR2 DEFAULT NULL,
                      p_node_name       IN VARCHAR2 DEFAULT NULL,
                      p_subnode_id      IN VARCHAR2 DEFAULT NULL,
                      p_subnode_name    IN VARCHAR2 DEFAULT NULL,
                      p_message_type    IN VARCHAR2,
                      p_message_subtype IN VARCHAR2 DEFAULT NULL,
                      p_message_task    IN VARCHAR2,
                      p_duration        IN INTERVAL DAY TO SECOND DEFAULT NULL,
                      p_message_code    IN NUMBER DEFAULT NULL,
                      p_params          IN MSG_PARAMS DEFAULT NULL,
                      p_message_details IN VARCHAR2 DEFAULT NULL);

  DB_OBJECT_TABLE     CONSTANT VARCHAR2(30) := 'TABLE';
  DB_OBJECT_VIEW      CONSTANT VARCHAR2(30) := 'VIEW';
  DB_OBJECT_MODEL     CONSTANT VARCHAR2(30) := 'MODEL';
  DB_OBJECT_CHAIN     CONSTANT VARCHAR2(30) := 'CHAIN';
  DB_OBJECT_JOB       CONSTANT VARCHAR2(30) := 'JOB';
  DB_OBJECT_POLICY    CONSTANT VARCHAR2(30) := 'POLICY';
  DB_OBJECT_LEXER     CONSTANT VARCHAR2(30) := 'LEXER';
  DB_OBJECT_STOPLIST  CONSTANT VARCHAR2(30) := 'STOPLIST';

  TYPE DB_OBJECT IS RECORD (
    object_name VARCHAR2(30),
    object_type VARCHAR2(30), -- T - table/view, M - model, C - scheduler chain, J - scheduler job
    object_subtype VARCHAR2(32767), -- e.g. test metric, confusion matrix, lift, ROC, etc
    creation_date TIMESTAMP
    );
  TYPE DB_OBJECTS IS TABLE OF DB_OBJECT;

  /**
   -- @param p_db_objects IN OUT NOCOPY DB_OBJECTS
   */
  PROCEDURE delete_db_objects(p_db_objects IN OUT NOCOPY DB_OBJECTS);

  /**
   * If value is numeric then return true, else return false
   *
   -- @param p_value VARCHAR2
   */
  FUNCTION is_numeric(p_value VARCHAR2) RETURN BOOLEAN;


  /**
   -- @param p_datatype   in varchar2, 
   -- @param p_model_type in varchar2
   -- @return true if target datatype is supported for the model type
   */
  FUNCTION is_supported_target_datatype(
    p_datatype   in varchar2, 
    p_model_type in varchar2) return BOOLEAN;
  
  /**
   -- @param p_datatype   in varchar2, 
   -- @param p_model_type in varchar2
   -- @return true if target datatype is supported for the model type
   */ 
  FUNCTION is_supported_caseid_datatype(
    p_datatype   in varchar2) return BOOLEAN;
    
  /**
   -- @param p_datatype    in varchar2, 
   -- @param p_model_type  in varchar2, 
   -- @param p_mining_type in varchar2
   -- @return true if datatype is supported for the model type
   */
  FUNCTION is_supported_datatype(
    p_datatype    in varchar2, 
    p_model_type  in varchar2, 
    p_mining_type in varchar2) return BOOLEAN;


  /**
   * garbage collect all user created objects only if all workflows are deleted
   */
  PROCEDURE cleanup_user_repository;

  /**
   * add workfow comment on temp table/view, this is for clean up purpose
   *
   -- @param p_object_name IN VARCHAR2
   -- @param p_workflowId  IN NUMBER
   */
  PROCEDURE add_table_to_workflow(p_object_name IN VARCHAR2, p_workflowId IN NUMBER);

  PROCEDURE explain_plan (
              p_workflow_name IN VARCHAR2 DEFAULT NULL,
              p_workflowId    IN NUMBER DEFAULT NULL,
              p_nodeId        IN VARCHAR2 DEFAULT NULL,
              p_subnode_id    IN NUMBER DEFAULT NULL,
              p_input_sql     IN VARCHAR2,
              proc_name       IN VARCHAR2 DEFAULT NULL);

  /**
   -- @param p_workflow_name   IN VARCHAR2 DEFAULT NULL,
   -- @param p_workflowId      IN NUMBER DEFAULT NULL,
   -- @param p_nodeId          IN VARCHAR2 DEFAULT NULL,
   -- @param p_subnode_id      IN VARCHAR2 DEFAULT NULL,
   -- @param p_input_sql       IN OUT LSTMT_REC_TYPE
  */
  PROCEDURE explain_plan (
              p_workflow_name IN VARCHAR2 DEFAULT NULL,
              p_workflowId    IN NUMBER DEFAULT NULL,
              p_nodeId        IN VARCHAR2 DEFAULT NULL,
              p_subnode_id    IN NUMBER DEFAULT NULL,
              p_input_sql     IN OUT LSTMT_REC_TYPE,
              proc_name       IN VARCHAR2 DEFAULT NULL);
              
  PROCEDURE put_in_memory (p_table        IN VARCHAR2, 
                           p_compression  IN VARCHAR2 DEFAULT 'INMEMORY MEMCOMPRESS FOR QUERY LOW',
                           p_priority     IN VARCHAR2 DEFAULT ' ',
                           p_node_name    IN TYPE_VCHAR_130 DEFAULT NULL,
                           p_workflowId   IN NUMBER DEFAULT NULL,
                           p_nodeId       IN VARCHAR2 DEFAULT NULL );

  PROCEDURE remove_from_memory ( p_table IN VARCHAR2,
                                 p_node_name   IN TYPE_VCHAR_130 DEFAULT NULL,
                                 p_workflowId  IN NUMBER DEFAULT NULL,
                                 p_nodeId      IN VARCHAR2 DEFAULT NULL );

  PROCEDURE print_call_stack_12c( p_message     IN VARCHAR2,
                                  p_node_name   IN TYPE_VCHAR_130,
                                  p_workflowId  IN NUMBER,
                                  p_nodeId      IN VARCHAR2 );
  
  FUNCTION populateDataGuide(p_dataGuideTable IN VARCHAR2) RETURN DATAGUIDETYPE;

  FUNCTION populateDataGuide2(p_dataGuideTable IN VARCHAR2) RETURN DATAGUIDETYPE;

  PROCEDURE getDataGuide(p_workflowId IN NUMBER, p_nodeId IN VARCHAR2, p_json_column_name IN VARCHAR2, p_dataGuide IN OUT NOCOPY DATAGUIDETYPE);

  FUNCTION isDataGuideCompatible(p_dataGuideTable IN VARCHAR2, p_dataGuide IN OUT NOCOPY DATAGUIDETYPE) RETURN BOOLEAN;
  
END ODMR_INTERNAL_UTIL;
/
