-- Upgrade script for Reporting Schema from DM 3.0.0(665) Patch Release to DM 3.1.0(696) Release or later

--==========REPLACE INSTALLATION VIEWS==========
CREATE OR REPLACE FORCE VIEW DMRS_INSTALLATION AS select
1.6 DMRS_Persistence_Version,
1.0 DMRS_Reports_Version,
sysdate Created_On
from dual with read only;

CREATE OR REPLACE FORCE VIEW DMRV_REPORTS_VERSION_1_0 AS select
1.6 DMRS_Persistence_Version,
1.0 DMRS_Reports_Version,
sysdate Created_On
from dual with read only;

--==========CREATE TABLES==========
CREATE TABLE DMRS_AGGR_FUNC_DIMENSIONS (
Aggregate_Function_ID VARCHAR2 (70) NOT NULL, 
Aggregate_Function_Name VARCHAR2 (256) NOT NULL, 
Aggregate_Function_OVID VARCHAR2 (36) NOT NULL, 
Dimension_ID VARCHAR2 (70) NOT NULL, 
Dimension_Name VARCHAR2 (256) NOT NULL, 
Dimension_OVID VARCHAR2 (36) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_AGGR_FUNC_LEVELS (
Aggregate_Function_ID VARCHAR2 (70) NOT NULL, 
Aggregate_Function_Name VARCHAR2 (256) NOT NULL, 
Aggregate_Function_OVID VARCHAR2 (36) NOT NULL, 
Level_ID VARCHAR2 (70) NOT NULL, 
Level_Name VARCHAR2 (256) NOT NULL, 
Level_OVID VARCHAR2 (36) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_BUSINESS_INFO (
Design_ID VARCHAR2 (70) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL, 
Design_Name VARCHAR2 (256) NOT NULL, 
Business_Info_ID VARCHAR2 (70) NOT NULL, 
Business_Info_OVID VARCHAR2 (36) NOT NULL, 
Business_Info_Name VARCHAR2 (256) NOT NULL);

CREATE TABLE DMRS_CHANGE_REQUESTS (
Design_ID VARCHAR2 (70) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL, 
Design_Name VARCHAR2 (256) NOT NULL, 
Change_Request_ID VARCHAR2 (70) NOT NULL, 
Change_Request_OVID VARCHAR2 (36) NOT NULL, 
Change_Request_Name VARCHAR2 (256) NOT NULL, 
Request_Status VARCHAR2 (30), 
Request_Date_String VARCHAR2 (30), 
Completion_Date_String VARCHAR2 (30), 
Is_Completed CHAR (1), 
Reason VARCHAR2 (4000));

CREATE TABLE DMRS_CHANGE_REQUEST_ELEMENTS (
Change_Request_ID VARCHAR2 (70) NOT NULL, 
Change_Request_OVID VARCHAR2 (36) NOT NULL, 
Change_Request_Name VARCHAR2 (256) NOT NULL, 
Element_ID VARCHAR2 (70) NOT NULL, 
Element_OVID VARCHAR2 (36) NOT NULL, 
Element_Name VARCHAR2 (256) NOT NULL, 
Element_Type VARCHAR2 (30), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_CONTACTS (
Contact_ID VARCHAR2 (70) NOT NULL, 
Contact_OVID VARCHAR2 (36) NOT NULL, 
Contact_Name VARCHAR2 (256) NOT NULL, 
Business_Info_ID VARCHAR2 (70) NOT NULL, 
Business_Info_OVID VARCHAR2 (36) NOT NULL, 
Business_Info_Name VARCHAR2 (256) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_CONTACT_EMAILS (
Contact_ID VARCHAR2 (70) NOT NULL, 
Contact_OVID VARCHAR2 (36) NOT NULL, 
Contact_Name VARCHAR2 (256) NOT NULL, 
Email_ID VARCHAR2 (70) NOT NULL, 
Email_OVID VARCHAR2 (36) NOT NULL, 
Email_Name VARCHAR2 (256) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_CONTACT_LOCATIONS (
Contact_ID VARCHAR2 (70) NOT NULL, 
Contact_OVID VARCHAR2 (36) NOT NULL, 
Contact_Name VARCHAR2 (256) NOT NULL, 
Location_ID VARCHAR2 (70) NOT NULL, 
Location_OVID VARCHAR2 (36) NOT NULL, 
Location_Name VARCHAR2 (256) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_CONTACT_RES_LOCATORS (
Contact_ID VARCHAR2 (70) NOT NULL, 
Contact_OVID VARCHAR2 (36) NOT NULL, 
Contact_Name VARCHAR2 (256) NOT NULL, 
Resource_Locator_ID VARCHAR2 (70) NOT NULL, 
Resource_Locator_OVID VARCHAR2 (36) NOT NULL, 
Resource_Locator_Name VARCHAR2 (256) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_CONTACT_TELEPHONES (
Contact_ID VARCHAR2 (70) NOT NULL, 
Contact_OVID VARCHAR2 (36) NOT NULL, 
Contact_Name VARCHAR2 (256) NOT NULL, 
Telephone_ID VARCHAR2 (70) NOT NULL, 
Telephone_OVID VARCHAR2 (36) NOT NULL, 
Telephone_Name VARCHAR2 (256) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_CUBES (
Cube_ID VARCHAR2 (70) NOT NULL, 
Cube_Name VARCHAR2 (256) NOT NULL, 
Cube_OVID VARCHAR2 (36) NOT NULL, 
Model_ID VARCHAR2 (70) NOT NULL, 
Model_Name VARCHAR2 (256) NOT NULL, 
Model_OVID VARCHAR2 (36) NOT NULL, 
Part_Dimension_ID VARCHAR2 (70), 
Part_Dimension_Name VARCHAR2 (256), 
Part_Dimension_OVID VARCHAR2 (36), 
Part_Hierarchy_ID VARCHAR2 (70), 
Part_Hierarchy_Name VARCHAR2 (256), 
Part_Hierarchy_OVID VARCHAR2 (36), 
Part_Level_ID VARCHAR2 (70), 
Part_Level_Name VARCHAR2 (256), 
Part_Level_OVID VARCHAR2 (36), 
Full_Cube_Slice_ID VARCHAR2 (70), 
Full_Cube_Slice_Name VARCHAR2 (256), 
Full_Cube_Slice_OVID VARCHAR2 (36), 
Oracle_Long_Name VARCHAR2 (2000), 
Oracle_Plural_Name VARCHAR2 (2000), 
Oracle_Short_Name VARCHAR2 (2000), 
Is_Compressed_Composites CHAR (1), 
Is_Global_Composites CHAR (1), 
Is_Partitioned CHAR (1), 
Is_Virtual CHAR (1), 
Part_Description VARCHAR2 (4000), 
Description VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_CUBE_DIMENSIONS (
Cube_ID VARCHAR2 (70) NOT NULL, 
Cube_Name VARCHAR2 (256) NOT NULL, 
Cube_OVID VARCHAR2 (36) NOT NULL, 
Dimension_ID VARCHAR2 (70) NOT NULL, 
Dimension_Name VARCHAR2 (256) NOT NULL, 
Dimension_OVID VARCHAR2 (36) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_DIMENSIONS (
Dimension_ID VARCHAR2 (70) NOT NULL, 
Dimension_Name VARCHAR2 (256) NOT NULL, 
Dimension_OVID VARCHAR2 (36) NOT NULL, 
Model_ID VARCHAR2 (70) NOT NULL, 
Model_Name VARCHAR2 (256) NOT NULL, 
Model_OVID VARCHAR2 (36) NOT NULL, 
Base_Entity_ID VARCHAR2 (70), 
Base_Entity_Name VARCHAR2 (256), 
Base_Entity_OVID VARCHAR2 (36), 
Base_Level_ID VARCHAR2 (70), 
Base_Level_Name VARCHAR2 (256), 
Base_Level_OVID VARCHAR2 (36), 
Oracle_Long_Name VARCHAR2 (2000), 
Oracle_Plural_Name VARCHAR2 (2000), 
Oracle_Short_Name VARCHAR2 (2000), 
Description VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_DIMENSION_CALC_ATTRS (
Dimension_ID VARCHAR2 (70) NOT NULL, 
Dimension_Name VARCHAR2 (256) NOT NULL, 
Dimension_OVID VARCHAR2 (36) NOT NULL, 
Calc_Attribute_ID VARCHAR2 (70) NOT NULL, 
Calc_Attribute_Name VARCHAR2 (256) NOT NULL, 
Calc_Attribute_OVID VARCHAR2 (36) NOT NULL, 
Calculated_Expr VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_DIMENSION_LEVELS (
Dimension_ID VARCHAR2 (70) NOT NULL, 
Dimension_Name VARCHAR2 (256) NOT NULL, 
Dimension_OVID VARCHAR2 (36) NOT NULL, 
Level_ID VARCHAR2 (70) NOT NULL, 
Level_Name VARCHAR2 (256) NOT NULL, 
Level_OVID VARCHAR2 (36) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_DOCUMENTS (
Document_ID VARCHAR2 (70) NOT NULL, 
Document_OVID VARCHAR2 (36) NOT NULL, 
Document_Name VARCHAR2 (256) NOT NULL, 
Business_Info_ID VARCHAR2 (70) NOT NULL, 
Business_Info_OVID VARCHAR2 (36) NOT NULL, 
Business_Info_Name VARCHAR2 (256) NOT NULL, 
Parent_ID VARCHAR2 (70), 
Parent_OVID VARCHAR2 (36), 
Parent_Name VARCHAR2 (256), 
Doc_Reference VARCHAR2 (2000), 
Doc_Type VARCHAR2 (1000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_DOCUMENT_ELEMENTS (
Document_ID VARCHAR2 (70) NOT NULL, 
Document_OVID VARCHAR2 (36) NOT NULL, 
Document_Name VARCHAR2 (256) NOT NULL, 
Element_ID VARCHAR2 (70) NOT NULL, 
Element_OVID VARCHAR2 (36) NOT NULL, 
Element_Name VARCHAR2 (256) NOT NULL, 
Element_Type VARCHAR2 (30), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_EMAILS (
Email_ID VARCHAR2 (70) NOT NULL, 
Email_OVID VARCHAR2 (36) NOT NULL, 
Email_Name VARCHAR2 (256) NOT NULL, 
Business_Info_ID VARCHAR2 (70) NOT NULL, 
Business_Info_OVID VARCHAR2 (36) NOT NULL, 
Business_Info_Name VARCHAR2 (256) NOT NULL, 
Email_Address VARCHAR2 (2000), 
Email_Type VARCHAR2 (1000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_FACT_ENTITIES (
Cube_ID VARCHAR2 (70) NOT NULL, 
Cube_Name VARCHAR2 (256) NOT NULL, 
Cube_OVID VARCHAR2 (36) NOT NULL, 
Entity_ID VARCHAR2 (70) NOT NULL, 
Entity_Name VARCHAR2 (256) NOT NULL, 
Entity_OVID VARCHAR2 (36) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_FACT_ENTITIES_JOINS (
Join_ID VARCHAR2 (70) NOT NULL, 
Join_Name VARCHAR2 (256) NOT NULL, 
Join_OVID VARCHAR2 (36) NOT NULL, 
Cube_ID VARCHAR2 (70) NOT NULL, 
Cube_Name VARCHAR2 (256) NOT NULL, 
Cube_OVID VARCHAR2 (36) NOT NULL, 
Left_Entity_ID VARCHAR2 (70), 
Left_Entity_Name VARCHAR2 (256), 
Left_Entity_OVID VARCHAR2 (36), 
Right_Entity_ID VARCHAR2 (70), 
Right_Entity_Name VARCHAR2 (256), 
Right_Entity_OVID VARCHAR2 (36), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_HIERARCHIES (
Hierarchy_ID VARCHAR2 (70) NOT NULL, 
Hierarchy_Name VARCHAR2 (256) NOT NULL, 
Hierarchy_OVID VARCHAR2 (36) NOT NULL, 
Model_ID VARCHAR2 (70) NOT NULL, 
Model_Name VARCHAR2 (256) NOT NULL, 
Model_OVID VARCHAR2 (36) NOT NULL, 
Dimension_ID VARCHAR2 (70), 
Dimension_Name VARCHAR2 (256), 
Dimension_OVID VARCHAR2 (36), 
Oracle_Long_Name VARCHAR2 (2000), 
Oracle_Plural_Name VARCHAR2 (2000), 
Oracle_Short_Name VARCHAR2 (2000), 
Is_Default_Hierarchy CHAR (1), 
Is_Ragged_Hierarchy CHAR (1), 
Is_Value_Based_Hierarchy CHAR (1), 
Description VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_HIERARCHY_LEVELS (
Hierarchy_ID VARCHAR2 (70) NOT NULL, 
Hierarchy_Name VARCHAR2 (256) NOT NULL, 
Hierarchy_OVID VARCHAR2 (36) NOT NULL, 
Level_ID VARCHAR2 (70) NOT NULL, 
Level_Name VARCHAR2 (256) NOT NULL, 
Level_OVID VARCHAR2 (36) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_HIERARCHY_ROLLUP_LINKS (
Hierarchy_ID VARCHAR2 (70) NOT NULL, 
Hierarchy_Name VARCHAR2 (256) NOT NULL, 
Hierarchy_OVID VARCHAR2 (36) NOT NULL, 
Rollup_Link_ID VARCHAR2 (70) NOT NULL, 
Rollup_Link_Name VARCHAR2 (256) NOT NULL, 
Rollup_Link_OVID VARCHAR2 (36) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_LEVELS (
Level_ID VARCHAR2 (70) NOT NULL, 
Level_Name VARCHAR2 (256) NOT NULL, 
Level_OVID VARCHAR2 (36) NOT NULL, 
Model_ID VARCHAR2 (70) NOT NULL, 
Model_Name VARCHAR2 (256) NOT NULL, 
Model_OVID VARCHAR2 (36) NOT NULL, 
Entity_ID VARCHAR2 (70), 
Entity_Name VARCHAR2 (256), 
Entity_OVID VARCHAR2 (36), 
Name_Column_ID VARCHAR2 (70), 
Name_Column_Name VARCHAR2 (256), 
Name_Column_OVID VARCHAR2 (36), 
Value_Column_ID VARCHAR2 (70), 
Value_Column_Name VARCHAR2 (256), 
Value_Column_OVID VARCHAR2 (36), 
Oracle_Long_Name VARCHAR2 (2000), 
Oracle_Plural_Name VARCHAR2 (2000), 
Oracle_Short_Name VARCHAR2 (2000), 
Root_Identification VARCHAR2 (30), 
Identification_Value VARCHAR2 (2000), 
Selection_Criteria VARCHAR2 (4000), 
Selection_Criteria_Description VARCHAR2 (4000), 
Is_Value_Based_Hierarchy CHAR (1), 
Description VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_LEVEL_ATTRS (
Level_ID VARCHAR2 (70) NOT NULL, 
Level_Name VARCHAR2 (256) NOT NULL, 
Level_OVID VARCHAR2 (36) NOT NULL, 
Attribute_ID VARCHAR2 (70) NOT NULL, 
Attribute_Name VARCHAR2 (256) NOT NULL, 
Attribute_OVID VARCHAR2 (36) NOT NULL, 
Is_Default_Attr CHAR (1), 
Is_Level_Key_Attr CHAR (1), 
Is_Parent_Key_Attr CHAR (1), 
Is_Descriptive_Key_Attr CHAR (1), 
Is_Calculated_Attr CHAR (1), 
Descriptive_Name VARCHAR2 (256), 
Descriptive_Is_Indexed CHAR (1), 
Descriptive_Slow_Changing VARCHAR2 (30), 
Calculated_Expr VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_LOCATIONS (
Location_ID VARCHAR2 (70) NOT NULL, 
Location_OVID VARCHAR2 (36) NOT NULL, 
Location_Name VARCHAR2 (256) NOT NULL, 
Business_Info_ID VARCHAR2 (70) NOT NULL, 
Business_Info_OVID VARCHAR2 (36) NOT NULL, 
Business_Info_Name VARCHAR2 (256) NOT NULL, 
Loc_Address VARCHAR2 (1000), 
Loc_City VARCHAR2 (1000), 
Loc_Post_Code VARCHAR2 (1000), 
Loc_Area VARCHAR2 (1000), 
Loc_Country VARCHAR2 (1000), 
Loc_Type VARCHAR2 (1000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_MAPPING_TARGETS (
Object_ID VARCHAR2 (70) NOT NULL, 
Object_OVID VARCHAR2 (36) NOT NULL, 
Object_Name VARCHAR2 (256) NOT NULL, 
Target_ID VARCHAR2 (70) NOT NULL, 
Target_OVID VARCHAR2 (36) NOT NULL, 
Target_Name VARCHAR2 (256) NOT NULL, 
Object_Type VARCHAR2 (30), 
Target_Type VARCHAR2 (30), 
Transformation_Type VARCHAR2 (30), 
Description VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_MAPPING_TARGET_SOURCES (
Object_ID VARCHAR2 (70) NOT NULL, 
Object_OVID VARCHAR2 (36) NOT NULL, 
Object_Name VARCHAR2 (256) NOT NULL, 
Target_ID VARCHAR2 (70) NOT NULL, 
Target_OVID VARCHAR2 (36) NOT NULL, 
Target_Name VARCHAR2 (256) NOT NULL, 
Source_ID VARCHAR2 (70) NOT NULL, 
Source_OVID VARCHAR2 (36) NOT NULL, 
Source_Name VARCHAR2 (256) NOT NULL, 
Object_Type VARCHAR2 (30), 
Target_Type VARCHAR2 (30), 
Source_Type VARCHAR2 (30), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_MEASURES (
Measure_ID VARCHAR2 (70) NOT NULL, 
Measure_Name VARCHAR2 (256) NOT NULL, 
Measure_OVID VARCHAR2 (36) NOT NULL, 
Model_ID VARCHAR2 (70) NOT NULL, 
Model_Name VARCHAR2 (256) NOT NULL, 
Model_OVID VARCHAR2 (36) NOT NULL, 
Cube_ID VARCHAR2 (70), 
Cube_Name VARCHAR2 (256), 
Cube_OVID VARCHAR2 (36), 
Fact_Object_ID VARCHAR2 (70), 
Fact_Object_Name VARCHAR2 (256), 
Fact_Object_OVID VARCHAR2 (36), 
Oracle_Long_Name VARCHAR2 (2000), 
Oracle_Plural_Name VARCHAR2 (2000), 
Oracle_Short_Name VARCHAR2 (2000), 
Fact_Object_Type VARCHAR2 (30), 
Additivity_Type VARCHAR2 (30), 
Is_Fact_Dimension CHAR (1), 
Is_Formula CHAR (1), 
Is_Custom_Formula CHAR (1), 
Formula VARCHAR2 (4000), 
Where_Clause VARCHAR2 (4000), 
Description VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_MEASURE_AGGR_FUNCS (
Measure_ID VARCHAR2 (70) NOT NULL, 
Measure_Name VARCHAR2 (256) NOT NULL, 
Measure_OVID VARCHAR2 (36) NOT NULL, 
Aggregate_Function_ID VARCHAR2 (70) NOT NULL, 
Aggregate_Function_Name VARCHAR2 (256) NOT NULL, 
Aggregate_Function_OVID VARCHAR2 (36) NOT NULL, 
Measure_Alias VARCHAR2 (256), 
Is_Default CHAR (1), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_MEASURE_FOLDERS (
Measure_Folder_ID VARCHAR2 (70) NOT NULL, 
Measure_Folder_Name VARCHAR2 (256) NOT NULL, 
Measure_Folder_OVID VARCHAR2 (36) NOT NULL, 
Model_ID VARCHAR2 (70) NOT NULL, 
Model_Name VARCHAR2 (256) NOT NULL, 
Model_OVID VARCHAR2 (36) NOT NULL, 
Parent_Folder_ID VARCHAR2 (70), 
Parent_Folder_Name VARCHAR2 (256), 
Parent_Folder_OVID VARCHAR2 (36), 
Oracle_Long_Name VARCHAR2 (2000), 
Oracle_Plural_Name VARCHAR2 (2000), 
Oracle_Short_Name VARCHAR2 (2000), 
Is_Leaf CHAR (1), 
Description VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_MEASURE_FOLDER_MEASURES (
Measure_Folder_ID VARCHAR2 (70) NOT NULL, 
Measure_Folder_Name VARCHAR2 (256) NOT NULL, 
Measure_Folder_OVID VARCHAR2 (36) NOT NULL, 
Measure_ID VARCHAR2 (70) NOT NULL, 
Measure_Name VARCHAR2 (256) NOT NULL, 
Measure_OVID VARCHAR2 (36) NOT NULL, 
Parent_Object_ID VARCHAR2 (70), 
Parent_Object_Name VARCHAR2 (256), 
Parent_Object_OVID VARCHAR2 (36), 
Parent_Object_Type VARCHAR2 (30), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_RAGGED_HIER_LINKS (
Ragged_Hier_Link_ID VARCHAR2 (70) NOT NULL, 
Ragged_Hier_Link_Name VARCHAR2 (256) NOT NULL, 
Ragged_Hier_Link_OVID VARCHAR2 (36) NOT NULL, 
Model_ID VARCHAR2 (70) NOT NULL, 
Model_Name VARCHAR2 (256) NOT NULL, 
Model_OVID VARCHAR2 (36) NOT NULL, 
Parent_Level_ID VARCHAR2 (70), 
Parent_Level_Name VARCHAR2 (256), 
Parent_Level_OVID VARCHAR2 (36), 
Child_Level_ID VARCHAR2 (70), 
Child_Level_Name VARCHAR2 (256), 
Child_Level_OVID VARCHAR2 (36), 
Description VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_RAGGED_HIER_LINK_ATTRS (
Ragged_Hier_Link_ID VARCHAR2 (70) NOT NULL, 
Ragged_Hier_Link_Name VARCHAR2 (256) NOT NULL, 
Ragged_Hier_Link_OVID VARCHAR2 (36) NOT NULL, 
Attribute_ID VARCHAR2 (70) NOT NULL, 
Attribute_Name VARCHAR2 (256) NOT NULL, 
Attribute_OVID VARCHAR2 (36) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_RESOURCE_LOCATORS (
Resource_Locator_ID VARCHAR2 (70) NOT NULL, 
Resource_Locator_OVID VARCHAR2 (36) NOT NULL, 
Resource_Locator_Name VARCHAR2 (256) NOT NULL, 
Business_Info_ID VARCHAR2 (70) NOT NULL, 
Business_Info_OVID VARCHAR2 (36) NOT NULL, 
Business_Info_Name VARCHAR2 (256) NOT NULL, 
Url VARCHAR2 (2000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_RESPONSIBLE_PARTIES (
Responsible_Party_ID VARCHAR2 (70) NOT NULL, 
Responsible_Party_OVID VARCHAR2 (36) NOT NULL, 
Responsible_Party_Name VARCHAR2 (256) NOT NULL, 
Business_Info_ID VARCHAR2 (70) NOT NULL, 
Business_Info_OVID VARCHAR2 (36) NOT NULL, 
Business_Info_Name VARCHAR2 (256) NOT NULL, 
Parent_ID VARCHAR2 (70), 
Parent_OVID VARCHAR2 (36), 
Parent_Name VARCHAR2 (256), 
Responsibility VARCHAR2 (2000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_RES_PARTY_CONTACTS (
Responsible_Party_ID VARCHAR2 (70) NOT NULL, 
Responsible_Party_OVID VARCHAR2 (36) NOT NULL, 
Responsible_Party_Name VARCHAR2 (256) NOT NULL, 
Contact_ID VARCHAR2 (70) NOT NULL, 
Contact_OVID VARCHAR2 (36) NOT NULL, 
Contact_Name VARCHAR2 (256) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_RES_PARTY_ELEMENTS (
Responsible_Party_ID VARCHAR2 (70) NOT NULL, 
Responsible_Party_OVID VARCHAR2 (36) NOT NULL, 
Responsible_Party_Name VARCHAR2 (256) NOT NULL, 
Element_ID VARCHAR2 (70) NOT NULL, 
Element_OVID VARCHAR2 (36) NOT NULL, 
Element_Name VARCHAR2 (256) NOT NULL, 
Element_Type VARCHAR2 (30), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_ROLLUP_LINKS (
Rollup_Link_ID VARCHAR2 (70) NOT NULL, 
Rollup_Link_Name VARCHAR2 (256) NOT NULL, 
Rollup_Link_OVID VARCHAR2 (36) NOT NULL, 
Model_ID VARCHAR2 (70) NOT NULL, 
Model_Name VARCHAR2 (256) NOT NULL, 
Model_OVID VARCHAR2 (36) NOT NULL, 
Parent_Object_ID VARCHAR2 (70), 
Parent_Object_Name VARCHAR2 (256), 
Parent_Object_OVID VARCHAR2 (36), 
Child_Object_ID VARCHAR2 (70), 
Child_Object_Name VARCHAR2 (256), 
Child_Object_OVID VARCHAR2 (36), 
Fact_Entity_ID VARCHAR2 (70), 
Fact_Entity_Name VARCHAR2 (256), 
Fact_Entity_OVID VARCHAR2 (36), 
Parent_Object_Type VARCHAR2 (30), 
Child_Object_Type VARCHAR2 (30), 
Oracle_Long_Name VARCHAR2 (2000), 
Oracle_Plural_Name VARCHAR2 (2000), 
Oracle_Short_Name VARCHAR2 (2000), 
Default_Aggr_Operator VARCHAR2 (256), 
Is_Role_Playing CHAR (1), 
Is_Sparse_Dimension CHAR (1), 
Description VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_ROLLUP_LINK_ATTRS (
Rollup_Link_ID VARCHAR2 (70) NOT NULL, 
Rollup_Link_Name VARCHAR2 (256) NOT NULL, 
Rollup_Link_OVID VARCHAR2 (36) NOT NULL, 
Attribute_ID VARCHAR2 (70) NOT NULL, 
Attribute_Name VARCHAR2 (256) NOT NULL, 
Attribute_OVID VARCHAR2 (36) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_SLICES (
Slice_ID VARCHAR2 (70) NOT NULL, 
Slice_Name VARCHAR2 (256) NOT NULL, 
Slice_OVID VARCHAR2 (36) NOT NULL, 
Model_ID VARCHAR2 (70) NOT NULL, 
Model_Name VARCHAR2 (256) NOT NULL, 
Model_OVID VARCHAR2 (36) NOT NULL, 
Cube_ID VARCHAR2 (70), 
Cube_Name VARCHAR2 (256), 
Cube_OVID VARCHAR2 (36), 
Entity_ID VARCHAR2 (70), 
Entity_Name VARCHAR2 (256), 
Entity_OVID VARCHAR2 (36), 
Oracle_Long_Name VARCHAR2 (2000), 
Oracle_Plural_Name VARCHAR2 (2000), 
Oracle_Short_Name VARCHAR2 (2000), 
Is_Fully_Realized CHAR (1), 
Is_Read_Only CHAR (1), 
Description VARCHAR2 (4000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_SLICE_DIM_HIER_LEVEL (
Slice_ID VARCHAR2 (70) NOT NULL, 
Slice_Name VARCHAR2 (256) NOT NULL, 
Slice_OVID VARCHAR2 (36) NOT NULL, 
Dimension_ID VARCHAR2 (70), 
Dimension_Name VARCHAR2 (256), 
Dimension_OVID VARCHAR2 (36), 
Hierarchy_ID VARCHAR2 (70), 
Hierarchy_Name VARCHAR2 (256), 
Hierarchy_OVID VARCHAR2 (36), 
Level_ID VARCHAR2 (70), 
Level_Name VARCHAR2 (256), 
Level_OVID VARCHAR2 (36), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_SLICE_MEASURES (
Slice_ID VARCHAR2 (70) NOT NULL, 
Slice_Name VARCHAR2 (256) NOT NULL, 
Slice_OVID VARCHAR2 (36) NOT NULL, 
Measure_ID VARCHAR2 (70) NOT NULL, 
Measure_Name VARCHAR2 (256) NOT NULL, 
Measure_OVID VARCHAR2 (36) NOT NULL, 
Aggregate_Function_ID VARCHAR2 (70) NOT NULL, 
Aggregate_Function_Name VARCHAR2 (256) NOT NULL, 
Aggregate_Function_OVID VARCHAR2 (36) NOT NULL, 
Measure_Alias VARCHAR2 (256), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_SOURCE_INFO (
Source_Info_OVID VARCHAR2 (36) NOT NULL, 
Source_Info_Type CHAR (1) NOT NULL, 
DDL_File_Name VARCHAR2 (256), 
DDL_Path_Name VARCHAR2 (2000), 
DDL_DB_Type VARCHAR2 (30), 
DataDict_Connection_Name VARCHAR2 (256), 
DataDict_Connection_Url VARCHAR2 (2000), 
DataDict_DB_Type VARCHAR2 (30), 
Model_ID VARCHAR2 (70) NOT NULL, 
Model_OVID VARCHAR2 (36) NOT NULL, 
Model_Name VARCHAR2 (256) NOT NULL, 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_TELEPHONES (
Telephone_ID VARCHAR2 (70) NOT NULL, 
Telephone_OVID VARCHAR2 (36) NOT NULL, 
Telephone_Name VARCHAR2 (256) NOT NULL, 
Business_Info_ID VARCHAR2 (70) NOT NULL, 
Business_Info_OVID VARCHAR2 (36) NOT NULL, 
Business_Info_Name VARCHAR2 (256) NOT NULL, 
Phone_Number VARCHAR2 (1000), 
Phone_Type VARCHAR2 (1000), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_MEASUREMENTS (
Design_ID VARCHAR2 (70) NOT NULL,
Design_OVID VARCHAR2 (36) NOT NULL,
Design_Name VARCHAR2 (256) NOT NULL,
Model_OVID VARCHAR2 (36) NOT NULL,
Model_Name VARCHAR2 (256) NOT NULL,
Measurement_ID VARCHAR2 (70) NOT NULL,
Measurement_OVID VARCHAR2 (36) NOT NULL,
Measurement_Name VARCHAR2 (256) NOT NULL,
Measurement_Value NUMBER,
Measurement_Unit VARCHAR2 (36),
Measurement_Type VARCHAR2 (36),
Measurement_CR_Date VARCHAR2 (30),
Measurement_EF_Date VARCHAR2 (30),
Object_Name VARCHAR2 (256),
Object_Type VARCHAR2 (256),
Object_Model  VARCHAR2 (256));

CREATE TABLE DMRS_SCHEMA_OBJECT (
Object_ID VARCHAR2 (70) NOT NULL,
Schema_OVID VARCHAR2 (36) NOT NULL,
Schema_Name VARCHAR2 (256) NOT NULL);

CREATE TABLE DMRS_DYNAMIC_PROPERTIES (
Object_OVID VARCHAR2 (36) NOT NULL,
Object_ID VARCHAR2 (70) NOT NULL,
Object_Name VARCHAR2 (100) NOT NULL,
Object_Type VARCHAR2 (100) NOT NULL,
Name VARCHAR2 (256),
Value VARCHAR2 (256));

--==========ALTER TABLES==========

ALTER TABLE DMRS_STRUCTURED_TYPES ADD (
Model_OVID VARCHAR2 (36),
Model_Name VARCHAR2 (256));
UPDATE DMRS_STRUCTURED_TYPES s SET s.model_ovid =(SELECT m.model_ovid FROM dmrs_models m WHERE m.design_ovid = s.design_ovid AND m.model_name='DataTypes');
UPDATE DMRS_STRUCTURED_TYPES s SET s.model_name = (SELECT m.model_name FROM dmrs_models m WHERE m.design_ovid = s.design_ovid AND m.model_name='DataTypes');
ALTER TABLE DMRS_STRUCTURED_TYPES MODIFY (Model_OVID NOT NULL, Model_Name NOT NULL);

ALTER TABLE DMRS_DISTINCT_TYPES ADD (
Model_OVID VARCHAR2 (36),
Model_Name VARCHAR2 (256));
UPDATE DMRS_DISTINCT_TYPES s SET s.model_ovid =(SELECT m.model_ovid FROM dmrs_models m WHERE m.design_ovid = s.design_ovid AND m.model_name='DataTypes');
UPDATE DMRS_DISTINCT_TYPES s SET s.model_name = (SELECT m.model_name FROM dmrs_models m WHERE m.design_ovid = s.design_ovid AND m.model_name='DataTypes');
ALTER TABLE DMRS_DISTINCT_TYPES MODIFY (Model_OVID NOT NULL, Model_Name NOT NULL);

ALTER TABLE DMRS_COLLECTION_TYPES ADD ( 
Model_OVID VARCHAR2 (36),
Model_Name VARCHAR2 (256),
Char_Units CHAR (4),
T_Size NUMBER,
T_Precision NUMBER,
T_Scale NUMBER,
DataType_Kind VARCHAR2 (20),
Domain_Name VARCHAR2 (256));
UPDATE DMRS_COLLECTION_TYPES s SET s.model_ovid =(SELECT m.model_ovid FROM dmrs_models m WHERE m.design_ovid = s.design_ovid AND m.model_name='DataTypes');
UPDATE DMRS_COLLECTION_TYPES s SET s.model_name = (SELECT m.model_name FROM dmrs_models m WHERE m.design_ovid = s.design_ovid AND m.model_name='DataTypes');
ALTER TABLE DMRS_COLLECTION_TYPES MODIFY (Model_OVID NOT NULL, Model_Name NOT NULL);
      
ALTER TABLE DMRS_STRUCT_TYPE_ATTRS ADD (
Char_Units CHAR (4),
DataType_Kind VARCHAR2 (20),
Domain_Name VARCHAR2 (256));

ALTER TABLE DMRS_STRUCT_TYPE_METHODS
ADD (Overriding CHAR (1));

ALTER TABLE DMRS_CHANGE_REQUEST_ELEMENTS ADD (
Element_Model_Name VARCHAR2 (256));

ALTER TABLE DMRS_INDEXES ADD (
Schema_OVID VARCHAR2 (36),
Schema_Name VARCHAR2 (256));

ALTER TABLE DMRS_TABLES ADD (
Schema_OVID VARCHAR2 (36),
Schema_Name VARCHAR2 (256),
Source_Info_OVID VARCHAR2 (36),
Source_DataDict_Schema_Name VARCHAR2 (256),
Source_DataDict_Object_Name VARCHAR2 (256));

ALTER TABLE DMRS_TABLEVIEWS ADD (
Schema_OVID VARCHAR2 (36),
Schema_Name VARCHAR2 (256));

ALTER TABLE DMRS_ENTITIES MODIFY (
Min_Volume NUMBER,
Expected_Volume NUMBER,
Max_Volume NUMBER);

ALTER TABLE DMRS_TABLES MODIFY (
Min_Volume NUMBER,
Expected_Volume NUMBER,
Max_Volume NUMBER);

ALTER TABLE DMRS_MEASUREMENTS ADD (Temp_C VARCHAR2(50));
UPDATE DMRS_MEASUREMENTS SET Temp_C = Measurement_Value;
ALTER TABLE DMRS_MEASUREMENTS DROP COLUMN Measurement_Value;
ALTER TABLE DMRS_MEASUREMENTS ADD (Measurement_Value VARCHAR2(50));
UPDATE DMRS_MEASUREMENTS SET Measurement_Value = Temp_C;
ALTER TABLE DMRS_MEASUREMENTS DROP COLUMN Temp_C;

ALTER TABLE DMRS_SCHEMA_OBJECT ADD (Design_Ovid VARCHAR2 (36));
UPDATE Dmrs_Schema_Object s SET s.Design_Ovid = (SELECT DISTINCT(t.Design_Ovid) FROM Dmrs_Tables t WHERE t.Schema_Ovid = s.Schema_Ovid);
ALTER TABLE Dmrs_Schema_Object MODIFY Design_Ovid NOT NULL;

ALTER TABLE Dmrs_Processes MODIFY Parameters_Wrappers_String VARCHAR2(4000);

INSERT INTO DMRS_Large_Text (Object_ID, OVID, Object_Name, Type, Text, Design_OVID) SELECT Method_ID, Method_Ovid, Method_Name, 'ST Method Body', NVL(Body,' '), Design_Ovid FROM DMRS_STRUCT_TYPE_METHODS;
ALTER TABLE DMRS_STRUCT_TYPE_METHODS DROP COLUMN body;

ALTER TABLE DMRS_COLUMNS ADD (Temp_C VARCHAR2(20));
UPDATE DMRS_COLUMNS SET Temp_C = T_Size;
ALTER TABLE DMRS_COLUMNS DROP COLUMN T_Size;
ALTER TABLE DMRS_COLUMNS ADD (T_Size VARCHAR2(20));
UPDATE DMRS_COLUMNS SET T_Size = Temp_C;
ALTER TABLE DMRS_COLUMNS DROP COLUMN Temp_C;

ALTER TABLE DMRS_ATTRIBUTES ADD (Temp_C VARCHAR2(20));
UPDATE DMRS_ATTRIBUTES SET Temp_C = T_Size;
ALTER TABLE DMRS_ATTRIBUTES DROP COLUMN T_Size;
ALTER TABLE DMRS_ATTRIBUTES ADD (T_Size VARCHAR2(20));
UPDATE DMRS_ATTRIBUTES SET T_Size = Temp_C;
ALTER TABLE DMRS_ATTRIBUTES DROP COLUMN Temp_C;

ALTER TABLE DMRS_STRUCT_TYPE_METHOD_PARS ADD (Temp_C VARCHAR2(20));
UPDATE DMRS_STRUCT_TYPE_METHOD_PARS SET Temp_C = T_Size;
ALTER TABLE DMRS_STRUCT_TYPE_METHOD_PARS DROP COLUMN T_Size;
ALTER TABLE DMRS_STRUCT_TYPE_METHOD_PARS ADD (T_Size VARCHAR2(20));
UPDATE DMRS_STRUCT_TYPE_METHOD_PARS SET T_Size = Temp_C;
ALTER TABLE DMRS_STRUCT_TYPE_METHOD_PARS DROP COLUMN Temp_C;

ALTER TABLE DMRS_STRUCT_TYPE_ATTRS ADD (Temp_C VARCHAR2(20));
UPDATE DMRS_STRUCT_TYPE_ATTRS SET Temp_C = T_Size;
ALTER TABLE DMRS_STRUCT_TYPE_ATTRS DROP COLUMN T_Size;
ALTER TABLE DMRS_STRUCT_TYPE_ATTRS ADD (T_Size VARCHAR2(20));
UPDATE DMRS_STRUCT_TYPE_ATTRS SET T_Size = Temp_C;
ALTER TABLE DMRS_STRUCT_TYPE_ATTRS DROP COLUMN Temp_C;

ALTER TABLE DMRS_COLLECTION_TYPES ADD (Temp_C VARCHAR2(20));
UPDATE DMRS_COLLECTION_TYPES SET Temp_C = T_Size;
ALTER TABLE DMRS_COLLECTION_TYPES DROP COLUMN T_Size;
ALTER TABLE DMRS_COLLECTION_TYPES ADD (T_Size VARCHAR2(20));
UPDATE DMRS_COLLECTION_TYPES SET T_Size = Temp_C;
ALTER TABLE DMRS_COLLECTION_TYPES DROP COLUMN Temp_C;

ALTER TABLE DMRS_DISTINCT_TYPES ADD (Temp_C VARCHAR2(20));
UPDATE DMRS_DISTINCT_TYPES SET Temp_C = T_Size;
ALTER TABLE DMRS_DISTINCT_TYPES DROP COLUMN T_Size;
ALTER TABLE DMRS_DISTINCT_TYPES ADD (T_Size VARCHAR2(20));
UPDATE DMRS_DISTINCT_TYPES SET T_Size = Temp_C;
ALTER TABLE DMRS_DISTINCT_TYPES DROP COLUMN Temp_C;

--==========CREATE VIEWS==========
CREATE VIEW DMRV_AGGR_FUNC_DIMENSIONS 
(Aggregate_Function_ID, Aggregate_Function_Name, Aggregate_Function_OVID, Dimension_ID, Dimension_Name, Dimension_OVID, Design_OVID) AS select 
 Aggregate_Function_ID, Aggregate_Function_Name, Aggregate_Function_OVID, Dimension_ID, Dimension_Name, Dimension_OVID, Design_OVID from DMRS_AGGR_FUNC_DIMENSIONS;

CREATE VIEW DMRV_AGGR_FUNC_LEVELS 
(Aggregate_Function_ID, Aggregate_Function_Name, Aggregate_Function_OVID, Level_ID, Level_Name, Level_OVID, Design_OVID) AS select 
 Aggregate_Function_ID, Aggregate_Function_Name, Aggregate_Function_OVID, Level_ID, Level_Name, Level_OVID, Design_OVID from DMRS_AGGR_FUNC_LEVELS;

CREATE VIEW DMRV_BUSINESS_INFO 
(Design_ID, Design_OVID, Design_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name) AS select 
 Design_ID, Design_OVID, Design_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name from DMRS_BUSINESS_INFO;

CREATE VIEW DMRV_CHANGE_REQUESTS 
(Design_ID, Design_OVID, Design_Name, Change_Request_ID, Change_Request_OVID, Change_Request_Name, Request_Status, Request_Date_String, Completion_Date_String, Is_Completed, Reason) AS select 
 Design_ID, Design_OVID, Design_Name, Change_Request_ID, Change_Request_OVID, Change_Request_Name, Request_Status, Request_Date_String, Completion_Date_String, Is_Completed, Reason from DMRS_CHANGE_REQUESTS;

CREATE VIEW DMRV_CHANGE_REQUEST_ELEMENTS 
(Change_Request_ID, Change_Request_OVID, Change_Request_Name, Element_ID, Element_OVID, Element_Name, Element_Type, Design_OVID) AS select 
 Change_Request_ID, Change_Request_OVID, Change_Request_Name, Element_ID, Element_OVID, Element_Name, Element_Type, Design_OVID from DMRS_CHANGE_REQUEST_ELEMENTS;

CREATE VIEW DMRV_CONTACTS 
(Contact_ID, Contact_OVID, Contact_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, Design_OVID) AS select 
 Contact_ID, Contact_OVID, Contact_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, Design_OVID from DMRS_CONTACTS;

CREATE VIEW DMRV_CONTACT_EMAILS 
(Contact_ID, Contact_OVID, Contact_Name, Email_ID, Email_OVID, Email_Name, Design_OVID) AS select 
 Contact_ID, Contact_OVID, Contact_Name, Email_ID, Email_OVID, Email_Name, Design_OVID from DMRS_CONTACT_EMAILS;

CREATE VIEW DMRV_CONTACT_LOCATIONS 
(Contact_ID, Contact_OVID, Contact_Name, Location_ID, Location_OVID, Location_Name, Design_OVID) AS select 
 Contact_ID, Contact_OVID, Contact_Name, Location_ID, Location_OVID, Location_Name, Design_OVID from DMRS_CONTACT_LOCATIONS;

CREATE VIEW DMRV_CONTACT_RES_LOCATORS 
(Contact_ID, Contact_OVID, Contact_Name, Resource_Locator_ID, Resource_Locator_OVID, Resource_Locator_Name, Design_OVID) AS select 
 Contact_ID, Contact_OVID, Contact_Name, Resource_Locator_ID, Resource_Locator_OVID, Resource_Locator_Name, Design_OVID from DMRS_CONTACT_RES_LOCATORS;

CREATE VIEW DMRV_CONTACT_TELEPHONES 
(Contact_ID, Contact_OVID, Contact_Name, Telephone_ID, Telephone_OVID, Telephone_Name, Design_OVID) AS select 
 Contact_ID, Contact_OVID, Contact_Name, Telephone_ID, Telephone_OVID, Telephone_Name, Design_OVID from DMRS_CONTACT_TELEPHONES;

CREATE VIEW DMRV_CUBES 
(Cube_ID, Cube_Name, Cube_OVID, Model_ID, Model_Name, Model_OVID, Part_Dimension_ID, Part_Dimension_Name, Part_Dimension_OVID, Part_Hierarchy_ID, Part_Hierarchy_Name, Part_Hierarchy_OVID, 
Part_Level_ID, Part_Level_Name, Part_Level_OVID, Full_Cube_Slice_ID, Full_Cube_Slice_Name, Full_Cube_Slice_OVID, Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, 
Is_Compressed_Composites, Is_Global_Composites, Is_Partitioned, Is_Virtual, Part_Description, Description, Design_OVID) AS select 
 Cube_ID, Cube_Name, Cube_OVID, Model_ID, Model_Name, Model_OVID, Part_Dimension_ID, Part_Dimension_Name, Part_Dimension_OVID, Part_Hierarchy_ID, Part_Hierarchy_Name, Part_Hierarchy_OVID, 
Part_Level_ID, Part_Level_Name, Part_Level_OVID, Full_Cube_Slice_ID, Full_Cube_Slice_Name, Full_Cube_Slice_OVID, Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, 
Is_Compressed_Composites, Is_Global_Composites, Is_Partitioned, Is_Virtual, Part_Description, Description, Design_OVID from DMRS_CUBES;

CREATE VIEW DMRV_CUBE_DIMENSIONS 
(Cube_ID, Cube_Name, Cube_OVID, Dimension_ID, Dimension_Name, Dimension_OVID, Design_OVID) AS select 
 Cube_ID, Cube_Name, Cube_OVID, Dimension_ID, Dimension_Name, Dimension_OVID, Design_OVID from DMRS_CUBE_DIMENSIONS;

CREATE VIEW DMRV_DIMENSIONS 
(Dimension_ID, Dimension_Name, Dimension_OVID, Model_ID, Model_Name, Model_OVID, Base_Entity_ID, Base_Entity_Name, Base_Entity_OVID, 
Base_Level_ID, Base_Level_Name, Base_Level_OVID, Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Description, Design_OVID) AS select 
 Dimension_ID, Dimension_Name, Dimension_OVID, Model_ID, Model_Name, Model_OVID, Base_Entity_ID, Base_Entity_Name, Base_Entity_OVID, 
Base_Level_ID, Base_Level_Name, Base_Level_OVID, Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Description, Design_OVID from DMRS_DIMENSIONS;

CREATE VIEW DMRV_DIMENSION_CALC_ATTRS 
(Dimension_ID, Dimension_Name, Dimension_OVID, Calc_Attribute_ID, Calc_Attribute_Name, Calc_Attribute_OVID, Calculated_Expr, Design_OVID) AS select 
 Dimension_ID, Dimension_Name, Dimension_OVID, Calc_Attribute_ID, Calc_Attribute_Name, Calc_Attribute_OVID, Calculated_Expr, Design_OVID from DMRS_DIMENSION_CALC_ATTRS;

CREATE VIEW DMRV_DIMENSION_LEVELS 
(Dimension_ID, Dimension_Name, Dimension_OVID, Level_ID, Level_Name, Level_OVID, Design_OVID) AS select 
 Dimension_ID, Dimension_Name, Dimension_OVID, Level_ID, Level_Name, Level_OVID, Design_OVID from DMRS_DIMENSION_LEVELS;

CREATE VIEW DMRV_DOCUMENTS 
(Document_ID, Document_OVID, Document_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, Parent_ID, Parent_OVID, Parent_Name, Doc_Reference, Doc_Type, Design_OVID) AS select 
 Document_ID, Document_OVID, Document_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, Parent_ID, Parent_OVID, Parent_Name, Doc_Reference, Doc_Type, Design_OVID from DMRS_DOCUMENTS;

CREATE VIEW DMRV_DOCUMENT_ELEMENTS 
(Document_ID, Document_OVID, Document_Name, Element_ID, Element_OVID, Element_Name, Element_Type, Design_OVID) AS select 
 Document_ID, Document_OVID, Document_Name, Element_ID, Element_OVID, Element_Name, Element_Type, Design_OVID from DMRS_DOCUMENT_ELEMENTS;

CREATE VIEW DMRV_EMAILS 
(Email_ID, Email_OVID, Email_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, Email_Address, Email_Type, Design_OVID) AS select 
 Email_ID, Email_OVID, Email_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, Email_Address, Email_Type, Design_OVID from DMRS_EMAILS;

CREATE VIEW DMRV_FACT_ENTITIES 
(Cube_ID, Cube_Name, Cube_OVID, Entity_ID, Entity_Name, Entity_OVID, Design_OVID) AS select 
 Cube_ID, Cube_Name, Cube_OVID, Entity_ID, Entity_Name, Entity_OVID, Design_OVID from DMRS_FACT_ENTITIES;

CREATE VIEW DMRV_FACT_ENTITIES_JOINS 
(Join_ID, Join_Name, Join_OVID, Cube_ID, Cube_Name, Cube_OVID, Left_Entity_ID, Left_Entity_Name, Left_Entity_OVID, Right_Entity_ID, Right_Entity_Name, Right_Entity_OVID, Design_OVID) AS select 
 Join_ID, Join_Name, Join_OVID, Cube_ID, Cube_Name, Cube_OVID, Left_Entity_ID, Left_Entity_Name, Left_Entity_OVID, Right_Entity_ID, Right_Entity_Name, Right_Entity_OVID, Design_OVID from DMRS_FACT_ENTITIES_JOINS;

CREATE VIEW DMRV_HIERARCHIES 
(Hierarchy_ID, Hierarchy_Name, Hierarchy_OVID, Model_ID, Model_Name, Model_OVID, Dimension_ID, Dimension_Name, Dimension_OVID, 
Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Is_Default_Hierarchy, Is_Ragged_Hierarchy, Is_Value_Based_Hierarchy, Description, Design_OVID) AS select 
 Hierarchy_ID, Hierarchy_Name, Hierarchy_OVID, Model_ID, Model_Name, Model_OVID, Dimension_ID, Dimension_Name, Dimension_OVID, 
Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Is_Default_Hierarchy, Is_Ragged_Hierarchy, Is_Value_Based_Hierarchy, Description, Design_OVID from DMRS_HIERARCHIES;

CREATE VIEW DMRV_HIERARCHY_LEVELS 
(Hierarchy_ID, Hierarchy_Name, Hierarchy_OVID, Level_ID, Level_Name, Level_OVID, Design_OVID) AS select 
 Hierarchy_ID, Hierarchy_Name, Hierarchy_OVID, Level_ID, Level_Name, Level_OVID, Design_OVID from DMRS_HIERARCHY_LEVELS;

CREATE VIEW DMRV_HIERARCHY_ROLLUP_LINKS 
(Hierarchy_ID, Hierarchy_Name, Hierarchy_OVID, Rollup_Link_ID, Rollup_Link_Name, Rollup_Link_OVID, Design_OVID) AS select 
 Hierarchy_ID, Hierarchy_Name, Hierarchy_OVID, Rollup_Link_ID, Rollup_Link_Name, Rollup_Link_OVID, Design_OVID from DMRS_HIERARCHY_ROLLUP_LINKS;

CREATE VIEW DMRV_LEVELS 
(Level_ID, Level_Name, Level_OVID, Model_ID, Model_Name, Model_OVID, Entity_ID, Entity_Name, Entity_OVID, Name_Column_ID, Name_Column_Name, Name_Column_OVID, 
Value_Column_ID, Value_Column_Name, Value_Column_OVID, Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Root_Identification, Identification_Value, 
Selection_Criteria, Selection_Criteria_Description, Is_Value_Based_Hierarchy, Description, Design_OVID) AS select 
 Level_ID, Level_Name, Level_OVID, Model_ID, Model_Name, Model_OVID, Entity_ID, Entity_Name, Entity_OVID, Name_Column_ID, Name_Column_Name, Name_Column_OVID, 
Value_Column_ID, Value_Column_Name, Value_Column_OVID, Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Root_Identification, Identification_Value, 
Selection_Criteria, Selection_Criteria_Description, Is_Value_Based_Hierarchy, Description, Design_OVID from DMRS_LEVELS;

CREATE VIEW DMRV_LEVEL_ATTRS 
(Level_ID, Level_Name, Level_OVID, Attribute_ID, Attribute_Name, Attribute_OVID, Is_Default_Attr, Is_Level_Key_Attr, Is_Parent_Key_Attr, Is_Descriptive_Key_Attr, 
Is_Calculated_Attr, Descriptive_Name, Descriptive_Is_Indexed, Descriptive_Slow_Changing, Calculated_Expr, Design_OVID) AS select 
 Level_ID, Level_Name, Level_OVID, Attribute_ID, Attribute_Name, Attribute_OVID, Is_Default_Attr, Is_Level_Key_Attr, Is_Parent_Key_Attr, Is_Descriptive_Key_Attr, 
Is_Calculated_Attr, Descriptive_Name, Descriptive_Is_Indexed, Descriptive_Slow_Changing, Calculated_Expr, Design_OVID from DMRS_LEVEL_ATTRS;

CREATE VIEW DMRV_LOCATIONS 
(Location_ID, Location_OVID, Location_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, 
Loc_Address, Loc_City, Loc_Post_Code, Loc_Area, Loc_Country, Loc_Type, Design_OVID) AS select 
 Location_ID, Location_OVID, Location_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, 
Loc_Address, Loc_City, Loc_Post_Code, Loc_Area, Loc_Country, Loc_Type, Design_OVID from DMRS_LOCATIONS;

CREATE VIEW DMRV_MAPPING_TARGETS 
(Object_ID, Object_OVID, Object_Name, Target_ID, Target_OVID, Target_Name, 
Object_Type, Target_Type, Transformation_Type, Description, Design_OVID) AS select 
 Object_ID, Object_OVID, Object_Name, Target_ID, Target_OVID, Target_Name, 
Object_Type, Target_Type, Transformation_Type, Description, Design_OVID from DMRS_MAPPING_TARGETS;

CREATE VIEW DMRV_MAPPING_TARGET_SOURCES 
(Object_ID, Object_OVID, Object_Name, Target_ID, Target_OVID, Target_Name, 
Source_ID, Source_OVID, Source_Name, Object_Type, Target_Type, Source_Type, Design_OVID) AS select 
 Object_ID, Object_OVID, Object_Name, Target_ID, Target_OVID, Target_Name, 
Source_ID, Source_OVID, Source_Name, Object_Type, Target_Type, Source_Type, Design_OVID from DMRS_MAPPING_TARGET_SOURCES;

CREATE VIEW DMRV_MEASURES 
(Measure_ID, Measure_Name, Measure_OVID, Model_ID, Model_Name, Model_OVID, Cube_ID, Cube_Name, Cube_OVID, Fact_Object_ID, Fact_Object_Name, Fact_Object_OVID, 
Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Fact_Object_Type, Additivity_Type, Is_Fact_Dimension, Is_Formula, Is_Custom_Formula, Formula, Where_Clause, Description, Design_OVID) AS select 
 Measure_ID, Measure_Name, Measure_OVID, Model_ID, Model_Name, Model_OVID, Cube_ID, Cube_Name, Cube_OVID, Fact_Object_ID, Fact_Object_Name, Fact_Object_OVID, 
Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Fact_Object_Type, Additivity_Type, Is_Fact_Dimension, Is_Formula, Is_Custom_Formula, Formula, Where_Clause, Description, Design_OVID from DMRS_MEASURES;

CREATE VIEW DMRV_MEASURE_AGGR_FUNCS 
(Measure_ID, Measure_Name, Measure_OVID, Aggregate_Function_ID, Aggregate_Function_Name, Aggregate_Function_OVID, Measure_Alias, Is_Default, Design_OVID) AS select 
 Measure_ID, Measure_Name, Measure_OVID, Aggregate_Function_ID, Aggregate_Function_Name, Aggregate_Function_OVID, Measure_Alias, Is_Default, Design_OVID from DMRS_MEASURE_AGGR_FUNCS;

CREATE VIEW DMRV_MEASURE_FOLDERS 
(Measure_Folder_ID, Measure_Folder_Name, Measure_Folder_OVID, Model_ID, Model_Name, Model_OVID, Parent_Folder_ID, Parent_Folder_Name, Parent_Folder_OVID, 
Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Is_Leaf, Description, Design_OVID) AS select 
 Measure_Folder_ID, Measure_Folder_Name, Measure_Folder_OVID, Model_ID, Model_Name, Model_OVID, Parent_Folder_ID, Parent_Folder_Name, Parent_Folder_OVID, 
Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Is_Leaf, Description, Design_OVID from DMRS_MEASURE_FOLDERS;

CREATE VIEW DMRV_MEASURE_FOLDER_MEASURES 
(Measure_Folder_ID, Measure_Folder_Name, Measure_Folder_OVID, Measure_ID, Measure_Name, Measure_OVID, Parent_Object_ID, Parent_Object_Name, Parent_Object_OVID, Parent_Object_Type, Design_OVID) AS select 
 Measure_Folder_ID, Measure_Folder_Name, Measure_Folder_OVID, Measure_ID, Measure_Name, Measure_OVID, Parent_Object_ID, Parent_Object_Name, Parent_Object_OVID, Parent_Object_Type, Design_OVID from DMRS_MEASURE_FOLDER_MEASURES;

CREATE VIEW DMRV_RAGGED_HIER_LINKS 
(Ragged_Hier_Link_ID, Ragged_Hier_Link_Name, Ragged_Hier_Link_OVID, Model_ID, Model_Name, Model_OVID, Parent_Level_ID, Parent_Level_Name, Parent_Level_OVID, Child_Level_ID, Child_Level_Name, Child_Level_OVID, Description, Design_OVID) AS select 
 Ragged_Hier_Link_ID, Ragged_Hier_Link_Name, Ragged_Hier_Link_OVID, Model_ID, Model_Name, Model_OVID, Parent_Level_ID, Parent_Level_Name, Parent_Level_OVID, Child_Level_ID, Child_Level_Name, Child_Level_OVID, Description, Design_OVID from DMRS_RAGGED_HIER_LINKS;

CREATE VIEW DMRV_RAGGED_HIER_LINK_ATTRS 
(Ragged_Hier_Link_ID, Ragged_Hier_Link_Name, Ragged_Hier_Link_OVID, Attribute_ID, Attribute_Name, Attribute_OVID, Design_OVID) AS select 
 Ragged_Hier_Link_ID, Ragged_Hier_Link_Name, Ragged_Hier_Link_OVID, Attribute_ID, Attribute_Name, Attribute_OVID, Design_OVID from DMRS_RAGGED_HIER_LINK_ATTRS;

CREATE VIEW DMRV_RESOURCE_LOCATORS 
(Resource_Locator_ID, Resource_Locator_OVID, Resource_Locator_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, Url, Design_OVID) AS select 
 Resource_Locator_ID, Resource_Locator_OVID, Resource_Locator_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, Url, Design_OVID from DMRS_RESOURCE_LOCATORS;

CREATE VIEW DMRV_RESPONSIBLE_PARTIES 
(Responsible_Party_ID, Responsible_Party_OVID, Responsible_Party_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, Parent_ID, Parent_OVID, Parent_Name, Responsibility, Design_OVID) AS select 
 Responsible_Party_ID, Responsible_Party_OVID, Responsible_Party_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, Parent_ID, Parent_OVID, Parent_Name, Responsibility, Design_OVID from DMRS_RESPONSIBLE_PARTIES;

CREATE VIEW DMRV_RES_PARTY_CONTACTS 
(Responsible_Party_ID, Responsible_Party_OVID, Responsible_Party_Name, Contact_ID, Contact_OVID, Contact_Name, Design_OVID) AS select 
 Responsible_Party_ID, Responsible_Party_OVID, Responsible_Party_Name, Contact_ID, Contact_OVID, Contact_Name, Design_OVID from DMRS_RES_PARTY_CONTACTS;

CREATE VIEW DMRV_RES_PARTY_ELEMENTS 
(Responsible_Party_ID, Responsible_Party_OVID, Responsible_Party_Name, Element_ID, Element_OVID, Element_Name, Element_Type, Design_OVID) AS select 
 Responsible_Party_ID, Responsible_Party_OVID, Responsible_Party_Name, Element_ID, Element_OVID, Element_Name, Element_Type, Design_OVID from DMRS_RES_PARTY_ELEMENTS;

CREATE VIEW DMRV_ROLLUP_LINKS 
(Rollup_Link_ID, Rollup_Link_Name, Rollup_Link_OVID, Model_ID, Model_Name, Model_OVID, Parent_Object_ID, Parent_Object_Name, Parent_Object_OVID, Child_Object_ID, Child_Object_Name, Child_Object_OVID, Fact_Entity_ID, Fact_Entity_Name, Fact_Entity_OVID, 
Parent_Object_Type, Child_Object_Type, Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Default_Aggr_Operator, Is_Role_Playing, Is_Sparse_Dimension, Description, Design_OVID) AS select 
 Rollup_Link_ID, Rollup_Link_Name, Rollup_Link_OVID, Model_ID, Model_Name, Model_OVID, Parent_Object_ID, Parent_Object_Name, Parent_Object_OVID, Child_Object_ID, Child_Object_Name, Child_Object_OVID, Fact_Entity_ID, Fact_Entity_Name, Fact_Entity_OVID, 
Parent_Object_Type, Child_Object_Type, Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Default_Aggr_Operator, Is_Role_Playing, Is_Sparse_Dimension, Description, Design_OVID from DMRS_ROLLUP_LINKS;

CREATE VIEW DMRV_ROLLUP_LINK_ATTRS 
(Rollup_Link_ID, Rollup_Link_Name, Rollup_Link_OVID, Attribute_ID, Attribute_Name, Attribute_OVID, Design_OVID) AS select 
 Rollup_Link_ID, Rollup_Link_Name, Rollup_Link_OVID, Attribute_ID, Attribute_Name, Attribute_OVID, Design_OVID from DMRS_ROLLUP_LINK_ATTRS;

CREATE VIEW DMRV_SLICES 
(Slice_ID, Slice_Name, Slice_OVID, Model_ID, Model_Name, Model_OVID, Cube_ID, Cube_Name, Cube_OVID, Entity_ID, Entity_Name, Entity_OVID, Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Is_Fully_Realized, Is_Read_Only, Description, Design_OVID) AS select 
 Slice_ID, Slice_Name, Slice_OVID, Model_ID, Model_Name, Model_OVID, Cube_ID, Cube_Name, Cube_OVID, Entity_ID, Entity_Name, Entity_OVID, Oracle_Long_Name, Oracle_Plural_Name, Oracle_Short_Name, Is_Fully_Realized, Is_Read_Only, Description, Design_OVID from DMRS_SLICES;

CREATE VIEW DMRV_SLICE_DIM_HIER_LEVEL 
(Slice_ID, Slice_Name, Slice_OVID, Dimension_ID, Dimension_Name, Dimension_OVID, Hierarchy_ID, Hierarchy_Name, Hierarchy_OVID, Level_ID, Level_Name, Level_OVID, Design_OVID) AS select 
 Slice_ID, Slice_Name, Slice_OVID, Dimension_ID, Dimension_Name, Dimension_OVID, Hierarchy_ID, Hierarchy_Name, Hierarchy_OVID, Level_ID, Level_Name, Level_OVID, Design_OVID from DMRS_SLICE_DIM_HIER_LEVEL;

CREATE VIEW DMRV_SLICE_MEASURES 
(Slice_ID, Slice_Name, Slice_OVID, Measure_ID, Measure_Name, Measure_OVID, Aggregate_Function_ID, Aggregate_Function_Name, Aggregate_Function_OVID, Measure_Alias, Design_OVID) AS select 
 Slice_ID, Slice_Name, Slice_OVID, Measure_ID, Measure_Name, Measure_OVID, Aggregate_Function_ID, Aggregate_Function_Name, Aggregate_Function_OVID, Measure_Alias, Design_OVID from DMRS_SLICE_MEASURES;

CREATE VIEW DMRV_SOURCE_INFO 
(Source_Info_OVID, Source_Info_Type, DDL_File_Name, DDL_Path_Name, DDL_DB_Type, DataDict_Connection_Name, DataDict_Connection_Url, DataDict_DB_Type, Model_ID, Model_OVID, Model_Name, Design_OVID) AS select 
 Source_Info_OVID, Source_Info_Type, DDL_File_Name, DDL_Path_Name, DDL_DB_Type, DataDict_Connection_Name, DataDict_Connection_Url, DataDict_DB_Type, Model_ID, Model_OVID, Model_Name, Design_OVID from DMRS_SOURCE_INFO;

CREATE VIEW DMRV_TELEPHONES 
(Telephone_ID, Telephone_OVID, Telephone_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, Phone_Number, Phone_Type, Design_OVID) AS select 
 Telephone_ID, Telephone_OVID, Telephone_Name, Business_Info_ID, Business_Info_OVID, Business_Info_Name, Phone_Number, Phone_Type, Design_OVID from DMRS_TELEPHONES;

--==========CREATE INDEXES==========
CREATE INDEX AGGR_FUNC_DIMENSIONS_FK_IDX ON DMRS_AGGR_FUNC_DIMENSIONS (AGGREGATE_FUNCTION_OVID ASC) NOLOGGING;
CREATE INDEX AGGR_FUNC_DIMENSIONS_DES_IDX ON DMRS_AGGR_FUNC_DIMENSIONS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX AGGR_FUNC_LEVELS_FK_IDX ON DMRS_AGGR_FUNC_LEVELS (AGGREGATE_FUNCTION_OVID ASC) NOLOGGING;
CREATE INDEX AGGR_FUNC_LEVELS_DES_IDX ON DMRS_AGGR_FUNC_LEVELS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX MODEL_SUBVIEWS_PK_IDX ON DMRS_MODEL_SUBVIEWS (SUBVIEW_OVID ASC) NOLOGGING;
CREATE INDEX MODEL_SUBVIEWS_DES_IDX ON DMRS_MODEL_SUBVIEWS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX MODEL_DISPLAYS_PK_IDX ON DMRS_MODEL_DISPLAYS (DISPLAY_OVID ASC) NOLOGGING;
CREATE INDEX MODEL_DISPLAYS_DES_IDX ON DMRS_MODEL_DISPLAYS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX ATTRIBUTES_DES_IDX ON DMRS_ATTRIBUTES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX AVT_DATAELEMENT_DES_IDX ON DMRS_AVT(DESIGN_OVID) NOLOGGING;

CREATE INDEX BUSINESS_INFO_PK_IDX ON DMRS_BUSINESS_INFO(BUSINESS_INFO_OVID) NOLOGGING;
CREATE INDEX BUSINESS_INFO_DES_IDX ON DMRS_BUSINESS_INFO(DESIGN_OVID) NOLOGGING;

CREATE INDEX CHANGE_REQUESTS_PK_IDX ON DMRS_CHANGE_REQUESTS(CHANGE_REQUEST_OVID) NOLOGGING;
CREATE INDEX CHANGE_REQUESTS_DES_IDX ON DMRS_CHANGE_REQUESTS(DESIGN_OVID) NOLOGGING;

CREATE INDEX CHANGE_REQ_ELEMENTS_FK1_IDX ON DMRS_CHANGE_REQUEST_ELEMENTS(CHANGE_REQUEST_OVID) NOLOGGING;
CREATE INDEX CHANGE_REQ_ELEMENTS_FK2_IDX ON DMRS_CHANGE_REQUEST_ELEMENTS(ELEMENT_OVID) NOLOGGING;
CREATE INDEX CHANGE_REQ_ELEMENTS_DES_IDX ON DMRS_CHANGE_REQUEST_ELEMENTS(DESIGN_OVID) NOLOGGING;

CREATE INDEX CHECK_CONSTRAINTS_DES_DX ON DMRS_CHECK_CONSTRAINTS(DESIGN_OVID) NOLOGGING;

CREATE INDEX DMRS_COLL_TYPES_PK_IDX ON DMRS_COLLECTION_TYPES (COLLECTION_TYPE_OVID ASC) NOLOGGING;
CREATE INDEX DMRS_COLL_TYPES_DES_IDX ON DMRS_COLLECTION_TYPES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX COLUMNS_DES_IDX ON DMRS_COLUMNS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX CONSTR_INDEX_COLUMNS_DES_IDX ON DMRS_CONSTR_INDEX_COLUMNS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX COLUMN_UI_DES_IDX ON DMRS_COLUMN_UI (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX CONTACTS_PK_IDX ON DMRS_CONTACTS(CONTACT_OVID) NOLOGGING;
CREATE INDEX CONTACTS_DES_IDX ON DMRS_CONTACTS(DESIGN_OVID) NOLOGGING;

CREATE INDEX CONTACT_EMAILS_FK1_IDX ON DMRS_CONTACT_EMAILS(CONTACT_OVID) NOLOGGING;
CREATE INDEX CONTACT_EMAILS_DES_IDX ON DMRS_CONTACT_EMAILS(DESIGN_OVID) NOLOGGING;

CREATE INDEX CONTACT_LOCATIONS_FK1_IDX ON DMRS_CONTACT_LOCATIONS(CONTACT_OVID) NOLOGGING;
CREATE INDEX CONTACT_LOCATIONS_DES_IDX ON DMRS_CONTACT_LOCATIONS(DESIGN_OVID) NOLOGGING;

CREATE INDEX CONTACT_RES_LOCATORS_FK1_IDX ON DMRS_CONTACT_RES_LOCATORS(CONTACT_OVID) NOLOGGING;
CREATE INDEX CONTACT_RES_LOCATORS_DES_IDX ON DMRS_CONTACT_RES_LOCATORS(DESIGN_OVID) NOLOGGING;

CREATE INDEX CONTACT_TELEPHONES_FK1_IDX ON DMRS_CONTACT_TELEPHONES(CONTACT_OVID) NOLOGGING;
CREATE INDEX CONTACT_TELEPHONES_DES_IDX ON DMRS_CONTACT_TELEPHONES(DESIGN_OVID) NOLOGGING;

CREATE INDEX DFD_INFOS_DES_IDX ON DMRS_DATA_FLOW_DIAGRAM_INFOS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX DOCUMENTS_PK_IDX ON DMRS_DOCUMENTS(DOCUMENT_OVID) NOLOGGING;
CREATE INDEX DOCUMENTS_DES_IDX ON DMRS_DOCUMENTS(DESIGN_OVID) NOLOGGING;

CREATE INDEX DOCUMENT_ELEMENTS_FK1_IDX ON DMRS_DOCUMENT_ELEMENTS(DOCUMENT_OVID) NOLOGGING;
CREATE INDEX DOCUMENT_ELEMENTS_FK2_IDX ON DMRS_DOCUMENT_ELEMENTS(ELEMENT_OVID) NOLOGGING;
CREATE INDEX DOCUMENT_ELEMENTS_DES_IDX ON DMRS_DOCUMENT_ELEMENTS(DESIGN_OVID) NOLOGGING;

CREATE INDEX DOMAINS_PK1_IDX ON DMRS_DOMAINS (OVID ASC) NOLOGGING;

CREATE INDEX DOMAIN_AVT_DES_IDX ON DMRS_DOMAIN_AVT (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX DOMAIN_CHECK_CONSTR_DES_IDX ON DMRS_DOMAIN_CHECK_CONSTRAINTS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX DOMAIN_VALUE_RANGES_DES_IDX ON DMRS_DOMAIN_VALUE_RANGES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX DIAGRAM_ELEMENTS_PK_IDX ON DMRS_DIAGRAM_ELEMENTS (OVID ASC) NOLOGGING;
CREATE INDEX DIAGRAM_ELEMENTS_DES_IDX ON DMRS_DIAGRAM_ELEMENTS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX DIAGRAMS_DES_IDX ON DMRS_DIAGRAMS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX DISTINCT_TYPES_PK_IDX ON DMRS_DISTINCT_TYPES (DISTINCT_TYPE_OVID ASC) NOLOGGING;
CREATE INDEX DISTINCT_TYPES_DES_IDX ON DMRS_DISTINCT_TYPES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX EMAILS_PK_IDX ON DMRS_EMAILS(EMAIL_OVID) NOLOGGING;
CREATE INDEX EMAILS_DES_IDX ON DMRS_EMAILS(DESIGN_OVID) NOLOGGING;

CREATE INDEX ENTITIES_DES_IDX ON DMRS_ENTITIES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX ENTITYVIEWS_DES_IDX ON DMRS_ENTITYVIEWS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX EVENTS_DES_IDX ON DMRS_EVENTS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX EXT_AGENTS_DES_IDX ON DMRS_EXTERNAL_AGENTS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX EXT_AGENT_FLOWS_DES_IDX ON DMRS_EXT_AGENT_FLOWS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX EXT_AGENT_EXT_DATAS_DES_IDX ON DMRS_EXT_AGENT_EXT_DATAS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX EXT_DATAS_DES_IDX ON DMRS_EXTERNAL_DATAS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX FLOW_INFO_STRUCTS_DES_IDX ON DMRS_FLOW_INFO_STRUCTURES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX FLOWS_DES_IDX ON DMRS_FLOWS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX FOREIGNKEYS_DES_IDX ON DMRS_FOREIGNKEYS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX INDEXES_DES_IDX ON DMRS_INDEXES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX INFO_STORES_DES_IDX ON DMRS_INFO_STORES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX INFO_STRUCTS_DES_IDX ON DMRS_INFO_STRUCTURES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX KEYS_DES_IDX ON DMRS_KEYS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX KEY_ATTRIBUTES_DES_IDX ON DMRS_KEY_ATTRIBUTES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX KEY_ELEMENTS_DES_IDX ON DMRS_KEY_ELEMENTS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX LOCATIONS_PK_IDX ON DMRS_LOCATIONS(LOCATION_OVID) NOLOGGING;
CREATE INDEX LOCATIONS_DES_IDX ON DMRS_LOCATIONS(DESIGN_OVID) NOLOGGING;

CREATE INDEX NOTES_PK_IDX ON DMRS_NOTES (OVID ASC) NOLOGGING;
CREATE INDEX NOTES_DES_IDX ON DMRS_NOTES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX PK_OID_COLUMNS_PK_IDX ON DMRS_PK_OID_COLUMNS (COLUMN_OVID ASC) NOLOGGING;
CREATE INDEX PK_OID_COLUMNS_DES_IDX ON DMRS_PK_OID_COLUMNS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX PROCESS_ATTRS_PK_IDX ON DMRS_PROCESS_ATTRIBUTES (PROCESS_OVID ASC) NOLOGGING;
CREATE INDEX PROCESS_ATTRS_DES_IDX ON DMRS_PROCESS_ATTRIBUTES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX PROCESS_ENTS_PK_IDX ON DMRS_PROCESS_ENTITIES (PROCESS_OVID ASC) NOLOGGING;
CREATE INDEX PROCESS_ENTS_DES_IDX ON DMRS_PROCESS_ENTITIES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX PROCESSES_DES_IDX ON DMRS_PROCESSES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX RDBMS_SITES_PK_IDX ON DMRS_RDBMS_SITES (SITE_OVID ASC) NOLOGGING;
CREATE INDEX RDBMS_SITES_DES_IDX ON DMRS_RDBMS_SITES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX RECORD_STRUCTS_DES_IDX ON DMRS_RECORD_STRUCTURES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX REC_STRUCT_EXT_DATAS_DES_IDX ON DMRS_RECORD_STRUCT_EXT_DATAS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX RELATIONSHIPS_DES_IDX ON DMRS_RELATIONSHIPS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX RESOURCE_LOCATORS_PK_IDX ON DMRS_RESOURCE_LOCATORS (RESOURCE_LOCATOR_OVID ASC) NOLOGGING;
CREATE INDEX RESOURCE_LOCATORS_DES_IDX ON DMRS_RESOURCE_LOCATORS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX RESPONSIBLE_PARTIES_PK_IDX ON DMRS_RESPONSIBLE_PARTIES (RESPONSIBLE_PARTY_OVID ASC) NOLOGGING;
CREATE INDEX RESPONSIBLE_PARTIES_DES_IDX ON DMRS_RESPONSIBLE_PARTIES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX RES_PARTY_CONTACTS_FK1_IDX ON DMRS_RES_PARTY_CONTACTS (RESPONSIBLE_PARTY_OVID ASC) NOLOGGING;
CREATE INDEX RES_PARTY_CONTACTS_FK2_IDX ON DMRS_RES_PARTY_CONTACTS (CONTACT_OVID ASC) NOLOGGING;
CREATE INDEX RES_PARTY_CONTACTS_DES_IDX ON DMRS_RES_PARTY_CONTACTS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX RES_PARTY_ELEMENTS_FK1_IDX ON DMRS_RES_PARTY_ELEMENTS (RESPONSIBLE_PARTY_OVID ASC) NOLOGGING;
CREATE INDEX RES_PARTY_ELEMENTS_FK2_IDX ON DMRS_RES_PARTY_ELEMENTS (ELEMENT_OVID ASC) NOLOGGING;
CREATE INDEX RES_PARTY_ELEMENTS_DES_IDX ON DMRS_RES_PARTY_ELEMENTS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX ROLES_DES_IDX ON DMRS_ROLES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX ROLE_PROCESSES_DES_IDX ON DMRS_ROLE_PROCESSES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX SPATIAL_COL_DEFINITION_DES_IDX ON DMRS_SPATIAL_COLUMN_DEFINITION (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX SPATIAL_DIMENSIONS_DES_IDX ON DMRS_SPATIAL_DIMENSIONS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX STRUCTURED_TYPES_PK_IDX ON DMRS_STRUCTURED_TYPES (STRUCTURED_TYPE_OVID ASC) NOLOGGING;
CREATE INDEX STRUCTURED_TYPES_DES_IDX ON DMRS_STRUCTURED_TYPES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX STRUCT_TYPE_ATTRS_DES_IDX ON DMRS_STRUCT_TYPE_ATTRS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX STRUCT_TYPE_METHODS_DES_IDX ON DMRS_STRUCT_TYPE_METHODS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX STRUCT_TYPE_METHOD_PARS_DS_IDX ON DMRS_STRUCT_TYPE_METHOD_PARS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX TABLES_DES_IDX ON DMRS_TABLES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX TABLEVIEWS_DES_IDX ON DMRS_TABLEVIEWS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX TABLE_CONSTRAINTS_DES_IDX ON DMRS_TABLE_CONSTRAINTS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX COLUMN_GROUPS_DES_IDX ON DMRS_COLUMN_GROUPS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX CUBES_PK_IDX ON DMRS_CUBES (CUBE_OVID ASC) NOLOGGING;
CREATE INDEX CUBES_FK_IDX ON DMRS_CUBES (MODEL_OVID ASC) NOLOGGING;
CREATE INDEX CUBES_DES_IDX ON DMRS_CUBES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX CUBE_DIMENSIONS_FK1_IDX ON DMRS_CUBE_DIMENSIONS (CUBE_OVID ASC) NOLOGGING;
CREATE INDEX CUBE_DIMENSIONS_FK2_IDX ON DMRS_CUBE_DIMENSIONS (DIMENSION_OVID ASC) NOLOGGING;
CREATE INDEX CUBE_DIMENSIONS_DES_IDX ON DMRS_CUBE_DIMENSIONS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX DIMENSIONS_PK_IDX ON DMRS_DIMENSIONS (DIMENSION_OVID ASC) NOLOGGING;
CREATE INDEX DIMENSIONS_FK_IDX ON DMRS_DIMENSIONS (MODEL_OVID ASC) NOLOGGING;
CREATE INDEX DIMENSIONS_DES_IDX ON DMRS_DIMENSIONS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX DIMENSION_CALC_ATTRS_FK_IDX ON DMRS_DIMENSION_CALC_ATTRS (DIMENSION_OVID ASC) NOLOGGING;
CREATE INDEX DIMENSION_CALC_ATTRS_DES_IDX ON DMRS_DIMENSION_CALC_ATTRS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX DIMENSION_LEVELS_FK_IDX ON DMRS_DIMENSION_LEVELS (DIMENSION_OVID ASC) NOLOGGING;
CREATE INDEX DIMENSION_LEVELS_DES_IDX ON DMRS_DIMENSION_LEVELS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX FACT_ENTITIES_FK_IDX ON DMRS_FACT_ENTITIES (CUBE_OVID ASC) NOLOGGING;
CREATE INDEX FACT_ENTITIES_DES_IDX ON DMRS_FACT_ENTITIES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX FACT_ENTITIES_JOINS_FK_IDX ON DMRS_FACT_ENTITIES_JOINS (CUBE_OVID ASC) NOLOGGING;
CREATE INDEX FACT_ENTITIES_JOINS_DES_IDX ON DMRS_FACT_ENTITIES_JOINS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX HIERARCHIES_PK_IDX ON DMRS_HIERARCHIES (HIERARCHY_OVID ASC) NOLOGGING;
CREATE INDEX HIERARCHIES_FK_IDX ON DMRS_HIERARCHIES (MODEL_OVID ASC) NOLOGGING;
CREATE INDEX HIERARCHIES_DES_IDX ON DMRS_HIERARCHIES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX HIERARCHY_LEVELS_FK1_IDX ON DMRS_HIERARCHY_LEVELS (HIERARCHY_OVID ASC) NOLOGGING;
CREATE INDEX HIERARCHY_LEVELS_FK2_IDX ON DMRS_HIERARCHY_LEVELS (LEVEL_OVID ASC) NOLOGGING;
CREATE INDEX HIERARCHY_LEVELS_DES_IDX ON DMRS_HIERARCHY_LEVELS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX HIERARCHY_ROLLUP_LINKS_FK1_IDX ON DMRS_HIERARCHY_ROLLUP_LINKS (HIERARCHY_OVID ASC) NOLOGGING;
CREATE INDEX HIERARCHY_ROLLUP_LINKS_FK2_IDX ON DMRS_HIERARCHY_ROLLUP_LINKS (ROLLUP_LINK_OVID ASC) NOLOGGING;
CREATE INDEX HIERARCHY_ROLLUP_LINKS_DES_IDX ON DMRS_HIERARCHY_ROLLUP_LINKS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX LEVELS_PK_IDX ON DMRS_LEVELS (LEVEL_OVID ASC) NOLOGGING;
CREATE INDEX LEVELS_FK_IDX ON DMRS_LEVELS (MODEL_OVID ASC) NOLOGGING;
CREATE INDEX LEVELS_DES_IDX ON DMRS_LEVELS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX LEVEL_ATTRS_FK_IDX ON DMRS_LEVEL_ATTRS (LEVEL_OVID ASC) NOLOGGING;
CREATE INDEX LEVEL_ATTRS_DES_IDX ON DMRS_LEVEL_ATTRS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX MAPPING_TARGETS_FK1_IDX ON DMRS_MAPPING_TARGETS (OBJECT_OVID ASC) NOLOGGING;
CREATE INDEX MAPPING_TARGETS_FK2_IDX ON DMRS_MAPPING_TARGETS (TARGET_OVID ASC) NOLOGGING;
CREATE INDEX MAPPING_TARGETS_DES_IDX ON DMRS_MAPPING_TARGETS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX MAPPING_TARGET_SOURCES_FK1_IDX ON DMRS_MAPPING_TARGET_SOURCES (OBJECT_OVID ASC) NOLOGGING;
CREATE INDEX MAPPING_TARGET_SOURCES_FK2_IDX ON DMRS_MAPPING_TARGET_SOURCES (TARGET_OVID ASC) NOLOGGING;
CREATE INDEX MAPPING_TARGET_SOURCES_FK3_IDX ON DMRS_MAPPING_TARGET_SOURCES (SOURCE_OVID ASC) NOLOGGING;

CREATE INDEX MAPPING_TARGET_SOURCES_DES_IDX ON DMRS_MAPPING_TARGET_SOURCES (DESIGN_OVID ASC) NOLOGGING;
CREATE INDEX MEASURES_PK_IDX ON DMRS_MEASURES (MEASURE_OVID ASC) NOLOGGING;
CREATE INDEX MEASURES_FK_IDX ON DMRS_MEASURES (MODEL_OVID ASC) NOLOGGING;
CREATE INDEX MEASURES_DES_IDX ON DMRS_MEASURES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX MEASURE_AGGR_FUNCS_FK_IDX ON DMRS_MEASURE_AGGR_FUNCS (MEASURE_OVID ASC) NOLOGGING;
CREATE INDEX MEASURE_AGGR_FUNCS_DES_IDX ON DMRS_MEASURE_AGGR_FUNCS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX MEASURE_FOLDERS_PK_IDX ON DMRS_MEASURE_FOLDERS (MEASURE_FOLDER_OVID ASC) NOLOGGING;
CREATE INDEX MEASURE_FOLDERS_FK_IDX ON DMRS_MEASURE_FOLDERS (MODEL_OVID ASC) NOLOGGING;
CREATE INDEX MEASURE_FOLDERS_DES_IDX ON DMRS_MEASURE_FOLDERS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX MEASURE_FOLDER_MEAS_FK_IDX ON DMRS_MEASURE_FOLDER_MEASURES (MEASURE_FOLDER_OVID ASC) NOLOGGING;
CREATE INDEX MEASURE_FOLDER_MEAS_DES_IDX ON DMRS_MEASURE_FOLDER_MEASURES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX RAGGED_HIER_LINKS_PK_IDX ON DMRS_RAGGED_HIER_LINKS (RAGGED_HIER_LINK_OVID ASC) NOLOGGING;
CREATE INDEX RAGGED_HIER_LINKS_FK_IDX ON DMRS_RAGGED_HIER_LINKS (MODEL_OVID ASC) NOLOGGING;
CREATE INDEX RAGGED_HIER_LINKS_DES_IDX ON DMRS_RAGGED_HIER_LINKS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX RAGGED_HIER_LINK_ATTRS_FK_IDX ON DMRS_RAGGED_HIER_LINK_ATTRS (RAGGED_HIER_LINK_OVID ASC) NOLOGGING;
CREATE INDEX RAGGED_HIER_LINK_ATTRS_DES_IDX ON DMRS_RAGGED_HIER_LINK_ATTRS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX ROLLUP_LINKS_PK_IDX ON DMRS_ROLLUP_LINKS (ROLLUP_LINK_OVID ASC) NOLOGGING;
CREATE INDEX ROLLUP_LINKS_FK_IDX ON DMRS_ROLLUP_LINKS (MODEL_OVID ASC) NOLOGGING;
CREATE INDEX ROLLUP_LINKS_DES_IDX ON DMRS_ROLLUP_LINKS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX ROLLUP_LINK_ATTRS_FK_IDX ON DMRS_ROLLUP_LINK_ATTRS (ROLLUP_LINK_OVID ASC) NOLOGGING;
CREATE INDEX ROLLUP_LINK_ATTRS_DES_IDX ON DMRS_ROLLUP_LINK_ATTRS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX SLICES_PK_IDX ON DMRS_SLICES (SLICE_OVID ASC) NOLOGGING;
CREATE INDEX SLICES_FK_IDX ON DMRS_SLICES (MODEL_OVID ASC) NOLOGGING;
CREATE INDEX SLICES_DES_IDX ON DMRS_SLICES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX SLICE_DIM_HIER_LEVEL_FK_IDX ON DMRS_SLICE_DIM_HIER_LEVEL (SLICE_OVID ASC) NOLOGGING;
CREATE INDEX SLICE_DIM_HIER_LEVEL_DES_IDX ON DMRS_SLICE_DIM_HIER_LEVEL (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX SLICE_MEASURES_FK_IDX ON DMRS_SLICE_MEASURES (SLICE_OVID ASC) NOLOGGING;
CREATE INDEX SLICE_MEASURES_DES_IDX ON DMRS_SLICE_MEASURES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX SOURCE_INFO_PK_IDX ON DMRS_SOURCE_INFO (SOURCE_INFO_OVID ASC) NOLOGGING;

CREATE INDEX TABLE_INCLUDE_SCRIPTS_DES_IDX ON DMRS_TABLE_INCLUDE_SCRIPTS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX TASK_PARAMS_DES_IDX ON DMRS_TASK_PARAMS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX TASK_PARAMS_ITEMS_DES_IDX ON DMRS_TASK_PARAMS_ITEMS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX TELEPHONES_PK_IDX ON DMRS_TELEPHONES (TELEPHONE_OVID ASC) NOLOGGING;
CREATE INDEX TELEPHONES_DES_IDX ON DMRS_TELEPHONES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX TRANSFORM_PACKS_DES_IDX ON DMRS_TRANSFORMATION_PACKAGES (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX TRANSFORM_TASKS_DES_IDX ON DMRS_TRANSFORMATION_TASKS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX TRANSFORM_TASK_INFOS_DES_IDX ON DMRS_TRANSFORMATION_TASK_INFOS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX TRANSFORM_FLOWS_DES_IDX ON DMRS_TRANSFORMATION_FLOWS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX TRANSFORMS_DES_IDX ON DMRS_TRANSFORMATIONS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX VALUE_RANGES_DES_IDX ON DMRS_VALUE_RANGES(DESIGN_OVID) NOLOGGING;

CREATE INDEX VIEW_COLUMNS_DES_IDX ON DMRS_VIEW_COLUMNS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX VIEW_CONTAINERS_DES_IDX ON DMRS_VIEW_CONTAINERS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX VIEW_ORDER_GROUPBY_DES_IDX ON DMRS_VIEW_ORDER_GROUPBY (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX DMRS_LARGE_TEXT_DES_IDX ON DMRS_LARGE_TEXT (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX MODEL_NAMING_OPTIONS_DES_IDX ON DMRS_MODEL_NAMING_OPTIONS (DESIGN_OVID ASC) NOLOGGING;

CREATE INDEX PROCESS_ENTS_ENT_IDX ON DMRS_PROCESS_ENTITIES(ENTITY_OVID) NOLOGGING;
CREATE INDEX FOREIGNKEYS_CHILD_IDX ON DMRS_FOREIGNKEYS (child_table_ovid) NOLOGGING;
CREATE INDEX FOREIGNKEYS_PARENT_IDX ON DMRS_FOREIGNKEYS (REFERRED_TABLE_OVID) NOLOGGING;
CREATE INDEX COLUMNS_DOM_IDX on DMRS_COLUMNS(domain_ovid) NOLOGGING;
CREATE INDEX ATTRIBUTES_DOMAIN_IDX on DMRS_ATTRIBUTES(domain_ovid) NOLOGGING;

--==========ALTER INDEXES==========
ALTER INDEX ATTRIBUTES_PK_IDX NOLOGGING;
ALTER INDEX BUSINESS_INFO_PK_IDX NOLOGGING;
ALTER INDEX CHANGE_REQUESTS_PK_IDX NOLOGGING;
ALTER INDEX CHANGE_REQ_ELEMENTS_FK1_IDX NOLOGGING;
ALTER INDEX CHANGE_REQ_ELEMENTS_FK2_IDX NOLOGGING;
ALTER INDEX CLASS_TYPES_PK_IDX NOLOGGING;
ALTER INDEX DMRS_COLL_TYPES_PK_IDX NOLOGGING;
ALTER INDEX COLUMNS_PK_IDX NOLOGGING;
ALTER INDEX COLUMNS_FK_IDX NOLOGGING;
ALTER INDEX COLUMN_GROUPS_FK_IDX NOLOGGING;
ALTER INDEX COLUMN_UI_FK_IDX NOLOGGING;
ALTER INDEX CONSTR_INDEX_COLUMNS_FK_IDX NOLOGGING;
ALTER INDEX CONTACTS_PK_IDX NOLOGGING;
ALTER INDEX CONTACT_EMAILS_FK1_IDX NOLOGGING;
ALTER INDEX CONTACT_LOCATIONS_FK1_IDX NOLOGGING;
ALTER INDEX CONTACT_RES_LOCATORS_FK1_IDX NOLOGGING;
ALTER INDEX CONTACT_TELEPHONES_FK1_IDX NOLOGGING;
ALTER INDEX CUBES_PK_IDX NOLOGGING;
ALTER INDEX CUBES_FK_IDX NOLOGGING;
ALTER INDEX CUBE_DIMENSIONS_FK1_IDX NOLOGGING;
ALTER INDEX CUBE_DIMENSIONS_FK2_IDX NOLOGGING;
ALTER INDEX DESIGNS_PK_IDX NOLOGGING;
ALTER INDEX DIAGRAMS_PK_IDX NOLOGGING;
ALTER INDEX DIAGRAMS_FK_IDX NOLOGGING;
ALTER INDEX DIAGRAM_ELEMENTS_PK_IDX NOLOGGING;
ALTER INDEX DIAGRAM_ELEMENTS_FK_IDX NOLOGGING;
ALTER INDEX DFD_INFOS_FK1_IDX NOLOGGING;
ALTER INDEX DFD_INFOS_FK2_IDX NOLOGGING;
ALTER INDEX DIMENSIONS_PK_IDX NOLOGGING;
ALTER INDEX DIMENSIONS_FK_IDX NOLOGGING;
ALTER INDEX DIMENSION_CALC_ATTRS_FK_IDX NOLOGGING;
ALTER INDEX DIMENSION_LEVELS_FK_IDX NOLOGGING;
ALTER INDEX DISTINCT_TYPES_PK_IDX NOLOGGING;
ALTER INDEX DOCUMENTS_PK_IDX NOLOGGING;
ALTER INDEX DOCUMENT_ELEMENTS_FK1_IDX NOLOGGING;
ALTER INDEX DOCUMENT_ELEMENTS_FK2_IDX NOLOGGING;
ALTER INDEX DOMAINS_PK_IDX NOLOGGING;
ALTER INDEX DOMAINS_PK1_IDX NOLOGGING;
ALTER INDEX DOMAINS_FK_IDXv1 NOLOGGING;
ALTER INDEX DOMAIN_AVT_FK_IDX NOLOGGING;
ALTER INDEX DOMAIN_CHECK_CONSTR_FK_IDX NOLOGGING;
ALTER INDEX DOMAIN_VALUE_RANGES_FK_IDX NOLOGGING;
ALTER INDEX EMAILS_PK_IDX NOLOGGING;
ALTER INDEX ENTITIES_PK_IDX NOLOGGING;
ALTER INDEX ENTITIES_FK_IDX NOLOGGING;
ALTER INDEX ENTITIES_FK_IDXv1 NOLOGGING;
ALTER INDEX ENTITYVIEWS_PK_IDX NOLOGGING;
ALTER INDEX ENTITYVIEWS_FK_IDX NOLOGGING;
ALTER INDEX EVENTS_PK_IDX NOLOGGING;
ALTER INDEX EVENTS_FK_MODEL_IDX NOLOGGING;
ALTER INDEX EVENTS_FK_FLOW_IDX NOLOGGING;
ALTER INDEX EXT_AGENTS_PK_IDX NOLOGGING;
ALTER INDEX EXT_AGENTS_FK_DIAGRAM_IDX NOLOGGING;
ALTER INDEX EXT_AGENT_EXT_DATAS_FK1_IDX NOLOGGING;
ALTER INDEX EXT_AGENT_EXT_DATAS_FK2_IDX NOLOGGING;
ALTER INDEX EXT_AGENT_FLOWS_FK1_IDX NOLOGGING;
ALTER INDEX EXT_AGENT_FLOWS_FK2_IDX NOLOGGING;
ALTER INDEX EXT_DATAS_PK_IDX NOLOGGING;
ALTER INDEX EXT_DATAS_FK_MODEL_IDX NOLOGGING;
ALTER INDEX FACT_ENTITIES_FK_IDX NOLOGGING;
ALTER INDEX FACT_ENTITIES_JOINS_FK_IDX NOLOGGING;
ALTER INDEX FLOWS_PK_IDX NOLOGGING;
ALTER INDEX FLOWS_FK_DIAGRAM_IDX NOLOGGING;
ALTER INDEX FLOW_INFO_STRUCTS_FK1_IDX NOLOGGING;
ALTER INDEX FLOW_INFO_STRUCTS_FK2_IDX NOLOGGING;
ALTER INDEX FOREIGNKEYS_PK_IDX NOLOGGING;
ALTER INDEX FOREIGNKEYS_FK_IDX NOLOGGING;
ALTER INDEX HIERARCHIES_PK_IDX NOLOGGING;
ALTER INDEX HIERARCHIES_FK_IDX NOLOGGING;
ALTER INDEX HIERARCHY_LEVELS_FK1_IDX NOLOGGING;
ALTER INDEX HIERARCHY_LEVELS_FK2_IDX NOLOGGING;
ALTER INDEX HIERARCHY_ROLLUP_LINKS_FK1_IDX NOLOGGING;
ALTER INDEX HIERARCHY_ROLLUP_LINKS_FK2_IDX NOLOGGING;
ALTER INDEX INDEXES_PK_IDX NOLOGGING;
ALTER INDEX INDEXES_FK_IDX NOLOGGING;
ALTER INDEX INFO_STORES_PK_IDX NOLOGGING;
ALTER INDEX INFO_STORES_FK_MODEL_IDX NOLOGGING;
ALTER INDEX INFO_STRUCTS_PK_IDX NOLOGGING;
ALTER INDEX INFO_STRUCTS_FK_MODEL_IDX NOLOGGING;
ALTER INDEX TASK_PARAMS_PK_IDX NOLOGGING;
ALTER INDEX TASK_PARAMS_FK_TASK_IDX NOLOGGING;
ALTER INDEX TASK_PARAMS_ITEMS_PK_IDX NOLOGGING;
ALTER INDEX TASK_PARAMS_ITEMS_FK_PARS_IDX NOLOGGING;
ALTER INDEX KEYS_PK_IDX NOLOGGING;
ALTER INDEX KEYS_FK_IDX NOLOGGING;
ALTER INDEX KEY_ATTRIBUTES_FK_IDX NOLOGGING;
ALTER INDEX KEY_ELEMENTS_FK_IDX NOLOGGING;
ALTER INDEX LEVELS_PK_IDX NOLOGGING;
ALTER INDEX LEVELS_FK_IDX NOLOGGING;
ALTER INDEX LEVEL_ATTRS_FK_IDX NOLOGGING;
ALTER INDEX LOCATIONS_PK_IDX NOLOGGING;
ALTER INDEX LOGICAL_TO_NATIVE_FK_IDXv1 NOLOGGING;
ALTER INDEX LOGICAL_TYPES_PK_IDX NOLOGGING;
ALTER INDEX DMRS_LARGE_TEXT_PK_IDX NOLOGGING;
ALTER INDEX MAPPING_TARGETS_FK1_IDX NOLOGGING;
ALTER INDEX MAPPING_TARGETS_FK2_IDX NOLOGGING;
ALTER INDEX MAPPING_TARGET_SOURCES_FK1_IDX NOLOGGING;
ALTER INDEX MAPPING_TARGET_SOURCES_FK2_IDX NOLOGGING;
ALTER INDEX MAPPING_TARGET_SOURCES_FK3_IDX NOLOGGING;
ALTER INDEX MEASURES_PK_IDX NOLOGGING;
ALTER INDEX MEASURES_FK_IDX NOLOGGING;
ALTER INDEX MEASURE_AGGR_FUNCS_FK_IDX NOLOGGING;
ALTER INDEX AGGR_FUNC_DIMENSIONS_FK_IDX NOLOGGING;
ALTER INDEX AGGR_FUNC_LEVELS_FK_IDX NOLOGGING;
ALTER INDEX MEASURE_FOLDERS_PK_IDX NOLOGGING;
ALTER INDEX MEASURE_FOLDERS_FK_IDX NOLOGGING;
ALTER INDEX MEASURE_FOLDER_MEAS_FK_IDX NOLOGGING;
ALTER INDEX MODELS_PK_IDX NOLOGGING;
ALTER INDEX MODEL_SUBVIEWS_PK_IDX NOLOGGING;
ALTER INDEX MODEL_SUBVIEWS_FK_IDX NOLOGGING;
ALTER INDEX MODEL_DISPLAYS_PK_IDX NOLOGGING;
ALTER INDEX MODEL_DISPLAYS_FK_IDX NOLOGGING;
ALTER INDEX MODEL_NAMING_OPTIONS_FK_IDX NOLOGGING;
ALTER INDEX NATIVE_TO_LOGICAL_FK_IDXv1 NOLOGGING;
ALTER INDEX NOTES_PK_IDX NOLOGGING;
ALTER INDEX NOTES_FK_IDX NOLOGGING;
ALTER INDEX PK_OID_COLUMNS_PK_IDX NOLOGGING;
ALTER INDEX PK_OID_COLUMNS_FK_IDX NOLOGGING;
ALTER INDEX PROCESS_ATTRS_PK_IDX NOLOGGING;
ALTER INDEX PROCESS_ENTS_PK_IDX NOLOGGING;
ALTER INDEX PROCESSES_PK_IDX NOLOGGING;
ALTER INDEX PROCESSES_FK_DIAGRAM_IDX NOLOGGING;
ALTER INDEX RAGGED_HIER_LINKS_PK_IDX NOLOGGING;
ALTER INDEX RAGGED_HIER_LINKS_FK_IDX NOLOGGING;
ALTER INDEX RAGGED_HIER_LINK_ATTRS_FK_IDX NOLOGGING;
ALTER INDEX RDBMS_SITES_PK_IDX NOLOGGING;
ALTER INDEX RECORD_STRUCTS_PK_IDX NOLOGGING;
ALTER INDEX RECORD_STRUCTS_FK_MODEL_IDX NOLOGGING;
ALTER INDEX REC_STRUCT_EXT_DATAS_FK1_IDX NOLOGGING;
ALTER INDEX REC_STRUCT_EXT_DATAS_FK2_IDX NOLOGGING;
ALTER INDEX RELATIONSHIPS_PK_IDX NOLOGGING;
ALTER INDEX RELATIONSHIPS_FK_IDX NOLOGGING;
ALTER INDEX RELATIONSHIPS_FK_IDXv1 NOLOGGING;
ALTER INDEX RELATIONSHIPS_FK_IDXv2 NOLOGGING;
ALTER INDEX RESOURCE_LOCATORS_PK_IDX NOLOGGING;
ALTER INDEX RESPONSIBLE_PARTIES_PK_IDX NOLOGGING;
ALTER INDEX RES_PARTY_CONTACTS_FK1_IDX NOLOGGING;
ALTER INDEX RES_PARTY_CONTACTS_FK2_IDX NOLOGGING;
ALTER INDEX RES_PARTY_ELEMENTS_FK1_IDX NOLOGGING;
ALTER INDEX RES_PARTY_ELEMENTS_FK2_IDX NOLOGGING;
ALTER INDEX ROLES_PK_IDX NOLOGGING;
ALTER INDEX ROLES_FK_MODEL_IDX NOLOGGING;
ALTER INDEX ROLE_PROCESSES_FK1_IDX NOLOGGING;
ALTER INDEX ROLE_PROCESSES_FK2_IDX NOLOGGING;
ALTER INDEX ROLLUP_LINKS_PK_IDX NOLOGGING;
ALTER INDEX ROLLUP_LINKS_FK_IDX NOLOGGING;
ALTER INDEX ROLLUP_LINK_ATTRS_FK_IDX NOLOGGING;
ALTER INDEX SLICES_PK_IDX NOLOGGING;
ALTER INDEX SLICES_FK_IDX NOLOGGING;
ALTER INDEX SLICE_DIM_HIER_LEVEL_FK_IDX NOLOGGING;
ALTER INDEX SLICE_MEASURES_FK_IDX NOLOGGING;
ALTER INDEX SPATIAL_COL_DEFINITION_PK_IDX NOLOGGING;
ALTER INDEX SPATIAL_COL_DEFINITION_FK_IDX NOLOGGING;
ALTER INDEX SPATIAL_DIMENSIONS_FK_IDX NOLOGGING;
ALTER INDEX STRUCTURED_TYPES_PK_IDX NOLOGGING;
ALTER INDEX STRUCT_TYPE_ATTRS_FK_IDX NOLOGGING;
ALTER INDEX STRUCT_TYPE_METHODS_FK_IDX NOLOGGING;
ALTER INDEX STRUCT_TYPE_METHOD_PARS_FK_IDX NOLOGGING;
ALTER INDEX TABLES_PK_IDX NOLOGGING;
ALTER INDEX TABLES_FK_IDX NOLOGGING;
ALTER INDEX TABLES_FK_IDXv1 NOLOGGING;
ALTER INDEX TABLEVIEWS_PK_IDX NOLOGGING;
ALTER INDEX TABLEVIEWS_FK_IDX NOLOGGING;
ALTER INDEX TABLE_CONSTRAINTS_FK_IDX NOLOGGING;
ALTER INDEX TABLE_INCLUDE_SCRIPTS_FK_IDX NOLOGGING;
ALTER INDEX TELEPHONES_PK_IDX NOLOGGING;
ALTER INDEX TRANSFORM_PACKS_PK_IDX NOLOGGING;
ALTER INDEX TRANSFORM_PACKS_FK_MODEL_IDX NOLOGGING;
ALTER INDEX TRANSFORM_TASKS_PK_IDX NOLOGGING;
ALTER INDEX TRANSFORM_TASKS_FK_PACK_IDX NOLOGGING;
ALTER INDEX TRANSFORM_TASK_INFOS_FK1_IDX NOLOGGING;
ALTER INDEX TRANSFORM_TASK_INFOS_FK2_IDX NOLOGGING;
ALTER INDEX TRANSFORM_FLOWS_PK_IDX NOLOGGING;
ALTER INDEX TRANSFORM_FLOWS_FK_TASK_IDX NOLOGGING;
ALTER INDEX TRANSFORMS_PK_IDX NOLOGGING;
ALTER INDEX TRANSFORMS_FK_TASK_IDX NOLOGGING;
ALTER INDEX VIEW_COLUMNS_FK_IDX NOLOGGING;
ALTER INDEX VIEW_CONTAINERS_FK_IDX NOLOGGING;
ALTER INDEX VIEW_ORDER_GROUPBY_FK_IDX NOLOGGING;
ALTER INDEX ATTRIBUTES_CONTAINER_OVID_IDX NOLOGGING;
ALTER INDEX MAPPINGS_REL_OBJ_OVID_IDX NOLOGGING;
ALTER INDEX MAPPINGS_LOG_OBJ_OVID_IDX NOLOGGING;
ALTER INDEX VL_DATAELEMENT_OVID_IDX NOLOGGING;
ALTER INDEX AVT_DATAELEMENT_OVID_IDX NOLOGGING;
ALTER INDEX CC_DATAELEMENT_OVID_DX NOLOGGING;
ALTER INDEX PROCESS_ENTS_ENT_IDX NOLOGGING;
ALTER INDEX TABLES_NAME_IDX NOLOGGING;
ALTER INDEX MODELS_NAME_IDX NOLOGGING;

--==========CREATE TYPES==========
CREATE OR REPLACE TYPE report_template AS OBJECT (
  reportType                  INTEGER,
  useDescriptionInfo          INTEGER,
  useQuantitativeInfo         INTEGER,
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
  useMRImpactedObjects        INTEGER)
  
--==========DROP OBJECTS==========
DROP TABLE MSWORD_ML_DATA;
DROP TABLE MSWORD_REPORTS;
DROP PROCEDURE Java_XmlTransform;
DROP FUNCTION Apply_Transformation;
DROP SEQUENCE reports_seq;

DROP INDEX ATTRIBUTES_DOM_IDX;
DROP index COLUMNS_DOMAINS_IDX;
DROP INDEX COLUMNS_COM_IDX;
DROP index FOREIGNKEYS_PARENT_T_IDX;
DROP INDEX FOREIGNKEYS_CHILD_T_IDX;
DROP INDEX PE_INCOMING_IDX;
DROP INDEX ATTRIBUTES_DES_IDX;
DROP INDEX BUSINESS_INFO_DES_IDX;
DROP INDEX CHANGE_REQUESTS_DES_IDX;
DROP INDEX CHANGE_REQ_ELEMENTS_DES_IDX;
DROP INDEX CLASS_TYPES_DESIGNS_FK_IDX;
DROP INDEX DMRS_COLL_TYPES_DES_IDX;
DROP INDEX COLUMNS_DES_IDX;
DROP INDEX COLUMN_GROUPS_DES_IDX;
DROP INDEX COLUMN_UI_DES_IDX;
DROP INDEX CONSTR_INDEX_COLUMNS_DES_IDX;
DROP INDEX CONTACTS_DES_IDX;
DROP INDEX CONTACT_EMAILS_DES_IDX;
DROP INDEX CONTACT_LOCATIONS_DES_IDX;
DROP INDEX CONTACT_RES_LOCATORS_DES_IDX;
DROP INDEX CONTACT_TELEPHONES_DES_IDX;
DROP INDEX CUBES_DES_IDX;
DROP INDEX CUBE_DIMENSIONS_DES_IDX;
DROP INDEX DIAGRAMS_DES_IDX;
DROP INDEX DIAGRAM_ELEMENTS_DES_IDX;
DROP INDEX DFD_INFOS_DES_IDX;
DROP INDEX DIMENSIONS_DES_IDX;
DROP INDEX DIMENSION_CALC_ATTRS_DES_IDX;
DROP INDEX DIMENSION_LEVELS_DES_IDX;
DROP INDEX DISTINCT_TYPES_DES_IDX;
DROP INDEX DOCUMENTS_DES_IDX;
DROP INDEX DOCUMENT_ELEMENTS_DES_IDX;
DROP INDEX DOMAINS_FK_IDX;
DROP INDEX DOMAIN_AVT_DES_IDX;
DROP INDEX DOMAIN_CHECK_CONSTR_DES_IDX;
DROP INDEX DOMAIN_VALUE_RANGES_DES_IDX;
DROP INDEX EMAILS_DES_IDX;
DROP INDEX ENTITIES_DES_IDX;
DROP INDEX ENTITYVIEWS_DES_IDX;
DROP INDEX EVENTS_DES_IDX;
DROP INDEX EXT_AGENTS_DES_IDX;
DROP INDEX EXT_AGENT_EXT_DATAS_DES_IDX;
DROP INDEX EXT_AGENT_FLOWS_DES_IDX;
DROP INDEX EXT_DATAS_DES_IDX;
DROP INDEX FACT_ENTITIES_DES_IDX;
DROP INDEX FACT_ENTITIES_JOINS_DES_IDX;
DROP INDEX FLOWS_DES_IDX;
DROP INDEX FLOW_INFO_STRUCTS_DES_IDX;
DROP INDEX FOREIGNKEYS_DES_IDX;
DROP INDEX HIERARCHIES_DES_IDX;
DROP INDEX HIERARCHY_LEVELS_DES_IDX;
DROP INDEX HIERARCHY_ROLLUP_LINKS_DES_IDX;
DROP INDEX INDEXES_DES_IDX;
DROP INDEX INFO_STORES_DES_IDX;
DROP INDEX INFO_STRUCTS_DES_IDX;
DROP INDEX TASK_PARAMS_DES_IDX;
DROP INDEX TASK_PARAMS_ITEMS_DES_IDX;
DROP INDEX KEYS_DES_IDX;
DROP INDEX KEY_ATTRIBUTES_DES_IDX;
DROP INDEX KEY_ELEMENTS_DES_IDX;
DROP INDEX LEVELS_DES_IDX;
DROP INDEX LEVEL_ATTRS_DES_IDX;
DROP INDEX LOCATIONS_DES_IDX;
DROP INDEX LOGICAL_TO_NATIVE_FK_IDX;
DROP INDEX LOGICAL_TYPES_FK_IDX;
DROP INDEX DMRS_LARGE_TEXT_DES_IDX;
DROP INDEX MAPPINGS_FK_IDX;
DROP INDEX MAPPING_TARGETS_DES_IDX;
DROP INDEX MAPPING_TARGET_SOURCES_DES_IDX;
DROP INDEX MEASURES_DES_IDX;
DROP INDEX MEASURE_AGGR_FUNCS_DES_IDX;
DROP INDEX AGGR_FUNC_DIMENSIONS_DES_IDX;
DROP INDEX AGGR_FUNC_LEVELS_DES_IDX;
DROP INDEX MEASURE_FOLDERS_DES_IDX;
DROP INDEX MEASURE_FOLDER_MEAS_DES_IDX;
DROP INDEX MODELS_FK_IDX;
DROP INDEX MODEL_SUBVIEWS_DES_IDX;
DROP INDEX MODEL_DISPLAYS_DES_IDX;
DROP INDEX MODEL_NAMING_OPTIONS_DES_IDX;
DROP INDEX NATIVE_TO_LOGICAL_FK_IDX;
DROP INDEX NOTES_DES_IDX;
DROP INDEX PK_OID_COLUMNS_DES_IDX;
DROP INDEX PROCESS_ATTRS_DES_IDX;
DROP INDEX PROCESS_ENTS_DES_IDX;
DROP INDEX PROCESSES_DES_IDX;
DROP INDEX RAGGED_HIER_LINKS_DES_IDX;
DROP INDEX RAGGED_HIER_LINK_ATTRS_DES_IDX;
DROP INDEX RDBMS_SITES_DES_IDX;
DROP INDEX RECORD_STRUCTS_DES_IDX;
DROP INDEX REC_STRUCT_EXT_DATAS_DES_IDX;
DROP INDEX RELATIONSHIPS_DES_IDX;
DROP INDEX RESOURCE_LOCATORS_DES_IDX;
DROP INDEX RESPONSIBLE_PARTIES_DES_IDX;
DROP INDEX RES_PARTY_CONTACTS_DES_IDX;
DROP INDEX RES_PARTY_ELEMENTS_DES_IDX;
DROP INDEX ROLES_DES_IDX;
DROP INDEX ROLE_PROCESSES_DES_IDX;
DROP INDEX ROLLUP_LINKS_DES_IDX;
DROP INDEX ROLLUP_LINK_ATTRS_DES_IDX;
DROP INDEX SLICES_DES_IDX;
DROP INDEX SLICE_DIM_HIER_LEVEL_DES_IDX;
DROP INDEX SLICE_MEASURES_DES_IDX;
DROP INDEX SPATIAL_COL_DEFINITION_DES_IDX;
DROP INDEX SPATIAL_DIMENSIONS_DES_IDX;
DROP INDEX STRUCTURED_TYPES_DES_IDX;
DROP INDEX STRUCT_TYPE_ATTRS_DES_IDX;
DROP INDEX STRUCT_TYPE_METHODS_DES_IDX;
DROP INDEX STRUCT_TYPE_METHOD_PARS_DS_IDX;
DROP INDEX TABLES_DES_IDX;
DROP INDEX TABLEVIEWS_DES_IDX;
DROP INDEX TABLE_CONSTRAINTS_DES_IDX;
DROP INDEX TABLE_INCLUDE_SCRIPTS_DES_IDX;
DROP INDEX TELEPHONES_DES_IDX;
DROP INDEX TRANSFORM_PACKS_DES_IDX;
DROP INDEX TRANSFORM_TASKS_DES_IDX;
DROP INDEX TRANSFORM_TASK_INFOS_DES_IDX;
DROP INDEX TRANSFORM_FLOWS_DES_IDX;
DROP INDEX TRANSFORMS_DES_IDX;
DROP INDEX VIEW_COLUMNS_DES_IDX;
DROP INDEX VIEW_CONTAINERS_DES_IDX;
DROP INDEX VIEW_ORDER_GROUPBY_DES_IDX;
DROP INDEX VALUE_RANGES_DES_IDX;
DROP INDEX AVT_DATAELEMENT_DES_IDX;
DROP INDEX CHECK_CONSTRAINTS_DES_DX;
DROP INDEX KEY_EL_IDX;
DROP INDEX CIC_NAME_IDX;
