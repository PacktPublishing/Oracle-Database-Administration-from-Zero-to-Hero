CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_ENGINE_OUTPUT" 
AUTHID CURRENT_USER AS

  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE MODELDETAILS_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE TESTDETAILS_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE FILTERDETAILS_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);

END;
/
