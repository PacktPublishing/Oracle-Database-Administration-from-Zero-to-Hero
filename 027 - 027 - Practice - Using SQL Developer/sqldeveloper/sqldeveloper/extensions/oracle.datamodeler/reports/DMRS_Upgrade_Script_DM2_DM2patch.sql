-- Upgrade script for Reporting Schema from DM 2.0.0(570) Release to DM 2.0.0(578) Patch Release

ALTER TABLE DMRS_ATTRIBUTES
MODIFY ( Formula VARCHAR2 (4000),
         Check_Constraint_Name VARCHAR2 (256),
         Logical_Type_Name VARCHAR2 (256),
         Structured_Type_Name VARCHAR2 (256),
         Distinct_Type_Name VARCHAR2 (256),
         Collection_Type_Name VARCHAR2 (256),
         Synonyms VARCHAR2 (4000) );

ALTER TABLE DMRS_CHECK_CONSTRAINTS
MODIFY ( Constraint_Name VARCHAR2 (256),
         Text VARCHAR2 (4000) );

ALTER TABLE DMRS_CLASSIFICATION_TYPES
MODIFY ( Type_Name VARCHAR2 (256) );

ALTER TABLE DMRS_COLUMNS
MODIFY ( Formula VARCHAR2 (4000),
         Check_Constraint_Name VARCHAR2 (256),
         Logical_Type_Name VARCHAR2 (256),
         Structured_Type_Name VARCHAR2 (256),
         Distinct_Type_Name VARCHAR2 (256),
         Collection_Type_Name VARCHAR2 (256) );

ALTER TABLE DMRS_DOMAINS
MODIFY ( Synonyms VARCHAR2 (4000) );

ALTER TABLE DMRS_ENTITIES
MODIFY ( Structured_Type_Name VARCHAR2 (256),
         Classification_Type_Name VARCHAR2 (256),
         Synonyms VARCHAR2 (4000) );

ALTER TABLE DMRS_ENTITYVIEWS
MODIFY ( Structured_Type_Name VARCHAR2 (256) );

ALTER TABLE DMRS_FOREIGNKEYS
MODIFY ( Child_Table_Name VARCHAR2 (256),
         Referred_Table_Name VARCHAR2 (256) );

ALTER TABLE DMRS_KEYS
MODIFY ( Synonyms VARCHAR2 (4000) );

ALTER TABLE DMRS_SPATIAL_COLUMN_DEFINITION
MODIFY ( Definition_Name VARCHAR2 (256) );

ALTER TABLE DMRS_SPATIAL_DIMENSIONS
MODIFY ( Definition_Name VARCHAR2 (256),
         Dimension_Name VARCHAR2 (256) );

ALTER TABLE DMRS_TABLES
MODIFY ( Structured_Type_Name VARCHAR2 (256),
         Classification_Type_Name VARCHAR2 (256) );

ALTER TABLE DMRS_TABLEVIEWS
MODIFY ( Structured_Type_Name VARCHAR2 (256) );

ALTER TABLE DMRS_TABLE_CONSTRAINTS
MODIFY ( Constraint_Name VARCHAR2 (256) );

ALTER TABLE DMRS_COLUMN_GROUPS
MODIFY ( ColumnGroup_Name VARCHAR2 (256) );

CREATE TABLE DMRS_GLOSSARIES (
Glossary_ID VARCHAR2 (70) NOT NULL,
Glossary_OVID VARCHAR2 (36) NOT NULL,
Glossary_Name VARCHAR2 (256) NOT NULL,
File_Name VARCHAR2 (256),
Description VARCHAR2 (4000),
Incomplete_Modifiers CHAR(1),
Case_Sensitive CHAR(1),
Unique_Abbrevs CHAR(1),
Separator_Type VARCHAR2(10),
Separator_Char CHAR(1),
Date_Published TIMESTAMP NOT NULL,
Published_By VARCHAR2 (80),
Persistence_Version NUMBER (5,2) NOT NULL,
Version_Comments VARCHAR2 (4000) );

CREATE VIEW DMRV_GLOSSARIES 
(Glossary_ID, Glossary_OVID, Glossary_Name, File_Name, Description, Incomplete_Modifiers, Case_Sensitive, Unique_Abbrevs, 
Separator_Type, Separator_Char, Date_Published, Published_By, Persistence_Version, Version_Comments) AS select 
 Glossary_ID, Glossary_OVID, Glossary_Name, File_Name, Description, Incomplete_Modifiers, Case_Sensitive, Unique_Abbrevs, 
Separator_Type, Separator_Char, Date_Published, Published_By, Persistence_Version, Version_Comments from DMRS_GLOSSARIES;

CREATE TABLE DMRS_GLOSSARY_TERMS (
Term_ID VARCHAR2 (70) NOT NULL,
Term_OVID VARCHAR2 (36) NOT NULL,
Term_Name VARCHAR2 (256) NOT NULL,
Short_Description VARCHAR2 (4000),
Abbrev VARCHAR2 (256),
Alt_Abbrev VARCHAR2 (256),
Prime_Word CHAR (1),
Class_Word CHAR (1),
Modifier CHAR (1),
Qualifier CHAR (1),
Glossary_ID VARCHAR2 (70) NOT NULL,
Glossary_OVID VARCHAR2 (36) NOT NULL,
Glossary_Name VARCHAR2 (256) NOT NULL );

CREATE VIEW DMRV_GLOSSARY_TERMS
(Term_ID, Term_OVID, Term_Name, Short_Description, Abbrev, Alt_Abbrev, Prime_Word, 
Class_Word, Modifier, Qualifier, Glossary_ID, Glossary_OVID, Glossary_Name) AS select 
 Term_ID, Term_OVID, Term_Name, Short_Description, Abbrev, Alt_Abbrev, Prime_Word, 
Class_Word, Modifier, Qualifier, Glossary_ID, Glossary_OVID, Glossary_Name from DMRS_GLOSSARY_TERMS;

CREATE INDEX GLOSSARY_TERMS_FK_IDX ON DMRS_GLOSSARY_TERMS (Glossary_OVID ASC);

CREATE INDEX MAPPINGS_OVIDS_IX on DMRS_MAPPINGS (LOGICAL_OBJECT_OVID,RELATIONAL_OBJECT_OVID);