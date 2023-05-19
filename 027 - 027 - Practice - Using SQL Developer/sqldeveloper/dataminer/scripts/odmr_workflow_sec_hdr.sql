CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_WORKFLOW_SEC" 
AUTHID DEFINER AS

  XML_NAME_SPACE_URL  CONSTANT VARCHAR2(100) := '"http://xmlns.oracle.com/odmr11"';
  XML_NAME_SPACE_URL_NQ  CONSTANT VARCHAR2(100) := 'http://xmlns.oracle.com/odmr11';
  XML_NAME_SPACE      CONSTANT VARCHAR2(100) := 'xmlns="http://xmlns.oracle.com/odmr11"';
  XML_LOCATION        CONSTANT VARCHAR2(100) := 'xsi:schemaLocation="http://xmlns.oracle.com/odmr11 http://xmlns.oracle.com/odmr11/odmr.xsd"';

  TYPE LOOKUPTYPE IS TABLE OF ODMR_INTERNAL_UTIL.TYPE_VCHAR_261 INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_261;

  TYPE NODERECTYPE IS RECORD (
    TYPE      VARCHAR2(30),
    ID        VARCHAR2(30),
    NAME      ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    STATUS    VARCHAR2(30));
    
  TYPE NODELOOKUPTYPE IS TABLE OF NODERECTYPE INDEX BY VARCHAR2(30);

  TYPE WORKFLOWRECTYPE IS RECORD (
    PARENT_ID           VARCHAR2(30),
    PARENT              ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    CHILD_ID            VARCHAR2(30),
    CHILD_TYPE          VARCHAR2(30),
    CHILD               ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    EXPRESSION          CLOB );

  TYPE WORKFLOWRECTYPES is TABLE OF WORKFLOWRECTYPE INDEX BY VARCHAR2(60);

  TYPE RUNNODERECTYPE IS RECORD (
    NODE_ID           VARCHAR2(30),
    SUBNODE_ID        VARCHAR2(30));
  
  TYPE RUNNODERECTYPES IS TABLE OF RUNNODERECTYPE;
  
  /**
   -- @param p_workflowId Workflow ID
   */
  FUNCTION get_workflow_run_mode(p_workflowId IN NUMBER) RETURN VARCHAR2;

  /**
   -- @param p_workflowId Workflow ID
   */
  --FUNCTION get_workflow_status(p_workflowId IN NUMBER) RETURN VARCHAR2;

  /**
   -- @param p_workflowId Workflow ID
   */
  --FUNCTION is_workflow_running(p_workflowId IN NUMBER) RETURN BOOLEAN;

  /**
   -- @param p_workflowId Workflow ID
   -- @param p_status     Status
   */
  PROCEDURE update_workflow_status(p_workflowId IN NUMBER, p_status IN VARCHAR2);

  /**
   -- @param p_user            User Name
   -- @param p_project_id      Project ID
   -- @param p_workflow_name   Workflow Name
   */
  FUNCTION workflow_exist(p_user IN VARCHAR2, p_project_id IN NUMBER, p_workflow_name IN VARCHAR2) RETURN BOOLEAN;

  /**
   -- @param p_user            User Name
   -- @param p_project_name    Project Name
   -- @param p_workflow_name   Workflow Name
   */
  FUNCTION workflow_exist(p_user IN VARCHAR2, p_project_name IN VARCHAR2, p_workflow_name IN VARCHAR2) RETURN BOOLEAN;

  /**
   -- @param p_user         User Name
   -- @param p_workflowId   Workflow ID
   */
  FUNCTION workflow_exist(p_user IN VARCHAR2, p_workflowId NUMBER) RETURN BOOLEAN;

  /**
   -- @param p_workflowId           Workflow ID
   -- @param p_last_updated_time    Time
   */
  PROCEDURE set_timestamp(p_workflowId IN NUMBER, p_last_updated_time IN TIMESTAMP);

  /**
   -- @param p_workflowId           Workflow ID
   -- @param p_job_submitted_time   Last job submitted time
   */
  --PROCEDURE set_jobSubmittedTimestamp(p_workflowId IN NUMBER, p_job_submitted_time IN TIMESTAMP);

  /**
   -- @param p_workflowId           Workflow ID
   -- @param p_job_completed_time   Last job completion time
   */
  --PROCEDURE set_jobCompletedTimestamp(p_workflowId IN NUMBER, p_job_completed_time IN TIMESTAMP);
  
  /**
   -- @param p_workflowId           Workflow ID
   -- @param p_last_job_id          Last job id
   */
  --PROCEDURE set_lastJobId(p_workflowId IN NUMBER, p_last_job_id IN VARCHAR2);

  /**
   -- @param p_workflowId           Workflow ID
   -- @param p_all                  All steps completed?
   */
  PROCEDURE set_jobStepCompleted(p_workflowId IN NUMBER, p_all IN BOOLEAN DEFAULT FALSE);

  /**
   -- @param p_workflowId Workflow ID
   */
  FUNCTION get_timestamp(p_workflowId IN NUMBER) RETURN TIMESTAMP;

  --FUNCTION lock_workflow(p_user_session IN VARCHAR2, p_workflowId IN NUMBER) RETURN BOOLEAN;

  /**
   * Check if the workflow has been submitted for running or running already.
   *
   -- @param wf_id Workflow ID
   */
  --FUNCTION is_server_lock(wf_id IN NUMBER) RETURN BOOLEAN;

  /**
   * Submit workflow for running (place a server lock)
   *
   -- @param wf_id Workflow ID
   */
  --FUNCTION server_lock(wf_id IN NUMBER) RETURN BOOLEAN;

  /**
   * Unlock the workflow regardless current state (use for exceptional case)
   *
   -- @param wf_id Workflow ID
   */
  FUNCTION server_unlock(wf_id IN NUMBER) RETURN BOOLEAN;

  /**
   * Request a DB session lock on the workflow
   *
   -- @param wf_id Workflow ID
   */
  FUNCTION session_lock(wf_id IN NUMBER) RETURN BOOLEAN;

  --PROCEDURE clear_workflow_lock(p_workflowId IN NUMBER);

  /**
   -- @param p_workflowId   Workflow ID
   */
  FUNCTION is_workflow_valid(p_workflowId IN NUMBER) RETURN BOOLEAN;

  PROCEDURE find_children_node(p_workflowId IN NUMBER,
                               p_runNodes IN OUT NOCOPY ODMR_OBJECT_NAMES,
                               p_node_lookup IN OUT NOCOPY NODELOOKUPTYPE,
                               p_all_nodes IN OUT NOCOPY ODMR_OBJECT_NAMES,
                               p_leaf_nodes IN OUT NOCOPY ODMR_OBJECT_NAMES,
                               p_inclusive IN BOOLEAN);
                          
  PROCEDURE find_parent_nodes(p_workflowId IN NUMBER,
                              p_runNodes IN OUT NOCOPY ODMR_OBJECT_NAMES,
                              p_node_lookup IN OUT NOCOPY NODELOOKUPTYPE,
                              p_parent_nodes IN OUT NOCOPY ODMR_OBJECT_NAMES,
                              p_mode IN VARCHAR2, -- IMMEDIATE parents only, ALL parents
                              p_inclusive IN BOOLEAN); -- include itself?

  /**
   -- @param p_workflowId  IN NUMBER,
   -- @param p_run_mode    IN VARCHAR2,
   -- @param p_node_lookup IN OUT NOCOPY NODELOOKUPTYPE,
   -- @param p_workflow    IN OUT NOCOPY WORKFLOWRECTYPES,
   -- @param p_runNodes    IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE find_source_node(p_workflowId IN NUMBER,
                             p_run_mode IN VARCHAR2,
                             p_node_lookup IN OUT NOCOPY NODELOOKUPTYPE,
                             p_workflow IN OUT NOCOPY WORKFLOWRECTYPES,
                             p_runNodes IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   * Create steps for models
   *
   -- @param p_workflowId    IN NUMBER, 
   -- @param p_run_mode      IN VARCHAR2, 
   -- @param p_buildNodeId   IN VARCHAR2, 
   -- @param p_buildNodeType IN VARCHAR2, 
   -- @param p_models        IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE getBuildNodeModels(
    p_workflowId    IN NUMBER, 
    p_run_mode      IN VARCHAR2, 
    p_buildNodeId   IN VARCHAR2, 
    p_buildNodeType IN VARCHAR2, 
    p_models        IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_user_session IN VARCHAR2, 
   -- @param p_models       IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE WF_GET_ALL_MODELS(
    p_user_session IN VARCHAR2, 
    p_models       IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_user_session IN VARCHAR2, 
   -- @param p_tables       IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE WF_GET_ALL_TABLES(
    p_user_session IN VARCHAR2, 
    p_tables       IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   * Create an empty workflow using the supplied name.
   * 
   -- @param p_project_id     project id
   -- @param p_workflow_name  workflow name
   -- @param p_comment        Comment
   -- @returns workflow id
   -- @throws If workflow name conflict, then error
   */
  FUNCTION WF_CREATE(
    p_project_id IN NUMBER,
    p_workflow_name IN VARCHAR2,
    p_comment IN VARCHAR2) RETURN NUMBER;

  /**
   * Return the workflow XML definition.  
   * User needs to specify the desired access mode for the returned workflow.  
   * The API will try to honor the access mode if possible; otherwise it will return the available access mode based on the current workflow state.  
   * For example, user specifies the ¿W¿(read/write) access mode to load the workflow for editing, but the workflow is being used, so the API returns the ¿R¿(read only) access mode.   
   * In this case, the user should not modify the returned workflow.
   *
   -- @param p_workflowId  workflow id
   -- @param p_workflow    IN OUT XMLType, 
   -- @param p_timestamp   IN OUT TIMESTAMP
   -- @return p_mode ¿ W ¿ read/write, R ¿ read only
  */
  PROCEDURE WF_LOAD(
    p_workflowId IN NUMBER, 
    p_workflow   IN OUT XMLType, 
    p_timestamp  IN OUT TIMESTAMP);

  /**
   -- @param p_workflowId IN NUMBER, 
   -- @param p_workflow   IN OUT CLOB, 
   -- @param p_timestamp  IN OUT TIMESTAMP
   */
  PROCEDURE WF_LOAD2(
    p_workflowId IN NUMBER, 
    p_workflow  IN OUT CLOB, 
    p_timestamp IN OUT TIMESTAMP);

  /**
   -- @param p_workflowId    IN NUMBER, 
   -- @param p_workflow_data IN XMLType,
   -- @param p_db_objects    IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   */
  PROCEDURE WF_SAVE(
    p_workflowId    IN NUMBER, 
    p_workflow_data IN XMLType,
    p_db_objects    IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS,
    p_user_session  IN VARCHAR2);

  /**
   * Run the workflow
   * Starting from the destination node(s), it walks up the lineage to the immediate valid data source node(s).
   * From the data source node(s), it walks down the lineage to create chain steps for all non-COMPLETE nodes as it builds the scheduler chain.
   * All children nodes of a non-COMPLETE parent will be considered non-COMPLETE regardless of their own states.
   * The workflow run may overwrite any existing objects (model, test, apply results).
   * As the workflow runs, it updates the node status in the XML definition.
   * The client SHOULD NOT modify the XML definition during the workflow run.
   * The client may want to reload the XML definition (via LOAD) when the workflow completes.
   * The client can use the workflow VIEW to monitor the workflow status and individual node status.
   * 
   -- @param p_workflowId       workflow id
   -- @param p_nodeIds          destination node id(s) - only one node is supported:2
   -- @param p_max_num_threads  max number of parallel threads for the workflow execution
   -- @param p_job_class        user defined job class, where the Chain job will be based, NULL if no user defined class
   -- @param p_start_time       scheduled start time, NULL if run immediately
   -- @return job id - scheduler chain job id
   -- @throws If the workflow is in either running or edit mode, then error
  */
  PROCEDURE wf_run(p_workflowid        IN NUMBER,
                   p_run_mode          IN VARCHAR2,
                   p_run_nodes         IN OUT NOCOPY ODMR_OBJECT_NAMES,
                   p_chain_name        IN VARCHAR2,
                   p_job_name          IN VARCHAR2,
                   p_schedule          IN VARCHAR2,
                   p_start_date        IN TIMESTAMP WITH TIME ZONE,
                   p_repeat_interval   IN VARCHAR2,
                   p_end_date          IN TIMESTAMP WITH TIME ZONE,
                   p_runnodes          IN OUT NOCOPY ODMR_WORKFLOW_SEC.RUNNODERECTYPES);

  PROCEDURE reset_node_status(p_workflow_id IN NUMBER);

  /**
   -- @param p_workflowId    IN NUMBER, 
   -- @param p_workflow_name IN VARCHAR2)
   */
  PROCEDURE WF_RENAME(p_workflowId IN NUMBER, p_workflow_name IN VARCHAR2);

  /**
   * Delete the workflow
   *
   -- @param p_workflowId  workflow id
   -- @param p_db_objects  IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   -- @throws If the workflow is in either running or edit mode, then error
  */
  PROCEDURE WF_DELETE(
    p_workflowId IN NUMBER, 
    p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS);

  /**
   -- @param p_project_id    IN NUMBER
   -- @param p_workflow_name IN VARCHAR2
   -- @param p_workflow_data IN XMLType
   -- @param p_comment       IN VARCHAR2
   -- @param p_user          IN VARCHAR2
   */
  FUNCTION WF_IMPORT(p_project_id IN NUMBER,
                     p_workflow_name IN VARCHAR2, 
                     p_workflow_data IN XMLType, 
                     p_comment IN VARCHAR2,
                     p_user IN VARCHAR2,
                     p_force IN BOOLEAN) RETURN NUMBER;

  /**
   -- @param p_workflow_id   IN NUMBER
   -- @param p_user          IN VARCHAR2
   */
  FUNCTION WF_EXPORT(p_workflow_id IN NUMBER, p_user IN VARCHAR2) RETURN XMLType;

  /**
   -- @param p_workflowId IN NUMBER
   -- @param p_comment    IN VARCHAR2
   */
  PROCEDURE SET_COMMENT(p_workflowId IN NUMBER, p_comment IN VARCHAR2);

  /**
   -- @param p_node_type IN VARCHAR2, 
   -- @param p_user      IN VARCHAR2, 
   -- @param p_nodes     IN OUT NOCOPY ODMR_NODE_REFERENCE_SET
   */
  PROCEDURE WF_GET_NODES_BY_TYPE(
    p_node_type IN VARCHAR2, 
    p_user      IN VARCHAR2, 
    p_nodes     IN OUT NOCOPY ODMR_NODE_REFERENCE_SET);

  /**
   -- @param p_user        IN VARCHAR2 
   -- @param p_node_type   IN VARCHAR2
   -- @param p_project_id  IN NUMBER
   -- @param p_workflow_id IN NUMBER 
   -- @param p_node_id     IN NUMBER
   */
  FUNCTION WF_GET_NODE_CONTENT(
    p_user        IN VARCHAR2, 
    p_node_type   IN VARCHAR2, 
    p_project_id  IN NUMBER,
    p_workflow_id IN NUMBER, 
    p_node_id     IN NUMBER) RETURN CLOB;

  /**
   -- @param p_workflowId  IN NUMBER, 
   -- @param p_node_lookup IN OUT NOCOPY NODELOOKUPTYPE
   */
  PROCEDURE init_node_lookup(
    p_workflowId  IN NUMBER, 
    p_node_lookup IN OUT NOCOPY NODELOOKUPTYPE);
  
  /**
   -- @param p_node_lookup IN OUT NOCOPY NODELOOKUPTYPE, 
   -- @param p_nodeId      IN VARCHAR2, 
   -- @param p_nodeType    OUT VARCHAR2, 
   -- @param p_nodeName    OUT VARCHAR2, 
   -- @param p_nodeStatus  OUT VARCHAR2
   */
  PROCEDURE get_node_info(
    p_node_lookup IN OUT NOCOPY NODELOOKUPTYPE, 
    p_nodeId      IN VARCHAR2, 
    p_nodeType    OUT VARCHAR2, 
    p_nodeName    OUT VARCHAR2, 
    p_nodeStatus  OUT VARCHAR2);

  /**
   -- @param  p_workflowId Workflow ID
   */  
  FUNCTION getOutputTablesOrViews(
    p_workflowId IN NUMBER) RETURN ODMR_OBJECT_NAMES;

END;
/
