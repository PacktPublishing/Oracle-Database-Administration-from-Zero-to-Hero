-- Run this script to migrate an existing ODMRSYS account from OR to Binary (require new tablespace of ASM type)
-- Successful completion of the script requires there to be no sessions active with the role of ODMRUSER.
-- Active ODMRUSER sessions can result in object locks that block the migration.
-- The following parameter is available for detecting and managing such sessions.
-- 1. Action Flags:
--    R = report only, do not disconnect any sessions
--    D = disconnect only, displays disconnect  only
--    DR or RD = disconnect and report
-- Example:
-- Option 1: Conservative approach, which will require DBA to manually review active sessions and 
-- determine how to end them. The migration process will stop if there are active sessions and a log
-- is produced listing the sessions to be manually reviewed and handled.
-- @upgradeRepoWithNewTableSpace.sql <ASM Tablespace> R 
-- Option 2: Force migration approach which will disconnect sessions and proceed with migration as 
-- long as all sessions are succesfully disconnected.
-- @upgradeRepoWithNewTableSpace.sql <ASM Tablespace> DR 

set serveroutput on

EXECUTE dbms_output.put_line('Start Data Miner Repository Upgrade Process. ' || systimestamp);

DEFINE D_TABLESPACE = &1
DEFINE D_SESSION_ACTION = &2

WHENEVER SQLERROR EXIT SQL.SQLCODE;
-- check to insure that no workflows are either queued or active.
-- Abort the process if this condition exists.
@@insureWorkflowsInactive.sql

-- determine if migration can proceed (db >= 11.2.0.4 and supplied tablespace is ASM).
-- Abort the process if migration is not allowed
@@isBinaryXMLMigrationAllowed.sql &D_TABLESPACE

-- disconnect any existing odmruser sessions, or odmrsys sessions
@@disconnectODMRSessions.sql &D_SESSION_ACTION T

-- backup user grants
@@createusersgrantbackup.sql

-- revoke grants on ODMRUSER role and associated objects
@@usergrantshelper.sql REVOKE ODMRUSER

-- run a final check to insure that no sessions were missed (should not be any ODMRUSER roles granted)
@@disconnectODMRSessions.sql &D_SESSION_ACTION T

-- update the status of the repository
EXECUTE dbms_output.put_line('Update repository status to NOT_LOADED.');
@@updateRepositoryProperty.sql REPOSITORY_STATUS  NOT_LOADED

-- backup XML workflows
@@createxmlworkflowsbackup.sql;

-- change the WORKFLOW_DATA column data storage from OR to Binary
@@upgradeTablespaceForBinary.sql &D_TABLESPACE

-- migrate repository
@@migrateodmrhelper.sql

-- fail if the versions do not match the target versions 
@@validateVersionUpgrade.sql 

-- update the status of the repository
EXECUTE dbms_output.put_line('Update repository status to LOADED.');
@@updateRepositoryProperty.sql REPOSITORY_STATUS  LOADED

-- grant ODMRUSER role and associated objects privileges to users previously holding these grants
@@usergrantshelper.sql GRANT USE_BACKUP_TABLE

EXECUTE dbms_output.put_line('End of Data Miner Repository Upgrade Process. ' || systimestamp);
