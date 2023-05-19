CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_ENGINE_DATA" 
AUTHID CURRENT_USER AS

  TYPE tab_cols_col_name_type IS TABLE OF all_tab_columns.column_name%TYPE;
  TYPE tab_cols_data_type_type IS TABLE OF all_tab_columns.data_type%TYPE;

  /** 
   * DATASOURCE_PROG description 
   -- @param p_job_name   Job Name
   -- @param p_chain_step Chain step
   */
  PROCEDURE DATASOURCE_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE CREATETABLE_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE UPDATETABLE_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE DATAPROFILE_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE AGGREGATION_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);

  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE RESET_SQL_EXPRESSION(p_workflow_id IN VARCHAR2, p_nodeId IN VARCHAR2);

END;
/
