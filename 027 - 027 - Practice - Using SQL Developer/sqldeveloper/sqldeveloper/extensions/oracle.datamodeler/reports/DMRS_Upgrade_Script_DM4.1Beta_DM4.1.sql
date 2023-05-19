-- Upgrade script for Reporting Schema from DM 4.1 Beta(4.1.0.866) to DM 4.1

--==========ALTER TABLES==========
ALTER TABLE DMRS_DYNAMIC_PROPERTIES MODIFY Value VARCHAR2 (4000);
