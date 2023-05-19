WHENEVER SQLERROR EXIT SQL.SQLCODE;

EXECUTE dbms_output.put_line('');
EXECUTE dbms_output.put_line('Start Restore Data Miner Workflows');
EXECUTE dbms_output.put_line('');

-- restore backup workflows to ODMR$WORKFLOWS
BEGIN
  FOR wf IN (
    SELECT 
      b.WORKFLOW_ID,
      b.WORKFLOW_NAME, 
      b.WORKFLOW_DATA
    FROM ODMRSYS.ODMR$WORKFLOWS_BACKUP b, ODMRSYS.ODMR$WORKFLOWS a
    WHERE b.WORKFLOW_ID = a.WORKFLOW_ID
    AND b.VERSION = (SELECT MAX(VERSION) FROM ODMRSYS.ODMR$WORKFLOWS_BACKUP)
  )
  LOOP
    BEGIN
      UPDATE ODMRSYS.ODMR$WORKFLOWS w
      SET w.WORKFLOW_DATA = wf.WORKFLOW_DATA
      WHERE w.WORKFLOW_ID = wf.WORKFLOW_ID;
      COMMIT;
      dbms_output.put_line('Workflow restored: '||wf.WORKFLOW_NAME);
    EXCEPTION WHEN OTHERS THEN
      dbms_output.put_line('Workflow restore failed: '||wf.WORKFLOW_NAME);
    END;
  END LOOP;
END;
/

EXECUTE dbms_output.put_line('End Restore Data Miner Workflows');
