-- disconnects Data Miner sessions 
-- Parameter:
-- 1. Action Flags:
--    R = report only, do not disconnect any sessions
--    D = disconnect only, displays disconnect  only
--    DR or RD = disconnect and report
-- 2. Abort Flag
--    T = abort if any session is unable to be disconnected.
--        abort if there are sessions detected that have the ODMRUSER privilege and
--        the action flag is R. 
--    F = do not abort regardless of session status
-- Example:
-- @disconnectODMRSessions.sql DR T

EXECUTE dbms_output.put_line('Disconnect any existing ODMRUSER sessions, or ODMRSYS sessions. ' || systimestamp);

SET serveroutput ON
SET verify OFF
DECLARE
v_sid  VARCHAR2(100);
v_serial# VARCHAR2(100);
v_username VARCHAR2(30);
v_status VARCHAR2 (100);
v_program VARCHAR2 (100);
v_type VARCHAR2 (100);
v_module VARCHAR2 (100);
action VARCHAR2(30) := '&1';
abort_flag VARCHAR2(30) := '&2';
report BOOLEAN := TRUE;
killSession BOOLEAN := TRUE; 
countSessions integer := 0;
countSessionsDropped integer := 0;
countSessionsFailedToDrop integer := 0;
countSessionsStillActive integer := 0;
sql_text VARCHAR2(256);
Dynamic_Cursor integer; 
dummy integer; 
v_err_msg  VARCHAR2(4000);


cursor session_cursor is
select v.sid, v.serial#, v.username, v.status, v.program, v.type , v.module from v$session v, dba_role_privs r
where v.type = 'USER'
AND v.username not in ('SYS', 'sys', 'SYSTEM', 'system')
AND v.username = r.grantee
AND r.granted_role = 'ODMRUSER'
UNION 
select v.sid, v.serial#, v.username, v.status, v.program, v.type , v.module from v$session v
where v.type = 'USER'
and v.username = 'ODMRSYS';


BEGIN
 DBMS_OUTPUT.ENABLE(NULL);
  -- Check for valid action parameter
  IF ((action = 'R') OR (action = 'D') OR (action = 'DR') OR (action = 'RD')) THEN
    NULL;
  ELSE
    RAISE_APPLICATION_ERROR(-20000, 'Invalid action parameter passed in to disconnect sessions: ' || action || '. Value must be one of the following: D,R,DR,RD.');
  END IF;
  
  -- Check for valid abort flag parameter
  IF ((abort_flag = 'T') OR (abort_flag = 'F')) THEN
    NULL;
  ELSE
    RAISE_APPLICATION_ERROR(-20000, 'Invalid abort flag parameter passed in to disconnect sessions: ' || abort_flag || '. Value must be T or F.');
  END IF;
 
  
  CASE action
    WHEN 'R' THEN report := TRUE;
    WHEN 'DR' THEN report := TRUE;
    WHEN 'RD' THEN report := TRUE;
    ELSE report := FALSE;
  END CASE;

  CASE action
    WHEN 'D' THEN killSession := TRUE;
    WHEN 'DR' THEN killSession := TRUE;
    WHEN 'RD' THEN killSession := TRUE;
    ELSE killSession := FALSE;
  END CASE;


open session_cursor;
fetch session_cursor into v_sid, v_serial#, v_username, v_status, v_program, v_type, v_module;
while session_cursor%FOUND loop
  IF report  THEN
      DBMS_OUTPUT.PUT_LINE('Session sid: ' || v_sid || ' serial#: ' || v_serial# || ' username: ' || v_username ||
      ' status: ' || v_status ||
      ' program: ' || v_program || ' type: ' || v_type || ' module: ' || v_module);
  END IF;

BEGIN
   IF killSession  THEN
      sql_text := 'ALTER SYSTEM DISCONNECT SESSION ' || '''' || v_sid || ',' || v_serial# || '''' ||
      ' IMMEDIATE ';
      DBMS_OUTPUT.PUT_LINE('Command: ' || sql_text);
      Dynamic_Cursor := dbms_sql.open_cursor;
      dbms_sql.parse(Dynamic_Cursor, sql_text, dbms_sql.native);
      dummy := dbms_sql.execute(Dynamic_Cursor);
      dbms_sql.close_cursor(Dynamic_Cursor);
      DBMS_OUTPUT.PUT_LINE('Session Disconnected: ' ||'sid: ' || v_sid || ' serial#: ' || v_serial# || ' username: ' || v_username ||
      ' status: ' || v_status ||
      ' program: ' || v_program || ' type: ' || v_type || ' module: ' || v_module ); 
      countSessionsDropped := countSessionsDropped + 1;  
   END IF;
EXCEPTION
WHEN OTHERS THEN
        v_err_msg := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000);
        DBMS_OUTPUT.PUT_LINE('Session Disconnect Failed: ' || 'sid: ' || v_sid || ' serial#: ' || v_serial# || ' username: ' || v_username ||
        ' status: ' || v_status ||
        ' program: ' || v_program || ' type: ' || v_type || ' module: ' || v_module || ' Error: ' || v_err_msg);        
        countSessionsFailedToDrop := countSessionsFailedToDrop + 1;
END;
   countSessions := countSessions + 1;
fetch session_cursor into v_sid, v_serial#, v_username, v_status, v_program, v_type, v_module;
end loop;
close session_cursor;

 DBMS_OUTPUT.PUT_LINE
   ('Total Number of Sessions: ' || countSessions );  
 DBMS_OUTPUT.PUT_LINE
   ('Total Number of Sessions Disconnected: ' || countSessionsDropped ); 
 DBMS_OUTPUT.PUT_LINE
   ('Total Number of Sessions Failed to Disconnect: ' || countSessionsFailedToDrop ); 

 -- Determine whether to abort
 IF ((abort_flag = 'T') AND (killSession = TRUE) AND (countSessionsFailedToDrop > 0)) THEN
    -- Sleep before checking again to see if sessions are still active that were marked for disconnect
    -- The rollback may take too long and require the user to retry.
    DBMS_OUTPUT.PUT_LINE('Not all sessions were immediately disconnected. Sleep for 15 seconds and revalidate status.');
    DBMS_LOCK.SLEEP(15);
    open session_cursor;
    fetch session_cursor into v_sid, v_serial#, v_username, v_status, v_program, v_type, v_module;
    DBMS_OUTPUT.PUT_LINE('List any sessions still found with ODMRUSER role');
    while session_cursor%FOUND loop
       DBMS_OUTPUT.PUT_LINE('Session sid: ' || v_sid || ' serial#: ' || v_serial# || ' username: ' || v_username ||
          ' status: ' || v_status ||
          ' program: ' || v_program || ' type: ' || v_type || ' module: ' || v_module);
       countSessionsStillActive := countSessionsStillActive + 1;
    end loop;
    close session_cursor;
    if (countSessionsStillActive > 0) THEN
      RAISE_APPLICATION_ERROR(-20000, 'Unable to disconnect all sessions that have role ODMRUSER. See log. Halting process to avoid possible lock contention.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('All sessions have been disconnected');
    END IF;
 ELSIF ((abort_flag = 'T') AND (action = 'R') AND (countSessions > 0)) THEN
    RAISE_APPLICATION_ERROR(-20000, 'Detected sessions that have role ODMRUSER. See log. Halting process to avoid possible lock contention. Consider using disconnect session parameter.');
 END IF;
 
 --Waits 30 seconds  if kills have been performed.
 IF (killSession = TRUE AND countSessionsDropped > 0) THEN
    
    DBMS_OUTPUT.PUT_LINE('Waiting for 30 seconds after ' || countSessionsDropped || ' sessions dropped');
    DBMS_LOCK.SLEEP( 30 );
        
 END IF;
 
END;
/



EXECUTE dbms_output.put_line('Detecting locks on Data Miner Repository. ' || systimestamp); 

DECLARE
 CURSOR locks_cur IS
    SELECT l.session_id || '-' ||v.serial# sid_serial, l.ORACLE_USERNAME ora_user,
           o.owner, o.object_name, o.object_type, o.status, 
           DECODE(l.locked_mode, 0, 'None', 1, 'Null', 2, 'Row-S (SS)', 3, 'Row-X (SX)', 4, 'Share', 
                                 5, 'S/Row-X (SSX)', 6, 'Exclusive', TO_CHAR(l.locked_mode) ) lock_mode
    FROM dba_objects o, gv$locked_object l, v$session v
    WHERE o.object_id = l.object_id
    AND l.SESSION_ID = v.sid
    AND o.owner = 'ODMRSYS'
    ORDER BY 2,3;
  
  lock_row    locks_cur%ROWTYPE;
  row_count   INTEGER := 0;
  
BEGIN

  OPEN locks_cur;     
  LOOP
    FETCH locks_cur into lock_row;
    EXIT WHEN locks_cur%NOTFOUND;
      
    row_count := row_count + 1;
    IF( locks_cur%ROWCOUNT = 1 ) THEN
      dbms_output.put_line('');
      dbms_output.put_line('------ Locks on Data Miner Repository Objects ------');
      dbms_output.put_line('SID_SERIAL,' || CHR(9) || 'ORA_USER,' || CHR(9) || 'OWNER,' || CHR(9) || 
                           'OBJECT_NAME,' || CHR(9) || 'OBJECT_TYPE,' || CHR(9) || 'STATUS,' || CHR(9) || 
                           'LOCK_MODE');
    END IF;
    dbms_output.put_line(lock_row.sid_serial || ',' || CHR(9) || lock_row.ora_user || ',' || CHR(9) || 
                         lock_row.owner || ',' || CHR(9) || lock_row.object_name || ',' || CHR(9) || 
                         lock_row.object_type || ',' || CHR(9) || lock_row.status || ',' || CHR(9) ||
                         lock_row.lock_mode);
  END LOOP;
      
  CLOSE locks_cur;
      
  IF( row_count >= 1 ) THEN      
    RAISE_APPLICATION_ERROR(-20000, 'Database locks on objects in the Data Miner Repository (ODMRSYS account) were detected. \n
      The sessions holding the locks have been written to the log. Disconnect these sessions and retry the operation. \n
      In the meantime, the Data Miner Repository remains in a valid state for continued access by users.');
  ELSE
    dbms_output.put_line('NO Database locks where detected. ' || systimestamp);
  END IF;
END;
/

EXECUTE dbms_output.put_line('Finish checking for Database Locks ' || systimestamp);

EXECUTE dbms_output.put_line('Finished disconnecting any existing ODMRUSER sessions, or ODMRSYS sessions. ' || systimestamp);