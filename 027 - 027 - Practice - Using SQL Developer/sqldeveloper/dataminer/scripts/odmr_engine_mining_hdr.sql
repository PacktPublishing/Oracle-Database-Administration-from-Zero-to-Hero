CREATE OR REPLACE PACKAGE "ODMRSYS"."ODMR_ENGINE_MINING" 
AUTHID CURRENT_USER AS

  c_build_lock    CONSTANT VARCHAR2(30) := 'ODMR$BUILD$';

  TYPE LOOKUPTYPE IS TABLE OF NUMBER INDEX BY ODMR_INTERNAL_UTIL.TYPE_VCHAR_130;

  TYPE WEIGHTS is TABLE OF NUMBER;

  /*
  TYPE DU_OBJECT IS RECORD (
    model_type    VARCHAR2(30),      -- model type
    --model_id      NUMBER,
    attr_names    ODMR_OBJECT_NAMES, -- attribute name
    attr_types    ODMR_OBJECT_NAMES, -- DB datatype
    mining_types  ODMR_OBJECT_NAMES, -- Categorical or Numerical
    --auto_preps    ODMR_OBJECT_NAMES, -- auto prep
    input_types   ODMR_OBJECT_NAMES  -- Yes or No
    );
  TYPE DU_OBJECTS IS TABLE OF DU_OBJECT;
  */
  
  TYPE DU_RESULT_OBJECT IS RECORD (
    attr_name                 ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    data_type                 VARCHAR2(50),
    mining_type               VARCHAR2(30),
    include                   BOOLEAN,  -- predictor (e.g. exclude case id)?
    pass_through              BOOLEAN,  -- pass thru attrs (e.g. partition keys)?
    NULL_LIMIT                BOOLEAN,
    CONSTANT_LIMIT            BOOLEAN,
    CAT_UNIQUE_PERCENT_LIMIT  BOOLEAN,
    CAT_UNIQUE_COUNT_LIMIT    BOOLEAN,
    NUM_TO_CAT_MINING_TYPE    BOOLEAN,
    CHAR_TO_TEXT_MINING_TYPE  BOOLEAN,
    DATA_TYPE_SUPPORT         BOOLEAN,
    modified                  BOOLEAN
    );
  TYPE DU_RESULTS IS TABLE OF DU_RESULT_OBJECT;
  
  TYPE RS_OBJECT IS RECORD (
    result_name ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    result_type VARCHAR2(30), -- C - classification, R - regression
    model_name  ODMR_INTERNAL_UTIL.TYPE_VCHAR_130,
    model_id    VARCHAR2(30),
    results     ODMR_INTERNAL_UTIL.DB_OBJECTS,
    creation_date TIMESTAMP
    );
  TYPE RS_OBJECTS IS TABLE OF RS_OBJECT;

  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE SUBFLOW_START_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE SUBFLOW_CLEANUP_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE CLASS_BUILD_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE REGRESS_BUILD_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE CLUST_BUILD_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE FEATURE_BUILD_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);

  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE EFE_BUILD_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE ANOMALY_BUILD_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE ASSOC_BUILD_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE MODEL_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE APPLY_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
  /**
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE TEST_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);

  /**
   * Procedure called when a chain step involving a R build node is needed to be run
   -- @param p_job_name   _
   -- @param p_chain_step _
   */
  PROCEDURE R_BUILD_PROG(p_job_name IN VARCHAR2, p_chain_step IN VARCHAR2);
  
END;
/
