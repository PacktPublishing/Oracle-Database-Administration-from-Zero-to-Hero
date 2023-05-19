CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_WORKFLOW" 
AUTHID CURRENT_USER AS

  -- WF_RUN P_RUN_MODE options 
  VALIDATE_ONLY       CONSTANT VARCHAR2(30) := 'VALIDATE';            -- validate parent nodes of the specified nodes (p_node_names)
  RUN_NODE_ONLY       CONSTANT VARCHAR2(30) := 'RUN';                 -- run the specified nodes (p_node_names). 
                                                                      -- If nodes have already been run (status != READY), they will be ignored.  
                                                                      -- If parent nodes have not been run, they will be run, otherwise they will be ignored
  RERUN_NODE_ONLY     CONSTANT VARCHAR2(30) := 'RERUN_NODE_ONLY';     -- reset status of the specified nodes (p_node_names) to READY, then run these nodes
  RERUN_NODE_CHILDREN CONSTANT VARCHAR2(30) := 'RERUN_NODE_CHILDREN'; -- reset status of the specified nodes (p_node_names) and their children nodes to READY, then run these nodes
  RERUN_NODE_PARENTS  CONSTANT VARCHAR2(30) := 'RERUN_NODE_PARENTS';  -- reset status of the specified nodes (p_node_names) and their parent nodes to READY, then run these nodes
  RERUN_CHILDREN_ONLY CONSTANT VARCHAR2(30) := 'RERUN_CHILDREN_ONLY'; -- reset status of children nodes of the specified nodes (p_node_names) to READY, then run these nodes. Notice the specified nodes will not be run
  RERUN_WORKFLOW      CONSTANT VARCHAR2(30) := 'RERUN';               -- RESET STATUS OF ALL NODES TO READY, THEN RUN THEM.  NOTICE P_NODE_NAMES IS IGNORED

  /*
   * Run a workflow
   * Validation:
   *   If the workflow is either already running or opened by the Data Miner, raise an exception
   *
   -- @param P_PROJECT_NAME             project name
   -- @param P_WORKFLOW_NAME            workflow name
   -- @param P_NODE_NAMES               nodes to be run
   -- @param P_RUN_MODE                 see below for how the workflow will be run:
                VALIDATE_ONLY           validate parent nodes of the specified nodes (p_node_names)
                RUN_NODE_ONLY           run the specified nodes (p_node_names). 
                                          If nodes have already been run (status != READY), they will be ignored.  
                                          If parent nodes have not been run, they will be run, otherwise they will be ignored
                RERUN_NODE_ONLY         reset status of the specified nodes (p_node_names) to READY, then run these nodes
                RERUN_NODE_CHILDREN     reset status of the specified nodes (p_node_names) and their children nodes to READY, then run these nodes
                RERUN_NODE_PARENTS      reset status of the specified nodes (p_node_names) and their parent nodes to READY, then run these nodes
                RERUN_CHILDREN_ONLY     reset status of children nodes of the specified nodes (p_node_names) to READY, then run these nodes. Notice the specified nodes will not be run
                RERUN_WORKFLOW          reset status of all nodes to READY, then run them.  Notice p_node_names is ignored
   -- @param P_MAX_NUM_THREADS          max number of parallel model builds desired, NULL if system determined
   -- @param P_SCHEDULE                 schedule object specifies when and how many times the workflow is run. If NULL, workflow runs immediately
   -- @param P_START_DATE               scheduled start time, NULL if run immediately
   -- @param P_REPEAT_INTERVAL          repeat interval for workflow run
   -- @param P_END_DATE                 scheduled end time, NULL if none
   -- @param P_JOB_CLASS                job class. If NULL, default job class will be used
  
   return scheduler chain job id
  */
  FUNCTION WF_RUN(P_PROJECT_NAME    IN VARCHAR2,
                  P_WORKFLOW_NAME   IN VARCHAR2,
                  P_NODE_NAMES      IN ODMR_OBJECT_NAMES,
                  P_RUN_MODE        IN VARCHAR2 DEFAULT ODMR_WORKFLOW.RUN_NODE_ONLY,
                  P_MAX_NUM_THREADS IN NUMBER DEFAULT NULL,
                  P_SCHEDULE        IN VARCHAR2 DEFAULT NULL,
                  P_JOB_CLASS       IN VARCHAR2 DEFAULT NULL)
  RETURN VARCHAR2;

  FUNCTION WF_RUN(P_PROJECT_ID      IN NUMBER,
                  P_WORKFLOW_ID     IN NUMBER,
                  P_NODE_IDS        IN ODMR_OBJECT_IDS,
                  P_RUN_MODE        IN VARCHAR2 DEFAULT ODMR_WORKFLOW.RUN_NODE_ONLY,
                  P_MAX_NUM_THREADS IN NUMBER DEFAULT NULL,
                  P_SCHEDULE        IN VARCHAR2 DEFAULT NULL,
                  P_JOB_CLASS       IN VARCHAR2 DEFAULT NULL)
  RETURN VARCHAR2;
  
  FUNCTION WF_RUN(P_PROJECT_NAME    IN VARCHAR2,
                  P_WORKFLOW_NAME   IN VARCHAR2,
                  P_NODE_NAMES      IN ODMR_OBJECT_NAMES,
                  P_RUN_MODE        IN VARCHAR2 DEFAULT ODMR_WORKFLOW.RUN_NODE_ONLY,
                  P_MAX_NUM_THREADS IN NUMBER DEFAULT NULL,
                  P_START_DATE      IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
                  P_REPEAT_INTERVAL IN VARCHAR2 DEFAULT NULL,
                  P_END_DATE        IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
                  P_JOB_CLASS       IN VARCHAR2 DEFAULT NULL)
  RETURN VARCHAR2;
  
  FUNCTION WF_RUN(P_PROJECT_ID      IN NUMBER,
                  P_WORKFLOW_ID     IN NUMBER,
                  P_NODE_IDS        IN ODMR_OBJECT_IDS,
                  P_RUN_MODE        IN VARCHAR2 DEFAULT ODMR_WORKFLOW.RUN_NODE_ONLY,
                  P_MAX_NUM_THREADS IN NUMBER DEFAULT NULL,
                  P_START_DATE      IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
                  P_REPEAT_INTERVAL IN VARCHAR2 DEFAULT NULL,
                  P_END_DATE        IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
                  P_JOB_CLASS       IN VARCHAR2 DEFAULT NULL)
  RETURN VARCHAR2;

  /*
   * Stop a running workflow gracefully or cancel a scheduled workflow
   * Validation:
   *   If the workflow is not already running, raise an exception  
   * 
   -- @param p_workflowId  workflow id
  */   
  PROCEDURE WF_STOP(p_workflowId IN NUMBER);

  /*
   * Delete a workflow along with all generated objects (e.g. tables, views, models, test results, etc).
   * Validation:
   *   If the workflow is either already running or opened by the Data Miner, raise an exception
   *
   -- @param p_workflowId      workflow id
  */
  PROCEDURE WF_DELETE(p_workflowId IN NUMBER);

  /*
   * Rename a workflow
   * Validation:
   *   If the workflow is either already running or opened by the Data Miner, raise an exception
   *
   -- @param p_workflowId       workflow id
   -- @param p_workflow_name    new workflow name
   -- @param p_mode             R, W
                                  R - Request read only mode after the rename
                                  W - Request write mode after the rename (used by Data Miner)
  */   
  PROCEDURE WF_RENAME(
    p_workflowId    IN NUMBER, 
    p_workflow_name IN VARCHAR2, 
    p_mode          IN CHAR DEFAULT 'R');

  /**
   * Import a workflow to the specific project.
   * Validation:
   *   If the workflow violates the workflow schema or incompatible with current repository, 
   *       raise an exception
   *   If the workflow already exists, raise an exception
   *
   -- @param p_project_id     project id
   -- @param p_workflow_name  workflow name
   -- @param p_workflow_data  workflow xml
   -- @param p_comment        workflow comment
   -- @param p_force          whether to force the import if object name conflicts are detected with existing workflows in the repository
   --          FALSE          raise an exception if the workflow has object name conflicts with existing workflows in the repository
   --          TRUE           force the import regardless of object name conflicts with existing workflows in the repository
   -- @return workflow id
  */
  FUNCTION WF_IMPORT(p_project_id IN NUMBER,
                     p_workflow_name IN VARCHAR2, 
                     p_workflow_data IN XMLType, 
                     p_comment IN VARCHAR2,
                     p_force IN BOOLEAN DEFAULT FALSE) RETURN NUMBER;

  /**
   * Export the specified workflow.
   * Validation:
   *   If the workflow is either already running or opened by the Data Miner, raise an exception
   *
   -- @param p_workflow_id  workflow id
   -- @return workflow xml
  */
  FUNCTION WF_EXPORT(p_workflow_id IN NUMBER) RETURN XMLType;

  /**
   * Create an empty workflow using the supplied name.
   *
   -- @param p_project_id     project id
   -- @param p_workflow_name  workflow id
   -- @param p_comment        workflow comment
   -- @return workflow id
   -- @throws if workflow name conflict, then error.
   */
  FUNCTION WF_CREATE(p_project_id IN NUMBER,
                     p_workflow_name IN VARCHAR2, 
                     p_comment IN VARCHAR2,
                     p_timestamp IN OUT TIMESTAMP) RETURN NUMBER;



  -- PRIVATE: DO NOT USE ANYTHING BELOW THIS LINE
  RUN_MODE            CONSTANT VARCHAR2(30) := 'RUN';
  RERUN_MODE          CONSTANT VARCHAR2(30) := 'RERUN';
  VALIDATE_MODE       CONSTANT VARCHAR2(30) := 'VALIDATE';
  UPSTREAM            CONSTANT VARCHAR2(30) := 'UPSTREAM';
  DOWNSTREAM          CONSTANT VARCHAR2(30) := 'DOWNSTREAM';

  /*
  Return the workflow XML definition.  User needs to specify the desired access mode for the returned workflow.  The API will try to honor the access mode if possible; otherwise it will return the available access mode based on the current workflow state.  For example, user specifies the ¿W¿(read/write) access mode to load the workflow for editing, but the workflow is being used, so the API returns the ¿R¿(read only) access mode.   In this case, the user should not modify the returned workflow.
  Parameters:
    p_workflowId    workflow id
    p_mode          W read/write, R read only
  Return:
    p_mode          W read/write, R read only
    workflow XML definition
  Validation:
  */
  --FUNCTION WF_OLD_LOAD(p_workflowId IN NUMBER, p_mode IN OUT CHAR, p_timestamp IN OUT TIMESTAMP) RETURN XMLType;

  /**
   -- @param p_workflowId
   -- @param p_mode
   -- @param p_timestamp
   -- @return 
   */
  FUNCTION WF_LOAD(p_workflowId IN NUMBER, p_mode IN OUT CHAR, p_timestamp IN OUT TIMESTAMP) RETURN CLOB;

  /**
   * WF_SAVE
   *
   * Save the workflow that was previously loaded in read/write mode.  
   *  User can specify the desired access mode after the workflow is saved.  
   *  By default after the workflow is saved, it switches to ¿R¿ access mode,
   *  so the workflow can be run (lock released). <br/>
   * The new workflow XML definition will be compared against the persisted one.  
   * If any nodes are deleted, their associated/generated objects (e.g. cache, models, result outputs) 
   *   will be deleted from the user account. <br/>
   * If workflow is locked by another client, server throws an exception, as expected. 
   * Otherwise, it compares the previously saved time stamp with p_timestamp. <br/>
   * If time stamps are equal, server saves the workflow, updates and returns the new time stamp, 
   * and (optionally) re-locks the workflow. <br/>
   * If time stamps differ, server throws an exception allowing the client to prompt the user whether 
   * to overwrite the document.  
   * If the user decides to overwrite, the client invokes WF_SAVE with p_force set to 'Y', which saves workflow,
   * updates the time stamp, and (optionally) re-locks the workflow. <br/>
   * <br/>
   * Validation:  <br/>
   *   If the workflow was not previously loaded in read/write mode, then error
   *
   -- @param p_workflowId      workflow id
   -- @param p_workflow_data   workflow XML definition
   -- @param p_mode            W read/write, R read only (default)
  */
  PROCEDURE WF_SAVE(p_workflowId IN NUMBER, p_workflow_data IN XMLType,
                  p_timestamp IN OUT TIMESTAMP, p_mode IN CHAR DEFAULT 'R', p_force IN CHAR DEFAULT 'N');

  /**
   * Unlock the workflow regardless of any lock on it.
   *
   -- @param p_workflowId  workflow id
   -- @return
   */
  FUNCTION WF_UNLOCK(p_workflowId IN NUMBER) RETURN BOOLEAN;

  /*
   * Run the workflow
   * Validation:
   *   If the workflow is either in running or edit mode, then error
   *
   -- @param p_project_name     project name
   -- @param p_workflow_name    workflow name
   -- @param p_node_name        run node names
   -- @param p_run_mode         RUN, VALIDATE, RERUN
                                RUN - run nodes with non-complete status
                                VALIDATE - validate parent nodes
                                RERUN - run nodes regardless of their status (PLANNED)
   -- @param p_direction        UPSTREAM or DOWNSTREAM
                                UPSTREAM - run the node and its parents
                                DOWNSTREAM - run the node and its children, ignore if VALIDATE_MODE
   -- @param p_max_num_threads  max number of parallel model builds
   -- @param p_start_time       scheduled start time, NULL if run immediately
   -- @param p_repeat_interval  repeat interval for workflow run
   -- @param p_end_date         scheduled end time, NULL if none
   -- @param p_job_class        job class, if NULL, default job class will be used
   *
   -- @return scheduler chain job id
   */
  FUNCTION WF_RUN(p_project_name      IN VARCHAR2,
                  p_workflow_name     IN VARCHAR2,
                  p_node_names        IN OUT NOCOPY ODMR_OBJECT_NAMES,
                  p_run_mode          IN VARCHAR2,
                  p_direction         IN VARCHAR2,
                  p_max_num_threads   IN NUMBER,
                  p_start_date        IN TIMESTAMP WITH TIME ZONE,
                  p_repeat_interval   IN VARCHAR2,
                  p_end_date          IN TIMESTAMP WITH TIME ZONE,
                  p_job_class         IN VARCHAR2)
    RETURN VARCHAR2;

  /*
   * Run the workflow
   * Validation:
   *   If the workflow is either in running or edit mode, then error
   *
   -- @param p_workflow_id      workflow id
   -- @param p_node_ids         run node ids
   -- @param p_run_mode         RUN, VALIDATE, RERUN
                                RUN - run nodes with non-complete status
                                VALIDATE - validate parent nodes
                                RERUN - run nodes regardless of their status (PLANNED)
   -- @param p_direction        UPSTREAM or DOWNSTREAM
                                UPSTREAM - run the node and its parents
                                DOWNSTREAM - run the node and its children, ignore if VALIDATE_MODE
   -- @param p_max_num_threads  max number of parallel model builds
   -- @param p_start_time       scheduled start time, NULL if run immediately
   -- @param p_repeat_interval  repeat interval for workflow run
   -- @param p_end_date         scheduled end time, NULL if none
   -- @param p_job_class        job class, if NULL, default job class will be used
   *
   -- @return scheduler chain job id
   */
  FUNCTION WF_RUN(p_workflow_id       IN VARCHAR2,
                  p_node_ids          IN OUT NOCOPY ODMR_OBJECT_NAMES,
                  p_run_mode          IN VARCHAR2,
                  p_direction         IN VARCHAR2,
                  p_max_num_threads   IN NUMBER,
                  p_start_date        IN TIMESTAMP WITH TIME ZONE,
                  p_repeat_interval   IN VARCHAR2,
                  p_end_date          IN TIMESTAMP WITH TIME ZONE,
                  p_job_class         IN VARCHAR2)
    RETURN VARCHAR2;

  /**
   * WF_RUN (deprecated)
   * 
   -- @param p_workflowId
   -- @param p_nodeId
   -- @param p_run_mode
   -- @param p_max_num_threads
   -- @param p_job_class
   -- @param p_start_time
   -- @param p_direction
   *
   -- @return VARCHAR2
   */
  FUNCTION WF_RUN(p_workflowId IN NUMBER,
                  p_nodeId IN VARCHAR2,
                  p_run_mode IN VARCHAR2,
                  p_max_num_threads IN NUMBER,
                  p_job_class IN VARCHAR2,
                  p_start_time IN TIMESTAMP WITH TIME ZONE,
                  p_direction IN VARCHAR2)
    RETURN VARCHAR2;

  /**
   -- @param p_models IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE WF_GET_ALL_MODELS(p_models IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_tables IN OUT NOCOPY ODMR_OBJECT_NAMES
   */
  PROCEDURE WF_GET_ALL_TABLES(p_tables IN OUT NOCOPY ODMR_OBJECT_NAMES);

  /**
   -- @param p_node_type IN VARCHAR2, 
   -- @param p_nodes     IN OUT NOCOPY ODMR_NODE_REFERENCE_SET
   */
  PROCEDURE WF_GET_NODES_BY_TYPE(
    p_node_type IN VARCHAR2, 
    p_nodes     IN OUT NOCOPY ODMR_NODE_REFERENCE_SET);

  /**
   -- @param p_node_type   IN VARCHAR2, 
   -- @param p_project_id  IN NUMBER, 
   -- @param p_workflow_id IN NUMBER, 
   -- @param p_node_id     IN NUMBER
   */
  FUNCTION WF_GET_NODE_CONTENT(
    p_node_type   IN VARCHAR2, 
    p_project_id  IN NUMBER, 
    p_workflow_id IN NUMBER, 
    p_node_id     IN NUMBER) RETURN CLOB;

  FUNCTION is_server_lock(wf_id IN NUMBER) RETURN BOOLEAN;

END ODMR_WORKFLOW;
/
