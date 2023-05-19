  CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_ENGINE_DYNAMIC_NODE" 
AUTHID CURRENT_USER AS

  SUBTYPE   TYPE_VCHAR_100     IS   VARCHAR2(100);

  /**
   * Dynamic Prediction
   *
   -- @param p_job_name    _
   -- @param p_chain_step  _
   */
  PROCEDURE PREDICTION_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   * Dynamic Cluster 
   *
   -- @param p_job_name    _
   -- @param p_chain_step  _
   */
  PROCEDURE CLUSTER_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   * Dynamic Feature 
   *
   -- @param p_job_name    _
   -- @param p_chain_step  _
   */
  PROCEDURE FEATURE_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   * Dynamic Anomaly 
   *
   -- @param p_job_name    _
   -- @param p_chain_step  _
   */
  PROCEDURE ANOMALY_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   * Perform heuristic only if: <br/>
   * DynamicPredictionNodeType->DynamicNodeBaseSettingsType->MiningAttributes->AutoSpecType = Yes
   -- @param p_job          _
   -- @param p_workflow_id  _
   -- @param p_nodeId       _
   -- @param p_node_name    _
   -- @param p_prediction   1 - prediction, 0 - rest of nodes
   -- @param p_input_sql    _
   */
  PROCEDURE CREATE_DYNAMIC_DATA_USAGE (p_job                    IN VARCHAR2, 
                                       p_workflow_id            IN NUMBER,
                                       p_nodeId                 IN NUMBER,
                                       p_node_name              IN VARCHAR2,
                                       p_prediction             IN NUMBER, -- 1 - prediction, 0 - rest of nodes
                                       p_input_sql              IN ODMR_INTERNAL_UTIL.LSTMT_REC_TYPE,
                                       p_parallel_query_hint    IN VARCHAR2,
                                       p_parallel_insert_hint   IN VARCHAR2,
                                       p_parallel_table_hint    IN VARCHAR2,
                                       p_in_memory              IN BOOLEAN,
                                       p_compression            IN VARCHAR2,
                                       p_priority               IN VARCHAR2);
  
  /**
   -- @param p_name    _
   */
  FUNCTION remove_quotes ( p_name VARCHAR2 ) RETURN VARCHAR2;

END;
/
