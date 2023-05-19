
WHENEVER SQLERROR EXIT SQL.SQLCODE;

EXECUTE dbms_output.put_line('Start migrateodmrhelper. ' || systimestamp);

alter session set current_schema = "SYS";

-- migrate the XML Schema to current version
@@upgradexmlschema.sql

-- upgrade ODMr Repository
alter session set current_schema = "ODMRSYS";

-- upgradeRepository.sql sets WHENEVER SQLERROR EXIT SQL.SQLCODE
@@upgradeRepository.sql

-- install new packages
@@instpackages.sql

-- install the stopwords used for Oracle Text operations
@@inststopwords.sql

-- install NLS messages
@@instmessages.sql

-- redo grants
@@instgrants.sql

WHENEVER SQLERROR EXIT SQL.SQLCODE;

alter session set current_schema = "SYS";
-- insure there are no invalid objects
@@validateODMRSYS.sql ALL

EXECUTE dbms_output.put_line('Finished migrateodmrhelper. ' || systimestamp);
