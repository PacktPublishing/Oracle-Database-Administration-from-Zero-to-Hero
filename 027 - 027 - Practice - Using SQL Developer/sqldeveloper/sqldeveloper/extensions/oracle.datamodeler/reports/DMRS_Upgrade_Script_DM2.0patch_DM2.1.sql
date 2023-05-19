-- Upgrade script for Reporting Schema from DM 2.0.0(584) Patch Release to DM 2.1.0(618) Release or later

--==========CREATE TABLES==========
CREATE TABLE DMRS_COLLECTION_TYPES (
Design_OVID VARCHAR2 (36) NOT NULL,
Design_Name VARCHAR2 (256) NOT NULL,
Collection_Type_ID VARCHAR2 (70) NOT NULL,
Collection_Type_OVID VARCHAR2 (36) NOT NULL,
Collection_Type_Name VARCHAR2 (256) NOT NULL,
C_Type VARCHAR2 (30),
DataType_ID VARCHAR2 (70),
DataType_OVID VARCHAR2 (36),
DataType_Name VARCHAR2 (256),
DT_Type VARCHAR2 (30),
DT_Ref CHAR (1),
Max_Element NUMBER,
Predefined CHAR (1),
Design_ID VARCHAR2 (70) NOT NULL );

CREATE TABLE DMRS_DISTINCT_TYPES (
Design_OVID VARCHAR2 (36) NOT NULL,
Design_Name VARCHAR2 (256) NOT NULL,
Distinct_Type_ID VARCHAR2 (70) NOT NULL,
Distinct_Type_OVID VARCHAR2 (36) NOT NULL,
Distinct_Type_Name VARCHAR2 (256) NOT NULL,
Logical_Type_ID VARCHAR2 (70),
Logical_Type_OVID VARCHAR2 (36),
Logical_Type_Name VARCHAR2 (256),
T_Size NUMBER,
T_Precision NUMBER,
T_Scale NUMBER,
Design_ID VARCHAR2 (70) NOT NULL );

CREATE TABLE DMRS_MODEL_DISPLAYS (
Display_ID VARCHAR2(70 BYTE) NOT NULL, 
Display_OVID VARCHAR2(36 BYTE) NOT NULL, 
Display_Name VARCHAR2(256 BYTE) NOT NULL, 
Model_ID VARCHAR2(70 BYTE) NOT NULL, 
Model_OVID VARCHAR2(36 BYTE) NOT NULL, 
Model_Name VARCHAR2(256 BYTE) NOT NULL, 
Design_OVID VARCHAR2(36 BYTE) NOT NULL );

CREATE TABLE DMRS_MODEL_SUBVIEWS (
Subview_ID VARCHAR2(70 BYTE) NOT NULL, 
Subview_OVID VARCHAR2(36 BYTE) NOT NULL, 
Subview_Name VARCHAR2(256 BYTE) NOT NULL, 
Model_ID VARCHAR2(70 BYTE) NOT NULL, 
Model_OVID VARCHAR2(36 BYTE) NOT NULL, 
Model_Name VARCHAR2(256 BYTE) NOT NULL, 
Design_OVID VARCHAR2(36 BYTE) NOT NULL );

CREATE TABLE DMRS_STRUCTURED_TYPES (
Design_OVID VARCHAR2 (36) NOT NULL,
Design_Name VARCHAR2 (256) NOT NULL,
Structured_Type_ID VARCHAR2 (70) NOT NULL,
Structured_Type_OVID VARCHAR2 (36) NOT NULL,
Structured_Type_Name VARCHAR2 (256) NOT NULL,
Super_Type_ID VARCHAR2 (70),
Super_Type_OVID VARCHAR2 (36),
Super_Type_Name VARCHAR2 (256),
Predefined CHAR (1),
ST_Final CHAR (1),
ST_Instantiable CHAR (1),
Design_ID VARCHAR2 (70) NOT NULL );

CREATE TABLE DMRS_STRUCT_TYPE_ATTRS ( 
Attribute_ID VARCHAR2 (70) NOT NULL, 
Attribute_OVID VARCHAR2 (36) NOT NULL, 
Attribute_Name VARCHAR2 (256) NOT NULL, 
Structured_Type_ID VARCHAR2 (70) NOT NULL, 
Structured_Type_OVID VARCHAR2 (36) NOT NULL, 
Structured_Type_Name VARCHAR2 (256) NOT NULL, 
Mandatory CHAR (1) NOT NULL, 
Reference CHAR (1) NOT NULL, 
T_Size NUMBER, 
T_Precision NUMBER, 
T_Scale NUMBER, 
Type_ID VARCHAR2 (70), 
Type_OVID VARCHAR2 (36), 
Type_Name VARCHAR2 (256), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_STRUCT_TYPE_METHODS ( 
Method_ID VARCHAR2 (70) NOT NULL, 
Method_OVID VARCHAR2 (36) NOT NULL, 
Method_Name VARCHAR2 (256) NOT NULL, 
Structured_Type_ID VARCHAR2 (70) NOT NULL, 
Structured_Type_OVID VARCHAR2 (36) NOT NULL, 
Structured_Type_Name VARCHAR2 (256) NOT NULL, 
Body VARCHAR2 (4000), 
Constructor CHAR (1), 
Overridden_Method_ID VARCHAR2 (70), 
Overridden_Method_OVID VARCHAR2 (36), 
Overridden_Method_Name VARCHAR2 (256), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_STRUCT_TYPE_METHOD_PARS ( 
Parameter_ID VARCHAR2 (70) NOT NULL, 
Parameter_OVID VARCHAR2 (36) NOT NULL, 
Parameter_Name VARCHAR2 (256) NOT NULL, 
Method_ID VARCHAR2 (70) NOT NULL, 
Method_OVID VARCHAR2 (36) NOT NULL, 
Method_Name VARCHAR2 (256) NOT NULL, 
Return_Value CHAR (1) NOT NULL, 
Reference CHAR (1) NOT NULL, 
Seq NUMBER, 
T_Size NUMBER, 
T_Precision NUMBER, 
T_Scale NUMBER, 
Type_ID VARCHAR2 (70), 
Type_OVID VARCHAR2 (36), 
Type_Name VARCHAR2 (256), 
Design_OVID VARCHAR2 (36) NOT NULL);

CREATE TABLE DMRS_VIEW_COLUMNS (
View_OVID VARCHAR2 (36) NOT NULL,
View_ID VARCHAR2 (70) NOT NULL,
View_Name VARCHAR2 (256) NOT NULL,
Container_ID VARCHAR2 (70) NOT NULL,
Container_OVID VARCHAR2 (36) NOT NULL,
Container_Name VARCHAR2 (256) NOT NULL,
Container_Alias VARCHAR2 (256),
Is_Expression CHAR (1),
Column_ID VARCHAR2 (70) NOT NULL,
Column_OVID VARCHAR2 (36) NOT NULL,
Column_Name VARCHAR2 (256) NOT NULL,
Column_Alias VARCHAR2 (256),
Native_Type VARCHAR2 (60),
Type CHAR (1),
Expression VARCHAR2 (2000),
Sequence NUMBER (3) NOT NULL,
Personally_ID_Information CHAR (1),
Sensitive_Information CHAR (1),
Mask_For_None_Production CHAR (1),
Model_ID VARCHAR2 (70) NOT NULL,
Model_OVID VARCHAR2 (36) NOT NULL,
Model_Name VARCHAR2 (256) NOT NULL,
Design_OVID VARCHAR2 (36) NOT NULL );

CREATE TABLE DMRS_VIEW_CONTAINERS (
View_OVID VARCHAR2 (36) NOT NULL,
View_ID VARCHAR2 (70) NOT NULL,
View_Name VARCHAR2 (256) NOT NULL,
Container_ID VARCHAR2 (70) NOT NULL,
Container_OVID VARCHAR2 (36) NOT NULL,
Container_Name VARCHAR2 (256) NOT NULL,
Type CHAR (1) NOT NULL,
Alias VARCHAR2 (256),
Sequence NUMBER (3) NOT NULL,
Model_ID VARCHAR2 (70) NOT NULL,
Model_OVID VARCHAR2 (36) NOT NULL,
Model_Name VARCHAR2 (256) NOT NULL,
Design_OVID VARCHAR2 (36) NOT NULL );

CREATE TABLE DMRS_VIEW_ORDER_GROUPBY (
View_OVID VARCHAR2 (36) NOT NULL,
View_ID VARCHAR2 (70) NOT NULL,
View_Name VARCHAR2 (256) NOT NULL,
Container_ID VARCHAR2 (70) NOT NULL,
Container_OVID VARCHAR2 (36) NOT NULL,
Container_Name VARCHAR2 (256) NOT NULL,
Container_Alias VARCHAR2 (256),
Is_Expression CHAR (1),
Usage CHAR (1),
Sequence NUMBER (3) NOT NULL,
Column_ID VARCHAR2 (70),
Column_OVID VARCHAR2 (36),
Column_Name VARCHAR2 (256),
Column_Alias VARCHAR2 (256),
Sort_Order VARCHAR2 (4),
Expression VARCHAR2 (2000),
Design_OVID VARCHAR2 (36) NOT NULL );

--==========CHANGE TABLES==========
ALTER TABLE DMRS_ATTRIBUTES
ADD ( ScopeEntity_Name VARCHAR2 (256) );

ALTER TABLE DMRS_AVT
ADD ( Container_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL,
      Container_OVID VARCHAR2 (36) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_CHECK_CONSTRAINTS
ADD ( Container_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL,
      Container_OVID VARCHAR2 (36) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_CLASSIFICATION_TYPES
MODIFY ( Type_ID VARCHAR2 (70) );

ALTER TABLE DMRS_CLASSIFICATION_TYPES
ADD ( Design_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_COLUMN_GROUPS
ADD ( ColumnGroup_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL,
      ColumnGroup_OVID VARCHAR2 (36) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_COLUMN_UI
ADD ( Object_Name VARCHAR2 (256) );

ALTER TABLE DMRS_COLUMNS
ADD ( Computed CHAR (1),
      ScopeEntity_Name VARCHAR2 (256) );

ALTER TABLE DMRS_DIAGRAM_ELEMENTS
ADD ( Source_Name VARCHAR2 (256),
      Target_Name VARCHAR2 (256),
      Model_Name VARCHAR2 (256) );

ALTER TABLE DMRS_DIAGRAMS
ADD ( Master_Diagram_Name VARCHAR2 (256),
      Subview_ID VARCHAR2 (70),
      Subview_OVID VARCHAR2 (36),
      Subview_Name VARCHAR2 (256),
      Display_ID VARCHAR2 (70),
      Display_OVID VARCHAR2 (36),
      Display_Name VARCHAR2 (256) );

ALTER TABLE DMRS_DOMAIN_AVT
MODIFY ( Domain_OVID VARCHAR2 (36) );

ALTER TABLE DMRS_DOMAIN_CHECK_CONSTRAINTS
MODIFY ( Domain_OVID VARCHAR2 (36) );

ALTER TABLE DMRS_DOMAIN_VALUE_RANGES
MODIFY ( Domain_OVID VARCHAR2 (36) );

ALTER TABLE DMRS_DOMAINS
ADD ( Design_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_ENTITIES
MODIFY ( Classification_Type_ID VARCHAR2 (70) );

ALTER TABLE DMRS_ENTITIES
ADD ( Model_Name VARCHAR2 (256),
      Substitution_Parent_Name VARCHAR2 (256),
      SuperTypeEntity_Name VARCHAR2 (256) );

ALTER TABLE DMRS_ENTITYVIEWS
ADD ( Model_Name VARCHAR2 (256) );

ALTER TABLE DMRS_FOREIGNKEYS
MODIFY ( Arc_ID VARCHAR2 (70) );

ALTER TABLE DMRS_FOREIGNKEYS
ADD ( Model_Name VARCHAR2 (256),
      Referred_Key_Name VARCHAR2 (256) );

ALTER TABLE DMRS_KEY_ATTRIBUTES
ADD ( Relationship_Name VARCHAR2 (256) );

ALTER TABLE DMRS_LARGE_TEXT
ADD ( Object_Name VARCHAR2 (256) );

ALTER TABLE DMRS_LOGICAL_TO_NATIVE
ADD ( Design_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_LOGICAL_TYPES
ADD ( Design_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_MAPPINGS
ADD ( Entity_ID VARCHAR2 (70),
      Entity_OVID VARCHAR2 (36),
      Table_ID VARCHAR2 (70),
      Table_OVID VARCHAR2 (36),
      Design_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_MODELS
ADD ( Design_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_NATIVE_TO_LOGICAL
ADD ( Design_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL,
      Design_Name VARCHAR2 (256) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_NOTES
ADD ( Object_Name VARCHAR2 (256) );

ALTER TABLE DMRS_PROCESS_ENTITIES
ADD ( Model_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL,
      Model_OVID VARCHAR2 (36) DEFAULT ' ' NOT NULL,
      Model_Name VARCHAR2 (256) );

ALTER TABLE DMRS_RDBMS_SITES
ADD ( Site_OVID VARCHAR2 (36) );

ALTER TABLE DMRS_RELATIONSHIPS
MODIFY ( Arc_ID VARCHAR2 (70) );

ALTER TABLE DMRS_RELATIONSHIPS
ADD ( Model_Name VARCHAR2 (256),
      Source_Name VARCHAR2 (256),
      Target_Name VARCHAR2 (256) );

ALTER TABLE DMRS_SPATIAL_COLUMN_DEFINITION
MODIFY ( Coordinate_System_ID VARCHAR2 (70) );

ALTER TABLE DMRS_SPATIAL_COLUMN_DEFINITION
ADD ( Spatial_Index_Name VARCHAR2 (256),
      Definition_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_SPATIAL_DIMENSIONS
ADD ( Definition_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_TABLES
MODIFY ( Classification_Type_ID VARCHAR2 (70) );

ALTER TABLE DMRS_TABLE_CONSTRAINTS
ADD ( Constraint_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL,
      Constraint_OVID VARCHAR2 (36) DEFAULT ' ' NOT NULL );

ALTER TABLE DMRS_TABLE_INCLUDE_SCRIPTS
ADD ( Table_Name VARCHAR2 (256) );

ALTER TABLE DMRS_TABLES
ADD ( Model_Name VARCHAR2 (256),
      Substitution_Parent_Name VARCHAR2 (256) );

ALTER TABLE DMRS_TABLEVIEWS
ADD ( Where_Clause VARCHAR2 (4000),
      Having_Clause VARCHAR2 (4000),
      Model_Name VARCHAR2 (256) );

ALTER TABLE DMRS_VALUE_RANGES
ADD ( Container_ID VARCHAR2 (70) DEFAULT ' ' NOT NULL,
      Container_OVID VARCHAR2 (36) DEFAULT ' ' NOT NULL );

--==========CREATE VIEWS==========
CREATE OR REPLACE FORCE VIEW DMRS_INSTALLATION AS select
1.5 DMRS_Persistence_Version,
1.0 DMRS_Reports_Version,
sysdate Created_On
from dual with read only;
				
CREATE VIEW DMRV_REPORTS_VERSION_1_0 AS select
1.5 DMRS_Persistence_Version,
1.0 DMRS_Reports_Version,
sysdate Created_On
from dual with read only;
			    
CREATE VIEW DMRV_ATTRIBUTES
(Attribute_Name, Object_ID, OVID, Import_ID, Container_ID, Container_OVID, Mandatory, DataType_Kind, Value_Type, Formula, 
ScopeEntity_ID, ScopeEntity_OVID, Domain_ID, Domain_OVID, Logical_Type_ID, Logical_Type_OVID, Distinct_Type_ID, 
Distinct_Type_OVID, Structured_Type_ID, Structured_Type_OVID, Collection_Type_ID, Collection_Type_OVID, Check_Constraint_Name, 
Default_Value, Use_Domain_Constraint, Domain_Name, Logical_Type_Name, Structured_Type_Name, Distinct_Type_Name, 
Collection_Type_Name, Synonyms, Preferred_Abbreviation, Relationship_ID, Relationship_OVID, Entity_Name, PK_Flag, FK_Flag, 
Relationship_Name, Sequence, T_Size, T_Precision, T_Scale, Data_Source, ScopeEntity_Name, Design_OVID) AS select 
 Attribute_Name, Object_ID, OVID, Import_ID, Container_ID, Container_OVID, Mandatory, DataType_Kind, Value_Type, Formula, 
ScopeEntity_ID, ScopeEntity_OVID, Domain_ID, Domain_OVID, Logical_Type_ID, Logical_Type_OVID, Distinct_Type_ID, 
Distinct_Type_OVID, Structured_Type_ID, Structured_Type_OVID, Collection_Type_ID, Collection_Type_OVID, Check_Constraint_Name, 
Default_Value, Use_Domain_Constraint, Domain_Name, Logical_Type_Name, Structured_Type_Name, Distinct_Type_Name, 
Collection_Type_Name, Synonyms, Preferred_Abbreviation, Relationship_ID, Relationship_OVID, Entity_Name, PK_Flag, FK_Flag, 
Relationship_Name, Sequence, T_Size, T_Precision, T_Scale, Data_Source, ScopeEntity_Name, Design_OVID from DMRS_ATTRIBUTES;

CREATE VIEW DMRV_AVT 
(DataElement_ID, DataElement_OVID, Type, Sequence, Value, Short_Description, Container_ID, Container_OVID, Container_Name, DataElement_Name, Design_OVID) AS select 
 DataElement_ID, DataElement_OVID, Type, Sequence, Value, Short_Description, Container_ID, Container_OVID, Container_Name, DataElement_Name, Design_OVID from DMRS_AVT;

CREATE VIEW DMRV_CHECK_CONSTRAINTS 
(DataElement_ID, DataElement_OVID, Type, Sequence, Constraint_Name, Text, Database_Type, Container_ID, Container_OVID, Container_Name, DataElement_Name, Design_OVID) AS select 
 DataElement_ID, DataElement_OVID, Type, Sequence, Constraint_Name, Text, Database_Type, Container_ID, Container_OVID, Container_Name, DataElement_Name, Design_OVID from DMRS_CHECK_CONSTRAINTS;

CREATE VIEW DMRV_CLASSIFICATION_TYPES
(Type_ID, Type_OVID, Type_Name, Design_ID, Design_OVID, Design_Name) AS select 
 Type_ID, Type_OVID, Type_Name, Design_ID, Design_OVID, Design_Name from DMRS_CLASSIFICATION_TYPES;

CREATE VIEW DMRV_COLLECTION_TYPES
(Design_ID, Design_OVID, Design_Name, Collection_Type_ID, Collection_Type_OVID, Collection_Type_Name, C_Type, 
DataType_ID, DataType_OVID, DataType_Name, DT_Type, DT_Ref, Max_Element, Predefined) AS select 
 Design_ID, Design_OVID, Design_Name, Collection_Type_ID, Collection_Type_OVID, Collection_Type_Name, C_Type, 
DataType_ID, DataType_OVID, DataType_Name, DT_Type, DT_Ref, Max_Element, Predefined from DMRS_COLLECTION_TYPES;

CREATE VIEW DMRV_COLUMN_GROUPS
(Table_ID, Table_OVID, Sequence, ColumnGroup_ID, ColumnGroup_OVID, ColumnGroup_Name, Columns, Notes, Table_Name, Design_OVID) AS select 
 Table_ID, Table_OVID, Sequence, ColumnGroup_ID, ColumnGroup_OVID, ColumnGroup_Name, Columns, Notes, Table_Name, Design_OVID from DMRS_COLUMN_GROUPS;

CREATE VIEW DMRV_COLUMN_UI 
(Label, Format_Mask, Form_Display_Width, Form_Maximum_Width, Display_As, Form_Height, Displayed_On_Forms, 
Displayed_On_Reports, Read_Only, Help_Text, Object_ID, Object_OVID, Object_Name, Design_OVID) AS select 
 Label, Format_Mask, Form_Display_Width, Form_Maximum_Width, Display_As, Form_Height, Displayed_On_Forms, 
Displayed_On_Reports, Read_Only, Help_Text, Object_ID, Object_OVID, Object_Name, Design_OVID from DMRS_COLUMN_UI;

CREATE VIEW DMRV_COLUMNS 
(Column_Name, Abbreviation, Object_ID, OVID, Import_ID, Container_ID, Container_OVID, Mandatory, DataType_Kind, Value_Type, 
Computed, Formula, ScopeEntity_ID, ScopeEntity_OVID, Domain_ID, Domain_OVID, Logical_Type_ID, Logical_Type_OVID, Distinct_Type_ID, 
Distinct_Type_OVID, Structured_Type_ID, Structured_Type_OVID, Collection_Type_ID, Collection_Type_OVID, Check_Constraint_Name, 
Default_Value, Use_Domain_Constraint, Domain_Name, Logical_Type_Name, Structured_Type_Name, Distinct_Type_Name, Collection_Type_Name, 
Uses_Default, Engineer, Table_Name, PK_Flag, FK_Flag, Native_Type, Sequence, Model_ID, Model_OVID, Model_Name, T_Size, T_Precision, T_Scale, 
Char_Units, Personally_ID_Information, Sensitive_Information, Mask_For_None_Production, ScopeEntity_Name, Design_OVID) AS select 
 Column_Name, Abbreviation, Object_ID, OVID, Import_ID, Container_ID, Container_OVID, Mandatory, DataType_Kind, Value_Type, 
Computed, Formula, ScopeEntity_ID, ScopeEntity_OVID, Domain_ID, Domain_OVID, Logical_Type_ID, Logical_Type_OVID, Distinct_Type_ID, 
Distinct_Type_OVID, Structured_Type_ID, Structured_Type_OVID, Collection_Type_ID, Collection_Type_OVID, Check_Constraint_Name, 
Default_Value, Use_Domain_Constraint, Domain_Name, Logical_Type_Name, Structured_Type_Name, Distinct_Type_Name, Collection_Type_Name, 
Uses_Default, Engineer, Table_Name, PK_Flag, FK_Flag, Native_Type, Sequence, Model_ID, Model_OVID, Model_Name, T_Size, T_Precision, T_Scale, 
Char_Units, Personally_ID_Information, Sensitive_Information, Mask_For_None_Production, ScopeEntity_Name, Design_OVID from DMRS_COLUMNS;
			    
CREATE VIEW DMRV_CONSTR_INDEX_COLUMNS
(Index_ID, Index_OVID, Column_ID, Column_OVID, Table_ID, Table_OVID, Index_Name, Table_Name, Column_Name, Sequence, Sort_Order, Design_OVID) AS select
 Index_ID, Index_OVID, Column_ID, Column_OVID, Table_ID, Table_OVID, Index_Name, Table_Name, Column_Name, Sequence, Sort_Order, Design_OVID from DMRS_CONSTR_INDEX_COLUMNS;

CREATE VIEW DMRV_DESIGNS
(Design_ID, Design_OVID, Design_Name, Date_Published, Published_By, Persistence_Version, Version_Comments) AS select
 Design_ID, Design_OVID, Design_Name, Date_Published, Published_By, Persistence_Version, Version_Comments from DMRS_DESIGNS;

CREATE VIEW DMRV_DIAGRAM_ELEMENTS 
(Name, Type, Geometry_Type, Object_ID, OVID, View_ID, Source_ID, Source_OVID, Source_View_ID, Target_ID, Target_OVID, 
Target_View_ID, Model_ID, Model_OVID, Location_X, Height, Width, BG_Color, FG_Color, Use_Default_Color, Formatting, 
Points, Diagram_OVID, Diagram_ID, Diagram_Name, Source_Name, Target_Name, Model_Name, Design_OVID) AS select 
 Name, Type, Geometry_Type, Object_ID, OVID, View_ID, Source_ID, Source_OVID, Source_View_ID, Target_ID, Target_OVID, 
Target_View_ID, Model_ID, Model_OVID, Location_X, Height, Width, BG_Color, FG_Color, Use_Default_Color, Formatting, 
Points, Diagram_OVID, Diagram_ID, Diagram_Name, Source_Name, Target_Name, Model_Name, Design_OVID from DMRS_DIAGRAM_ELEMENTS;

CREATE VIEW DMRV_DIAGRAMS 
(Diagram_Name, Object_ID, OVID, Diagram_Type, Is_Display, Visible, Master_Diagram_ID, Master_Diagram_OVID, Model_ID, 
Model_OVID, Model_Name, Subview_ID, Subview_OVID, Subview_Name, Display_ID, Display_OVID, Display_Name, 
Notation, Show_All_Details, Show_Names_Only, Show_Elements, Show_Datatype, Show_Keys, 
Autoroute, Box_In_box, Master_Diagram_Name, Diagram_SVG, Diagram_PDF, Design_OVID) AS select 
 Diagram_Name, Object_ID, OVID, Diagram_Type, Is_Display, Visible, Master_Diagram_ID, Master_Diagram_OVID, Model_ID, 
Model_OVID, Model_Name, Subview_ID, Subview_OVID, Subview_Name, Display_ID, Display_OVID, Display_Name, 
Notation, Show_All_Details, Show_Names_Only, Show_Elements, Show_Datatype, Show_Keys, 
Autoroute, Box_In_box, Master_Diagram_Name, Diagram_SVG, Diagram_PDF, Design_OVID from DMRS_DIAGRAMS;

CREATE VIEW DMRV_DISTINCT_TYPES
(Design_ID, Design_OVID, Design_Name, Distinct_Type_ID, Distinct_Type_OVID, Distinct_Type_Name, 
Logical_Type_ID, Logical_Type_OVID, Logical_Type_Name, T_Size, T_Precision, T_Scale) AS select 
 Design_ID, Design_OVID, Design_Name, Distinct_Type_ID, Distinct_Type_OVID, Distinct_Type_Name, 
Logical_Type_ID, Logical_Type_OVID, Logical_Type_Name, T_Size, T_Precision, T_Scale from DMRS_DISTINCT_TYPES;

CREATE VIEW DMRV_DOMAIN_AVT
(Domain_ID, Domain_OVID, Sequence, Value, Short_Description, Domain_Name, Design_OVID) AS select
 Domain_ID, Domain_OVID, Sequence, Value, Short_Description, Domain_Name, Design_OVID from DMRS_DOMAIN_AVT;

CREATE VIEW DMRV_DOMAIN_CHECK_CONSTRAINTS
(Domain_ID, Domain_OVID, Sequence, Text, Database_Type, Domain_Name, Design_OVID) AS select
 Domain_ID, Domain_OVID, Sequence, Text, Database_Type, Domain_Name, Design_OVID from DMRS_DOMAIN_CHECK_CONSTRAINTS;

CREATE VIEW DMRV_DOMAIN_VALUE_RANGES
(Domain_ID, Domain_OVID, Sequence, Begin_Value, End_Value, Short_Description, Domain_Name, Design_OVID) AS select
 Domain_ID, Domain_OVID, Sequence, Begin_Value, End_Value, Short_Description, Domain_Name, Design_OVID from DMRS_DOMAIN_VALUE_RANGES;

CREATE VIEW DMRV_DOMAINS
(Domain_ID, Domain_Name, OVID, Synonyms, Logical_Type_ID, Logical_Type_OVID, T_Size, T_Precision, 
T_Scale, Native_Type, LT_Name, Design_ID, Design_OVID, Design_Name, Char_Units) AS select 
 Domain_ID, Domain_Name, OVID, Synonyms, Logical_Type_ID, Logical_Type_OVID, T_Size, T_Precision, 
T_Scale, Native_Type, LT_Name, Design_ID, Design_OVID, Design_Name, Char_Units from DMRS_DOMAINS;

CREATE VIEW DMRV_ENTITIES 
(Entity_Name, Object_ID, OVID, Import_ID, Model_ID, Model_OVID, Structured_Type_ID, Structured_Type_OVID, Structured_Type_Name, 
Number_Data_Elements, Classification_Type_ID, Classification_Type_OVID, Classification_Type_Name, Allow_Type_Substitution, 
Min_Volume, Expected_Volume, Max_Volume, Growth_Rate_Percents, Growth_Rate_Interval, Normal_Form, Temporary_Object_Scope, 
Adequately_Normalized, Substitution_Parent, Substitution_Parent_OVID, Synonyms, Synonym_To_Display, Preferred_Abbreviation, 
SuperTypeEntity_ID, SuperTypeEntity_OVID, Engineering_Strategy, Owner, Entity_Source, Model_Name, Substitution_Parent_Name, 
SuperTypeEntity_Name, Design_OVID) AS select 
 Entity_Name, Object_ID, OVID, Import_ID, Model_ID, Model_OVID, Structured_Type_ID, Structured_Type_OVID, Structured_Type_Name, 
Number_Data_Elements, Classification_Type_ID, Classification_Type_OVID, Classification_Type_Name, Allow_Type_Substitution, 
Min_Volume, Expected_Volume, Max_Volume, Growth_Rate_Percents, Growth_Rate_Interval, Normal_Form, Temporary_Object_Scope, 
Adequately_Normalized, Substitution_Parent, Substitution_Parent_OVID, Synonyms, Synonym_To_Display, Preferred_Abbreviation, 
SuperTypeEntity_ID, SuperTypeEntity_OVID, Engineering_Strategy, Owner, Entity_Source, Model_Name, Substitution_Parent_Name, 
SuperTypeEntity_Name, Design_OVID from DMRS_ENTITIES;

CREATE VIEW DMRV_ENTITYVIEWS 
(EntityView_Name, Object_ID, OVID, Model_ID, Model_OVID, Import_ID, Structured_Type_ID, Structured_Type_OVID, 
Structured_Type_Name, User_Defined, View_Type, Model_Name, Design_OVID) AS select 
 EntityView_Name, Object_ID, OVID, Model_ID, Model_OVID, Import_ID, Structured_Type_ID, Structured_Type_OVID, 
Structured_Type_Name, User_Defined, View_Type, Model_Name, Design_OVID from DMRS_ENTITYVIEWS;

CREATE VIEW DMRV_FOREIGNKEYS 
(FK_Name, Model_ID, Model_OVID, Object_ID, OVID, Import_ID, Child_Table_Name, Referred_Table_Name, Engineer, 
Delete_Rule, Child_Table_ID, Child_Table_OVID, Referred_Table_ID, Referred_Table_OVID, Referred_Key_ID, 
Referred_Key_OVID, Number_Of_Columns, Mandatory, Transferable, In_Arc, Arc_ID, Model_Name, Referred_Key_Name, Design_OVID) AS select 
 FK_Name, Model_ID, Model_OVID, Object_ID, OVID, Import_ID, Child_Table_Name, Referred_Table_Name, Engineer, 
Delete_Rule, Child_Table_ID, Child_Table_OVID, Referred_Table_ID, Referred_Table_OVID, Referred_Key_ID, 
Referred_Key_OVID, Number_Of_Columns, Mandatory, Transferable, In_Arc, Arc_ID, Model_Name, Referred_Key_Name, Design_OVID from DMRS_FOREIGNKEYS;

CREATE VIEW DMRV_INDEXES 
(Index_Name, Object_ID, OVID, Import_ID, Container_ID, Container_OVID, State, Functional, Expression, Engineer, 
Table_Name, Spatial_Index, Spatial_Layer_Type, Geodetic_Index, Number_Of_Dimensions, Design_OVID) AS select 
 Index_Name, Object_ID, OVID, Import_ID, Container_ID, Container_OVID, State, Functional, Expression, Engineer, 
Table_Name, Spatial_Index, Spatial_Layer_Type, Geodetic_Index, Number_Of_Dimensions, Design_OVID from DMRS_INDEXES;

CREATE VIEW DMRV_KEY_ATTRIBUTES 
(Key_ID, Key_OVID, Attribute_ID, Attribute_OVID, Entity_ID, Entity_OVID, Key_Name, Entity_Name, 
Attribute_Name, Sequence, Relationship_ID, Relationship_OVID, Relationship_Name, Design_OVID) AS select 
 Key_ID, Key_OVID, Attribute_ID, Attribute_OVID, Entity_ID, Entity_OVID, Key_Name, Entity_Name, 
Attribute_Name, Sequence, Relationship_ID, Relationship_OVID, Relationship_Name, Design_OVID from DMRS_KEY_ATTRIBUTES;

CREATE VIEW DMRV_KEY_ELEMENTS
(Key_ID, Key_OVID, Type, Element_ID, Element_OVID, Element_Name, Sequence, Source_Label, Target_Label,
Entity_ID, Key_Name, Entity_OVID, Entity_Name, Design_OVID) AS select
 Key_ID, Key_OVID, Type, Element_ID, Element_OVID, Element_Name, Sequence, Source_Label, Target_Label,
Entity_ID, Key_Name, Entity_OVID, Entity_Name, Design_OVID from DMRS_KEY_ELEMENTS;

CREATE VIEW DMRV_KEYS 
(Key_Name, Object_ID, OVID, Import_ID, Container_ID, Container_OVID, State, Synonyms, Entity_Name, Design_OVID) AS select 
 Key_Name, Object_ID, OVID, Import_ID, Container_ID, Container_OVID, State, Synonyms, Entity_Name, Design_OVID from DMRS_KEYS;

CREATE VIEW DMRV_LARGE_TEXT 
(Object_ID, OVID, Object_Name, Type, Text, Design_OVID) AS select 
 Object_ID, OVID, Object_Name, Type, Text, Design_OVID from DMRS_LARGE_TEXT;
			    
CREATE VIEW DMRV_LOGICAL_TO_NATIVE
(Design_ID, Design_OVID, Design_Name, Logical_Type_ID, Logical_Type_OVID, LT_Name, Native_Type, 
RDBMS_Type, RDBMS_Version, Has_Size, Has_Precision, Has_Scale) AS select 
 Design_ID, Design_OVID, Design_Name, Logical_Type_ID, Logical_Type_OVID, LT_Name, Native_Type, 
RDBMS_Type, RDBMS_Version, Has_Size, Has_Precision, Has_Scale from DMRS_LOGICAL_TO_NATIVE;

CREATE VIEW DMRV_LOGICAL_TYPES
(Design_ID, Design_OVID, Design_Name, Logical_Type_ID, OVID, LT_Name) AS select 
 Design_ID, Design_OVID, Design_Name, Logical_Type_ID, OVID, LT_Name from DMRS_LOGICAL_TYPES;

CREATE VIEW DMRV_MAPPINGS
(Logical_Model_ID, Logical_Model_OVID, Logical_Model_Name, Logical_Object_ID, Logical_Object_OVID, Logical_Object_Name, 
Logical_Object_Type, Relational_Model_ID, Relational_Model_OVID, Relational_Model_Name, Relational_Object_ID, 
Relational_Object_OVID, Relational_Object_Name, Relational_Object_Type, Entity_ID, Entity_OVID, Entity_Name, 
Table_ID, Table_OVID, Table_Name, Design_ID, Design_OVID, Design_Name) AS select 
 Logical_Model_ID, Logical_Model_OVID, Logical_Model_Name, Logical_Object_ID, Logical_Object_OVID, Logical_Object_Name, 
Logical_Object_Type, Relational_Model_ID, Relational_Model_OVID, Relational_Model_Name, Relational_Object_ID, 
Relational_Object_OVID, Relational_Object_Name, Relational_Object_Type, Entity_ID, Entity_OVID, Entity_Name, 
Table_ID, Table_OVID, Table_Name, Design_ID, Design_OVID, Design_Name from DMRS_MAPPINGS;

CREATE VIEW DMRV_MODEL_NAMING_OPTIONS
(Object_type, Max_Name_Length, Character_Case, Valid_Characters,
Model_ID, Model_OVID, Model_Name, Model_Type, Design_OVID) AS select
 Object_type, Max_Name_Length, Character_Case, Valid_Characters,
Model_ID, Model_OVID, Model_Name, Model_Type, Design_OVID from DMRS_MODEL_NAMING_OPTIONS;

CREATE VIEW DMRV_MODELS
(Design_ID, Design_OVID, Design_Name, Model_ID, Model_OVID, Model_Name, Model_Type, RDBMS_Type) AS select 
 Design_ID, Design_OVID, Design_Name, Model_ID, Model_OVID, Model_Name, Model_Type, RDBMS_Type from DMRS_MODELS;

CREATE VIEW DMRV_MODEL_SUBVIEWS 
(Subview_ID, Subview_OVID, Subview_Name, Model_ID, Model_OVID, Model_Name, Design_OVID) AS select 
 Subview_ID, Subview_OVID, Subview_Name, Model_ID, Model_OVID, Model_Name, Design_OVID from DMRS_MODEL_SUBVIEWS;

CREATE VIEW DMRV_MODEL_DISPLAYS 
(Display_ID, Display_OVID, Display_Name, Model_ID, Model_OVID, Model_Name, Design_OVID) AS select 
 Display_ID, Display_OVID, Display_Name, Model_ID, Model_OVID, Model_Name, Design_OVID from DMRS_MODEL_DISPLAYS;

CREATE VIEW DMRV_NATIVE_TO_LOGICAL 
(RDBMS_Type, RDBMS_Version, Native_Type, LT_Name, Logical_Type_ID, Logical_Type_OVID, Design_ID, Design_OVID, Design_Name) AS select 
 RDBMS_Type, RDBMS_Version, Native_Type, LT_Name, Logical_Type_ID, Logical_Type_OVID, Design_ID, Design_OVID, Design_Name from DMRS_NATIVE_TO_LOGICAL;

CREATE VIEW DMRV_NOTES 
(Object_ID, OVID, Object_Name, Model_OVID, Model_ID, Model_Name, Design_OVID) AS select 
 Object_ID, OVID, Object_Name, Model_OVID, Model_ID, Model_Name, Design_OVID from DMRS_NOTES;

CREATE VIEW DMRV_PK_OID_COLUMNS
(Column_ID, Column_OVID, Table_ID, Table_OVID, Table_Name, Column_Name, Design_OVID) AS select
 Column_ID, Column_OVID, Table_ID, Table_OVID, Table_Name, Column_Name, Design_OVID from DMRS_PK_OID_COLUMNS;

CREATE VIEW DMRV_PROCESS_ATTRIBUTES
(Process_ID, Process_OVID, Entity_ID, Entity_OVID, Flow_ID, Flow_OVID, DFD_ID, DFD_OVID, Process_Name,
Entity_Name, Flow_Name, DFD_Name, OP_Read, OP_Create, OP_Update, OP_Delete, CRUD_Code, Flow_Direction,
Attribute_ID, Attribute_OVID, Attribute_Name, Design_OVID) AS select
 Process_ID, Process_OVID, Entity_ID, Entity_OVID, Flow_ID, Flow_OVID, DFD_ID, DFD_OVID, Process_Name,
Entity_Name, Flow_Name, DFD_Name, OP_Read, OP_Create, OP_Update, OP_Delete, CRUD_Code, Flow_Direction,
Attribute_ID, Attribute_OVID, Attribute_Name, Design_OVID from DMRS_PROCESS_ATTRIBUTES;

CREATE VIEW DMRV_PROCESS_ENTITIES 
(Process_ID, Process_OVID, Entity_ID, Entity_OVID, Flow_ID, Flow_OVID, DFD_ID, DFD_OVID, Process_Name, Entity_Name, 
Flow_Name, DFD_Name, OP_Read, OP_Create, OP_Update, OP_Delete, CRUD_Code, Flow_Direction, Model_ID, Model_OVID, 
Model_Name, Design_OVID) AS select 
 Process_ID, Process_OVID, Entity_ID, Entity_OVID, Flow_ID, Flow_OVID, DFD_ID, DFD_OVID, Process_Name, Entity_Name, 
Flow_Name, DFD_Name, OP_Read, OP_Create, OP_Update, OP_Delete, CRUD_Code, Flow_Direction, Model_ID, Model_OVID, 
Model_Name, Design_OVID from DMRS_PROCESS_ENTITIES;

CREATE VIEW DMRV_RDBMS_SITES
(Site_Name, Site_ID, Site_OVID, RDBMS_Type, Design_OVID) AS select 
 Site_Name, Site_ID, Site_OVID, RDBMS_Type, Design_OVID from DMRS_RDBMS_SITES;

CREATE VIEW DMRV_RELATIONSHIPS 
(Relationship_Name, Model_ID, Model_OVID, Object_ID, OVID, Import_ID, Source_Entity_Name, Target_Entity_Name, Source_Label, 
Target_Label, SourceTo_Target_Cardinality, TargetTo_Source_Cardinality, Source_Optional, Target_Optional, Dominant_Role, Identifying, 
Source_ID, Source_OVID, Target_ID, Target_OVID, Number_Of_Attributes, Transferable, In_Arc, Arc_ID, Model_Name, Design_OVID) AS select 
 Relationship_Name, Model_ID, Model_OVID, Object_ID, OVID, Import_ID, Source_Entity_Name, Target_Entity_Name, Source_Label, 
Target_Label, SourceTo_Target_Cardinality, TargetTo_Source_Cardinality, Source_Optional, Target_Optional, Dominant_Role, Identifying, 
Source_ID, Source_OVID, Target_ID, Target_OVID, Number_Of_Attributes, Transferable, In_Arc, Arc_ID, Model_Name, Design_OVID from DMRS_RELATIONSHIPS;

CREATE VIEW DMRV_SPATIAL_COLUMN_DEFINITION 
(Table_ID, Table_OVID, Definition_ID, Definition_OVID, Definition_Name, Table_Name, Column_ID, Column_OVID, Column_Name, Use_Function, 
Function_Expression, Coordinate_System_ID, Has_Spatial_Index, Spatial_Index_ID, Spatial_Index_OVID, Spatial_Index_Name, Design_OVID) AS select 
 Table_ID, Table_OVID, Definition_ID, Definition_OVID, Definition_Name, Table_Name, Column_ID, Column_OVID, Column_Name, Use_Function, 
Function_Expression, Coordinate_System_ID, Has_Spatial_Index, Spatial_Index_ID, Spatial_Index_OVID, Spatial_Index_Name, Design_OVID from DMRS_SPATIAL_COLUMN_DEFINITION;

CREATE VIEW DMRV_SPATIAL_DIMENSIONS 
(Definition_ID, Definition_OVID, Definition_Name, Dimension_Name, Low_Boundary, Upper_Boundary, Tolerance, Design_OVID) AS select 
 Definition_ID, Definition_OVID, Definition_Name, Dimension_Name, Low_Boundary, Upper_Boundary, Tolerance, Design_OVID from DMRS_SPATIAL_DIMENSIONS;

CREATE VIEW DMRV_STRUCTURED_TYPES
(Design_ID, Design_OVID, Design_Name, Structured_Type_ID, Structured_Type_OVID, Structured_Type_Name, 
Super_Type_ID, Super_Type_OVID, Super_Type_Name, Predefined, ST_Final, ST_Instantiable) AS select 
 Design_ID, Design_OVID, Design_Name, Structured_Type_ID, Structured_Type_OVID, Structured_Type_Name, 
Super_Type_ID, Super_Type_OVID, Super_Type_Name, Predefined, ST_Final, ST_Instantiable from DMRS_STRUCTURED_TYPES;

CREATE VIEW DMRV_STRUCT_TYPE_ATTRS 
(Attribute_ID, Attribute_OVID, Attribute_Name, Structured_Type_ID, Structured_Type_OVID, Structured_Type_Name, 
Mandatory, Reference, T_Size, T_Precision, T_Scale, Type_ID, Type_OVID, Type_Name, Design_OVID) AS SELECT
 Attribute_ID, Attribute_OVID, Attribute_Name, Structured_Type_ID, Structured_Type_OVID, Structured_Type_Name, 
Mandatory, Reference, T_Size, T_Precision, T_Scale, Type_ID, Type_OVID, Type_Name, Design_OVID FROM DMRS_STRUCT_TYPE_ATTRS;

CREATE VIEW DMRV_STRUCT_TYPE_METHOD_PARS 
(Parameter_ID, Parameter_OVID, Parameter_Name, Method_ID, Method_OVID, Method_Name, 
Return_Value, Reference, Seq, T_Size, T_Precision, T_Scale, Type_ID, Type_OVID, Type_Name, Design_OVID) AS SELECT 
 Parameter_ID, Parameter_OVID, Parameter_Name, Method_ID, Method_OVID, Method_Name, 
Return_Value, Reference, Seq, T_Size, T_Precision, T_Scale, Type_ID, Type_OVID, Type_Name, Design_OVID FROM DMRS_STRUCT_TYPE_METHOD_PARS;

CREATE VIEW DMRV_STRUCT_TYPE_METHODS 
(Method_ID, Method_OVID, Method_Name, Structured_Type_ID, Structured_Type_OVID, Structured_Type_Name, 
Body, Constructor, Overridden_Method_ID, Overridden_Method_OVID, Overridden_Method_Name, Design_OVID) AS SELECT 
 Method_ID, Method_OVID, Method_Name, Structured_Type_ID, Structured_Type_OVID, Structured_Type_Name, 
Body, Constructor, Overridden_Method_ID, Overridden_Method_OVID, Overridden_Method_Name, Design_OVID FROM DMRS_STRUCT_TYPE_METHODS;

CREATE VIEW DMRV_TABLE_CONSTRAINTS
(Table_ID, Table_OVID, Sequence, Constraint_ID, Constraint_OVID, Constraint_Name, Text, Table_Name, Design_OVID) AS select 
 Table_ID, Table_OVID, Sequence, Constraint_ID, Constraint_OVID, Constraint_Name, Text, Table_Name, Design_OVID from DMRS_TABLE_CONSTRAINTS;
			    
CREATE VIEW DMRV_TABLE_INCLUDE_SCRIPTS 
(Table_ID, Table_OVID, Table_Name, Type, Sequence, Text, Design_OVID) AS select 
 Table_ID, Table_OVID, Table_Name, Type, Sequence, Text, Design_OVID from DMRS_TABLE_INCLUDE_SCRIPTS;

CREATE VIEW DMRV_TABLES 
(Table_Name, Abbreviation, Object_ID, OVID, Import_ID, Model_ID, Model_OVID, Structured_Type_ID, Structured_Type_OVID, 
Structured_Type_Name, Number_Data_Elements, Classification_Type_ID, Classification_Type_OVID, Classification_Type_Name, 
Allow_Type_Substitution, Min_Volume, Expected_Volume, Max_Volume, Growth_Rate_Percents, Growth_Rate_Interval, 
Normal_Form, Temporary_Object_Scope, Adequately_Normalized, Substitution_Parent, Substitution_Parent_OVID, Engineer, 
Spatial_Table, OID_is_PK, OID_is_User_Defined, Include_Scripts_Into_DDL, Model_Name, Substitution_Parent_Name, Design_OVID) AS select 
 Table_Name, Abbreviation, Object_ID, OVID, Import_ID, Model_ID, Model_OVID, Structured_Type_ID, Structured_Type_OVID, 
Structured_Type_Name, Number_Data_Elements, Classification_Type_ID, Classification_Type_OVID, Classification_Type_Name, 
Allow_Type_Substitution, Min_Volume, Expected_Volume, Max_Volume, Growth_Rate_Percents, Growth_Rate_Interval, 
Normal_Form, Temporary_Object_Scope, Adequately_Normalized, Substitution_Parent, Substitution_Parent_OVID, Engineer, 
Spatial_Table, OID_is_PK, OID_is_User_Defined, Include_Scripts_Into_DDL, Model_Name, Substitution_Parent_Name, Design_OVID from DMRS_TABLES;

CREATE VIEW DMRV_TABLEVIEWS 
(TableView_Name, Object_ID, OVID, Import_ID, Model_ID, Model_OVID, Structured_Type_ID, Structured_Type_OVID, 
Structured_Type_Name, Where_Clause, Having_Clause, User_Defined, Engineer, Allow_Type_Substitution, OID_Columns, 
Model_Name, Design_OVID) AS select 
 TableView_Name, Object_ID, OVID, Import_ID, Model_ID, Model_OVID, Structured_Type_ID, Structured_Type_OVID, 
Structured_Type_Name, Where_Clause, Having_Clause, User_Defined, Engineer, Allow_Type_Substitution, OID_Columns, 
Model_Name, Design_OVID from DMRS_TABLEVIEWS;

CREATE VIEW DMRV_VALUE_RANGES
(DataElement_ID, DataElement_OVID, Type, Sequence, Begin_Value, End_Value, Short_Description, 
Container_ID, Container_OVID, Container_Name, DataElement_Name, Design_OVID) AS select 
 DataElement_ID, DataElement_OVID, Type, Sequence, Begin_Value, End_Value, Short_Description, 
Container_ID, Container_OVID, Container_Name, DataElement_Name, Design_OVID from DMRS_VALUE_RANGES;
			    
CREATE VIEW DMRV_VIEW_COLUMNS
(View_OVID, View_ID, View_Name, Container_ID, Container_OVID, Container_Name, Container_Alias,
Is_Expression, Column_ID, Column_OVID, Column_Name, Column_Alias, Native_Type, Type, Expression,
Sequence, Personally_ID_Information, Sensitive_Information, Mask_For_None_Production,
Model_ID, Model_OVID, Model_Name, Design_OVID) AS select
 View_OVID, View_ID, View_Name, Container_ID, Container_OVID, Container_Name, Container_Alias,
Is_Expression, Column_ID, Column_OVID, Column_Name, Column_Alias, Native_Type, Type, Expression,
Sequence, Personally_ID_Information, Sensitive_Information, Mask_For_None_Production,
Model_ID, Model_OVID, Model_Name, Design_OVID from DMRS_VIEW_COLUMNS;
			    
CREATE VIEW DMRV_VIEW_CONTAINERS
(View_OVID, View_ID, View_Name, Container_ID, Container_OVID, Container_Name, Type,
Alias, Sequence, Model_ID, Model_OVID, Model_Name, Design_OVID) AS select
 View_OVID, View_ID, View_Name, Container_ID, Container_OVID, Container_Name, Type,
Alias, Sequence, Model_ID, Model_OVID, Model_Name, Design_OVID from DMRS_VIEW_CONTAINERS;
			    
CREATE VIEW DMRV_VIEW_ORDER_GROUPBY
(View_OVID, View_ID, View_Name, Container_ID, Container_OVID, Container_Name,
Container_Alias, Is_Expression, Usage, Sequence, Column_ID, Column_OVID, Column_Name,
Column_Alias, Sort_Order, Expression, Design_OVID) AS select
 View_OVID, View_ID, View_Name, Container_ID, Container_OVID, Container_Name,
Container_Alias, Is_Expression, Usage, Sequence, Column_ID, Column_OVID, Column_Name,
Column_Alias, Sort_Order, Expression, Design_OVID from DMRS_VIEW_ORDER_GROUPBY;

--==========CREATE INDEXES==========
CREATE INDEX VIEW_COLUMNS_FK_IDX ON DMRS_VIEW_COLUMNS (VIEW_OVID ASC);
				
CREATE INDEX VIEW_CONTAINERS_FK_IDX ON DMRS_VIEW_CONTAINERS (VIEW_OVID ASC);
				
CREATE INDEX VIEW_ORDER_GROUPBY_FK_IDX ON DMRS_VIEW_ORDER_GROUPBY (VIEW_OVID ASC);

CREATE INDEX STRUCT_TYPE_ATTRS_FK_IDX ON DMRS_STRUCT_TYPE_ATTRS (STRUCTURED_TYPE_OVID ASC);

CREATE INDEX STRUCT_TYPE_METHODS_FK_IDX ON DMRS_STRUCT_TYPE_METHODS (STRUCTURED_TYPE_OVID ASC);

CREATE INDEX MODEL_SUBVIEWS_FK_IDX ON DMRS_MODEL_SUBVIEWS (MODEL_OVID ASC);

CREATE INDEX MODEL_DISPLAYS_FK_IDX ON DMRS_MODEL_DISPLAYS (MODEL_OVID ASC);

CREATE INDEX STRUCT_TYPE_METHOD_PARS_FK_IDX ON DMRS_STRUCT_TYPE_METHOD_PARS (METHOD_OVID ASC);

