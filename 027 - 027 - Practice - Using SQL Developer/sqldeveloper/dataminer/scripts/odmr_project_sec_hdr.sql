CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_PROJECT_SEC" 
AUTHID DEFINER AS

  /**
   -- @param p_user         IN VARCHAR2
   -- @param p_project_name VARCHAR2
   */
  FUNCTION project_exist(
    p_user         IN VARCHAR2, 
    p_project_name VARCHAR2) RETURN BOOLEAN;

  /**
   -- @param p_user         IN VARCHAR2
   -- @param p_project_id   NUMBER
   */
  FUNCTION project_exist(
    p_user         IN VARCHAR2, 
    p_project_id   IN NUMBER) RETURN BOOLEAN;

  /**
   -- @param p_user         IN VARCHAR2
   -- @param p_project_ids  ODMR_OBJECT_IDS
   */
  FUNCTION project_exist(
    p_user         IN VARCHAR2, 
    p_project_ids  ODMR_OBJECT_IDS) RETURN BOOLEAN;

  /**
   -- @param p_project_id        IN NUMBER, 
   -- @param p_last_updated_time IN TIMESTAMP
   */
  PROCEDURE set_timestamp(
    p_project_id        IN NUMBER, 
    p_last_updated_time IN TIMESTAMP);

  /**
   * Create a project, populate all project meta data
   *
   -- @param project_name  project name
   -- @param comment       project comment
   -- @return project id
   -- @throws if project name conflict, then error
  */
  FUNCTION PROJECT_CREATE(
    p_user         IN VARCHAR2, 
    p_project_name IN VARCHAR2, 
    p_comment      IN VARCHAR2) RETURN NUMBER;

  /**
   * Delete projects and all dependent objects will be deleted
   *
   -- @param project_ids   project ids
   -- @param p_db_objects  IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS
   */
  PROCEDURE PROJECT_DELETE(
    p_project_ids IN ODMR_OBJECT_IDS, 
    p_db_objects  IN OUT NOCOPY ODMR_INTERNAL_UTIL.DB_OBJECTS);

  /**
   * Rename the project
   *
   -- @param project_id    project id
   -- @param project_name  new project name
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

END ODMR_PROJECT_SEC;
/
 
