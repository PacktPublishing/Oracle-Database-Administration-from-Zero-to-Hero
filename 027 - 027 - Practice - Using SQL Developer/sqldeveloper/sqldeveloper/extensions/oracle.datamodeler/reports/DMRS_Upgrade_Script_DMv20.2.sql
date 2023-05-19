-- Upgrade script for Reporting Schema DM v20.2

--==========ALTER TABLES==========
ALTER TABLE DMRS_ENTITIES ADD Short_Name VARCHAR2 (256);
