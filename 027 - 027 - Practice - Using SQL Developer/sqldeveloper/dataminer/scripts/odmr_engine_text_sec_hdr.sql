CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_ENGINE_TEXT_SEC" 
AS
  /**
   * get all selected source columns (pass through columns)
   *
   -- @param p_workflowId  IN NUMBER,
   -- @param p_nodeType    IN VARCHAR2,
   -- @param p_nodeId      IN VARCHAR2,
   -- @param p_attributes  IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_datatypes   IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_output_columns_src(
    p_workflowId  IN NUMBER,
    p_nodeType    IN VARCHAR2,
    p_nodeId      IN VARCHAR2,
    p_attributes  IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_datatypes   IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   * get all selected output columns with their source columns and transform types
   *
   -- @param p_workflowId  IN NUMBER,
   -- @param p_nodeType    IN VARCHAR2,
   -- @param p_nodeId      IN VARCHAR2,
   -- @param p_xformed_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_transform_types  IN OUT NOCOPY ODMR_OBJECT_IDS
   */
  PROCEDURE get_output_columns_xformed(
    p_workflowId  IN NUMBER,
    p_nodeType    IN VARCHAR2,
    p_nodeId      IN VARCHAR2,
    p_xformed_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_source_columns  IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_transform_types  IN OUT NOCOPY ODMR_OBJECT_IDS);

  /**
   -- @param p_workflowId        IN NUMBER,
   -- @param p_nodeType          IN VARCHAR2,
   -- @param p_nodeId            IN VARCHAR2,
   -- @param p_stoplistId        IN VARCHAR2,
   -- @param p_stoplist_type     OUT VARCHAR2,
   -- @param p_stoplist_language OUT VARCHAR2,
   -- @param p_stoplist_dbname   OUT VARCHAR2,
   -- @param p_token_types       IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_token_languages   IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_token_items       IN OUT NOCOPY ODMR_OBJECT_VALUES
   */
  PROCEDURE get_stopwords(
    p_workflowId        IN NUMBER,
    p_nodeType          IN VARCHAR2,
    p_nodeId            IN VARCHAR2,
    p_stoplistId        IN VARCHAR2,
    p_stoplist_type     OUT VARCHAR2,
    p_stoplist_language OUT VARCHAR2,
    p_stoplist_dbname   OUT VARCHAR2,
    p_token_types       IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_token_languages   IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_token_items       IN OUT NOCOPY ODMR_OBJECT_VALUES);

  /**
   * get xformed column policy name, stoplist name, lexer names, lexer attributes
   *
   -- @param p_workflowId          IN NUMBER,
   -- @param p_nodeType            IN VARCHAR2,
   -- @param p_nodeId              IN VARCHAR2,
   -- @param p_stoplistId          IN VARCHAR2,
   -- @param p_xformed_col         IN VARCHAR2,
   -- @param p_stoplist_dbname     OUT VARCHAR2,
   -- @param p_policy_name         OUT VARCHAR2,
   -- @param p_stat_table_name     OUT VARCHAR2,
   -- @param p_lexer_type          OUT VARCHAR2,
   -- @param p_lexer_name          OUT VARCHAR2,
   -- @param p_lexer_attr_names    IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param p_lexer_attr_strings  IN OUT NOCOPY ODMR_OBJECT_VALUES,
   -- @param p_lexer_attr_numbers  IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param p_lexer_attr_types    IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_column_xformed_text_attrs(
    p_workflowId          IN NUMBER,
    p_nodeType            IN VARCHAR2,
    p_nodeId              IN VARCHAR2,
    p_stoplistId          IN VARCHAR2,
    p_xformed_col         IN VARCHAR2,
    p_stoplist_dbname     OUT VARCHAR2,
    p_policy_name         OUT VARCHAR2,
    p_stat_table_name     OUT VARCHAR2,
    p_lexer_type          OUT VARCHAR2,
    p_lexer_name          OUT VARCHAR2,
    p_lexer_attr_names    IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_lexer_attr_strings  IN OUT NOCOPY ODMR_OBJECT_VALUES,
    p_lexer_attr_numbers  IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_lexer_attr_types    IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId           IN NUMBER,
   -- @param  p_nodeType            IN VARCHAR2,
   -- @param  p_nodeId              IN VARCHAR2,
   -- @param  p_stoplistId          IN VARCHAR2,
   -- @param  p_xformed_col         IN VARCHAR2,
   -- @param  p_stoplist_dbname     IN VARCHAR2,
   -- @param  p_policy_name         IN VARCHAR2,
   -- @param  p_lexer_type          IN VARCHAR2,
   -- @param  p_lexer_name          IN VARCHAR2,
   -- @param  p_lexer_attr_names    IN OUT NOCOPY ODMR_OBJECT_NAMES,
   -- @param  p_lexer_attr_strings  IN OUT NOCOPY ODMR_OBJECT_VALUES,
   -- @param  p_lexer_attr_numbers  IN OUT NOCOPY ODMR_OBJECT_IDS,
   -- @param  p_lexer_attr_types    IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE update_col_xformed_text_attrs(
    p_workflowId          IN NUMBER,
    p_nodeType            IN VARCHAR2,
    p_nodeId              IN VARCHAR2,
    p_stoplistId          IN VARCHAR2,
    p_xformed_col         IN VARCHAR2,
    p_stoplist_dbname     IN VARCHAR2,
    p_policy_name         IN VARCHAR2,
    p_lexer_type          IN VARCHAR2,
    p_lexer_name          IN VARCHAR2,
    p_lexer_attr_names    IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_lexer_attr_strings  IN OUT NOCOPY ODMR_OBJECT_VALUES,
    p_lexer_attr_numbers  IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_lexer_attr_types    IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId              IN NUMBER,
   -- @param p_nodeType                IN VARCHAR2,
   -- @param p_nodeId                  IN VARCHAR2,
   -- @param p_xformed_col             IN VARCHAR2,
   -- @param p_features_table          IN VARCHAR2,
   -- @param p_output_table            IN VARCHAR2,
   -- @param p_old_features_table      OUT VARCHAR2,
   -- @param p_old_output_table        OUT VARCHAR2
   */
  PROCEDURE update_result_tables(
    p_workflowId              IN NUMBER,
    p_nodeType                IN VARCHAR2,
    p_nodeId                  IN VARCHAR2,
    p_xformed_col             IN VARCHAR2,
    p_features_table          IN VARCHAR2,
    p_output_table            IN VARCHAR2,
    p_old_features_table      OUT VARCHAR2,
    p_old_output_table        OUT VARCHAR2);

  /**
   -- @param p_workflowId              IN NUMBER,
   -- @param p_nodeType                IN VARCHAR2,
   -- @param p_nodeId                  IN VARCHAR2,
   -- @param p_xformed_col             IN VARCHAR2,
   -- @param p_maxNumberPerDoc         OUT NUMBER,
   -- @param p_maxNumberAllDocs        OUT NUMBER,
   -- @param p_frequency               OUT VARCHAR2,
   -- @param p_stoplistId              OUT VARCHAR2,
   -- @param p_language_names          IN OUT NOCOPY ODMR_OBJECT_NAMES, 
   -- @param p_language_types          IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_column_xformed_token_info(
    p_workflowId              IN NUMBER,
    p_nodeType                IN VARCHAR2,
    p_nodeId                  IN VARCHAR2,
    p_xformed_col             IN VARCHAR2,
    p_maxNumberPerDoc         OUT NUMBER,
    p_maxNumberAllDocs        OUT NUMBER,
    p_frequency               OUT VARCHAR2,
    p_stoplistId              OUT VARCHAR2,
    p_language_names          IN OUT NOCOPY ODMR_OBJECT_NAMES, 
    p_language_types          IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId              IN NUMBER,
   -- @param p_nodeType                IN VARCHAR2,
   -- @param p_nodeId                  IN VARCHAR2,
   -- @param p_xformed_col             IN VARCHAR2,
   -- @param p_full_theme              OUT NUMBER,
   -- @param p_maxNumberPerDoc         OUT NUMBER,
   -- @param p_maxNumberAllDocs        OUT NUMBER,
   -- @param p_frequency               OUT VARCHAR2,
   -- @param p_stoplistId              OUT VARCHAR2,
   -- @param p_language_name           OUT VARCHAR2, 
   -- @param p_language_type           OUT VARCHAR2
   */
  PROCEDURE get_column_xformed_theme_info(
    p_workflowId              IN NUMBER,
    p_nodeType                IN VARCHAR2,
    p_nodeId                  IN VARCHAR2,
    p_xformed_col             IN VARCHAR2,
    p_full_theme              OUT NUMBER,
    p_maxNumberPerDoc         OUT NUMBER,
    p_maxNumberAllDocs        OUT NUMBER,
    p_frequency               OUT VARCHAR2,
    p_stoplistId              OUT VARCHAR2,
    p_language_name           OUT VARCHAR2, 
    p_language_type           OUT VARCHAR2);
/*
  PROCEDURE create_sql_expression(
    p_workflowId      IN NUMBER,
    p_nodeType                IN VARCHAR2,
    p_nodeId          IN VARCHAR2,
    p_case_column     IN VARCHAR2,
    p_maxNumberPerDocs IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_frequencies     IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_full_themes     IN OUT NOCOPY ODMR_OBJECT_IDS, -- for theme only
    p_attributes      IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_xformed_cols    IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_xform_types     IN OUT NOCOPY ODMR_OBJECT_IDS,
    p_source_cols     IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_policy_names    IN OUT NOCOPY ODMR_OBJECT_NAMES,
    p_features_tables IN OUT NOCOPY ODMR_OBJECT_NAMES);
*/

  /**
   -- @param p_workflowId     IN NUMBER,
   -- @param p_nodeId         IN VARCHAR2,
   -- @param p_featureTables  IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE get_feature_tables(p_workflowId    IN NUMBER,
                               p_nodeId        IN VARCHAR2,
                               p_featureTables IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_workflowId  IN NUMBER,
   -- @param p_nodeType    IN VARCHAR2,
   -- @param p_nodeId      IN VARCHAR2,
   -- @param p_db_objects  IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   */
  PROCEDURE drop_buildtext_node_tables(
    p_workflowId  IN NUMBER,
    p_nodeType    IN VARCHAR2,
    p_nodeId      IN VARCHAR2,
    p_db_objects  IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_nodeId     IN VARCHAR2, 
   -- @param p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   */
  PROCEDURE delete(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2, 
    p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS);

END ODMR_ENGINE_TEXT_SEC;
/
 
