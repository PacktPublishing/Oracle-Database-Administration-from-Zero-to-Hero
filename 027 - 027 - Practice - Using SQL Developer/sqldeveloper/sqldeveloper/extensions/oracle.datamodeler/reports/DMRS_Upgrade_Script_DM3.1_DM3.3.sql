-- Upgrade script for Reporting Schema from DM 3.1 (3.1.0.700) to DM 3.3 (3.3.0.743) Release or later

--==========CREATE TABLES==========
CREATE TABLE DMRS_CONSTR_FK_COLUMNS (
Fk_ID VARCHAR2 (70) NOT NULL, 
Fk_OVID VARCHAR2 (36) NOT NULL, 
Column_ID VARCHAR2 (70) NOT NULL, 
Column_OVID VARCHAR2 (36) NOT NULL, 
Table_ID VARCHAR2 (70) NOT NULL, 
Table_OVID VARCHAR2 (36) NOT NULL, 
Index_Name VARCHAR2 (256) NOT NULL, 
Table_Name VARCHAR2 (256) NOT NULL, 
Column_Name VARCHAR2 (256) NOT NULL, 
Sequence NUMBER NOT NULL, 
Sort_Order VARCHAR2 (4), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_INFO_STRUCT_ATTRS (
Info_Structure_ID VARCHAR2 (70) NOT NULL, 
Info_Structure_OVID VARCHAR2 (36) NOT NULL, 
Info_Structure_Name VARCHAR2 (256) NOT NULL, 
Attribute_ID VARCHAR2 (70) NOT NULL, 
Attribute_OVID VARCHAR2 (36) NOT NULL, 
Attribute_Name VARCHAR2 (256) NOT NULL, 
Entity_ID VARCHAR2 (70) NOT NULL, 
Entity_OVID VARCHAR2 (36) NOT NULL, 
Entity_Name VARCHAR2 (256) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

DROP TABLE DMRS_EXTERNAL_DATAS;

CREATE TABLE DMRS_EXTERNAL_DATAS (
External_Data_ID VARCHAR2 (70) NOT NULL, 
External_Data_OVID VARCHAR2 (36) NOT NULL, 
External_Data_Name VARCHAR2 (256) NOT NULL, 
Model_ID VARCHAR2 (70) NOT NULL, 
Model_OVID VARCHAR2 (36) NOT NULL, 
Model_Name VARCHAR2 (256) NOT NULL, 
Logical_Type_ID VARCHAR2 (70), 
Logical_Type_OVID VARCHAR2 (36), 
Logical_Type_Name VARCHAR2 (256), 
Record_Structure_Type_ID VARCHAR2 (70), 
Record_Structure_Type_OVID VARCHAR2 (36), 
Record_Structure_Type_Name VARCHAR2 (256), 
Starting_Pos NUMBER (10), 
Description VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

--==========ALTER TABLES==========
ALTER TABLE dmrs_tables ADD (Source_Info_OVID VARCHAR2 (36));
ALTER TABLE dmrs_tables ADD (Source_DataDict_Schema_Name VARCHAR2 (256));
ALTER TABLE dmrs_tables ADD (Source_DataDict_Object_Name VARCHAR2 (256));
ALTER TABLE dmrs_dynamic_properties ADD (Design_OVID VARCHAR2 (36));
ALTER TABLE dmrs_entities MODIFY (entity_source VARCHAR2 (200));
ALTER TABLE dmrs_relationships MODIFY (Model_ID VARCHAR2 (80));
ALTER TABLE dmrs_relationships MODIFY (Object_ID VARCHAR2 (80));
ALTER TABLE dmrs_attributes MODIFY (Object_ID VARCHAR2 (80));
ALTER TABLE dmrs_diagram_elements MODIFY (Object_ID VARCHAR2 (80));
ALTER TABLE dmrs_key_elements MODIFY (Key_ID VARCHAR2 (80));
ALTER TABLE dmrs_key_elements MODIFY (Element_ID VARCHAR2 (80));
ALTER TABLE dmrs_columns MODIFY (Mask_For_None_Production CHAR (12));
ALTER TABLE dmrs_view_columns MODIFY (Mask_For_None_Production CHAR (12));
--change columns to NULL because level descriptive attribute could exist without mapping to attribute (LM)
ALTER TABLE DMRS_LEVEL_ATTRS MODIFY (Attribute_ID NULL);
ALTER TABLE DMRS_LEVEL_ATTRS MODIFY (Attribute_Name NULL);
ALTER TABLE DMRS_LEVEL_ATTRS MODIFY (Attribute_OVID NULL);

--==========CREATE TYPES==========
CREATE OR REPLACE TYPE OBJECTS_LIST IS TABLE OF VARCHAR2(32767);

CREATE OR REPLACE TYPE report_template AS OBJECT (
  reportType                  INTEGER,
  useDescriptionInfo          INTEGER,
  useQuantitativeInfo         INTEGER,
  useDiagrams                 INTEGER,
  useTableColumns             INTEGER,
  useTableColumnsComments     INTEGER,
  useTableIndexes             INTEGER,
  useTableConstraints         INTEGER,
  useTableFKReferringTo       INTEGER,
  useTableFKReferredFrom      INTEGER,
  useEntityAttributes         INTEGER,
  useEntityAttributesComments INTEGER,
  useEntityConstraints        INTEGER,
  useEntityIdentifiers        INTEGER,
  useEntityRelationships      INTEGER,
  useEntityIncomingProcesses  INTEGER,
  useEntityOutgoingProcesses  INTEGER,
  useDomainConstraints        INTEGER,
  useDomainUsedInTables       INTEGER,
  useDomainUsedInEntities     INTEGER,
  useSTAttributes             INTEGER,
  useSTAttributesComments     INTEGER,
  useSTMethods                INTEGER,
  useSTUsedInTables           INTEGER,
  useSTUsedInEntities         INTEGER,
  useCTUsedInTables           INTEGER,
  useCTUsedInEntities         INTEGER,
  useDTUsedInTables           INTEGER,
  useDTUsedInEntities         INTEGER,
  useCRImpactedObjects        INTEGER,
  useMRImpactedObjects        INTEGER);

--==========CREATE VIEWS==========
CREATE VIEW DMRV_INFO_STRUCT_ATTRS 
(Info_Structure_ID, Info_Structure_OVID, Info_Structure_Name, Attribute_ID, Attribute_OVID, Attribute_Name,
 Entity_ID, Entity_OVID, Entity_Name, Design_OVID) AS select 
 Info_Structure_ID, Info_Structure_OVID, Info_Structure_Name, Attribute_ID, Attribute_OVID, Attribute_Name,
 Entity_ID, Entity_OVID, Entity_Name, Design_OVID from DMRS_INFO_STRUCT_ATTRS;

DROP VIEW DMRV_EXTERNAL_DATAS;

CREATE VIEW DMRV_EXTERNAL_DATAS 
(External_Data_ID, External_Data_OVID, External_Data_Name, Model_ID, Model_OVID, Model_Name, 
Logical_Type_ID, Logical_Type_OVID, Logical_Type_Name, Record_Structure_Type_ID, Record_Structure_Type_OVID, Record_Structure_Type_Name, 
Starting_Pos, Description, Design_OVID) AS select 
 External_Data_ID, External_Data_OVID, External_Data_Name, Model_ID, Model_OVID, Model_Name, 
Logical_Type_ID, Logical_Type_OVID, Logical_Type_Name, Record_Structure_Type_ID, Record_Structure_Type_OVID, Record_Structure_Type_Name, 
Starting_Pos, Description, Design_OVID from DMRS_EXTERNAL_DATAS;
