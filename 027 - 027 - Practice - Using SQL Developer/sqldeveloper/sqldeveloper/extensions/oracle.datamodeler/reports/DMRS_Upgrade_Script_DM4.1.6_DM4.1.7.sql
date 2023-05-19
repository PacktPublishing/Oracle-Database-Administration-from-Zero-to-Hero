-- Upgrade script for Reporting Schema from DM 4.1.6 to DM 4.1.7 release or later

--==========ALTER TABLES==========
ALTER TABLE dmrs_schema_object ADD (model_ovid VARCHAR2 (36));
ALTER TABLE dmrs_diagram_elements ADD (Long_Name VARCHAR2 (256));
