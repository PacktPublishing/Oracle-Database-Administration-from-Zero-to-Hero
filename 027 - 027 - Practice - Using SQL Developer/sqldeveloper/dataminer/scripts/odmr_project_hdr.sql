CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_PROJECT" 
AUTHID CURRENT_USER AS

  /**
   * Create a project
   *
   -- @param project_name   project name
   -- @param comment        project comment
   -- @return project id
   -- @throws if project name conflict, then error
  */
  FUNCTION PROJECT_CREATE(p_project_name IN VARCHAR2, p_comment IN VARCHAR2) RETURN NUMBER;

  /**
   * Delete the project and associated workflows (generated models/results will be deleted)
   *
   -- @param project_id - project id
   */
  PROCEDURE PROJECT_DELETE(p_project_id IN NUMBER);

  /**
   * Delete the projects and associated workflows (generated models/results will be deleted)
   * 
   -- @param project_ids - project ids
   */
  PROCEDURE PROJECT_DELETE(p_project_ids IN ODMR_OBJECT_IDS);

  /**
   * Rename the project
   *
   -- @param project_id     project id
   -- @param project_name   new project name
   -- @throws If name already existed, then error
  */
  PROCEDURE PROJECT_RENAME(p_project_id IN NUMBER, p_project_name IN VARCHAR2);

  /**
   * Set/Replace the project comment
   *
   -- @param project_id  project id
   -- @param comment     project comment
  */
  PROCEDURE SET_COMMENT(p_project_id IN NUMBER, p_comment IN VARCHAR2);

END ODMR_PROJECT;
/
