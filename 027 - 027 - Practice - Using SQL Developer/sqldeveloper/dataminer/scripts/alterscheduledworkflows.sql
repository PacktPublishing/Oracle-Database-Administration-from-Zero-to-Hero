-- alter all scheduled workflows in the repository  
-- Parameters:
-- 1. Action Flags:
--    D = disable workflows
--    E = enable workflows
-- Example:
-- @alterscheduledworkflows.sql D
set serveroutput on
set verify on

DECLARE
  action varchar2(10) := '&1';
  countWFJobsToDisable integer := 0;
  countWFJobsFailedToDisable integer := 0;
  countWFJobsToEnable integer := 0;
  countWFJobsFailedToEnable integer := 0;
  v_err_msg  VARCHAR2(4000);
BEGIN
  IF (action = 'D') THEN
    FOR jobs IN (
      SELECT owner, job_name FROM all_scheduler_jobs WHERE STATE = 'SCHEDULED' AND enabled = 'TRUE' AND job_name LIKE 'ODMR$WFJOB%' )
    LOOP
      BEGIN
        dbms_scheduler.disable('"' || jobs.owner || '"."' || jobs.job_name || '"');
        DBMS_OUTPUT.PUT_LINE('Disable workflow job: "' || jobs.owner || '"."' || jobs.job_name || '"');
        countWFJobsToDisable := countWFJobsToDisable + 1;
      EXCEPTION
      WHEN OTHERS THEN
        v_err_msg := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000);
        DBMS_OUTPUT.PUT_LINE ('Workflow Jobs Disable failed: "' || jobs.owner || '"."' || jobs.job_name || '" Error: ' || v_err_msg);
        countWFJobsFailedToDisable := countWFJobsFailedToDisable + 1;
      END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('Total Number of Workflow Jobs Failed to Disable: ' || countWFJobsFailedToDisable );
    DBMS_OUTPUT.PUT_LINE ('Total Number of Workflow Jobs Disabled: ' || countWFJobsToDisable );
  END IF;
  IF (action = 'E') THEN
    FOR jobs IN (
      SELECT owner, job_name FROM all_scheduler_jobs WHERE STATE = 'DISABLED' AND enabled = 'FALSE' AND job_name LIKE 'ODMR$WFJOB%' )
    LOOP
      BEGIN
        dbms_scheduler.enable('"' || jobs.owner || '"."' || jobs.job_name || '"');
        DBMS_OUTPUT.PUT_LINE('Enable workflow job: "' || jobs.owner || '"."' || jobs.job_name || '"');
        countWFJobsToEnable := countWFJobsToEnable + 1;
      EXCEPTION
      WHEN OTHERS THEN
        v_err_msg := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000);
        DBMS_OUTPUT.PUT_LINE ('Workflow Jobs Enable failed: "' || jobs.owner || '"."' || jobs.job_name || '" Error: ' || v_err_msg);
        countWFJobsFailedToEnable := countWFJobsFailedToEnable + 1;
      END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('Total Number of Workflow Jobs Failed to Enable: ' || countWFJobsFailedToEnable );
    DBMS_OUTPUT.PUT_LINE ('Total Number of Workflow Jobs Enabled: ' || countWFJobsToEnable );
  END IF;
END;
/