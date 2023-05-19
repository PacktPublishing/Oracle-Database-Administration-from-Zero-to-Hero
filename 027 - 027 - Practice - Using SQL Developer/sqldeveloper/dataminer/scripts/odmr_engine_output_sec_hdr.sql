CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_ENGINE_OUTPUT_SEC" 
AS

  /**
  -- @param p_workflowId IN NUMBER, 
  -- @param p_nodeId     IN VARCHAR2, 
  -- @param p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   */
  PROCEDURE delete(
    p_workflowId IN NUMBER, 
    p_nodeId     IN VARCHAR2, 
    p_db_objects IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS);

END ODMR_ENGINE_OUTPUT_SEC;
/
