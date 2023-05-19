-- this file was generated

WHENEVER SQLERROR EXIT SQL.SQLCODE;

EXECUTE dbms_output.put_line('Start install of xml schema. ' || systimestamp);

ALTER session set current_schema = "SYS";
/
DECLARE
  schema_exist NUMBER;
BEGIN
  SELECT COUNT(*) INTO schema_exist FROM ALL_XML_SCHEMAS WHERE SCHEMA_URL='http://xmlns.oracle.com/odmr11/odmr.xsd';
  IF (schema_exist > 0) THEN
    DBMS_XMLSCHEMA.DELETESCHEMA('http://xmlns.oracle.com/odmr11/odmr.xsd', DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
    SELECT COUNT(*) INTO schema_exist FROM ALL_XML_SCHEMAS WHERE SCHEMA_URL='http://xmlns.oracle.com/odmr11/odmr.xsd';
    IF (schema_exist > 0) THEN
      DBMS_OUTPUT.PUT_LINE('Dropped Data Miner Workflow XML Schema failed.');
      RAISE_APPLICATION_ERROR(-20999, 'Dropped Data Miner Workflow XML Schema failed.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Dropped Data Miner Workflow XML Schema success.');
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN
  RAISE;
END;
/

ALTER session set current_schema = "SYS";

SET DEFINE OFF

DECLARE
  db_ver VARCHAR2(30);
  -- Declare a CLOB variable
  schema1 CLOB;
  schema2 CLOB;
  schema3 CLOB;
  schema4 CLOB;
  schema5 CLOB;
  schema6 CLOB;
  schema7 CLOB;
BEGIN
  SELECT VERSION INTO db_ver FROM product_component_version WHERE product LIKE 'Oracle Database%' OR product like 'Personal Oracle Database%';
  IF ( INSTR(db_ver, '11.2.0.3') > 0 
    OR INSTR(db_ver, '11.2.0.2') > 0 
    OR INSTR(db_ver, '11.2.0.1') > 0 
    OR INSTR(db_ver, '11.2.0.0') > 0) THEN
schema1 := '<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns="http://xmlns.oracle.com/odmr11"
           xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns:xdb="http://xmlns.oracle.com/xdb"
           targetNamespace="http://xmlns.oracle.com/odmr11"
           elementFormDefault="qualified" attributeFormDefault="unqualified"
           version="12.2.0.0.1" xdb:storeVarrayAsTable="true">
 <xs:element name="WorkflowProcess" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element name="Nodes" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:sequence>
       <xs:element ref="DataSource" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="DATA_SOURCE_TAB" xdb:SQLInline="false"  />
       <xs:element ref="DataProfile" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="DATA_PROFILE_TAB" xdb:SQLInline="false"/>
       <xs:element ref="CreateTable" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="CREATE_TABLE_TAB" xdb:SQLInline="false"/>
       <xs:element ref="UpdateTable" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="UPDATE_TABLE_TAB" xdb:SQLInline="false"/>
       <xs:element ref="Aggregation" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="AGGREGATION_TAB" xdb:SQLInline="false"/>
       <!-- Transformation Start -->
       <xs:element ref="Transformation" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="TRANSFORMATION_TAB" xdb:SQLInline="false"/>
       <!-- Transformation End -->
       <xs:element ref="Join" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="JOIN_TAB" xdb:SQLInline="false"/>
       <xs:element maxOccurs="unbounded" ref="BuildTextRef" minOccurs="0" xdb:defaultTable="BUILD_TEXT_REF_TAB" xdb:SQLInline="false"/>
       <xs:element maxOccurs="unbounded" minOccurs="0" ref="ApplyText" xdb:defaultTable="APPLY_TEXT_TAB" xdb:SQLInline="false"/>
       <xs:element ref="BuildText" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="BUILD_TEXT_TAB" xdb:SQLInline="false"/>
       <xs:element ref="Sample" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="SAMPLE_TAB" xdb:SQLInline="false"/>
       <xs:element ref="ColumnFilter" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="COLUMN_FILTER_TAB" xdb:SQLInline="false"/>
       <xs:element ref="RowFilter" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="ROW_FILTER_TAB" xdb:SQLInline="false"/>
       <xs:element ref="ClassificationBuild" minOccurs="0"
                   maxOccurs="unbounded" xdb:defaultTable="CLASSIFICATION_BUILD_TAB" xdb:SQLInline="false"/>
       <xs:element ref="RegressionBuild" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="REGRESSION_BUILD_TAB" xdb:SQLInline="false"/>
       <xs:element ref="ClusteringBuild" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="CLUSTERING_BUILD_TAB" xdb:SQLInline="false"/>
       <xs:element ref="AssociationBuild" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="ASSOCIATION_BUILD_TAB" xdb:SQLInline="false"/>
       <xs:element ref="FeatureExtractionBuild" minOccurs="0"
                   maxOccurs="unbounded" xdb:defaultTable="FEATURE_EXT_BUILD_TAB" xdb:SQLInline="false"/>
       <xs:element ref="AnomalyDetectionBuild" minOccurs="0"
                   maxOccurs="unbounded" xdb:defaultTable="ANOMALY_DETECT_BUILD_TAB" xdb:SQLInline="false"/>
       <xs:element ref="Model" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="MODEL_TAB" xdb:SQLInline="false"/>
       <xs:element ref="Apply" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="APPLY_TAB" xdb:SQLInline="false"/>
       <xs:element ref="Test" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="TEST_TAB" xdb:SQLInline="false"/>
       <xs:element ref="ModelDetails" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="MODEL_DETAILS_TAB" xdb:SQLInline="false"/>
       <xs:element ref="TestDetails" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="TEST_DETAILS_TAB" xdb:SQLInline="false"/>
       <xs:element ref="FilterDetails" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="FILTER_DETAILS_TAB" xdb:SQLInline="false"/>
       <xs:element ref="DynamicPrediction" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="DYNAMIC_PREDICT_TAB" xdb:SQLInline="false"/>
       <xs:element ref="DynamicFeature" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="DYNAMIC_FEATURE_TAB" xdb:SQLInline="false"/>
       <xs:element ref="DynamicCluster" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="DYNAMIC_CLUSTER_TAB" xdb:SQLInline="false"/>
       <xs:element ref="DynamicAnomaly" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="DYNAMIC_ANOMALY_TAB" xdb:SQLInline="false"/>
       <xs:element ref="SQLQuery" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="SQL_QUERY_TAB" xdb:SQLInline="false"/>
       <xs:element ref="Graph" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="GRAPH_TAB" xdb:SQLInline="false"/>
       <xs:element ref="JSONQuery" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="JSON_QUERY_TAB" xdb:SQLInline="false"/>
       <xs:element ref="FeatureCompare" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="FEATURE_COMPARE_TAB" xdb:SQLInline="false"/>
       <xs:element ref="ExplicitFeatureExtractionBuild" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="EFE_BUILD_TAB" xdb:SQLInline="false"/>
       <xs:element ref="RBuild" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="R_BUILD_TAB" xdb:SQLInline="false"/>
      </xs:sequence>
     </xs:complexType>
    </xs:element>
    <xs:element name="Links" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:sequence>
       <xs:element ref="Link" maxOccurs="unbounded" minOccurs="0" xdb:defaultTable="LINKS_TAB" xdb:SQLInline="false"/>
      </xs:sequence>
     </xs:complexType>
    </xs:element>
    <xs:element minOccurs="0" ref="Messages"/>
    <xs:element name="Comment" minOccurs="0" type="xs:string"/>
   </xs:sequence>
   <xs:attribute name="Version" type="xs:string" use="required"/>
   <xs:attribute name="DBVersion" type="xs:string" use="optional"/>
   <xs:attribute name="Schema" type="xs:string" use="optional"/>
  </xs:complexType>
 </xs:element>
 <!-- Transformation Start -->
 <!-- Transformation End -->
 <xs:element name="Aggregation" type="AggregationNodeType" xdb:defaultTable=""/>
 <xs:element name="AggregationElement" type="AggregationElementType"
             xdb:defaultTable=""/>
 <xs:element name="AggregationElements" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="AggregationElement" maxOccurs="unbounded" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <xs:element name="AnomalyDetectionBuild" type="AnomalyDetectionBuildNodeType"
             xdb:defaultTable=""/>
 <xs:element name="Apply" type="ApplyNodeType" xdb:defaultTable=""/>
 <xs:element name="AssociationBuild" type="AssociationBuildNodeType"
             xdb:defaultTable=""/>
 <xs:element name="Attribute" type="AttributeType" xdb:defaultTable=""/>
 <xs:element name="Attributes" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="Attribute" maxOccurs="unbounded" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <!--Agg.Node start-->
 <!--Agg.Node end-->
 <xs:element name="BuildDataSource" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:attribute name="SourceId" use="required" type="xs:string"/>
  </xs:complexType>
 </xs:element>
 <xs:element name="BuildTextRef" type="BuildTextNodeRefType" xdb:defaultTable=""/>
 <xs:element name="ApplyText" type="ApplyTextNodeType" xdb:defaultTable=""/>
 <xs:element name="BuildText" type="BuildTextNodeType" xdb:defaultTable=""/>
 <xs:element name="CacheSettings" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence minOccurs="0">
    <xs:choice>
     <xs:element name="NumberOfRows" default="2000" minOccurs="0">
      <xs:simpleType>
       <xs:restriction base="xs:long">
        <xs:minInclusive value="1"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:element>
     <xs:element name="PercentOfTotal" default="10" minOccurs="0">
      <xs:simpleType>
       <xs:restriction base="xs:double">
        <xs:maxInclusive value="100"/>
        <xs:minInclusive value="1"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:element>
    </xs:choice>
    <xs:element name="Method">
     <xs:complexType xdb:maintainDOM="true">
      <xs:choice>
       <xs:element name="Random" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:attribute name="Seed" type="xs:integer" use="required"/>
        </xs:complexType>
       </xs:element>
       <xs:element name="Stratified" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:attribute name="TargetAttr" type="xs:string" use="required">
         </xs:attribute>
        </xs:complexType>
       </xs:element>
       <xs:element name="TopN" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true"/>
       </xs:element>
      </xs:choice>
     </xs:complexType>
    </xs:element>
    <xs:element ref="OutputTable" minOccurs="0"/>
   </xs:sequence>
   <xs:attribute name="UseFullData" type="xs:boolean" use="optional"
                 default="false"/>
   <xs:attribute name="GenerateCache" type="xs:boolean" use="required"/>
  </xs:complexType>
 </xs:element>
 <xs:element name="CaseAttributes" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="Attribute" maxOccurs="unbounded" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <xs:element name="ASSO_AGGREGATES" xdb:defaultTable="">
   <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="Attribute" maxOccurs="unbounded" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <xs:element name="CGeneralizedLinearAlgo" type="CGeneralizedLinearAlgoType"
             xdb:defaultTable=""/>
 <xs:element name="CGeneralizedLinearModel" type="CGeneralizedLinearModelType"
             xdb:defaultTable=""/>
 <xs:element name="ClassificationBuild" type="ClassificationBuildNodeType"
             xdb:defaultTable=""/>
 <xs:element name="ClassificationResult"
             xdb:defaultTable="" type="ClassificationResultType"/>
 <xs:element name="ClusteringBuild" type="ClusteringBuildNodeType"
             xdb:defaultTable=""/>
 <xs:element name="ColumnFilter" type="ColumnFilterNodeType"
             xdb:defaultTable=""/>
 <xs:element name="ConfusionMatrix" type="ResultType" xdb:defaultTable=""/>
 <xs:element name="ConnectorGraphicsInfo" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="Coordinates" minOccurs="0" maxOccurs="unbounded"/>
   </xs:sequence>
   <xs:attribute name="Style" type="xs:string" use="optional"/>
   <xs:attribute name="BorderColor" type="xs:string" use="optional"/>
   <xs:attribute name="FillColor" type="xs:string" use="optional"/>
  </xs:complexType>
 </xs:element>
 <xs:element name="Coordinates" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:attribute name="XCoordinate" type="xs:double" use="required"/>
   <xs:attribute name="YCoordinate" type="xs:double" use="required"/>
  </xs:complexType>
 </xs:element>
 <xs:element name="CostMatrix" type="CostMatrixType" xdb:defaultTable=""/>
 <xs:element name="CreateTable" type="CreateTableNodeType" xdb:defaultTable=""/>
 <xs:element name="CSupportVectorMachineModel"
             type="CSupportVectorMachineModelType" xdb:defaultTable=""/>
 <xs:element name="CSupportVectorMachineAlgo"
             type="CSupportVectorMachineAlgoType" xdb:defaultTable=""/>
 <xs:element name="DataProfile" type="DataProfileNodeType" xdb:defaultTable=""/>
 <xs:element name="DBAttribute" type="DBColumnType" xdb:defaultTable=""/>
 <xs:element name="DBAttributes" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="DBAttribute" maxOccurs="unbounded" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <xs:element name="DataSource" type="DataSourceNodeType" xdb:defaultTable=""/>
 <xs:element name="DecisionTreeAlgo" type="DecisionTreeAlgoType"
             xdb:defaultTable=""/>
 <xs:element name="DecisionTreeModel" type="DecisionTreeModelType"
             xdb:defaultTable=""/>                         
 <xs:element name="FeatureExtractionBuild" type="FeatureExtractionBuildNodeType"
             xdb:defaultTable=""/> 
 <xs:element name="FilterDetails" type="FilterDetailsDataNodeType"
             xdb:defaultTable=""/>
 <xs:element name="Icon" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:simpleContent>
    <xs:extension base="xs:string">
     <xs:attribute name="XCOORD" type="xs:integer" use="required"/>
     <xs:attribute name="YCOORD" type="xs:integer" use="required"/>
     <xs:attribute name="WIDTH" type="xs:integer" use="optional"/>
     <xs:attribute name="HEIGHT" type="xs:integer" use="optional"/>
     <xs:attribute name="BorderColor" type="xs:string" use="optional"/>
     <xs:attribute name="FillColor" type="xs:string" use="optional"/>
     <xs:attribute name="SHAPE" use="optional" default="RoundRectangle">
      <xs:simpleType>
       <xs:restriction base="xs:NMTOKEN">
        <xs:enumeration value="RoundRectangle"/>
        <xs:enumeration value="Rectangle"/>
        <xs:enumeration value="Ellipse"/>
        <xs:enumeration value="Diamond"/>
        <xs:enumeration value="Ellipse"/>
        <xs:enumeration value="UpTriangle"/>
        <xs:enumeration value="DownTriangle"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
    </xs:extension>
   </xs:simpleContent>
  </xs:complexType>
 </xs:element>
 <xs:element name="InputMiningData" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="MiningAttributes" minOccurs="0"/>
    <xs:element name="HeuristicResult" type="HeuristicResultType" minOccurs="0"/>
   </xs:sequence>
   <xs:attribute name="DataUsage" use="required" type="InputMiningDataType"/>
   <xs:attribute name="MiningUsage" type="InputMiningDataType" use="required"/>
  </xs:complexType>
 </xs:element>
 <xs:element name="Join" type="JoinNodeType" xdb:defaultTable=""/>
 <xs:element name="Lifts" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element name="Lift" type="TargetResultType" minOccurs="0"
                maxOccurs="unbounded"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <xs:element name="Link" type="GeneralLinkType" xdb:defaultTable=""/>
 <xs:element name="Messages" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element name="Message" maxOccurs="unbounded" type="MessageType"
                minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <xs:element name="MiningAttribute" type="MiningAttributeType"
             xdb:defaultTable=""/>
 <xs:element name="MiningAttributes" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="MiningAttribute" maxOccurs="unbounded" minOccurs="0" xdb:defaultTable="MINING_ATTRIBUTE_TAB" xdb:SQLInline="false"/>
   </xs:sequence>
   <xs:attribute name="AutoSpec" type="AutoSpecType" use="optional"/>
  </xs:complexType>
 </xs:element>
 <xs:element name="Model" type="ModelNodeType" xdb:defaultTable=""/>
 <xs:element name="ModelDetails" type="ModelDetailsDataNodeType"
             xdb:defaultTable=""/>
 <xs:element name="ModelSettingsODM" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element name="ModelSettingODM" maxOccurs="unbounded"
                type="ModelSettingODMType" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <xs:element name="NaiveBayesAlgo" type="NaiveBayesAlgoType"
             xdb:defaultTable=""/>
 <xs:element name="NaiveBayesModel" type="NaiveBayesModelType"
             xdb:defaultTable=""/>
 <xs:element name="NodeReference"  xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:simpleContent>
    <xs:extension base="xs:string">
     <xs:attribute name="NodeId" type="xs:integer" use="required" />
     <xs:attribute name="NodeName" type="xs:string" use="required" />
     <xs:attribute name="WorkflowId" type="xs:integer" use="required" />
     <xs:attribute name="WorkflowName" type="xs:string" use="required" />
     <xs:attribute name="ProjectId" type="xs:integer" use="required" />
     <xs:attribute name="ProjectName" type="xs:string" use="required" />
    </xs:extension>
   </xs:simpleContent>
  </xs:complexType>
 </xs:element>
 <xs:element name="OutputTable" type="ResultType" xdb:defaultTable=""/>
 <xs:element name="RegressionBuild" type="RegressionBuildNodeType"
             xdb:defaultTable=""/>
 <xs:element name="RegressionResult" type="RegressionResultType"  xdb:defaultTable=""/>
 <xs:element name="ResidualPlot" type="ResultType" xdb:defaultTable=""/>
 <xs:element name="RGeneralizedLinearModel" type="RGeneralizedLinearModelType"
             xdb:defaultTable=""/>
 <xs:element name="RGeneralizedLinearModelAlgo"
             type="RGeneralizedLinearAlgoType" xdb:defaultTable=""/>
 <xs:element name="ROCs" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element name="ROC" type="TargetResultType" minOccurs="0" maxOccurs="2"/>
    <xs:element name="AreaUnderCurve" maxOccurs="2" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:attribute name="Area" use="required" type="xs:double"/>
      <xs:attribute name="TargetValue" use="required"/>
     </xs:complexType>
    </xs:element>
    <xs:element name="AreaUnderCurveEx" type="TargetResultType" minOccurs="0" maxOccurs="2"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <xs:element name="RowFilter" type="RowFilterNodeType" xdb:defaultTable=""/>
 <xs:element name="RSupportVectorMachineAlgo"
             type="RSupportVectorMachineAlgoType" xdb:defaultTable=""/>
 <xs:element name="RSupportVectorMachineModel"
             type="RSupportVectorMachineModelType" xdb:defaultTable=""/>
 <xs:element name="Sample" type="SampleNodeType" xdb:defaultTable=""/>
 <xs:element name="SampleSettings" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence minOccurs="0">
    <xs:choice>
     <xs:element name="NumberOfRows" default="2000" minOccurs="0">
      <xs:simpleType>
       <xs:restriction base="xs:long">
        <xs:minInclusive value="1"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:element>
     <xs:element name="PercentOfTotal" default="10" minOccurs="0">
      <xs:simpleType>
       <xs:restriction base="xs:double">
        <xs:maxInclusive value="100"/>
        <xs:minInclusive value="1"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:element>
    </xs:choice>
    <xs:element name="Method">
     <xs:complexType xdb:maintainDOM="true">
      <xs:choice>
       <xs:element name="Random" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:attribute name="Seed" type="xs:integer" use="required"/>
        </xs:complexType>
       </xs:element>
       <xs:element name="Stratified" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:attribute name="TargetAttr" type="xs:string" use="required">
         </xs:attribute>
        </xs:complexType>
       </xs:element>
       <xs:element name="TopN" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true"/>
       </xs:element>
      </xs:choice>
     </xs:complexType>
    </xs:element>
    <xs:element ref="OutputTable" minOccurs="0"/>
   </xs:sequence>
   <xs:attribute name="UseFullData" type="xs:boolean" use="required"/>
   <xs:attribute name="GenerateCache" type="xs:boolean" use="optional"
                 default="true"/>
  </xs:complexType>
 </xs:element>
 <xs:element name="SourceTable" type="TableType" xdb:defaultTable=""/>
 <xs:element name="SQLExpression" type="xs:string" xdb:SQLType="CLOB" xdb:defaultTable=""/>
 <xs:element name="TargetAttribute" type="AttributeType" xdb:defaultTable=""/>
 <xs:element name="TargetValues" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:choice>
    <xs:element name="TargetValueString" maxOccurs="unbounded"
                type="TargetValueStringType" minOccurs="0"/>
    <xs:element name="TargetValueNumber" maxOccurs="unbounded"
                type="TargetValueNumberType" minOccurs="0"/>
   </xs:choice>
  </xs:complexType>
 </xs:element>
 <xs:element name="Test" type="TestNodeType" xdb:defaultTable=""/>
 <xs:element name="TestDataSource" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:choice>
    <xs:element name="SplitData" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:attribute name="TestPercent" use="required">
       <xs:simpleType>
        <xs:restriction base="xs:double">
         <xs:minExclusive value="0"/>
         <xs:maxExclusive value="100"/>
        </xs:restriction>
       </xs:simpleType>
      </xs:attribute>
      <xs:attribute name="DataFormat" use="optional">
       <xs:simpleType>
        <xs:restriction base="xs:string">
         <xs:enumeration value="Table"/>
         <xs:enumeration value="View"/>
        </xs:restriction>
       </xs:simpleType>
      </xs:attribute>
      <xs:attribute name="UseParallel" type="xs:boolean" use="optional"/>
     </xs:complexType>
    </xs:element>
    <xs:element name="BuildData" minOccurs="0">
      <xs:complexType>
       <xs:complexContent>
        <xs:restriction base="xs:anyType"/>
       </xs:complexContent>
      </xs:complexType>
    </xs:element>
    <xs:element name="TestData" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:attribute name="SourceId" use="required" type="xs:string"/>
     </xs:complexType>
    </xs:element>
    <xs:element name="None" minOccurs="0">
      <xs:complexType>
       <xs:complexContent>
        <xs:restriction base="xs:anyType"/>
       </xs:complexContent>
      </xs:complexType>
    </xs:element>
   </xs:choice>
  </xs:complexType>
 </xs:element>
 <xs:element name="TestDetails" type="TestDetailsDataNodeType"
             xdb:defaultTable=""/>
 <xs:element name="TestMetrics" type="ResultType" xdb:defaultTable=""/>
 <xs:element name="Transformation" type="TransformationNodeType"
             xdb:defaultTable=""/>
 <xs:element name="UpdateTable" type="UpdateTableNodeType" xdb:defaultTable=""/>
 <xs:element name="UpdateTableAttributes" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="UpdateTableItemType" maxOccurs="unbounded" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <xs:element name="UpdateTableItemType" type="MapTargetSourceType"
             xdb:defaultTable=""/>
 <xs:element name="UpdateTargetTable" type="TableType" xdb:defaultTable=""/>
 <xs:element name="FeatureCompare" type="FeatureCompareNodeType" xdb:defaultTable=""/>
 <xs:simpleType name="AttributeStatus">
  <xs:restriction base="xs:string">
   <xs:enumeration value="Valid"/>
   <xs:enumeration value="Invalid"/>
   <xs:enumeration value="Missing"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="AutoSpecType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="Yes"/>
   <xs:enumeration value="No"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="ColumnFilterReasonEnumType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="NULL_LIMIT"/>
   <xs:enumeration value="CONSTANT_LIMIT"/>
   <xs:enumeration value="UNIQUE_LIMIT"/>
   <xs:enumeration value="TOPN_LIMIT"/>
   <xs:enumeration value="CUTOFF_LIMIT"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="FilterDetailType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="AttributeImportance"/>
   <xs:enumeration value="AttributeDependencies"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="InputMiningDataType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="AUTO"/>
   <xs:enumeration value="MANUAL"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="JoinType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="Inner"/>
   <xs:enumeration value="Left Outer"/>
   <xs:enumeration value="Right Outer"/>
   <xs:enumeration value="Full Outer"/>
   <xs:enumeration value="Cartesian"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="LiftType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="Cumulative Lift"/>
   <xs:enumeration value="Cumulative Positive Cases"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="MessageEnumType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="ADVISORY"/>
   <xs:enumeration value="ERROR"/>
   <xs:enumeration value="INCOMPLETE"/>
   <xs:enumeration value="WARNING"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="MiningAlgorithmType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="DECISION_TREE"/>
   <xs:enumeration value="NAIVE_BAYES"/>
   <xs:enumeration value="GENERALIZED_LINEAR_MODEL"/>
   <xs:enumeration value="SUPPORT_VECTOR_MACHINES"/>
   <xs:enumeration value="KMEANS"/>
   <xs:enumeration value="O_CLUSTER"/>
   <xs:enumeration value="AI_MDL"/>
   <xs:enumeration value="APRIORI_ASSOCIATION_RULES"/>
   <xs:enumeration value="NONNEGATIVE_MATRIX_FACTOR"/>
   <xs:enumeration value="ALL"/>
   <xs:enumeration value="EXPECTATION_MAXIMIZATION"/>
   <xs:enumeration value="SINGULAR_VALUE_DECOMP"/>
   <xs:enumeration value="PRINCIPAL_COMPONENT_ANALYSIS"/>
   <xs:enumeration value="EXPLICIT_SEMANTIC_ANALYSIS"/>
   <xs:enumeration value="R_EXTENSIBLE"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="MiningDataType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="CHAR"/>
   <xs:enumeration value="VARCHAR2"/>
   <xs:enumeration value="NUMBER"/>
   <xs:enumeration value="CLOB"/>
   <xs:enumeration value="DM_NESTED_NUMERICALS"/>
   <xs:enumeration value="DM_NESTED_CATEGORICALS"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="MiningFunctionType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="ANOMALY_DETECTION"/>
   <xs:enumeration value="ASSOCIATION"/>
   <xs:enumeration value="ATTRIBUTE_IMPORTANCE"/>
   <xs:enumeration value="CLASSIFICATION"/>
   <xs:enumeration value="CLUSTERING"/>
   <xs:enumeration value="FEATURE_EXTRACTION"/>
   <xs:enumeration value="REGRESSION"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="ModelDetailType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="DTFullTree"/>
   <xs:enumeration value="DTLeafNodesOnly"/>
   <xs:enumeration value="DTLeafNodesOnlyProfileVersion"/>
   <xs:enumeration value="DTFullTreeXMLVersion"/>
   <xs:enumeration value="NBPairProbabilities"/>
   <xs:enumeration value="SVMCCoefficients"/>
   <xs:enumeration value="SVMRCoefficients"/>
   <xs:enumeration value="ADCoefficients"/>
   <xs:enumeration value="GLMCCoefficientsAndStatistics"/>
   <xs:enumeration value="GLMRCoefficientsAndStatistics"/>
   <xs:enumeration value="GLMCRowDiagnostics"/>
   <xs:enumeration value="GLMRRowDiagnostics"/>
   <xs:enumeration value="ClusterDetails"/>
   <xs:enumeration value="ClusterRules"/>
   <xs:enumeration value="ClusterAttributeHistograms"/>
   <xs:enumeration value="ClusterAll"/>
   <xs:enumeration value="ARRulesStringVersion"/>
   <xs:enumeration value="ARRulesAggregatesStringVersion"/>
   <xs:enumeration value="ARRulesDMPredicateVersion"/>
   <xs:enumeration value="ARFrequentItemSetsTransactionalVersion"/>
   <xs:enumeration value="ARFrequentItemSetsAggregatesTransactionalVersion"/>
   <xs:enumeration value="ARFrequentItemSetsDMItemVersion"/>
   <xs:enumeration value="NMFDetailsTransactionalVersion"/>
   <xs:enumeration value="NMFDetailsDMAttributesVersion"/>
   <xs:enumeration value="ModelSignature"/>
   <xs:enumeration value="GlobalDetails"/>
   <xs:enumeration value="EMComponents"/>
   <xs:enumeration value="EMProjections"/>
   <xs:enumeration value="EMClusters"/>
   <xs:enumeration value="EMPriors"/>
   <xs:enumeration value="EMGaussianDetails"/>
   <xs:enumeration value="EMBernoulliDetails"/>
   <xs:enumeration value="FeatureProjections"/>
   <xs:enumeration value="PCAEigenvalues"/>
   <xs:enumeration value="SVDSingularValues"/>
   <xs:enumeration value="Centroids"/>
   <xs:enumeration value="CentroidScoring"/>
   <xs:enumeration value="RModelDetails"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="ModelStatusType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="Ready"/>
   <xs:enumeration value="Complete"/>
   <xs:enumeration value="Failure"/>
   <xs:enumeration value="Warning"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="NodeStatusType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="Invalid"/>
   <xs:enumeration value="Ready"/>
   <xs:enumeration value="Complete"/>
   <xs:enumeration value="Failure"/>
   <xs:enumeration value="Warning"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="ParameterDataType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="String"/>
   <xs:enumeration value="Date"/>
   <xs:enumeration value="Number"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="RefModelStatusType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="Valid"/>
   <xs:enumeration value="Invalid"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="ROCAccuracyType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="CurrentModel"/>
   <xs:enumeration value="MaxAccuracy"/>
   <xs:enumeration value="AvgAccuracy"/>
   <xs:enumeration value="CustomAccuracy"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="ROCCustomThresholdType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="HitRatio"/>
   <xs:enumeration value="FalseAlarm"/>
   <xs:enumeration value="FalsePosNegRatio"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="StratifiedType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="Original"/>
   <xs:enumeration value="Balanced"/>
   <xs:enumeration value="Custom"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="TargetValueNumberType">
  <xs:restriction base="xs:double"/>
 </xs:simpleType>
 <xs:simpleType name="TargetValueStringType">
  <xs:restriction base="xs:string">
   <xs:minLength value="1"/>
   <xs:maxLength value="32767"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:complexType name="AggregationElementType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Source" type="GroupingElementType" minOccurs="1"/>
   <xs:element name="Output" type="AttributeType" minOccurs="1"/>
   <xs:element name="AggregationFunction" type="xs:string" minOccurs="0"/>
   <xs:element name="SubGroupBy" type="GroupingElementType" minOccurs="0"/>
  </xs:sequence>
 </xs:complexType>
 <!--Agg.Node start-->
 <xs:complexType xdb:maintainDOM="true" name="AggregationNodeType">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element ref="AggregationElements"/>
     <xs:element name="GroupingElement" type="GroupingElementType"
                 minOccurs="0"/>
     <xs:e';

schema2 := 'lement name="AutoSpec" type="AutoSpecType" minOccurs="1"/>
    </xs:sequence>
    <!--<xs:attribute name="AutoSpec" type="AutoSpecType" use="required"/>-->
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <!--Agg.Node end-->
 <xs:complexType name="AnomalyDetectionBuildNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="BuildNodeType">
    <xs:sequence>
     <xs:element name="Models">
      <xs:complexType>
       <xs:sequence>
        <xs:element name="AnomalyDetectionModel"
                    type="AnomalyDetectionModelType" minOccurs="0"
                    maxOccurs="unbounded" xdb:defaultTable="ANOM_DETECT_M_TAB" xdb:SQLInline="false"/>
       </xs:sequence>
      </xs:complexType>
     </xs:element>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="AnomalyDetectionModelType">
  <xs:complexContent>
   <xs:extension base="ModelType">
    <xs:sequence>
     <xs:element name="AnomalyDetectionAlgo" type="AnomalyDetectionAlgoType"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="AnomalyDetectionAlgoType">
  <xs:complexContent>
   <xs:extension base="SupportVectorMachineAlgoType">
    <xs:sequence>
     <xs:element name="SVMS_OUTLIER_RATE" minOccurs="0" default="0.1">
      <xs:simpleType>
       <xs:restriction base="xs:double">
        <xs:minExclusive value="0"/>
        <xs:maxExclusive value="1"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:element>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="ApplyOutputColumnsType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="OutputColumn" minOccurs="0" maxOccurs="unbounded">
    <xs:complexType xdb:maintainDOM="true">
     <xs:sequence>
      <xs:element name="Model" type="RefModelType"/>
      <xs:choice>
       <xs:element name="Prediction" type="PredictionType" minOccurs="0"/>
       <xs:element name="PredictionBounds" type="PredictionBoundsType"
                   minOccurs="0"/>
       <xs:element name="PredictionCost" type="PredictionCostType"
                   minOccurs="0"/>
       <xs:element name="PredictionDetails" type="PredictionDetailsType"
                   minOccurs="0"/>
       <xs:element name="PredictionProbability" type="PredictionProbabilityType"
                   minOccurs="0"/>
       <xs:element name="PredictionSet" type="PredictionSetType" minOccurs="0"/>
       <xs:element name="ClusterId" type="ClusterIdType" minOccurs="0"/>
       <xs:element name="ClusterProbability" type="ClusterProbabilityType"
                   minOccurs="0"/>
       <xs:element name="ClusterSet" type="ClusterSetType" minOccurs="0"/>
       <xs:element name="FeatureId" type="FeatureIdType" minOccurs="0"/>
       <xs:element name="FeatureSet" type="FeatureSetType" minOccurs="0"/>
       <xs:element name="FeatureValue" type="FeatureValueType" minOccurs="0"/>
       <xs:element name="ClusterDetails" minOccurs="0" type="ClusterDetailsType"/>
       <xs:element name="ClusterDistance" minOccurs="0" type="ClusterDistanceType"/>
       <xs:element name="FeatureDetails" minOccurs="0" type="FeatureDetailsType"/>
       <xs:element name="PartitionName" minOccurs="0" type="PartitionNameType"/>
      </xs:choice>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
  <xs:attribute name="AutoSpec" type="AutoSpecType" use="required"/>
 </xs:complexType>
 <xs:complexType name="ApplyNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element name="SupplementalAttributes" minOccurs="1"
                 type="SupplementalAttributesType"></xs:element>
     <xs:element name="OutputColumns" type="ApplyOutputColumnsType"></xs:element>
     <xs:element ref="CaseAttributes" minOccurs="0"/>   
    </xs:sequence>
    <xs:attribute name="ColumnOutputOrder" use="required">
     <xs:simpleType>
      <xs:restriction base="xs:string">
       <xs:enumeration value="OutputColumns"/>
       <xs:enumeration value="SupplementalColumns"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:attribute>
    <xs:attribute name="OrderPartitions" use="optional">
        <xs:simpleType>
         <xs:restriction base="xs:string">
          <xs:enumeration value="Yes"/>
          <xs:enumeration value="No"/>
         </xs:restriction>
        </xs:simpleType>
    </xs:attribute>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="AprioriAlgoType">
  <xs:sequence>
   <xs:element name="ASSO_MAX_RULE_LENGTH" default="4">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="2"/>
      <xs:maxInclusive value="20"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="ASSO_MIN_CONFIDENCE" default="0.1">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minInclusive value="0"/>
      <xs:maxInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="ASSO_MIN_SUPPORT" default="0.1">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minInclusive value="0"/>
      <xs:maxInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="ASSO_MIN_REV_CONFIDENCE" minOccurs="0" default="0.0">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minInclusive value="0"/>
      <xs:maxInclusive value="100"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="ASSO_MIN_SUPPORT_INT" minOccurs="0" default="1">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="ASSO_ANT_IN_RULES" type="RuleItemsType" minOccurs="0"/>
   <xs:element name="ASSO_CONS_IN_RULES" type="RuleItemsType" minOccurs="0"/>
   <xs:element name="ASSO_ANT_EX_RULES" type="RuleItemsType" minOccurs="0"/>
   <xs:element name="ASSO_CONS_EX_RULES" type="RuleItemsType" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="ASSO_FILTERS_ACTIVE" type="xs:boolean" use="optional" default="false"/>
 </xs:complexType>
 <xs:complexType name="AprioriModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ModelType">
    <xs:sequence>
     <xs:element name="AprioriAlgo" type="AprioriAlgoType"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="AssociationBuildNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="BuildNodeType">
    <xs:sequence>
     <xs:element ref="ASSO_AGGREGATES" minOccurs="0"/>
     <xs:element name="ItemID" type="AttributeType" minOccurs="0"/>
     <xs:element name="ItemValue" type="AttributeType" minOccurs="0"/>     
     <xs:element name="Models">
      <xs:complexType>
       <xs:sequence>
        <xs:element name="AprioriModel" type="AprioriModelType" minOccurs="0"
                    maxOccurs="unbounded" xdb:defaultTable="APRIORI_M_TAB" xdb:SQLInline="false"/>
       </xs:sequence>
      </xs:complexType>
     </xs:element>
    </xs:sequence>
    <xs:attribute name="MaxDistinctItemValue" type="xs:integer"/>
    <xs:attribute name="ASSO_GENERATE_PREPROCESSED_TABLE" type="xs:boolean" use="optional" default="false"/>
    <xs:attribute name="ASSO_PREPROCESSED_TABLE_NAME" type="xs:string" use="optional" default=""/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="AttributeType" xdb:maintainDOM="true">
  <xs:attribute name="Name" use="required" type="xs:string"/>
  <xs:attribute name="DataType" use="required" type="xs:string"/>
  <xs:attribute name="Status" type="AttributeStatus" use="required"/>
  <xs:attribute name="Alias" use="optional" type="xs:string"/>
  <xs:attribute name="Annotation" type="xs:string"/>
  <xs:attribute name="DataTypeQualifier" use="optional" type="xs:string"/>
 </xs:complexType>
 <!--  Update Table Type Node start -->
 <!--  Update Table Type Node end -->
 <xs:complexType name="AttrImportantSettingsType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element ref="TargetAttribute" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="CutOff" use="optional">
   <xs:simpleType>
    <xs:restriction base="xs:double">
     <xs:minInclusive value="0"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
  <xs:attribute name="TopN" use="optional">
   <xs:simpleType>
    <xs:restriction base="xs:integer">
     <xs:minExclusive value="0"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
  <xs:attribute name="SamplingType" use="optional">
   <xs:simpleType>
    <xs:restriction base="xs:string">
     <xs:enumeration value="Random"/>
     <xs:enumeration value="Stratified"/>
     <xs:enumeration value="System"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
  <xs:attribute name="StratifiedCutoff" use="optional">
   <xs:simpleType>
    <xs:restriction base="xs:integer">
     <xs:minExclusive value="0"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
  <xs:attribute name="AttributeDependency" type="xs:boolean" use="optional"/>
 </xs:complexType>
 <xs:complexType name="BuildNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="MiningNodeType">
    <xs:sequence>
     <xs:element ref="BuildDataSource" minOccurs="0"/>
     <xs:element ref="CaseAttributes" minOccurs="0"/>
     <xs:element ref="MiningAttributes" minOccurs="0"/>
     <xs:element name="Stoplists" minOccurs="0">
      <xs:complexType>
       <xs:sequence>
        <xs:element name="Stoplist" maxOccurs="unbounded" minOccurs="0" type="StoplistType"/>
       </xs:sequence>
      </xs:complexType>
     </xs:element>
     <xs:element name="TextSettings" minOccurs="0">
      <xs:complexType>
       <xs:sequence>
        <xs:element name="Token" type="TransformationTokenType"/>
        <xs:element name="Theme" minOccurs="1">
         <xs:complexType>
          <xs:complexContent>
           <xs:extension base="TransformationTokenType">
            <xs:attribute name="Type" use="required">
             <xs:simpleType>
              <xs:restriction base="xs:string">
               <xs:enumeration value="Single"/>
               <xs:enumeration value="Full"/>
              </xs:restriction>
             </xs:simpleType>
            </xs:attribute>
           </xs:extension>
          </xs:complexContent>
         </xs:complexType>
        </xs:element>
        <xs:element name="Synonym" minOccurs="0">
         <xs:complexType>
           <xs:complexContent>
            <xs:extension base="TransformationTokenType">
             <xs:attribute name="Thesaurus" type="xs:string" use="optional"/>
            </xs:extension>
           </xs:complexContent>
          </xs:complexType>
         </xs:element>
       </xs:sequence>
       <xs:attribute name="TransformType" use="required">
        <xs:simpleType>
         <xs:restriction base="xs:string">
          <xs:enumeration value="Token"/>
          <xs:enumeration value="Theme"/>
          <xs:enumeration value="Synonym"/>
         </xs:restriction>
        </xs:simpleType>
       </xs:attribute>
     <xs:attribute name="CategoricalCutOffValue" use="required">
      <xs:simpleType>
       <xs:restriction base="xs:integer">
        <xs:minInclusive value="2"/>
        <xs:maxInclusive value="4000"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
      </xs:complexType>
     </xs:element>
     <xs:element name="TextAttributes" type="TransformedAttributesType" minOccurs="0"/>
     <xs:element name="HeuristicSummaryResult" type="HeuristicSummaryResultType" minOccurs="0"/>
     <xs:element ref="PartitionExpressions" minOccurs="0"/>
    </xs:sequence>
    <xs:attribute name="MaxNumPartitions" type="xs:unsignedLong" use="optional"/>
    <xs:attribute name="ODMS_SAMPLING" type="xs:boolean" use="optional" default="false"/>
    <xs:attribute name="ODMS_SAMPLE_SIZE" type="xs:unsignedLong" use="optional"/>
    <xs:attribute name="ODMS_PARTITION_BUILD_TYPE" use="optional">
     <xs:simpleType>
      <xs:restriction base="xs:string">
       <xs:enumeration value="ODMS_PARTITION_BUILD_INTRA"/>
       <xs:enumeration value="ODMS_PARTITION_BUILD_INTER"/>
       <xs:enumeration value="ODMS_PARTITION_BUILD_HYBRID"/>
      </xs:restriction>
     </xs:simpleType>
   </xs:attribute>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
<xs:complexType name="BuildTextNodeRefType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TextNodeType">
    <xs:sequence>
     <xs:element ref="NodeReference" minOccurs="0"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="ApplyTextNodeType">
  <xs:complexContent>
   <xs:extension base="BuildTextNodeType"/>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="BuildTextNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TextNodeType">
    <xs:sequence>
     <xs:element ref="SampleSettings"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <!--
 <xs:complexType name="CacheSettingsType">
  <xs:sequence minOccurs="0">
   <xs:choice>
    <xs:element name="NumberOfRows" default="2000">
     <xs:simpleType>
      <xs:restriction base="xs:long">
       <xs:minInclusive value="1"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:element>
    <xs:element name="PercentOfTotal" default="10">
     <xs:simpleType>
      <xs:restriction base="xs:double">
       <xs:maxInclusive value="100"/>
       <xs:minInclusive value="1"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:element>
   </xs:choice>
   <xs:element name="Method">
    <xs:complexType xdb:maintainDOM="true">
     <xs:choice>
      <xs:element name="Random">
       <xs:complexType xdb:maintainDOM="true">
        <xs:attribute name="Seed" type="xs:integer" use="required"/>
       </xs:complexType>
      </xs:element>
      <xs:element name="Stratified">
       <xs:complexType xdb:maintainDOM="true">
        <xs:attribute name="TargetAttr" use="required">
         <xs:simpleType>
          <xs:restriction base="xs:string">
           <xs:minLength value="1"/>
           <xs:maxLength value="30"/>
          </xs:restriction>
         </xs:simpleType>
        </xs:attribute>
       </xs:complexType>
      </xs:element>
      <xs:element name="TopN">
       <xs:complexType xdb:maintainDOM="true"/>
      </xs:element>
     </xs:choice>
    </xs:complexType>
   </xs:element>
   <xs:element ref="OutputTable" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="UseFullData" type="xs:boolean" use="required"/>
 </xs:complexType>
 -->
  <xs:complexType name="RuleItemsType">
  <xs:sequence>
   <xs:element name="RuleItems" minOccurs="0">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="Item" maxOccurs="unbounded" minOccurs="0" type="xs:string">
      </xs:element>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="CGeneralizedLinearAlgoType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="GeneralizedLinearAlgoType"/>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="CGeneralizedLinearModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ClassificationModelType">
    <xs:sequence>
     <xs:element ref="CGeneralizedLinearAlgo"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="ClassificationBuildNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="SuperviseBuildNodeType">
    <xs:sequence>
     <xs:element name="Models">
      <xs:complexType>
       <xs:sequence>
        <xs:element ref="NaiveBayesModel" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="NAIVE_BAYES_M_TAB" xdb:SQLInline="false"/>
        <xs:element ref="DecisionTreeModel" minOccurs="0"
                    maxOccurs="unbounded" xdb:defaultTable="DECISION_TREE_M_TAB" xdb:SQLInline="false"/>
        <xs:element ref="CSupportVectorMachineModel" minOccurs="0"
                    maxOccurs="unbounded" xdb:defaultTable="SUPT_VECTOR_MACH_C_M_TAB" xdb:SQLInline="false"/>
        <xs:element ref="CGeneralizedLinearModel" minOccurs="0"
                    maxOccurs="unbounded" xdb:defaultTable="GEN_LINEAR_C_M_TAB" xdb:SQLInline="false"/>
       </xs:sequence>
      </xs:complexType>
     </xs:element>
     <xs:element name="CostSettings" type="CostMatrixType" minOccurs="0"/>
     <xs:element name="BenefitSettings" type="WeightsType" minOccurs="0"/>
     <xs:element name="TestSettings" type="ClassificationTestSettingsType"/>
     <xs:element name="ProfitSettings" minOccurs="0">
      <xs:complexType xdb:maintainDOM="true">
       <xs:attribute name="StartupCost" use="required" type="xs:double"/>
       <xs:attribute name="IncrementalRevenue" use="required" type="xs:double"/>
       <xs:attribute name="IncrementalCost" use="required" type="xs:double"/>
       <xs:attribute name="Budget" use="required" type="xs:double"/>
       <xs:attribute name="Population" use="required" type="xs:double"/>
      </xs:complexType>
     </xs:element>
     <xs:element name="Results" minOccurs="1">
      <xs:complexType xdb:maintainDOM="true">
       <xs:sequence>
        <xs:element maxOccurs="unbounded" ref="ClassificationResult"
                    minOccurs="0"/>
        <xs:element name="ClassificationResultForTuning" maxOccurs="unbounded" minOccurs="0" type="ClassificationResultType"/>
       </xs:sequence>
       <xs:attribute name="genAccuracyMetrics" type="xs:boolean" use="optional"/>
       <xs:attribute name="genConfusionMatrix" type="xs:boolean" use="optional"/>
       <xs:attribute name="genROC" type="xs:boolean" use="optional"/>
       <xs:attribute name="genLift" type="xs:boolean" use="optional"/>
       <xs:attribute name="genTuning" type="xs:boolean" use="optional"/>
       <xs:attribute name="useGroupingForPartition" type="xs:boolean" use="optional"/>
      </xs:complexType>
     </xs:element>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="ClassificationModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="SuperviseModelType">
    <xs:sequence>
     <xs:element minOccurs="0" maxOccurs="1" type="PerformanceType"
                 name="Performance"/>
     <xs:element type="TuningType" name="Tuning"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="ClassificationResultType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="MiningResultType">
    <xs:sequence>
     <xs:element ref="TestMetrics" xdb:SQLInline="false" xdb:defaultTable="TEST_METRICS_CLASS_TABLE"
                 minOccurs="0"/>
     <xs:element ref="ConfusionMatrix" xdb:SQLInline="false" xdb:defaultTable="CONFUSION_MATRIX_TABLE"
                 minOccurs="0"/>
     <xs:element ref="Lifts" xdb:SQLInline="false" xdb:defaultTable="LIFTS_TABLE"
                 minOccurs="0"/>
     <xs:element ref="ROCs" xdb:SQLInline="false" xdb:defaultTable="ROCS_TABLE"
                 minOccurs="0"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="ClassificationTestSettingsType" xdb:maintainDOM="true">
  <xs:choice>
   <xs:element name="TopNTargets" minOccurs="0">
    <xs:complexType>
     <xs:attribute name="Value" use="required" type="xs:integer"/>
    </xs:complexType>
   </xs:element>
   <xs:element name="BottomNTargets" minOccurs="0">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Value" type="xs:integer" use="required"/>
    </xs:complexType>
   </xs:element>
   <xs:element name="SpecificTargets" minOccurs="0">
    <xs:complexType xdb:maintainDOM="true">
     <xs:sequence>
      <xs:element name="TargetValue" maxOccurs="unbounded">
       <xs:complexType xdb:maintainDOM="true">
        <xs:attribute name="Value" use="required"/>
       </xs:complexType>
      </xs:element>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
  </xs:choice>
 </xs:complexType>
 <xs:complexType name="ClusteringBuildNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="BuildNodeType">
    <xs:sequence>
     <xs:element name="Models">
      <xs:complexType>
       <xs:sequence>
        <xs:element name="KMeansModel" type="KMeansModelType"
                    maxOccurs="unbounded" minOccurs="0" xdb:defaultTable="KMEANS_M_TAB" xdb:SQLInline="false"/>
        <xs:element name="OClusterModel" type="OClusterModelType"
                    maxOccurs="unbounded" minOccurs="0" xdb:defaultTable="OCLUSTER_M_TAB" xdb:SQLInline="false"/>
        <xs:element name="ExpectationMaximizationModel" type="ExpectationMaximizationModelType"
                    maxOccurs="unbounded" minOccurs="0" xdb:defaultTable="EM_M_TAB" xdb:SQLInline="false"/>
       </xs:sequence>
      </xs:complexType>
     </xs:element>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="ClusteringModelType">
  <xs:complexContent>
   <xs:extension base="ModelType"/>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="ClusterIdType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="ClusterProbabilityType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
     <xs:attribute name="ClusterId" use="optional"/>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="ClusterSetType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column" minOccurs="1">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
     <xs:attribute name="TopNValue">
      <xs:simpleType>
       <xs:restriction base="xs:integer">
        <xs:minExclusive value="0"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
     <xs:attribute name="CutOffValue">
      <xs:simpleType>
       <xs:restriction base="xs:double">
        <xs:minInclusive value="0"/>
        <xs:maxInclusive value="1"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="DataQualitySettingsType" xdb:maintainDOM="true">
  <xs:attribute name="NullsPercent" use="optional">
   <xs:simpleType>
    <xs:restriction base="xs:double">
     <xs:minInclusive value="0"/>
     <xs:maxInclusive value="100"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
  <xs:attribute name="UniquePercent" use="optional">
   <xs:simpleType>
    <xs:restriction base="xs:double">
     <xs:minInclusive value="0"/>
     <xs:maxInclusive value="100"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
  <xs:attribute name="ConstantPercent" use="optional">
   <xs:simpleType>
    <xs:restriction base="xs:double">
     <xs:minInclusive value="0"/>
     <xs:maxInclusive value="100"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
 </xs:complexType>
 <xs:complexType name="ColumnFilterSettingsType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="DataQualitySettings" type="DataQualitySettingsType"/>
   <xs:element name="AttrImportantSettings" type="AttrImportantSettingsType"/>
  </xs:sequence>
  <xs:attribute name="SamplingEnabled" use="optional" type="xs:boolean" /> 
  <xs:attribute name="NumberOfRows" use="optional">
   <xs:simpleType>
    <xs:restriction base="xs:integer">
     <xs:minInclusive value="0"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
 </xs:complexType>
 <xs:complexType name="ColumnFilterAttributeType" xdb:maintainDOM="true">
  <xs:sequence minOccurs="1">
   <xs:element name="Attribute" minOccurs="0" maxOccurs="unbounded">
    <xs:complexType>
     <xs:complexContent>
      <xs:extension base="AttributeType">
       <xs:attribute name="AutomaticFiltering" use="required"
                     type="xs:boolean"/>
       <xs:attribute name="Output" use="required">
        <xs:simpleType>
         <xs:restriction base="xs:string">
          <xs:enumeration value="System"/>
          <xs:enumeration value="Yes"/>
          <xs:enumeration value="No"/>
         </xs:restriction>
        </xs:simpleType>
       </xs:attribute>
      </xs:extension>
     </xs:complexContent>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
  <xs:attribute name="AutoSpec" type="AutoSpecType" use="required"/>
  <xs:attribute name="AutomaticFilterEnable" type="AutoSpecType"
                use="required"/>
 </xs:complexType>
 <xs:complexType name="ColumnFilterResultType">
  <xs:sequence>
   <xs:element name="Attribute" minOccurs="0" maxOccurs="unbounded">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="Reason" minOccurs="0" maxOccurs="unbounded">
       <xs:complexType>
        <xs:attribute name="Type" type="ColumnFilterReasonEnumType"/>
       </xs:complexType>
      </xs:element>
     </xs:sequence>
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
  <xs:attribute name="DataQualityOutput" type="xs:string"/>
  <xs:attribute name="AttrImportanceOutput" type="xs:string"/>
  <xs:attribute name="AttrDependencyOutput" type="xs:string"/>
  <xs:attribute name="GenerateImportanceOutput" type="xs:boolean"
                use="required"/>
 </xs:complexType>
 <xs:complexType name="ColumnFilterNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element name="ColumnFilterSettings" type="ColumnFilterSettingsType"/>
     <xs:element name="ColumnFilterAttributes"
                 type="ColumnFilterAttributeType"/>
     <xs:element name="ColumnFilterResults"
                 minOccurs="0" type="ColumnFilterResultType"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="CostMatrixType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Item" maxOccurs="unbounded" minOccurs="0">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Actual" use="required" type="TargetValueStringType"/>
     <xs:attribute name="Predict" use="required" type="TargetValueStringType"/>
     <xs:attribute name="Cost" type="xs:double" use="required"/>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <!--  Create Table Type Node -->
 <xs:complexType name="CreateTableNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="DataNodeType">
    <xs:sequence>
     <xs:element ref="DBAttributes"/>
     <xs:element name="JSONColumns" minOccurs="0" type="JSONColumnsType"/>
     <xs:element name="DataGuideSettings" type="DataGuideSettingsType" minOccurs="0"/>
     <xs:element name="CreateTableOptions" type="CreateTableOptionsType" minOccurs="0"/>
    </xs:sequence>
    <xs:attribute name="TableName" type="xs:string" use="required">
    </xs:attribute>
    <!--<xs:attribute name="Schema" use="required">
     <xs:simpleType>
      <xs:restriction base="xs:string">
       <xs:minLength value="1"/>
       <xs:maxLength value="30"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:attribute>-->
    <xs:attribute name="Table" type="xs:boolean" use="required"/>
    <xs:attribute name="AutoSpec" type="AutoSpecType" default="Yes"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="CSupportVectorMachineAlgoType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="SupportVectorMachineAlgoType"/>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="CSupportVectorMachineModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ClassificationModelType">
    <xs:sequence>
     <xs:element ref="CSupportVectorMachineAlgo"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="DataNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="NodeType">
    <xs:sequence>
     <xs:element ref="CacheSettings"/>
     <xs:element ref="SQLExpression" minOccurs="0"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="DataProfileNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element name="DataProfileInput" type="DataProfileInputType"/>
     <xs:element name="DataProfileOutput" type="DataProfileOutputType"/>
     <xs:element name="DataProfileSettings" type="DataProfileSettingsType"/>
     <xs:element name="StatisticTable" type="ResultType" minOccurs="0"/>
     <xs:element ref="StatsSelection" minOccurs="0"/>
     <xs:element ref="SampleSettings"/>
    </xs:sequence>
    <xs:attribute name="NullsLabel" type="xs:string" use="optional"/>
    <xs:attribute name="OtherLabel" type="xs:string" use="optional"/>
    <xs:attribute name="AutoSpec" type="AutoSpecType" default="Yes"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="DataProfileInputType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element ref="Attributes"/>
   <xs:element name="GroupByAttribute" type="AttributeType" minOccurs="0"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="DataProfileOutputType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element ref="Attributes"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="DataProfileSettingsType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="NumericalBins" default="10">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:maxInclusive value="128"/>
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="CategoricalBins" default="10">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:maxInclusive value="128"/>
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="DateBins" default="10">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:maxInclusive value="128"/>
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="DataSourceNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="DataNodeType">
    <xs:sequence>
     <xs:element ref="Attributes"/>
     <xs:element ref="SourceTable" minOccurs="0"/>
     <xs:elem';

schema3 := 'ent name="JSONColumns" minOccurs="0" type="JSONColumnsType"/>
     <xs:element name="DataGuideSettings" type="DataGuideSettingsType" minOccurs="0"/>
     <xs:element name="includeAllAvailableAttributes" type="xs:boolean" default="false" minOccurs="0"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="DBColumnType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="AttributeType">
    <xs:attribute name="Key" use="optional">
     <xs:simpleType>
      <xs:restriction base="xs:string">
       <xs:enumeration value="Yes"/>
       <xs:enumeration value="No"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:attribute>
    <xs:attribute name="Index" use="optional">
     <xs:simpleType>
      <xs:restriction base="xs:string">
       <xs:enumeration value="Yes"/>
       <xs:enumeration value="No"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:attribute>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="DecisionTreeAlgoType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="TREE_IMPURITY_METRIC" default="TREE_IMPURITY_GINI">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="TREE_IMPURITY_GINI"/>
      <xs:enumeration value="TREE_IMPURITY_ENTROPY"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="TREE_TERM_MAX_DEPTH" default="7">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="2"/>
      <xs:maxInclusive value="20"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="TREE_TERM_MINPCT_NODE" default="0.05">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minInclusive value="0"/>
      <xs:maxInclusive value="10"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="TREE_TERM_MINPCT_SPLIT" default="0.1">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minInclusive value="0"/>
      <xs:maxInclusive value="20"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="TREE_TERM_MINREC_NODE" default="10">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="TREE_TERM_MINREC_SPLIT" default="20">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="CLAS_MAX_SUP_BINS" default="1" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="DecisionTreeModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ClassificationModelType">
    <xs:sequence>
     <xs:element ref="DecisionTreeAlgo"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="FeatureExtractionBuildNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="BuildNodeType">
    <xs:sequence>
     <xs:element name="Models">
      <xs:complexType>
       <xs:sequence>
        <xs:element name="NonNegativeMatrixFactorModel" type="NonNegativeMatrixFactorModelType"
                    maxOccurs="unbounded" minOccurs="0" xdb:defaultTable="NON_NEG_MATRIX_M_TAB" xdb:SQLInline="false"/>
        <xs:element name="SVDModel" type="SVDModelType"
                    maxOccurs="unbounded" minOccurs="0" xdb:defaultTable="SVD_M_TAB" xdb:SQLInline="false"/>
        <xs:element name="PCAModel" type="PCAModelType"
                    maxOccurs="unbounded" minOccurs="0" xdb:defaultTable="PCA_M_TAB" xdb:SQLInline="false"/>
       </xs:sequence>
      </xs:complexType>
     </xs:element>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="FeatureIdType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="FeatureSetType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column" minOccurs="1">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
     <xs:attribute name="TopNValue">
      <xs:simpleType>
       <xs:restriction base="xs:integer">
        <xs:minExclusive value="0"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
     <xs:attribute name="CutOffValue">
      <xs:simpleType>
       <xs:restriction base="xs:double">
        <xs:minInclusive value="0"/>
        <xs:maxInclusive value="1"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="FeatureValueType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
     <xs:attribute name="FeatureId" use="optional"/>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="FilterDetailsDataNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element name="FilterDetailsOutput" type="FilterDetailsOutputType"
                 minOccurs="0"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="FilterDetailsOutputType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element ref="Attributes"/>
  </xs:sequence>
  <xs:attribute name="Type" type="FilterDetailType"/>
  <xs:attribute name="AutoSpec" type="AutoSpecType" use="required"/>
 </xs:complexType>
 <xs:complexType name="GeneralizedLinearAlgoType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="GLMS_CONF_LEVEL" default="0.95">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
      <xs:maxExclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_DIAGNOSTICS_TABLE_NAME" type="xs:string"
               minOccurs="0"/>
   <xs:element name="GLMS_REFERENCE_CLASS_NAME" type="xs:string" minOccurs="0"/>
   <xs:element name="GLMS_RIDGE_REGRESSION" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_RIDGE_REG_ENABLE"/>
      <xs:enumeration value="GLMS_RIDGE_REG_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_RIDGE_VALUE" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_VIF_FOR_RIDGE" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_VIF_RIDGE_ENABLE"/>
      <xs:enumeration value="GLMS_VIF_RIDGE_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="ODMS_MISSING_VALUE_TREATMENT" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="ODMS_MISSING_VALUE_MEAN_MODE"/>
      <xs:enumeration value="ODMS_MISSING_VALUE_DELETE_ROW"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="ODMS_ROW_WEIGHT_COLUMN_NAME" type="xs:string" minOccurs="0">
   </xs:element>
   <xs:element name="GLMS_FTR_SEL_CRIT" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_FTR_SEL_NONE"/>
      <xs:enumeration value="GLMS_FTR_SEL_AIC"/>
      <xs:enumeration value="GLMS_FTR_SEL_SBIC"/>
      <xs:enumeration value="GLMS_FTR_SEL_RIC"/>
      <xs:enumeration value="GLMS_FTR_SEL_ALPHA_INV"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_MAX_FEATURES" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minExclusive value="0"/>
      <xs:maxInclusive value="2000"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_SELECT_BLOCK" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_SELECT_BLOCK_ENABLE"/>
      <xs:enumeration value="GLMS_SELECT_BLOCK_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_PRUNE_MODEL" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_PRUNE_MODEL_ENABLE"/>
      <xs:enumeration value="GLMS_PRUNE_MODEL_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_FTR_ACCEPTANCE" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_FTR_ACCEPTANCE_STRICT"/>
      <xs:enumeration value="GLMS_FTR_ACCEPTANCE_RELAXED"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_FTR_GENERATION" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_FTR_GENERATION_ENABLE"/>
      <xs:enumeration value="GLMS_FTR_GENERATION_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_FTR_SELECTION" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_FTR_SELECTION_ENABLE"/>
      <xs:enumeration value="GLMS_FTR_SELECTION_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_FTR_GEN_METHOD" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_FTR_GEN_QUADRATIC"/>
      <xs:enumeration value="GLMS_FTR_GEN_CUBIC"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="ODMS_APPROXIMATE_COMPUTATION" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="ODMS_APPR_COMP_ENABLE"/>
      <xs:enumeration value="ODMS_APPR_COMP_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_FTR_IDENTIFICATION" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_FTR_IDENTIFICATION_QUICK"/>
      <xs:enumeration value="GLMS_FTR_IDENTIFICATION_COMPLETE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_CONV_TOLERANCE" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
      <xs:maxExclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_NUM_ITERATIONS" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_BATCH_ROWS" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
    <xs:element name="GLMS_ROW_DIAGNOSTICS" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_ROW_DIAG_ENABLE"/>
      <xs:enumeration value="GLMS_ROW_DIAG_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_SOLVER" minOccurs="0">  <!-- new in 12.2 -->
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_SOLVER_SGD"/>
      <xs:enumeration value="GLMS_SOLVER_CHOL"/>
      <xs:enumeration value="GLMS_SOLVER_QR"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="GLMS_SPARSE_SOLVER" minOccurs="0">  <!-- new in 12.2 -->
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="GLMS_SPARSE_SOLVER_ENABLE"/>
      <xs:enumeration value="GLMS_SPARSE_SOLVER_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="GroupingElementType" xdb:maintainDOM="true">
  <xs:choice>
   <xs:element ref="Attributes" minOccurs="0"/>
   <xs:element name="Expression" type="xs:string" minOccurs="0"/>
  </xs:choice>
 </xs:complexType>
 <xs:complexType name="JoinSourceNodesType">
  <xs:sequence>
   <xs:element name="SourceNode" maxOccurs="unbounded" minOccurs="0">
    <xs:complexType>
     <xs:attribute name="NodeId" use="required" type="xs:string"/>
     <xs:attribute name="NodeName" use="required" type="xs:string"/>
     <xs:attribute name="Status" type="AttributeStatus" use="required"/>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="JoinKeyColumnsType">
  <xs:sequence>
   <xs:element name="JoinColumn" maxOccurs="unbounded" minOccurs="0">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="LeftColumn" type="RefDBColumnType"/>
      <xs:element name="RightColumn" type="RefDBColumnType"/>
     </xs:sequence>
     <xs:attribute name="Type" use="required" type="JoinType"/>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
  <xs:attribute name="AutoSpec" type="AutoSpecType" use="required"/>
 </xs:complexType>
 <xs:complexType name="JoinOutputColumnsType">
  <xs:sequence>
   <xs:element name="RefDBColumn" type="RefDBColumnType" maxOccurs="unbounded"
               minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="AutoSpec" type="AutoSpecType" use="required"/>
 </xs:complexType>

 <xs:complexType name="LinkType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element ref="ConnectorGraphicsInfo"/>
  </xs:sequence>
  <xs:attribute name="Id" type="xs:string" use="required"/>
  <xs:attribute name="From" type="xs:string" use="required"/>
  <xs:attribute name="To" type="xs:string" use="required"/>
  <xs:attribute name="Name" type="xs:string" use="required"/>
  <!-- <xs:simpleType>
    <xs:restriction base="xs:string">
     <xs:minLength value="1"/>
     <xs:maxLength value="30"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>-->
  <xs:attribute name="Label" type="xs:string"/>
 </xs:complexType>

  <xs:complexType name="GeneralLinkType" xdb:maintainDOM="true">
    <xs:complexContent>
     <xs:extension base="LinkType">
     </xs:extension>
    </xs:complexContent>
  </xs:complexType>

 <xs:complexType name="JoinNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:choice>
      <xs:element name="SourceNodes" type="JoinSourceNodesType"
                  minOccurs="0"/>
      <xs:element name="KeyColumns" type="JoinKeyColumnsType" minOccurs="0"/>
     </xs:choice>
     <xs:element name="OutputColumns" type="JoinOutputColumnsType"/>
     <xs:element name="Filter" type="xs:string" xdb:SQLType="CLOB"
                 minOccurs="0"/>
    </xs:sequence>
    <xs:attribute name="UseCartesian" type="xs:boolean" use="optional"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="KMeansAlgoType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="CLUS_NUM_CLUSTERS" default="10">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="KMNS_BLOCK_GROWTH" default="2">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minExclusive value="1"/>
      <xs:maxInclusive value="5"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="KMNS_CONV_TOLERANCE" default="0.01">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
      <xs:maxInclusive value="0.5"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="KMNS_DISTANCE" default="KMNS_EUCLIDEAN">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="KMNS_COSINE"/>
      <xs:enumeration value="KMNS_EUCLIDEAN"/>
      <xs:enumeration value="KMNS_FAST_COSINE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="KMNS_ITERATIONS" default="20">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minExclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="KMNS_MIN_PCT_ATTR_SUPPORT" default="0.1">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minInclusive value="0"/>
      <xs:maxInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="KMNS_NUM_BINS" default="10">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minExclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="KMNS_SPLIT_CRITERION" default="KMNS_VARIANCE">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="KMNS_SIZE"/>
      <xs:enumeration value="KMNS_VARIANCE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="KMNS_DETAILS" default="KMNS_DETAILS_ALL" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="KMNS_DETAILS_NONE"/>
      <xs:enumeration value="KMNS_DETAILS_HIERARCHY"/>
      <xs:enumeration value="KMNS_DETAILS_ALL"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="KMNS_RANDOM_SEED" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="KMeansModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ClusteringModelType">
    <xs:sequence>
     <xs:element name="KMeansAlgo" type="KMeansAlgoType"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="LexerType">
  <xs:sequence>
   <xs:element name="Settings">
    <xs:complexType>
     <xs:sequence>
<xs:element name="Attribute" maxOccurs="unbounded" minOccurs="0">
       <xs:complexType>
        <xs:attribute name="Name" type="xs:string" use="required"/>
        <xs:attribute name="ValueString" type="xs:string" use="optional"/>
        <xs:attribute name="ValueNumber" type="xs:integer" use="optional"/>
        <xs:attribute name="Type" use="required">
         <xs:simpleType>
          <xs:restriction base="xs:string">
           <xs:enumeration value="String"/>
           <xs:enumeration value="Number"/>
          </xs:restriction>
         </xs:simpleType>
        </xs:attribute>
       </xs:complexType>
      </xs:element>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
  <xs:attribute name="Name" type="xs:string" use="optional"/>
  <xs:attribute name="Type" use="required">
   <xs:simpleType>
    <xs:restriction base="xs:string">
     <xs:enumeration value="Basic"/>
     <xs:enumeration value="Auto"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
 </xs:complexType>
 <xs:complexType name="MapTargetSourceType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="key" type="UpdateTableColumnType"/>
   <xs:element name="value" type="AttributeType"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="MapTransformedSource" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="key" type="TransformationOutputAttribute"/>
   <xs:element ref="StringCollectionNames"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="MapTextTransformedSourceType">
  <xs:sequence>
   <xs:element name="Key" type="TextTransformationOutputAttributeType"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="MessageType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:choice>
    <xs:element name="Resource" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:sequence>
       <xs:element name="Parameters">
        <xs:complexType>
         <xs:sequence>
          <xs:element name="Value" maxOccurs="unbounded" minOccurs="0">
           <xs:complexType xdb:maintainDOM="true">
            <xs:simpleContent>
             <xs:extension base="xs:string">
              <xs:attribute name="Type" type="ParameterDataType"
                            use="required"/>
              <xs:attribute name="Pos" type="xs:integer"/>
             </xs:extension>
            </xs:simpleContent>
           </xs:complexType>
          </xs:element>
         </xs:sequence>
        </xs:complexType>
       </xs:element>
      </xs:sequence>
      <xs:attribute name="Id" type="xs:string" use="required"/>
     </xs:complexType>
    </xs:element>
    <xs:element name="DisplayValue" type="xs:string" minOccurs="0"/>
   </xs:choice>
   <xs:element name="ActionKeys" minOccurs="0">
    <xs:complexType xdb:maintainDOM="true">
     <xs:sequence>
      <xs:element name="Action" maxOccurs="unbounded">
       <xs:complexType xdb:maintainDOM="true">
        <xs:simpleContent>
         <xs:extension base="xs:string">
          <xs:attribute name="Id" type="xs:string" use="required"/>
          <xs:attribute name="Order"/>
         </xs:extension>
        </xs:simpleContent>
       </xs:complexType>
      </xs:element>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
   <xs:element name="ErrorDetail" type="xs:string" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="Id" use="optional" type="xs:string"/>
  <xs:attribute name="Type" type="MessageEnumType" use="required"/>
 </xs:complexType>
 <xs:complexType name="MiningAttributeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="AttributeType">
    <xs:attribute name="AutoPrep" use="required">
     <xs:simpleType>
      <xs:restriction base="xs:string">
       <xs:enumeration value="Yes"/>
       <xs:enumeration value="No"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:attribute>
    <xs:attribute name="MiningType" use="required">
     <xs:simpleType>
      <xs:restriction base="xs:string">
       <xs:enumeration value="Categorical"/>
       <xs:enumeration value="Numerical"/>
       <xs:enumeration value="Text"/>
       <xs:enumeration value="NotApplicable"/>
       <xs:enumeration value="TextCustom"/>
     </xs:restriction>
     </xs:simpleType>
    </xs:attribute>
    <xs:attribute name="Input" use="required">
     <xs:simpleType>
      <xs:restriction base="xs:string">
       <xs:enumeration value="Yes"/>
       <xs:enumeration value="No"/>
       <xs:enumeration value="Force"/>
       <xs:enumeration value="Maybe"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:attribute>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="MiningNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="NodeType"/>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="MiningResultType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ResultType">
    <xs:attribute name="ModelId" type="xs:string" use="required"/>
    <xs:attribute name="Status" type="ModelStatusType" use="required"/>
    <xs:attribute name="Annotation" type="xs:string"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="ModelDetailsDataNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element name="ModelDetailsOutput" type="ModelDetailsOutputType"
                 minOccurs="0"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="ModelDetailsOutputType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Models">
    <xs:complexType xdb:maintainDOM="true">
     <xs:sequence>
      <xs:element name="Model" maxOccurs="unbounded" type="RefModelType"
                  minOccurs="0"/>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
   <xs:element ref="Attributes"/>
  </xs:sequence>
  <xs:attribute name="Type" type="ModelDetailType"/>
  <xs:attribute name="MiningFunction" type="MiningFunctionType"/>
  <xs:attribute name="MiningAlgorithm" type="MiningAlgorithmType"/>
  <xs:attribute name="AutoSpec" type="AutoSpecType" use="required"/>
 </xs:complexType>
 <xs:complexType name="ModelInfoType" xdb:maintainDOM="true">
  <xs:attribute name="Schema" type="xs:string" use="required">
  </xs:attribute>
  <xs:attribute name="Name" type="xs:string" use="required"/>
  <xs:attribute name="MiningFunction" use="required" type="MiningFunctionType"/>
  <xs:attribute name="MiningAlgorithm" use="required"
                type="MiningAlgorithmType"/>
  <xs:attribute name="Status" use="required" type="RefModelStatusType"/>
  <xs:attribute name="UseForOutput" use="required" type="xs:boolean"/>
  <xs:attribute name="ModelId" use="required" type="xs:string"/>
 </xs:complexType>
 <xs:complexType name="ModelNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="MiningNodeType">
    <xs:sequence>
     <xs:element name="MiningFunction" type="MiningFunctionType" minOccurs="0"/>
     <xs:element name="Models" minOccurs="0">
      <xs:complexType xdb:maintainDOM="true">
       <xs:sequence>
        <xs:element name="Model" maxOccurs="unbounded" minOccurs="0">
         <xs:complexType xdb:maintainDOM="true">
          <xs:complexContent>
           <xs:extension base="ModelInfoType">
            <xs:sequence>
             <xs:element ref="ModelSettingsODM" minOccurs="0"/>
             <xs:element ref="PartitionExpressions" minOccurs="0"/>
            </xs:sequence>
           </xs:extension>
          </xs:complexContent>
         </xs:complexType>
        </xs:element>
       </xs:sequence>
      </xs:complexType>
     </xs:element>
     <xs:element ref="TargetAttribute" minOccurs="0"/>
     <xs:element ref="TargetValues" minOccurs="0"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="ModelSettingODMType" xdb:maintainDOM="true">
  <xs:attribute name="Name" type="xs:string" use="required">
  </xs:attribute>
  <xs:attribute name="Value" use="required">
   <xs:simpleType>
    <xs:restriction base="xs:string">
     <xs:minLength value="1"/>
     <xs:maxLength value="4000"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
  <xs:attribute name="Type" type="xs:string" use="required">
  </xs:attribute>
 </xs:complexType>
 <xs:complexType name="ModelType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element ref="InputMiningData" minOccurs="0"/>
   <xs:element name="Messages" minOccurs="0">
    <xs:complexType xdb:maintainDOM="true">
     <xs:sequence>
      <xs:element name="Message" maxOccurs="unbounded" type="MessageType"/>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
  <xs:attribute name="Id" type="xs:string" use="required"/>
  <xs:attribute name="Name" type="xs:string" use="required"/>
  <xs:attribute name="Status" type="ModelStatusType" use="required"/>
  <xs:attribute name="Valid" use="optional" type="xs:boolean"/>
  <xs:attribute name="CreationDate" type="xs:dateTime" xdb:SQLType="TIMESTAMP" use="optional"/>
  <xs:attribute name="Annotation" use="optional">
   <xs:simpleType>
    <xs:restriction base="xs:string">
     <xs:minLength value="0"/>
     <xs:maxLength value="4000"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
  <xs:attribute name="UseForOutput" use="required" type="xs:boolean"/>
 </xs:complexType>
 <xs:complexType name="NaiveBayesAlgoType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="NABS_PAIRWISE_THRESHOLD" default="0.01">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minInclusive value="0"/>
      <xs:maxInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="NABS_SINGLETON_THRESHOLD" default="0.01">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minInclusive value="0"/>
      <xs:maxInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="NaiveBayesModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ClassificationModelType">
    <xs:sequence>
     <xs:element ref="NaiveBayesAlgo"/>
     <xs:element name="Prior" type="PriorType" maxOccurs="1" minOccurs="0"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="NodeType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element ref="Icon"/>
   <xs:element ref="Messages" minOccurs="0"/>
   <xs:element name="Parallelism" type="ParallelismType" minOccurs="0"/>
   <xs:element name="InMemoryColumnar" type="InMemoryColumnarType" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="Id" type="xs:string" use="required"/>
  <xs:attribute name="Name" type="xs:string" use="required"/>
  <xs:attribute name="Status" type="NodeStatusType" use="required"/>
  <xs:attribute name="Annotation" type="xs:string"/>
 </xs:complexType>
 <xs:complexType name="NonNegativeMatrixFactorAlgoType">
  <xs:sequence>
   <xs:element name="FEAT_NUM_FEATURES" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="NMFS_CONV_TOLERANCE" default="0.05">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
      <xs:maxInclusive value="0.5"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="NMFS_NUM_ITERATIONS" default="50">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="1"/>
      <xs:maxInclusive value="500"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="NMFS_RANDOM_SEED" default="-1" minOccurs="1">
    <xs:simpleType>
     <xs:restriction base="xs:integer"/>
    </xs:simpleType>
   </xs:element>
   <xs:element name="NMFS_NONNEGATIVE_SCORING" type="xs:string" minOccurs="0"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="NonNegativeMatrixFactorModelType">
  <xs:complexContent>
   <xs:extension base="ModelType">
    <xs:sequence>
     <xs:element name="NonNegativeMatrixFactorAlgo"
                 type="NonNegativeMatrixFactorAlgoType"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="OClusterAlgoType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="CLUS_NUM_CLUSTERS" default="10">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="1"/';

schema4 := '>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="OCLT_MAX_BUFFER" default="50000">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="OCLT_SENSITIVITY" default="0.5">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minInclusive value="0"/>
      <xs:maxInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="OClusterModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ClusteringModelType">
    <xs:sequence>
     <xs:element name="OClusterAlgo" type="OClusterAlgoType"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="OutputNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="NodeType"/>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="PartitionNameType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="optional">
     </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="PerformanceType" xdb:maintainDOM="true">
  <xs:choice>
   <xs:element name="Balanced" minOccurs="0">
    <xs:complexType>
     <xs:attribute name="WeightsTable" use="optional" type="xs:string"/>
    </xs:complexType>
   </xs:element>
   <xs:element name="Natural" minOccurs="0">
     <xs:complexType>
      <xs:complexContent>
       <xs:restriction base="xs:anyType"/>
      </xs:complexContent>
     </xs:complexType>
   </xs:element>
   <xs:element name="Custom" minOccurs="0">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="Weights" type="WeightsType"/>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
  </xs:choice>
 </xs:complexType>
 <xs:complexType name="PredictionType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="CostOption" minOccurs="1">
    <xs:complexType xdb:maintainDOM="true">
     <xs:choice>
      <xs:element name="None" minOccurs="0">
        <xs:complexType>
         <xs:complexContent>
          <xs:restriction base="xs:anyType"/>
         </xs:complexContent>
        </xs:complexType>
      </xs:element>
      <xs:element name="Model" minOccurs="0">
        <xs:complexType>
         <xs:complexContent>
          <xs:restriction base="xs:anyType"/>
         </xs:complexContent>
        </xs:complexType>
      </xs:element>
      <xs:element name="Inline" minOccurs="0">
       <xs:complexType xdb:maintainDOM="true">
        <xs:sequence>
         <xs:element ref="CostMatrix"/>
        </xs:sequence>
       </xs:complexType>
      </xs:element>
     </xs:choice>
    </xs:complexType>
   </xs:element>
   <xs:element name="Column">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="PredictionBoundsType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column">
    <xs:complexType>
     <xs:attribute name="Name" type="xs:string" use="optional">
     </xs:attribute>
     <xs:attribute name="LowerBound" type="xs:string" use="optional">
     </xs:attribute>
     <xs:attribute name="UpperBound" type="xs:string" use="optional">
     </xs:attribute>
     <xs:attribute name="TargetValue" use="optional"/>
     <xs:attribute name="Confidence">
      <xs:simpleType>
       <xs:restriction base="xs:double">
        <xs:minInclusive value="0"/>
        <xs:maxInclusive value="1"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="PredictionCostType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="CostOption">
    <xs:complexType xdb:maintainDOM="true">
     <xs:choice>
      <xs:element name="None" minOccurs="0">
        <xs:complexType>
         <xs:complexContent>
          <xs:restriction base="xs:anyType"/>
         </xs:complexContent>
        </xs:complexType>
      </xs:element>
      <xs:element name="Model" minOccurs="0">
        <xs:complexType>
         <xs:complexContent>
          <xs:restriction base="xs:anyType"/>
         </xs:complexContent>
        </xs:complexType>
      </xs:element>
      <xs:element name="Inline" minOccurs="0">
       <xs:complexType xdb:maintainDOM="true">
        <xs:sequence>
         <xs:element ref="CostMatrix"/>
        </xs:sequence>
       </xs:complexType>
      </xs:element>
     </xs:choice>
    </xs:complexType>
   </xs:element>
   <xs:element name="Column">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
     <xs:attribute name="TargetValue" use="optional"/>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="PredictionDetailsType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
     <xs:attribute name="TargetValue"/>
     <xs:attribute name="TopNValue">
      <xs:simpleType>
       <xs:restriction base="xs:integer">
        <xs:minExclusive value="0"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
     <xs:attribute name="Sort">
       <xs:simpleType>
       <xs:restriction base="xs:string">
       <xs:enumeration value="DESC"/>
       <xs:enumeration value="ASC"/>
       <xs:enumeration value="ABS"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="PredictionProbabilityType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
     <xs:attribute name="TargetValue" use="optional"/>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="PredictionSetType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="CostOption">
    <xs:complexType xdb:maintainDOM="true">
     <xs:choice>
      <xs:element name="None" minOccurs="0">
        <xs:complexType>
         <xs:complexContent>
          <xs:restriction base="xs:anyType"/>
         </xs:complexContent>
        </xs:complexType>
      </xs:element>
      <xs:element name="Model" minOccurs="0">
        <xs:complexType>
         <xs:complexContent>
          <xs:restriction base="xs:anyType"/>
         </xs:complexContent>
        </xs:complexType>
      </xs:element>
      <xs:element name="Inline" minOccurs="0">
       <xs:complexType xdb:maintainDOM="true">
        <xs:sequence>
         <xs:element ref="CostMatrix"/>
        </xs:sequence>
       </xs:complexType>
      </xs:element>
     </xs:choice>
    </xs:complexType>
   </xs:element>
   <xs:element name="Column" minOccurs="1">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
     <xs:attribute name="TopNValue">
      <xs:simpleType>
       <xs:restriction base="xs:integer">
        <xs:minExclusive value="0"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
     <xs:attribute name="ProbCutOff">
      <xs:simpleType>
       <xs:restriction base="xs:double">
        <xs:minInclusive value="0"/>
        <xs:maxInclusive value="1"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
     <xs:attribute name="CostCutOff">
      <xs:simpleType>
       <xs:restriction base="xs:double">
        <xs:minInclusive value="0"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="PriorType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Item" maxOccurs="unbounded" minOccurs="0">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="TargetValue" type="TargetValueStringType"
                   use="required"></xs:attribute>
     <xs:attribute name="Prob" type="xs:double" use="required"/>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="RefDBColumnType">
  <xs:complexContent>
   <xs:extension base="DBColumnType">
    <xs:attribute name="NodeId" use="required" type="xs:string"/>
    <xs:attribute name="NodeName" use="required" type="xs:string"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="RefModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ModelInfoType">
    <xs:attribute name="IsModelBuilt" type="xs:boolean" use="required"/>
    <xs:attribute name="NodeId" use="required" type="xs:string"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="RegressionBuildNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="SuperviseBuildNodeType">
    <xs:sequence>
     <xs:element name="Models">
      <xs:complexType xdb:maintainDOM="true">
       <xs:sequence>
        <xs:element ref="RSupportVectorMachineModel" minOccurs="0"
                    maxOccurs="unbounded" xdb:defaultTable="SUPT_VECTOR_MACH_R_M_TAB" xdb:SQLInline="false"/>
        <xs:element ref="RGeneralizedLinearModel" minOccurs="0"
                    maxOccurs="unbounded" xdb:defaultTable="GEN_LINEAR_R_M_TAB" xdb:SQLInline="false"/>
       </xs:sequence>
      </xs:complexType>
     </xs:element>
     <xs:element name="Results" minOccurs="1">
      <xs:complexType xdb:maintainDOM="true">
       <xs:sequence>
        <xs:element minOccurs="0" maxOccurs="unbounded" ref="RegressionResult"/>
       </xs:sequence>
       <xs:attribute name="genAccuracyMetrics" type="xs:boolean" use="optional"/>
       <xs:attribute name="genResiduals" type="xs:boolean" use="optional"/>
       <xs:attribute name="useGroupingForPartition" type="xs:boolean" use="optional"/>
      </xs:complexType>
     </xs:element>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="RegressionModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="SuperviseModelType"/>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="RegressionResultType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="MiningResultType">
    <xs:sequence>
     <xs:element ref="TestMetrics" xdb:SQLInline="false" xdb:defaultTable="TEST_METRICS_REGR_TABLE"
                 minOccurs="0"/>
     <xs:element ref="ResidualPlot" xdb:SQLInline="false" xdb:defaultTable="RESIDUAL_PLOT_TABLE"
                 minOccurs="0"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="ResultType" xdb:maintainDOM="true">
  <xs:attribute name="Name" type="xs:string" use="required">
  </xs:attribute>
  <xs:attribute name="CreationDate" type="xs:dateTime" xdb:SQLType="TIMESTAMP"
                use="optional"/>
 </xs:complexType>
 <xs:complexType name="RGeneralizedLinearAlgoType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="GeneralizedLinearAlgoType"/>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="RGeneralizedLinearModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="RegressionModelType">
    <xs:sequence>
     <xs:element ref="RGeneralizedLinearModelAlgo"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="RowFilterOutputColumnsType">
  <xs:sequence>
   <xs:element name="Attribute" minOccurs="0" maxOccurs="unbounded"
               type="AttributeType"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="RowFilterNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element name="OutputColumns" type="RowFilterOutputColumnsType"/>
     <xs:element name="Filter" type="xs:string" xdb:SQLType="CLOB"
                 minOccurs="0"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="RSupportVectorMachineAlgoType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="SupportVectorMachineAlgoType">
    <xs:sequence>
     <xs:element name="SVMS_EPSILON" minOccurs="0">
      <xs:simpleType>
       <xs:restriction base="xs:double">
        <xs:minExclusive value="0"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:element>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="RSupportVectorMachineModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="RegressionModelType">
    <xs:sequence>
     <xs:element ref="RSupportVectorMachineAlgo"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="SamplingSettingsType">
  <xs:sequence minOccurs="1">
   <xs:choice>
    <xs:element name="NumberOfRows" default="2000" minOccurs="0">
     <xs:simpleType>
      <xs:restriction base="xs:long">
       <xs:minInclusive value="1"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:element>
    <xs:element name="PercentOfTotal" default="10" minOccurs="0">
     <xs:simpleType>
      <xs:restriction base="xs:double">
       <xs:maxInclusive value="100"/>
       <xs:minInclusive value="1"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:element>
   </xs:choice>
   <xs:element name="Method">
    <xs:complexType xdb:maintainDOM="true">
     <xs:choice>
      <xs:element name="Random" minOccurs="0">
       <xs:complexType xdb:maintainDOM="true">
        <xs:attribute name="Seed" type="xs:integer" use="required"/>
       </xs:complexType>
      </xs:element>
      <xs:element name="Stratified" minOccurs="0">
       <xs:complexType xdb:maintainDOM="true">
        <xs:sequence>
         <xs:element name="Distributions">
          <xs:complexType>
           <xs:sequence>
            <xs:element name="Distribution" maxOccurs="unbounded" minOccurs="0">
             <xs:complexType>
              <xs:attribute name="TargetValue" use="required">
               <xs:simpleType>
                <xs:restriction base="xs:string">
                 <xs:minLength value="1"/>
                 <xs:maxLength value="32767"/>
                </xs:restriction>
               </xs:simpleType>
              </xs:attribute>
              <xs:attribute name="Count" type="xs:integer" use="required"/>
             </xs:complexType>
            </xs:element>
           </xs:sequence>
          </xs:complexType>
         </xs:element>
        </xs:sequence>
        <xs:attribute name="TargetAttr" type="xs:string" use="required">
        </xs:attribute>
        <xs:attribute name="DataType" type="xs:string" use="required">
        </xs:attribute>
        <xs:attribute name="Status" type="AttributeStatus" use="required"/>
        <xs:attribute name="Type" use="required" type="StratifiedType"/>
        <xs:attribute name="Seed" type="xs:integer" use="required"/>
       </xs:complexType>
      </xs:element>
      <xs:element name="TopN" minOccurs="0">
       <xs:complexType xdb:maintainDOM="true"/>
      </xs:element>
     </xs:choice>
    </xs:complexType>
   </xs:element>
   <xs:element name="CaseAttribute" type="AttributeType" minOccurs="0"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="SampleNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element name="SamplingSettings" type="SamplingSettingsType"/>
     <xs:element name="StatisticTable" minOccurs="0">
      <xs:complexType>
       <xs:complexContent>
        <xs:extension base="ResultType">
         <xs:attribute name="Column" type="xs:string" use="required">
           </xs:attribute>
        </xs:extension>
       </xs:complexContent>
      </xs:complexType>
     </xs:element>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="StoplistType">
  <xs:sequence>
   <xs:element name="StopTokens">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="Token" maxOccurs="unbounded" minOccurs="0">
       <xs:complexType>
        <xs:sequence>
         <xs:element name="Item" type="xs:string"/>
        </xs:sequence>
        <xs:attribute name="Type" use="required">
         <xs:simpleType>
          <xs:restriction base="xs:string">
           <xs:enumeration value="Word"/>
           <xs:enumeration value="Theme"/>
          </xs:restriction>
         </xs:simpleType>
        </xs:attribute>
        <xs:attribute name="Language" type="xs:string" use="required"/>
       </xs:complexType>
      </xs:element>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
  <xs:attribute name="Id" type="xs:string" use="required"/>
  <xs:attribute name="Name" type="xs:string" use="required"/>
  <xs:attribute name="Type" use="required">
   <xs:simpleType>
    <xs:restriction base="xs:string">
     <xs:enumeration value="Basic"/>
     <xs:enumeration value="Multi"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
  <xs:attribute name="Language" type="xs:string" use="required"/>
  <xs:attribute name="DBName" type="xs:string"/>
 </xs:complexType>
 <xs:complexType name="StringCollection" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Value" maxOccurs="unbounded" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string"/>
    </xs:simpleType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="SuperviseBuildNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="BuildNodeType">
    <xs:sequence>
     <xs:element ref="TestDataSource" minOccurs="0"/>
     <xs:element ref="TargetAttribute" minOccurs="0"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="SuperviseModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ModelType">
    <xs:sequence>
     <xs:element ref="TargetAttribute" minOccurs="0"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="SupplementalAttributesType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element ref="Attribute" maxOccurs="unbounded" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="AutoSpec" type="AutoSpecType" use="required"/>
 </xs:complexType>
 <xs:complexType name="SupportVectorMachineAlgoType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="SVMS_ACTIVE_LEARNING" default="SVMS_AL_ENABLE">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="SVMS_AL_ENABLE"/>
      <xs:enumeration value="SVMS_AL_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVMS_COMPLEXITY_FACTOR" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVMS_CONV_TOLERANCE" default="0.001">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVMS_KERNEL_CACHE_SIZE" default="50000000" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minExclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVMS_KERNEL_FUNCTION" default="SVMS_LINEAR" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="SVMS_GAUSSIAN"/>
      <xs:enumeration value="SVMS_LINEAR"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVMS_STD_DEV" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVMS_REGULARIZER" minOccurs="0">  <!-- new in 12.2 -->
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="SVMS_REGULARIZER_L1"/>
      <xs:enumeration value="SVMS_REGULARIZER_L2"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
  <xs:element name="SVMS_SOLVER" type="xs:string" minOccurs="0">
   </xs:element>
   <xs:element name="SVMS_BATCH_ROWS" default="20000" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVMS_NUM_ITERATIONS" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
    <xs:element name="SVMS_NUM_PIVOTS" default="200" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="TableType" xdb:maintainDOM="true">
  <xs:attribute name="Schema" type="xs:string" use="optional">
  </xs:attribute>
  <xs:attribute name="Name" type="xs:string" use="optional">
  </xs:attribute>
  <xs:attribute name="Synonym" use="optional">
   <xs:simpleType>
    <xs:restriction base="xs:boolean">
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
 </xs:complexType>
 <xs:complexType name="TargetResultType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ResultType">
    <xs:attribute name="TargetValue" use="required"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="TestDetailsDataNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType"/>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="TestNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="MiningNodeType">
    <xs:sequence>
     <xs:element ref="TargetAttribute" minOccurs="0"/>
     <xs:element name="TestSettings" type="ClassificationTestSettingsType"
                 minOccurs="0"/>
     <xs:element ref="CaseAttributes"/>
     <xs:element name="TestModels" type="TestModelType"/>
     <xs:element name="Results">
      <xs:complexType>
       <xs:choice>
        <xs:element minOccurs="0" maxOccurs="unbounded"
                    ref="ClassificationResult"/>
        <xs:element minOccurs="0" maxOccurs="unbounded" ref="RegressionResult"/>
       </xs:choice>
       <xs:attribute name="genAccuracyMetrics" type="xs:boolean" use="optional"/>
       <xs:attribute name="genConfusionMatrix" type="xs:boolean" use="optional"/>
       <xs:attribute name="genROC" type="xs:boolean" use="optional"/>
       <xs:attribute name="genLift" type="xs:boolean" use="optional"/>
       <xs:attribute name="genResiduals" type="xs:boolean" use="optional"/>
       <xs:attribute name="useGroupingForPartition" type="xs:boolean" use="optional"/>
      </xs:complexType>
     </xs:element>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="TestModelType">
  <xs:sequence>
   <xs:element name="Model" maxOccurs="unbounded" minOccurs="0">
    <xs:complexType>
     <xs:complexContent>
      <xs:extension base="RefModelType">
       <xs:sequence>
        <xs:element ref="PartitionExpressions" minOccurs="0"/>
       </xs:sequence>
       <xs:attribute name="TestStatus" type="ModelStatusType" use="required"/>
      </xs:extension>
     </xs:complexContent>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
  <xs:attribute name="MiningFunction" type="MiningFunctionType" use="optional"/>
  <xs:attribute name="AutoSpec" type="AutoSpecType" use="required"/>
  <xs:attribute name="Archive" use="required">
   <xs:simpleType>
    <xs:restriction base="xs:string">
     <xs:enumeration value="Yes"/>
     <xs:enumeration value="No"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
  <xs:attribute name="generatePartitions" type="xs:boolean" use="optional" default="false"/>
 </xs:complexType>
 <xs:complexType name="TextNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element ref="CaseAttributes"/>
     <xs:element ref="TransformationSourceAttributes"/>
     <xs:element name="Stoplists">
      <xs:complexType>
       <xs:sequence>
        <xs:element name="Stoplist" maxOccurs="unbounded"
                    minOccurs="0" type="StoplistType"/>
       </xs:sequence>
      </xs:complexType>
     </xs:element>
     <xs:element name="TransformedAttributes" type="TransformedAttributesType"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="TransformedAttributesType">
  <xs:sequence>
   <xs:element name="MapTextTransformedSource" maxOccurs="unbounded" minOccurs="0"
               type="MapTextTransformedSourceType"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="TextTransformationOutputAttributeType">
  <xs:complexContent>
   <xs:extension base="TransformationSourceAttribute">
    <xs:sequence>
     <xs:element name="TransformationElement" type="TextTransformationType"/>
     <xs:element name="Modified" minOccurs="1">
      <xs:simpleType>
       <xs:restriction base="xs:boolean"/>
      </xs:simpleType>
     </xs:element>
    </xs:sequence>
    <xs:attribute name="Source" use="required" type="xs:string"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="TransformationTokenType">
  <xs:sequence>
   <xs:element name="Token">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="Lexer" type="LexerType" minOccurs="0"/>
      <xs:element name="Languages">
       <xs:complexType>
        <xs:sequence>
         <xs:element name="Language" minOccurs="0" maxOccurs="unbounded">
          <xs:complexType>
           <xs:attribute name="Name" use="required"/>
           <xs:attribute name="Type" use="required">
            <xs:simpleType>
             <xs:restriction base="xs:string">
              <xs:enumeration value="SingleByte"/>
              <xs:enumeration value="MultiByte"/>
             </xs:restriction>
            </xs:simpleType>
           </xs:attribute>
          </xs:complexType>
         </xs:element>
        </xs:sequence>
       </xs:complexType>
      </xs:element>
      <xs:element name="StatisticTable" type="ResultType" minOccurs="0"/>
      <xs:element name="FeatureTable" type="ResultType" minOccurs="0"/>
     </xs:sequence>
     <xs:attribute name="MaxNumberPerDoc" use="required">
      <xs:simpleType>
       <xs:restriction base="xs:integer">
        <xs:minExclusive value="0"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
     <xs:attribute name="MaxNumberAllDocs" use="required"><!-- ODMS_TEXT_MAX_FEATURES -->
      <xs:simpleType>
       <xs:restriction base="xs:integer">
        <xs:minExclusive value="0"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
    <xs:attribute name="MinNumberAllDocs" use="optional"><!-- ODMS_TEXT_MIN_DOCUMENTS -->
      <xs:simpleType>
       <xs:restriction base="xs:integer">
        <xs:minExclusive value="0"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
     <xs:attribute name="Frequency" use="required">
      <xs:simpleType>
       <xs:restriction base="xs:string">
        <xs:enumeration value="Terms"/>
        <xs:enumeration value="IDF"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
     <xs:attribute name="StoplistId" type="xs:string"/>
     <xs:attribute name="Policy" type="xs:string"/>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="TextTransformationType">
  <xs:choice>
   <xs:element name="Token" type="TransformationTokenType" minOccurs="0"/>
   <xs:element name="Theme" minOccurs="0">
    <xs:complexType>
     <xs:complexContent>
      <xs:extension base="TransformationTokenType">
       <xs:attribute name="Type" use="required">
        <xs:simpleType>
         <xs:restriction base="xs:string">
          <xs:enumeration value="Single"/>
          <xs:enumeration value="Full"/>
         </xs:restriction>
        </xs:simpleType>
       </xs:attribute>
      </xs:extension>
     </xs:complexContent>
    </xs:complexType>
   </xs:element>
   <xs:element name="Synonym" minOccurs="0">
   <xs:complexType>
     <xs:complexContent>
      <xs:extension base="TransformationTokenType">
       <xs:attribute name="Thesaurus" type="xs:string" use="optional"/>
      </xs:extension>
     </xs:complexContent>
    </xs:complexType>
   </xs:element>
  </xs:choice>
 </xs:complexType>
 <xs:complexType name="TransformsNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="DataNodeType"/>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="TransformationNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element ref="TransformationSourceAttributes"/>
     <xs:element ref="TransformedAttributes"/>
     <xs:element name="DataProfileSettings" type="DataProfileSettingsType"/>
     <xs:element ref="SampleSettings"/>
     <xs:element name="InputStatisticTable" type="ResultType" minOccurs="0"/>
     <xs:element name="TransformedStatisticTable" type="ResultType"
                 minOccurs="0"/>
     <xs:element ref="StatsSelection" minOccurs="0"/>
    </xs:sequence>
    <xs:attribute name="NullsLabel" type="xs:string" use="optional"/>
    <xs:attribute name="OtherLabel" type="xs:string" use="optional"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="TransformationOutputAttribute" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformationSourceAttribute">
    <xs:sequence>
     <xs:element ref="TransformationElementType"/>
     <xs:element name="Modified" minOccurs="1">
      <xs:simpleType>
       <xs:restriction base="xs:boolean"/>
      </xs:simpleType>
     </xs:element>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="TransformationSourceAttribute" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="AttributeType">
    <xs:sequence>
     <xs:element name="IsOutput" minOccurs="1">
      <xs:simpleType>
       <xs:restriction base="xs:boolean"/>
      </xs:simpleType>
     </xs:element>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="TransformationType"';

schema5 := ' xdb:maintainDOM="true">
  <xs:sequence>
   <xs:choice>
    <xs:element name="Normalization" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:choice>

       <xs:element name="Manual" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:complexContent>
           <xs:extension base="NormalizationValues">
         <!--
         <xs:attribute name="Shift" default="0">
          <xs:simpleType>
           <xs:restriction base="xs:double">
            <xs:minInclusive value="0"/>
           </xs:restriction>
          </xs:simpleType>
         </xs:attribute>
         <xs:attribute name="Scale" default="1">
          <xs:simpleType>
           <xs:restriction base="xs:double">
            <xs:minInclusive value="0"/>
           </xs:restriction>
          </xs:simpleType>
         </xs:attribute>
        -->
          </xs:extension>
         </xs:complexContent>
        </xs:complexType>
       </xs:element>

       <xs:element name="MinMax" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:complexContent>
           <xs:extension base="NormalizationValues"/>
         </xs:complexContent>
        </xs:complexType>
       </xs:element>

       <xs:element name="ZScore" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:complexContent>
           <xs:extension base="NormalizationValues"/>
         </xs:complexContent>
        </xs:complexType>
       </xs:element>

       <xs:element name="LinearScale" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:complexContent>
           <xs:extension base="NormalizationValues"/>
         </xs:complexContent>
        </xs:complexType>
       </xs:element>

      </xs:choice>
     </xs:complexType>
    </xs:element>
    <xs:element name="Outlier" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:choice>
       <xs:element name="StandardDeviation" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:complexContent>
           <xs:extension base="OutlierBound">
             <xs:attribute name="MultiplesSigma" default="3">
              <xs:simpleType>
               <xs:restriction base="xs:double">
                <xs:minExclusive value="0"/>
                <xs:maxExclusive value="20"/>
               </xs:restriction>
              </xs:simpleType>
             </xs:attribute>
             </xs:extension>
          </xs:complexContent>
        </xs:complexType>
       </xs:element>
       <xs:element name="Percent" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:complexContent>
           <xs:extension base="OutlierBound">
             <xs:attribute name="LowerPercent" default="5">
              <xs:simpleType>
               <xs:restriction base="xs:double">
                <xs:minInclusive value="0"/>
                <xs:maxInclusive value="100"/>
               </xs:restriction>
              </xs:simpleType>
             </xs:attribute>
             <xs:attribute name="UpperPercent" default="5">
              <xs:simpleType>
               <xs:restriction base="xs:double">
                <xs:minInclusive value="0"/>
                <xs:maxInclusive value="100"/>
               </xs:restriction>
              </xs:simpleType>
             </xs:attribute>
             </xs:extension>
          </xs:complexContent>
        </xs:complexType>
       </xs:element>
       <xs:element name="Value" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:attribute name="LowerValue" default="0">
          <xs:simpleType>
           <xs:restriction base="xs:double"/>
          </xs:simpleType>
         </xs:attribute>
         <xs:attribute name="UpperValue" default="1">
          <xs:simpleType>
           <xs:restriction base="xs:double"/>
          </xs:simpleType>
         </xs:attribute>
        </xs:complexType>
       </xs:element>
      </xs:choice>
      <xs:attribute name="ReplaceWith" default="Nulls">
       <xs:simpleType>
        <xs:restriction base="xs:string">
         <xs:enumeration value="Nulls"/>
         <xs:enumeration value="EdgeValues"/>
        </xs:restriction>
       </xs:simpleType>
      </xs:attribute>
     </xs:complexType>
    </xs:element>
    <xs:element name="MissingValuesNumeric" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:choice>
       <xs:element ref="NumericStatistic" minOccurs="0"/>
       <xs:element name="Value" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:attribute name="ReplaceNullsWith" default="0">
          <xs:simpleType>
           <xs:restriction base="xs:double"/>
          </xs:simpleType>
         </xs:attribute>
        </xs:complexType>
       </xs:element>
      </xs:choice>
     </xs:complexType>
    </xs:element>
    <xs:element name="MissingValuesCategorical" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:choice>
       <xs:element ref="CategoricalStatistic" minOccurs="0"/>
       <xs:element name="Value" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:attribute name="ReplaceNullsWith" default="0">
          <xs:simpleType>
           <xs:restriction base="xs:string"/>
          </xs:simpleType>
         </xs:attribute>
        </xs:complexType>
       </xs:element>
      </xs:choice>
     </xs:complexType>
    </xs:element>
    <xs:element name="MissingValuesDate" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:choice>
       <xs:element ref="DateStatistic" minOccurs="0"/>
       <xs:element name="Value" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:attribute name="ReplaceNullsWith" type="xs:dateTime" xdb:SQLType="TIMESTAMP WITH TIME ZONE" use="optional"/>
        </xs:complexType>
       </xs:element>
      </xs:choice>
     </xs:complexType>
    </xs:element>

    <xs:element name="CustomTransformationEx" type="xs:string" xdb:SQLType="CLOB" xdb:defaultTable="" minOccurs="0"/>
 
    <xs:element name="CustomTransformation" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:attribute name="Value" default="0">
       <xs:simpleType>
        <xs:restriction base="xs:string">
         <xs:minLength value="1"/>
         <xs:maxLength value="32767"/>
        </xs:restriction>
       </xs:simpleType>
      </xs:attribute>
     </xs:complexType>
    </xs:element>
    <xs:element name="Binning" minOccurs="0">
     <xs:complexType xdb:maintainDOM="true">
      <xs:choice>
       <xs:element name="Quantile" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:complexContent>
          <xs:extension base="NumericCutPoints">
           <xs:sequence>
            <xs:element ref="BinCount"/>
            <xs:element ref="BinGeneration"/>
           </xs:sequence>
          </xs:extension>
         </xs:complexContent>
        </xs:complexType>
       </xs:element>

      <xs:element name="CustomNumeric" minOccurs="0">
       <xs:complexType xdb:maintainDOM="true">
         <xs:complexContent>
          <xs:extension base="NumericCutPoints">
          </xs:extension>
         </xs:complexContent>
        </xs:complexType>
      </xs:element>

      <xs:element name="CustomCategorical" minOccurs="0">
       <xs:complexType xdb:maintainDOM="true">
        <xs:complexContent>
         <xs:extension base="CategoricalCutPoints">
         </xs:extension>
        </xs:complexContent>
       </xs:complexType>
      </xs:element>

      <xs:element name="CustomDate" minOccurs="0">
       <xs:complexType xdb:maintainDOM="true">
        <xs:complexContent>
         <xs:extension base="CustomDateCutPoints">
         </xs:extension>
        </xs:complexContent>
       </xs:complexType>
      </xs:element>

      <xs:element name="CustomTimestamp" minOccurs="0">
       <xs:complexType xdb:maintainDOM="true">
        <xs:complexContent>
         <xs:extension base="CustomTimestampCutPoints">
         </xs:extension>
        </xs:complexContent>
       </xs:complexType>
      </xs:element>

       <xs:element name="EqualWidth" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:complexContent>
           <xs:extension base="NumericCutPoints">
            <xs:sequence>
             <xs:element ref="BinCount"/>
             <xs:element ref="BinGeneration"/>
            </xs:sequence>
           </xs:extension>
          </xs:complexContent>
        </xs:complexType>
       </xs:element>
       <xs:element name="DateEqualWidth" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:complexContent>
           <xs:extension base="CustomDateCutPoints">
             <xs:sequence>
              <xs:element ref="BinCount"/>
              <xs:element ref="BinGeneration"/>
             </xs:sequence>
           </xs:extension>
          </xs:complexContent>
        </xs:complexType>
       </xs:element>
       <xs:element name="TimestampEqualWidth" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:complexContent>
           <xs:extension base="CustomTimestampCutPoints">
             <xs:sequence>
              <xs:element ref="BinCount"/>
              <xs:element ref="BinGeneration"/>
             </xs:sequence>
           </xs:extension>
          </xs:complexContent>
        </xs:complexType>
       </xs:element>
       <xs:element name="TopN" minOccurs="0">
        <xs:complexType xdb:maintainDOM="true">
         <xs:complexContent>
          <xs:extension base="CategoricalCutPoints">
           <xs:sequence>
            <xs:element ref="BinCount"/>
            <xs:element name="Other">
             <xs:simpleType>
              <xs:restriction base="xs:string"/>
             </xs:simpleType>
            </xs:element>
           </xs:sequence>
          </xs:extension>
         </xs:complexContent>
        </xs:complexType>
       </xs:element>
      </xs:choice>
     </xs:complexType>
    </xs:element>
   </xs:choice>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="TuningType" xdb:maintainDOM="true">
  <xs:choice>
   <xs:element name="None" minOccurs="0">
     <xs:complexType>
      <xs:complexContent>
       <xs:restriction base="xs:anyType"/>
      </xs:complexContent>
     </xs:complexType>
   </xs:element>
   <xs:element name="Cost" minOccurs="0">
    <xs:complexType xdb:maintainDOM="true">
     <xs:sequence>
      <xs:element ref="CostMatrix"/>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
   <xs:element name="Benefit" minOccurs="0">
    <xs:complexType xdb:maintainDOM="true">
     <xs:sequence>
      <xs:element name="BenefitWeights" type="WeightsType"/>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
   <xs:element name="Custom" minOccurs="0">
    <xs:complexType xdb:maintainDOM="true">
     <xs:sequence>
      <xs:element name="Settings">
       <xs:complexType xdb:maintainDOM="true">
        <xs:choice>
         <xs:element name="ROC" minOccurs="0">
          <xs:complexType xdb:maintainDOM="true">
           <xs:sequence>
            <xs:element name="CustomThreshold" minOccurs="0">
             <xs:complexType xdb:maintainDOM="true">
              <xs:attribute name="Type" use="required"
                            type="ROCCustomThresholdType"/>
              <xs:attribute name="Value" use="required" type="xs:double"/>
             </xs:complexType>
            </xs:element>
           </xs:sequence>
           <xs:attribute name="Accuracy" use="required" type="ROCAccuracyType"/>
           <xs:attribute name="Threshold" type="xs:double" use="required"/>
          </xs:complexType>
         </xs:element>
         <xs:element name="Lift" minOccurs="0">
          <xs:complexType>
           <xs:attribute name="Type" use="required" type="LiftType"/>
           <xs:attribute name="Quantile" use="required" type="xs:integer"/>
           <xs:attribute name="Threshold" type="xs:double" use="required"/>
          </xs:complexType>
         </xs:element>
         <xs:element name="Profit" minOccurs="0">
          <xs:complexType>
           <xs:attribute name="Population" use="required" type="xs:integer"/>
           <xs:attribute name="Profit" type="xs:double" use="required"/>
           <xs:attribute name="ROI" use="required" type="xs:double"/>
          </xs:complexType>
         </xs:element>
        </xs:choice>
        <xs:attribute name="TargetValue" use="required" type="xs:string"/>
       </xs:complexType>
      </xs:element>
      <xs:element ref="CostMatrix"/>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
  </xs:choice>
 </xs:complexType>
 <xs:complexType name="UpdateTableColumnType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="AttributeType">
    <xs:attribute name="RequiredColumn" type="xs:boolean" use="required"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="UpdateTableNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="DataNodeType">
    <xs:sequence>
     <xs:element ref="UpdateTargetTable" minOccurs="0"/>
     <xs:element ref="UpdateTableAttributes"/>
     <xs:element name="CreateTableOptions" type="CreateTableOptionsType" minOccurs="0"/>
    </xs:sequence>
    <xs:attribute name="DropExisting" type="xs:boolean" use="required"/>
    <xs:attribute name="AutoSpec" type="AutoSpecType" default="Yes"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="WeightsType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Item" maxOccurs="unbounded" minOccurs="0">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="TargetValue" type="TargetValueStringType"
                   use="required"></xs:attribute>
     <xs:attribute name="Weight" type="xs:double" use="required"/>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>

 <!-- Transformation Start -->

 <!-- custom transforms definitions -->
 <!--
 <xs:element name="StringCollection" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element name="Value" maxOccurs="unbounded" minOccurs="0">
     <xs:simpleType>
      <xs:restriction base="xs:string"/>
     </xs:simpleType>
    </xs:element>
    </xs:sequence>
   </xs:complexType>
  </xs:element>
-->

 <!-- definitions to support binning -->
 <xs:element name="BinGeneration" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:choice>
    <xs:element name="Auto" minOccurs="0">
      <xs:complexType>
       <xs:complexContent>
        <xs:restriction base="xs:anyType"/>
       </xs:complexContent>
      </xs:complexType>
    </xs:element>
    <xs:element name="Manual" minOccurs="0">
      <xs:complexType>
       <xs:complexContent>
        <xs:restriction base="xs:anyType"/>
       </xs:complexContent>
      </xs:complexType>
    </xs:element>
   </xs:choice>
  </xs:complexType>
 </xs:element>

 <xs:element name="BinCount" default="10" xdb:defaultTable="">
  <xs:simpleType>
   <xs:restriction base="xs:integer">
    <xs:minInclusive value="1"/>
   </xs:restriction>
  </xs:simpleType>
 </xs:element>

 <xs:element name="BinLabels" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:choice>
    <xs:element name="Range" minOccurs="0">
      <xs:complexType>
       <xs:complexContent>
        <xs:restriction base="xs:anyType"/>
       </xs:complexContent>
      </xs:complexType>
    </xs:element>
    <xs:element name="NumberSequence" minOccurs="0">
      <xs:complexType>
       <xs:complexContent>
        <xs:restriction base="xs:anyType"/>
       </xs:complexContent>
      </xs:complexType>
    </xs:element>
   </xs:choice>
  </xs:complexType>
 </xs:element>
 <xs:element name="CategoricalBin" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element name="Name">
     <xs:simpleType>
      <xs:restriction base="xs:string"/>
     </xs:simpleType>
    </xs:element>
    <xs:element name="IsOther" minOccurs="1" default="false">
     <xs:simpleType>
      <xs:restriction base="xs:boolean"/>
     </xs:simpleType>
    </xs:element>
    <xs:element ref="StringCollectionValues"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>

 <xs:element name="DateBin" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element name="Name">
     <xs:simpleType>
      <xs:restriction base="xs:string"/>
     </xs:simpleType>
    </xs:element>
    <xs:element name="LowerBound">
     <xs:complexType xdb:maintainDOM="true">
      <xs:attribute name="Value" type="xs:dateTime" xdb:SQLType="TIMESTAMP WITH TIME ZONE" use="optional"/>
     </xs:complexType>
    </xs:element>
   </xs:sequence>
  </xs:complexType>
 </xs:element>

 <xs:element name="TimestampTimezoneBin" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element name="Name">
     <xs:simpleType>
      <xs:restriction base="xs:string"/>
     </xs:simpleType>
    </xs:element>
    <xs:element name="LowerBound">
     <xs:complexType xdb:maintainDOM="true">
      <xs:attribute name="Value" type="xs:dateTime" xdb:SQLType="TIMESTAMP WITH TIME ZONE" use="optional"/>
     </xs:complexType>
    </xs:element>
   </xs:sequence>
  </xs:complexType>
 </xs:element>

  <!-- Definitions to support NULLs handling in transformations -->
  <xs:element name="TransformNulls" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element name="Label" default="Null bin">
     <xs:simpleType>
      <xs:restriction base="xs:string"/>
     </xs:simpleType>
    </xs:element>
    <xs:element name="IncludeNulls" default="true">
     <xs:simpleType>
      <xs:restriction base="xs:boolean"/>
     </xs:simpleType>
    </xs:element>
    <xs:element name="NullBinId" type="xs:integer" default="0" minOccurs="0"/>
    <xs:element name="NullBinsSelection" default="Auto" minOccurs="0">
     <xs:simpleType>
      <xs:restriction base="xs:string">
        <xs:enumeration value="Auto"/>
        <xs:enumeration value="Custom"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:element>
   </xs:sequence>
  </xs:complexType>
  </xs:element>

  <!-- Definitions to support Generate for Apply -->
  <xs:complexType name="NumericCutPoints" xdb:maintainDOM="true" >
   <xs:sequence>
    <xs:sequence>
     <xs:element ref="NumericBin" maxOccurs="unbounded" minOccurs="0"/>
    </xs:sequence>
    <xs:element ref="BinLabels"/>
    <xs:element ref="TransformNulls" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>

  <xs:complexType name="CategoricalCutPoints"  xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="CategoricalBin" maxOccurs="unbounded" minOccurs="0"/>
    <xs:element ref="TransformNulls" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>

  <xs:complexType name="CustomDateCutPoints"  xdb:maintainDOM="true">
   <xs:sequence>
    <xs:sequence>
     <xs:element ref="DateBin" maxOccurs="unbounded" minOccurs="0"/>
    </xs:sequence>
    <xs:element ref="BinLabels"/>
    <xs:element ref="TransformNulls" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>

  <xs:complexType name="CustomTimestampCutPoints" xdb:maintainDOM="true">
   <xs:sequence>
    <xs:sequence>
     <xs:element ref="TimestampTimezoneBin" maxOccurs="unbounded" minOccurs="0"/>
    </xs:sequence>
    <xs:element ref="BinLabels"/>
    <xs:element ref="TransformNulls" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>

  <xs:complexType name="OutlierBound" xdb:maintainDOM="true">
   <xs:attribute name="LowerValue" default="0">
    <xs:simpleType>
     <xs:restriction base="xs:double"/>
    </xs:simpleType>
   </xs:attribute>
   <xs:attribute name="UpperValue" default="1">
    <xs:simpleType>
     <xs:restriction base="xs:double"/>
    </xs:simpleType>
   </xs:attribute>
  </xs:complexType>

  <xs:complexType name="NormalizationValues" xdb:maintainDOM="true">
   <xs:attribute name="shift">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minInclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:attribute>
   <xs:attribute name="scale">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minInclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:attribute>
  </xs:complexType>

  <!-- End of definitions to support Generate for Apply -->
 <!-- end -->

 <!-- Definitions for Missing Values -->
 <xs:element name="CategoricalStatistic" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:attribute name="ReplaceNullsWith">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="Mode"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:attribute>

   <xs:attribute name="Value">
    <xs:simpleType>
     <xs:restriction base="xs:string"/>
    </xs:simpleType>
   </xs:attribute>

  </xs:complexType>
 </xs:element>

 <xs:element name="DateStatistic" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:attribute name="ReplaceNullsWith">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="Minimum"/>
      <xs:enumeration value="Maximum"/>
      <xs:enumeration value="Mean"/>
      <xs:enumeration value="Mode"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:attribute>

   <xs:attribute name="Value" type="xs:dateTime" xdb:SQLType="TIMESTAMP WITH TIME ZONE" use="optional"/>

  </xs:complexType>
 </xs:element>
 <xs:element name="MapTransformedSourceType" type="MapTransformedSource"
             xdb:defaultTable=""/>
 <xs:element name="NumericBin" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element name="BinName">
     <xs:simpleType>
      <xs:restriction base="xs:string"/>
     </xs:simpleType>
    </xs:element>
    <xs:element name="LowerBound">
     <xs:simpleType>
      <xs:restriction base="xs:double"/>
     </xs:simpleType>
    </xs:element>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <xs:element name="NumericStatistic" xdb:defaultTable="">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="ReplaceNullsWith">
      <xs:simpleType>
       <xs:restriction base="xs:string">
        <xs:enumeration value="Mean"/>
        <xs:enumeration value="Minimum"/>
        <xs:enumeration value="Maximum"/>
        <xs:enumeration value="Median"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>

     <xs:attribute name="Value">
      <xs:simpleType>
       <xs:restriction base="xs:double"/>
      </xs:simpleType>
     </xs:attribute>

    </xs:complexType>
   </xs:element>
  <!-- end -->

 <!-- Main transformation definition declaration-->
 <!-- end of TransformationType-->

 <!-- Instance of the transformation definition -->
 <xs:element name="StringCollectionNames" type="StringCollection"
             xdb:defaultTable=""/>
 <xs:element name="StringCollectionValues" type="StringCollection"
             xdb:defaultTable=""/>
 <xs:element name="TransformationElementType" type="TransformationType" xdb:defaultTable=""/>
 <xs:element name="TransformationSourceAttributes" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="TransformationSourceAttributeType" maxOccurs="unbounded"
                minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <!-- end -->

 <!-- Definition of transformation source attribute-->
 <xs:element name="TransformationSourceAttributeType" type="TransformationSourceAttribute" xdb:defaultTable=""/>

 <!-- Definition of transformed attribute-->
 <!-- end -->

 <!--Maps transformed attribute to its source-->
  <!-- end -->

  <!-- Collection of transformation output attributes (each mapped to its source) -->
 <xs:element name="TransformedAttributes" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="MapTransformedSourceType" maxOccurs="unbounded" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>

  <!-- Collection of transformation source attributes (each mapped to its source) -->

 <!-- Definition of transformation node -->

 <!-- Transformation End -->
 <xs:complexType name="ExpectationMaximizationAlgoType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="CLUS_NUM_CLUSTERS" minOccurs="0" default="10">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_CLUSTER_COMPONENTS" default="EMCS_CLUSTER_COMP_ENABLE">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="EMCS_CLUSTER_COMP_ENABLE"/>
      <xs:enumeration value="EMCS_CLUSTER_COMP_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_CLUSTER_THRESH" minOccurs="0" default="2">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_LINKAGE_FUNCTION" default="EMCS_LINKAGE_SINGLE">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="EMCS_LINKAGE_SINGLE"/>
      <xs:enumeration value="EMCS_LINKAGE_AVERAGE"/>
      <xs:enumeration value="EMCS_LINKAGE_COMPLETE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="ODMS_APPROXIMATE_COMPUTATION" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="ODMS_APPR_COMP_ENABLE"/>
      <xs:enumeration value="ODMS_APPR_COMP_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_NUM_COMPONENTS" minOccurs="0" default="20">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_NUM_ITERATIONS" minOccurs="1" default="100">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_LOGLIKE_IMPROVEMENT" default="0.001">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
      <xs:maxExclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_CONVERGENCE_CRITERION" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="EMCS_CONV_CRIT_HELDASIDE"/>
      <xs:enumeration value="EMCS_CONV_CRIT_BIC"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_NUM_DISTRIBUTION" minOccurs="0" default="EMCS_NUM_DISTR_SYSTEM">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="EMCS_NUM_DISTR_BERNOULLI"/>
      <xs:enumeration value="EMCS_NUM_DISTR_GAUSSIAN"/>
      <xs:enumeration value="EMCS_NUM_DISTR_SYSTEM"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_CLUSTER_STATISTICS" minOccurs="1" default="EMCS_CLUS_STATS_ENABLE">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="EMCS_CLUS_STATS_ENABLE"/>
      <xs:enumeration value="EMCS_CLUS_STATS_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_MIN_PCT_ATTR_SUPPORT" default="0.1" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:double">
      <xs:minExclusive value="0"/>
      <xs:maxExclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_MAX_NUM_ATTR_2D" minOccurs="1" default="50">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_NUM_PROJECTIONS" minOccurs="0" default="50">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minExclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_NUM_QUANTILE_BINS" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:maxInclusive value="255"/>
      <xs:minExclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_NUM_TOPN_BINS" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:maxInclusive value="255"/>
      <xs:minExclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_NUM_EQUIWIDTH_BINS" minOccurs="1" default="11">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:maxInclusive value="255"/>
      <xs:minExclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_ATTRIBUTE_FILTER" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="EMCS_ATTR_FILTER_ENABLE"/>
      <xs:enumeration value="EMCS_ATTR_FILTER_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <!-- new in 12.2 -->
   <xs:element name="EMCS_RANDOM_SEED" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="0"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_MODEL_SEARCH" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="EMCS_MODEL_SEARCH_ENABLE"/>
      <xs:enumeration value="EMCS_MODEL_SEARCH_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="EMCS_REMOVE_COMPONENTS" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="EMCS_REMOVE_COMPS_ENABLE"/>
      <xs:enumeration value="EMCS_REMOVE_COMPS_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="ExpectationMaximizationModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ClusteringModelType">
    <xs:sequence>
     <xs:element name="ExpectationMaximizationAlgo" type="ExpectationMaximizationAlgoType"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="SVDAlgoType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="FEAT_NUM_FEATURES" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="1"/>
      <xs:maxInclusive value="2500"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="ODMS_APPROXIMATE_COMPUTATION" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="ODMS_APPR_COMP_ENABLE"/>
      <xs:enumeration value="ODMS_APPR_COMP_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:elem';

schema6 := 'ent name="SVDS_U_MATRIX_OUTPUT" minOccurs="1" default="SVDS_U_MATRIX_DISABLE">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="SVDS_U_MATRIX_ENABLE"/>
      <xs:enumeration value="SVDS_U_MATRIX_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVDS_SCORING_MODE" minOccurs="1" default="SVDS_SCORING_SVD">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="SVDS_SCORING_SVD"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVDS_SOLVER" minOccurs="0">  <!-- new in 12.2 -->
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="SVDS_SOLVER_TSSVD"/>
      <xs:enumeration value="SVDS_SOLVER_TSEIGEN"/>
      <xs:enumeration value="SVDS_SOLVER_SSVD"/>
      <xs:enumeration value="SVDS_SOLVER_STEIGEN"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVDS_RANDOM_SEED" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer"/>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVDS_OVER_SAMPLING" default="5" minOccurs="0">
			<xs:simpleType>
				<xs:restriction base="xs:integer">
        <xs:minInclusive value="1"/>
        <xs:maxInclusive value="10000"/>
       </xs:restriction> 
			</xs:simpleType>
		</xs:element>
   <xs:element name="SVDS_POWER_ITERATIONS" default="2" minOccurs="0">
			<xs:simpleType>
				<xs:restriction base="xs:integer">
        <xs:minInclusive value="0"/>
        <xs:maxInclusive value="20"/>
       </xs:restriction> 
			</xs:simpleType>
	  </xs:element>
   <xs:element name="SVDS_TOLERANCE" minOccurs="0">
      <xs:simpleType>
       <xs:restriction base="xs:double">
        <xs:minInclusive value="0"/>
        <xs:maxInclusive value="1"/>
       </xs:restriction>
      </xs:simpleType>
    </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="SVDModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ModelType">
    <xs:sequence>
     <xs:element name="SVDAlgo" type="SVDAlgoType"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="PCAAlgoType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="FEAT_NUM_FEATURES" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer">
      <xs:minInclusive value="1"/>
      <xs:maxInclusive value="2500"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="ODMS_APPROXIMATE_COMPUTATION" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="ODMS_APPR_COMP_ENABLE"/>
      <xs:enumeration value="ODMS_APPR_COMP_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVDS_U_MATRIX_OUTPUT" minOccurs="1" default="SVDS_U_MATRIX_DISABLE">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="SVDS_U_MATRIX_ENABLE"/>
      <xs:enumeration value="SVDS_U_MATRIX_DISABLE"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVDS_SCORING_MODE" minOccurs="1" default="SVDS_SCORING_PCA">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="SVDS_SCORING_PCA"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVDS_SOLVER" minOccurs="0">  <!-- new in 12.2 -->
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="SVDS_SOLVER_TSSVD"/>
      <xs:enumeration value="SVDS_SOLVER_TSEIGEN"/>
      <xs:enumeration value="SVDS_SOLVER_SSVD"/>
      <xs:enumeration value="SVDS_SOLVER_STEIGEN"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVDS_RANDOM_SEED" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:integer"/>
    </xs:simpleType>
   </xs:element>
   <xs:element name="SVDS_OVER_SAMPLING" default="5" minOccurs="0">
			<xs:simpleType>
				<xs:restriction base="xs:integer">
        <xs:minInclusive value="1"/>
        <xs:maxInclusive value="10000"/>
       </xs:restriction> 
			</xs:simpleType>
		</xs:element>
   <xs:element name="SVDS_POWER_ITERATIONS" default="2" minOccurs="0">
			<xs:simpleType>
				<xs:restriction base="xs:integer">
        <xs:minInclusive value="0"/>
        <xs:maxInclusive value="20"/>
       </xs:restriction> 
			</xs:simpleType>
		</xs:element>
      <xs:element name="SVDS_TOLERANCE" minOccurs="0">
      <xs:simpleType>
       <xs:restriction base="xs:double">
        <xs:minInclusive value="0"/>
        <xs:maxInclusive value="1"/>
       </xs:restriction>
      </xs:simpleType>
    </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="PCAModelType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="ModelType">
    <xs:sequence>
     <xs:element name="PCAAlgo" type="PCAAlgoType"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 
 <xs:complexType name="ClusterDetailsType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
     <xs:attribute name="ClusterId"/>
     <xs:attribute name="TopNValue">
      <xs:simpleType>
       <xs:restriction base="xs:integer">
        <xs:minExclusive value="0"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
     <xs:attribute name="Sort">
       <xs:simpleType>
       <xs:restriction base="xs:string">
       <xs:enumeration value="DESC"/>
       <xs:enumeration value="ASC"/>
       <xs:enumeration value="ABS"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="ClusterDistanceType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
     <xs:attribute name="ClusterId"/>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="FeatureDetailsType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Column">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
     <xs:attribute name="FeatureId"/>
     <xs:attribute name="TopNValue">
      <xs:simpleType>
       <xs:restriction base="xs:integer">
        <xs:minExclusive value="0"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
     <xs:attribute name="Sort">
       <xs:simpleType>
       <xs:restriction base="xs:string">
       <xs:enumeration value="DESC"/>
       <xs:enumeration value="ASC"/>
       <xs:enumeration value="ABS"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="PartitionExpressionType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="PartitionAttribute" type="AttributeType" minOccurs="0"/>
   <xs:element ref="SQLExpression" minOccurs="0"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="DynamicApplyOutputColumnType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="TargetAttributeName" type="xs:string" minOccurs="0"/>
   <xs:choice>
    <xs:element name="Prediction" type="PredictionType" minOccurs="0"/>
    <xs:element name="PredictionBounds" type="PredictionBoundsType" minOccurs="0"/>
    <xs:element name="PredictionCost" type="PredictionCostType" minOccurs="0"/>
    <xs:element name="PredictionDetails" type="PredictionDetailsType" minOccurs="0"/>
    <xs:element name="PredictionProbability" type="PredictionProbabilityType" minOccurs="0"/>
    <xs:element name="PredictionSet" type="PredictionSetType" minOccurs="0"/>
    <xs:element name="ClusterId" type="ClusterIdType" minOccurs="0"/>
    <xs:element name="ClusterProbability" type="ClusterProbabilityType" minOccurs="0"/>
    <xs:element name="ClusterSet" type="ClusterSetType" minOccurs="0"/>
    <xs:element name="FeatureId" type="FeatureIdType" minOccurs="0"/>
    <xs:element name="FeatureSet" type="FeatureSetType" minOccurs="0"/>
    <xs:element name="FeatureValue" type="FeatureValueType" minOccurs="0"/>
    <xs:element name="ClusterDetails" minOccurs="0" type="ClusterDetailsType"/>
    <xs:element name="ClusterDistance" minOccurs="0" type="ClusterDistanceType"/>
    <xs:element name="FeatureDetails" minOccurs="0" type="FeatureDetailsType"/>
   </xs:choice>
  </xs:sequence>
 </xs:complexType>
 <xs:element name="TargetAttributes" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="MiningAttribute" maxOccurs="unbounded" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <xs:element name="SQLPredictionExpression" type="xs:string" xdb:SQLType="CLOB" xdb:defaultTable=""/>
 <xs:element name="PartitionExpression" type="PartitionExpressionType" xdb:defaultTable=""/>
 <xs:element name="PartitionExpressions" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="PartitionExpression" maxOccurs="unbounded" minOccurs="0"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>
 <xs:element name="DynamicApplyOutputColumn" type="DynamicApplyOutputColumnType" xdb:defaultTable=""/>
 <xs:element name="DynamicApplyOutputColumns" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element ref="DynamicApplyOutputColumn" maxOccurs="unbounded" minOccurs="0"/>
   </xs:sequence>
   <xs:attribute name="AutoSpec" type="AutoSpecType" use="optional"/>
  </xs:complexType>
 </xs:element>
 <xs:complexType name="PredictionAttributesType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element ref="TargetAttributes"/>
   <xs:element name="TargetValuesTable" type="ResultType" minOccurs="0"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="DynamicNodeBaseSettingsType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element ref="CaseAttributes"/>
   <xs:element ref="MiningAttributes"/>
   <xs:element ref="PartitionExpressions"/>
   <xs:element ref="DynamicApplyOutputColumns"/>
   <xs:element ref="SQLPredictionExpression" minOccurs="0"/>
   <xs:element name="SupplementalAttributes" minOccurs="0"
               type="SupplementalAttributesType"/>
   <xs:element name="HeuristicResult" type="HeuristicResultType" minOccurs="0"/>
  </xs:sequence>
 </xs:complexType>

 <xs:complexType name="DynamicPredictionNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element name="PredictionAttributes" type="PredictionAttributesType" minOccurs="0"/>
     <xs:element name="DynamicNodeBaseSettings" type="DynamicNodeBaseSettingsType" minOccurs="0" xdb:defaultTable=""/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>

 <xs:complexType name="DynamicFeatureNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
      <xs:element name="FeatureId" type="FeatureIdType" minOccurs="0"/>
     <xs:element name="DynamicNodeBaseSettings" type="DynamicNodeBaseSettingsType" minOccurs="0" xdb:defaultTable=""/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>

 <xs:complexType name="DynamicClusterNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
      <xs:element name="ClusterId" type="ClusterIdType" minOccurs="0"/>
     <xs:element name="DynamicNodeBaseSettings" type="DynamicNodeBaseSettingsType" minOccurs="0" xdb:defaultTable=""/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>

 <xs:complexType name="DynamicAnomalyNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element name="DynamicNodeBaseSettings" type="DynamicNodeBaseSettingsType" minOccurs="0" xdb:defaultTable=""/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>

 <xs:element name="DynamicPrediction" type="DynamicPredictionNodeType" xdb:defaultTable=""/>
 <xs:element name="DynamicFeature" type="DynamicFeatureNodeType" xdb:defaultTable=""/>
 <xs:element name="DynamicCluster" type="DynamicClusterNodeType" xdb:defaultTable=""/>
 <xs:element name="DynamicAnomaly" type="DynamicAnomalyNodeType" xdb:defaultTable=""/>
 <xs:complexType name="SQLQueryOutputColumnsType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element ref="Attribute" maxOccurs="unbounded" minOccurs="0"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="SQLQueryNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element name="SQLQueryExpression" type="xs:string" xdb:SQLType="CLOB" xdb:defaultTable="" minOccurs="0"/>
     <xs:element name="SQLQueryOutputColumns" type="SQLQueryOutputColumnsType"/>
    </xs:sequence>
     <xs:attribute name="HasWithClause" type="xs:boolean" use="required"/>
     <xs:attribute name="GenerateView" type="xs:boolean" use="required"/>
     <xs:attribute name="ViewName" type="xs:string" use="optional">
     </xs:attribute>
     <xs:attribute name="includeAllAvailableAttributes" type="xs:boolean" default="false" use="optional"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:element name="SQLQuery" type="SQLQueryNodeType"/>

 <xs:simpleType name="GraphType">
  <xs:restriction base="xs:string">
    <xs:enumeration value="Line"/>
    <xs:enumeration value="Scatter"/>
    <xs:enumeration value="Bar"/>
    <xs:enumeration value="Histogram"/>
    <xs:enumeration value="BoxPlot"/>
  </xs:restriction>
 </xs:simpleType>

 <xs:simpleType name="BinningType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="TopN"/>
   <xs:enumeration value="EqualWidth"/>
   <xs:enumeration value="None"/>
  </xs:restriction>
 </xs:simpleType>

 <xs:simpleType name="GraphAggregationFunctionType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="Mean"/>
   <xs:enumeration value="Min"/>
   <xs:enumeration value="Max"/>
   <xs:enumeration value="Median"/>
   <xs:enumeration value="Sum"/>
   <xs:enumeration value="Count"/>
  </xs:restriction>
 </xs:simpleType>

 <xs:complexType name="BinningSettingsType" xdb:maintainDOM="true">
   <xs:sequence>
     <xs:choice>
       <xs:element name="NumericBinCount" type="xs:integer" default="10" minOccurs="0"/>
       <xs:element name="StringFilterValues" type="xs:string" maxOccurs="unbounded" minOccurs="0"/>
       <xs:element name="CustomBinning" type="TransformationType" minOccurs="0"/>
     </xs:choice>
   </xs:sequence>
   <xs:attribute name="BinningEnabled" type="xs:boolean" use="required"/>
   <xs:attribute name="BinningKind" type="BinningType" use="required"/>
 </xs:complexType>

 <xs:complexType name="GroupByType" xdb:maintainDOM="true">
   <xs:sequence>
     <xs:element name="GroupByAttribute" type="AttributeType" minOccurs="1" maxOccurs="1"/>
     <xs:element name="BinningSettings" type="BinningSettingsType" minOccurs="1" maxOccurs="1"/>
   </xs:sequence>
   <xs:attribute name="GroupByEnabled" type="xs:boolean" use="required"/>
 </xs:complexType>

 <xs:complexType name="GraphSettingsType" xdb:maintainDOM="true">
  <xs:sequence>
    <xs:element name="Comment" type="xs:string" minOccurs="1" maxOccurs="1"/>
    <xs:element name="XAttribute" type="AttributeType" minOccurs="1" maxOccurs="1"/>
    <xs:element name="XBinningSettings" type="BinningSettingsType" minOccurs="1" maxOccurs="1"/>
    <xs:element name="YAttributes" minOccurs="0">
     <xs:complexType>
      <xs:sequence>
       <xs:element name="YAttribute" type="AttributeType" minOccurs="0" maxOccurs="unbounded"/>
      </xs:sequence>
      <xs:attribute name="AggregationFunction" type="GraphAggregationFunctionType"/>
     </xs:complexType>
    </xs:element>

    <xs:element name="GroupByOption" type="GroupByType" minOccurs="1" maxOccurs="1"/>
  </xs:sequence>
  <xs:attribute name="Name" type="xs:string" use="required"/>
  <xs:attribute name="Type" type="GraphType" use="required"/>
  <xs:attribute name="Id"   type="xs:string" use="optional"/>
 </xs:complexType>

 <xs:element name="GraphSettings" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:sequence>
    <xs:element name="GraphSetting"
                minOccurs="0" maxOccurs="unbounded" type="GraphSettingsType"/>
   </xs:sequence>
  </xs:complexType>
 </xs:element>

 <xs:complexType name="GraphSourceAttributesType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element ref="Attribute" maxOccurs="unbounded" minOccurs="0"/>
  </xs:sequence>
 </xs:complexType>

 <xs:complexType name="GraphNodeType" xdb:maintainDOM="true">
  <xs:complexContent>
    <xs:extension base="DataNodeType">
      <xs:sequence>
        <xs:element ref="GraphSettings"/>
        <xs:element name="GraphSourceAttributes" type="GraphSourceAttributesType" minOccurs="0"/>
        <xs:element ref="SampleSettings" minOccurs="0"/>
      </xs:sequence>
      <xs:attribute name="ViewName" type="xs:string" use="optional">
      </xs:attribute>
      <xs:attribute name="ViewDirty" type="xs:boolean" use="optional"/>
      <xs:attribute name="SampleDirty" type="xs:boolean" use="optional"/>
    </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:element name="Graph" type="GraphNodeType" xdb:defaultTable=""/>

 <xs:simpleType name="HeuristicRulesEnumType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="NULL_LIMIT"/>
   <xs:enumeration value="CONSTANT_LIMIT"/>
   <xs:enumeration value="CAT_UNIQUE_PERCENT_LIMIT"/>
   <xs:enumeration value="CAT_UNIQUE_COUNT_LIMIT"/>
   <xs:enumeration value="NUM_TO_CAT_MINING_TYPE"/>
   <xs:enumeration value="CHAR_TO_TEXT_MINING_TYPE"/>
   <xs:enumeration value="DATA_TYPE_NOT_SUPPORT"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:simpleType name="HeuristicSummaryRulesEnumType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="INPUT_NONE"/>
   <xs:enumeration value="INPUT_SOME"/>
   <xs:enumeration value="NUM_TO_CAT_MINING_TYPE"/>
   <xs:enumeration value="CHAR_TO_TEXT_MINING_TYPE"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:complexType name="HeuristicResultType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Attribute" minOccurs="0" maxOccurs="unbounded">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="Reason" minOccurs="0" maxOccurs="unbounded">
       <xs:complexType>
        <xs:attribute name="Type" type="HeuristicRulesEnumType"/>
       </xs:complexType>
      </xs:element>
     </xs:sequence>
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
  <xs:attribute name="StatisticTable" type="xs:string"/>
 </xs:complexType>
 <xs:complexType name="HeuristicSummaryResultType" xdb:maintainDOM="true">
  <xs:sequence>
   <xs:element name="Attribute" minOccurs="0" maxOccurs="unbounded">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="Reason" minOccurs="0" maxOccurs="unbounded">
       <xs:complexType>
        <xs:attribute name="Type" type="HeuristicSummaryRulesEnumType"/>
       </xs:complexType>
      </xs:element>
     </xs:sequence>
     <xs:attribute name="Name" type="xs:string" use="required">
     </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
  <xs:attribute name="StatisticTable" type="xs:string"/>
 </xs:complexType>
 <xs:element name="StatsSelection" xdb:defaultTable="">
  <xs:complexType xdb:maintainDOM="true">
   <xs:attribute name="percentdistinct" type="xs:boolean" use="optional" default="true"/>
   <xs:attribute name="percentnull" type="xs:boolean" use="optional" default="true"/>
   <xs:attribute name="max" type="xs:boolean" use="optional" default="true"/>
   <xs:attribute name="min" type="xs:boolean" use="optional" default="true"/>
   <xs:attribute name="avg" type="xs:boolean" use="optional" default="true"/>
   <xs:attribute name="std" type="xs:boolean" use="optional" default="true"/>
   <xs:attribute name="var" type="xs:boolean" use="optional" default="true"/>
   <xs:attribute name="kurtosis" type="xs:boolean" use="optional" default="false"/>
   <xs:attribute name="median" type="xs:boolean" use="optional" default="false"/>
   <xs:attribute name="skewness" type="xs:boolean" use="optional" default="false"/>
   <xs:attribute name="mode" type="xs:boolean" use="optional" default="true"/>
   <xs:attribute name="modesampled" type="xs:boolean" use="optional" default="true"/>
   <xs:attribute name="modeall" type="xs:boolean" use="optional" default="false"/>
   <xs:attribute name="histogram" type="xs:boolean" use="optional" default="true"/>
   <xs:attribute name="rowcount" type="xs:integer" use="optional" default="0"/>
  </xs:complexType>
 </xs:element>
 <xs:complexType name="ParallelismType">
  <xs:choice minOccurs="0">
   <xs:element name="SystemDetermined" minOccurs="0">
    <xs:complexType xdb:maintainDOM="true"/>
   </xs:element>
   <xs:element name="Custom" minOccurs="0">
    <xs:complexType xdb:maintainDOM="true">
     <xs:attribute name="Degree" use="required">
      <xs:simpleType>
       <xs:restriction base="xs:long">
        <xs:minInclusive value="0"/>
       </xs:restriction>
      </xs:simpleType>
     </xs:attribute>
    </xs:complexType>
   </xs:element>
  </xs:choice>
  <xs:attribute name="Enable" type="xs:boolean" use="required"/>
 </xs:complexType>
 <xs:complexType name="InMemoryColumnarType" xdb:maintainDOM="true">
  <xs:sequence minOccurs="0">
   <xs:element name="PriorityLevel" default="PRIORITY NONE">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="PRIORITY NONE"/>
      <xs:enumeration value="PRIORITY LOW"/>
      <xs:enumeration value="PRIORITY MEDIUM"/>
      <xs:enumeration value="PRIORITY HIGH"/>
      <xs:enumeration value="PRIORITY CRITICAL"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="CompressionMethod" default="INMEMORY MEMCOMPRESS FOR QUERY LOW">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="INMEMORY NO MEMCOMPRESS"/>
      <xs:enumeration value="INMEMORY MEMCOMPRESS FOR DML"/>
      <xs:enumeration value="INMEMORY MEMCOMPRESS FOR QUERY LOW"/>
      <xs:enumeration value="INMEMORY MEMCOMPRESS FOR QUERY HIGH"/>
      <xs:enumeration value="INMEMORY MEMCOMPRESS FOR CAPACITY LOW"/>
      <xs:enumeration value="INMEMORY MEMCOMPRESS FOR CAPACITY HIGH"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
  </xs:sequence>
  <xs:attribute name="Enable" type="xs:boolean" use="required"/>
 </xs:complexType>
 <xs:complexType name="CreateTableOptionsType" xdb:maintainDOM="true">
  <xs:sequence minOccurs="0">
   <xs:element name="Logging" default="NOLOGGING">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="NOLOGGING"/>
      <xs:enumeration value="LOGGING"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="TableCompression" default="ROW STORE COMPRESS">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="NONE"/>
      <xs:enumeration value="ROW STORE COMPRESS"/>
      <xs:enumeration value="ROW STORE COMPRESS ADVANCED"/>
      <xs:enumeration value="COLUMN STORE COMPRESS FOR QUERY HIGH"/>
      <xs:enumeration value="COLUMN STORE COMPRESS FOR ARCHIVE LOW"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
  </xs:sequence>
  <!--<xs:attribute name="Enable" type="xs:boolean" use="required"/>-->
 </xs:complexType>
 <xs:complexType name="DataGuideSettingsType">
  <xs:sequence>
   <xs:choice>
    <xs:element name="NumberOfRows" default="2000" minOccurs="0">
     <xs:simpleType>
      <xs:restriction base="xs:long">
       <xs:minInclusive value="1"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:element>
    <xs:element name="PercentOfTotal" default="10" minOccurs="0">
     <xs:simpleType>
      <xs:restriction base="xs:double">
       <xs:maxInclusive value="100"/>
       <xs:minInclusive value="1"/>
      </xs:restriction>
     </xs:simpleType>
    </xs:element>
   </xs:choice>
   <xs:element name="NumberOfValues" default="10000" minOccurs="0">
    <xs:simpleType>
     <xs:restriction base="xs:long">
      <xs:minInclusive value="1"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:element>
   <xs:element name="StopPaths" minOccurs="0" type="DataGuideType"/>
  </xs:sequence>
  <xs:attribute name="Generate" use="required" type="xs:boolean"/>
  <xs:attribute name="UseFullData" type="xs:boolean" use="required"/>
  <xs:attribute name="UseFullDoc" type="xs:boolean" use="required"/>
 </xs:complexType>
 <xs:complexType name="DataGuideType">
  <xs:sequence>
   <xs:element name="Item" maxOccurs="unbounded" minOccurs="0">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="Path" type="xs:string"/>
      <xs:element name="Type" type="xs:string"/>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:simpleType name="DataGuideGenEnumType">
  <xs:restriction base="xs:string">
   <xs:enumeration value="DEFAULT"/>
   <xs:enumeration value="ON"/>
   <xs:enumeration value="OFF"/>
  </xs:restriction>
 </xs:simpleType>
 <xs:complexType name="DataGuideInfoType">
  <xs:sequence>
   <xs:element ref="Messages" minOccurs="0"/>
   <xs:element name="StopPaths" minOccurs="0" type="DataGuideType"/>
   <xs:choice>
    <xs:element name="System" minOccurs="0">
     <xs:complexType>
      <xs:sequence>
       <xs:element name="DataGuide" type="DataGuideType" minOccurs="0"/>
      </xs:sequence>
      <xs:attribute name="DataGuideTable" use="optional" type="xs:string"/>
      <xs:attribute name="NumValuesProcessed" use="optional" type="xs:integer"/>
     </xs:complexType>
    </xs:element>
    <xs:element name="Custom" minOccurs="0">
     <xs:complexType>
      <xs:sequence>
       <xs:element name="DataGuide" type="DataGuideType"/>
      </xs:sequence>
     </xs:complexType>
    </xs:element>
   </xs:choice>
  </xs:sequence>
  <xs:attribute name="Status" type="ModelStatusType" use="required"/>
  <xs:attribute name="Generate" use="required" type="DataGuideGenEnumType"/>
 </xs:complexType>
 <xs:complexType name="JSONColumnsType">
  <xs:sequence>
   <xs:element name="Attribute" minOccurs="0" maxOccurs="unbounded">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="DataGuideInfo" type="DataGuideInfoType"/>
     </xs:sequence>
     <xs:attribute name="Name" use="required" type="xs:string"/>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="JSONAttributeType">
  <xs:sequence>
   <xs:element name="Path" type="xs:string"/>
  </xs:sequence>
  <xs:attribute name="DataType" use="required" type="xs:string"/>
  <xs:attribute name="Unnest" use="optional" type="xs:boolean"/>
  <xs:attribute name="DBDataType" use="optional" type="xs:string"/>
  <xs:attribute name="DBName" use="optional" type="xs:string"/>
  <xs:attribute name="Status" type="AttributeStatus" use="required"/>
 </xs:complexType>
 <xs:complexType name="AttributeExType">
  <xs:complexContent>
   <xs:extension base="AttributeType">
    <xs:attribute name="NewDataType" use="optional" type="xs:string"/>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:complexType name="JSONAttributesType">
  <xs:sequence>
   <xs:element name="JSONAttribute" type="JSONAttributeType" maxOccurs="unbounded" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="Source" type="xs:string" use="optional"/>
  <xs:attribute name="DataType" type="xs:string" use="optional"/>
 </xs:complexType>
 <xs:complexType name="RelationalAttributesType">
  <xs:sequence>
   <xs:element name="Attribute" type="AttributeExType" minOccurs="0" maxOccurs="unbounded"/>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="AggregationElementsExType">
  <xs:sequence>
   <xs:element name="AggregationElement" minOccurs="0" maxOccurs="unbounded">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="JSONAttribute" type="JSONAttributeType" minOccurs="1"/>
      <xs:element name="AggregationFunction" type="xs:string" minOccurs="1"/>
      <xs:element name="Output" type="AttributeType" minOccurs="1"/>
      <xs:element name="SubGroupBy">
       <xs:complexType>
        <xs:sequence>
         <xs:element name="Attributes" minOccurs="0">
          <xs:complexType>
           <xs:sequence>
            <xs:element name="JSONAttribute" type="JSONAttributeType" minOccurs="0" maxOccurs="unbounded"/>
           </xs:sequence>
          </xs:complexType>
         </xs:element>
        </xs:sequence>
       </xs:complexType>
      </xs:element>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="GroupingElementExType">
  <xs:sequence>
   <xs:element name="Attributes" minOccurs="0">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="JSONAttribute" type="JSONAttributeType" minOccurs="0" maxOccurs="unbounded"/>
      <xs:element name="Attribute" type="AttributeExType" minOccurs="0" maxOccurs="unbounded"/>
     </xs:sequence>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
 </xs:complexType>
 <xs:complexType name="JSONQueryNodeType">
  <xs:complexContent>
   <xs:extension base="TransformsNodeType">
    <xs:sequence>
     <xs:element name="JSONAttributes" type="JSONAttributesType" minOccurs="0"/>
     <xs:element name="RelationalAttributes" type="RelationalAttributesType" minOccurs="0"/>
     <xs:element name="AggregationElements" type="AggregationElementsExType" minOccurs="0"/>
     <xs:element name="GroupingElement" type="GroupingElementExType" minOccurs="0"/>
     <xs:element name="JSONFilters" minOccurs="0" type="JSONFilterType"/>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 <xs:element name="JSONQuery" type="JSONQueryNodeType"/>
 <xs:complexType name="JSONFilterType">
  <xs:sequence>
   <xs:element name="FilterElement" minOccurs="0" maxOccurs="unbounded">
    <xs:complexType>
     <xs:sequence>
      <xs:element name="JSONAttribute" type="JSONAttributeType" minOccurs="1"/>
      <xs:element name="Operator" default="Equal">
       <xs:simpleType>
        <xs:restriction base="xs:string">
         <xs:enumeration value="In"/>
         <xs:enumeration value="NotIn"/>
         <xs:enumeration value="Equal"/>
         <xs:enumeration value="NotEqual"/>
         <xs:enumeration value="Greater"/>
         <xs:enumeration value="GreaterOrEqual"/>
         <xs:enumeration value="Less"/>
         <xs:enumeration value="LessOrEqual"/>
         <xs:enumeration value="Contain"/>
         <xs:enumeration value="StartWith"/>
        </xs:restriction>
       </xs:simpleType>
      </xs:element>
      <xs:element name="Conditions" type="xs:string" minOccurs="1"/>
     </xs:sequen';

schema7 := 'ce>
    </xs:complexType>
   </xs:element>
  </xs:sequence>
  <xs:attribute name="Match" use="required">
   <xs:simpleType>
    <xs:restriction base="xs:string">
     <xs:enumeration value="All"/>
     <xs:enumeration value="Any"/>
    </xs:restriction>
   </xs:simpleType>
  </xs:attribute>
   <xs:attribute name="UseBy" use="required">
    <xs:simpleType>
     <xs:restriction base="xs:string">
      <xs:enumeration value="Unnest"/>
      <xs:enumeration value="Aggregation"/>
      <xs:enumeration value="All"/>
     </xs:restriction>
    </xs:simpleType>
   </xs:attribute>
 </xs:complexType>
 
  <xs:complexType name="ExplicitSemanticAnalysisAlgoType" xdb:maintainDOM="true">
    <xs:sequence>
      <xs:element name="ESAS_TOPN_FEATURES" default="1000">
        <xs:simpleType>
          <xs:restriction base="xs:integer" />
        </xs:simpleType>
      </xs:element>
      <xs:element name="ESAS_MIN_ITEMS" default="100">
        <xs:simpleType>
          <xs:restriction base="xs:integer" />
        </xs:simpleType>
      </xs:element>
      <xs:element name="ESAS_VALUE_THRESHOLD" default="0.00000001">
        <xs:simpleType>
          <xs:restriction base="xs:double" />
        </xs:simpleType>
      </xs:element>
    </xs:sequence>
  </xs:complexType>
  
  <xs:complexType name="ExplicitSemanticAnalysisModelType" xdb:maintainDOM="true">
    <xs:complexContent>
      <xs:extension base="ModelType">
        <xs:sequence>
          <xs:element name="ExplicitSemanticAnalysisAlgo" type="ExplicitSemanticAnalysisAlgoType" />
        </xs:sequence>
      </xs:extension>
    </xs:complexContent>
  </xs:complexType>
  <xs:complexType name="ExplicitFeatureExtractionBuildNodeType" xdb:maintainDOM="true">
    <xs:complexContent>
      <xs:extension base="BuildNodeType">
        <xs:sequence>
          <xs:element name="Models">
            <xs:complexType>
              <xs:sequence>
                <xs:element name="ExplicitSemanticAnalysisModel" type="ExplicitSemanticAnalysisModelType" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="ESA_M_TAB" xdb:SQLInline="false" />
              </xs:sequence>
            </xs:complexType>
          </xs:element>
        </xs:sequence>
      </xs:extension>
    </xs:complexContent>
  </xs:complexType>
  
  <xs:element name="ExplicitFeatureExtractionBuild" type="ExplicitFeatureExtractionBuildNodeType" xdb:defaultTable=""/>
 
  <xs:complexType name="ModelSignatureType">
    <xs:sequence>
      <xs:element name="Model" type="ModelInfoType" minOccurs="1"/>
      <xs:element ref="Attributes"/>
    </xs:sequence>
  </xs:complexType>
  <xs:complexType name="InputSourceType">
    <xs:choice>
      <xs:element name="DataSource" minOccurs="0">
        <xs:complexType>
          <xs:sequence>
            <xs:element name="Attributes">
              <xs:complexType>
                <xs:sequence>
                  <xs:element name="Attribute" maxOccurs="unbounded" minOccurs="0">
                    <xs:complexType>
                      <xs:complexContent>
                        <xs:extension base="AttributeType">
                          <xs:attribute name="Source" type="xs:string" use="required"/>
                        </xs:extension>
                      </xs:complexContent>
                    </xs:complexType>
                  </xs:element>
                </xs:sequence>
              </xs:complexType>
            </xs:element>
            <xs:element name="CaseAttribute" type="AttributeType" minOccurs="0"/>
          </xs:sequence>
          <xs:attribute name="Id" type="xs:string" use="required"/>
          <xs:attribute name="Name" type="xs:string" use="required"/>
          <xs:attribute name="Status" type="NodeStatusType" use="required"/>
        </xs:complexType>
      </xs:element>
      <xs:element name="Custom" minOccurs="0">
        <xs:complexType>
          <xs:sequence>
            <xs:element name="Attributes">
              <xs:complexType>
                <xs:sequence>
                  <xs:element name="Attribute" minOccurs="0" maxOccurs="unbounded">
                    <xs:complexType>
                      <xs:sequence>
                        <xs:element name="Value" type="xs:string"/>
                      </xs:sequence>
                      <xs:attribute name="Source" type="xs:string" use="required"/>
                    </xs:complexType>
                  </xs:element>
                </xs:sequence>
              </xs:complexType>
            </xs:element>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
    </xs:choice>
  </xs:complexType>
  <xs:complexType name="FeatureCompareNodeType">
    <xs:complexContent>
      <xs:extension base="TransformsNodeType">
        <xs:sequence>
          <xs:element name="ModelSignature" minOccurs="0" type="ModelSignatureType"/>
          <xs:element name="DataInput1" minOccurs="0" type="InputSourceType"/>
          <xs:element name="DataInput2" minOccurs="0" type="InputSourceType"/>
          <xs:element name="OutputColumn" minOccurs="0">
            <xs:complexType>
              <xs:attribute name="AutoSpec" use="required" type="AutoSpecType"/>
              <xs:attribute name="Name" use="required" type="xs:string"/>
            </xs:complexType>
          </xs:element>
          <xs:element name="SupplementalAttributes" minOccurs="0" type="SupplementalAttributesType"/>
        </xs:sequence>
      </xs:extension>
    </xs:complexContent>
  </xs:complexType>
  
  <xs:element name="RBuild" type="RBuildNodeType"/>

  <xs:complexType name="ExtensibleBuildNodeType" xdb:maintainDOM="true">
    <xs:complexContent>
      <xs:extension base="BuildNodeType">
        <xs:sequence>
            <xs:element ref="TestDataSource" minOccurs="0"/>
            <xs:element ref="TargetAttribute" minOccurs="0"/>
            <xs:element name="TestSettings" type="ClassificationTestSettingsType" minOccurs="0"/>
            <xs:element name="Results" minOccurs="0">
              <xs:complexType>
                <xs:choice>
                  <xs:element ref="RegressionResult" minOccurs="0" maxOccurs="unbounded"/>
                  <xs:element ref="ClassificationResult" minOccurs="0" maxOccurs="unbounded"/>
                </xs:choice>
                <xs:attribute name="genROC" type="xs:boolean" use="optional"/>
                <xs:attribute name="genLift" type="xs:boolean" use="optional"/>
                <xs:attribute name="genResiduals" type="xs:boolean" use="optional"/>
                <xs:attribute name="genAccuracyMetrics" type="xs:boolean" use="optional"/>
                <xs:attribute name="genConfusionMatrix" type="xs:boolean" use="optional"/>
                <xs:attribute name="useGroupingForPartition" type="xs:boolean" use="optional"/>
              </xs:complexType>
            </xs:element>
          </xs:sequence>
        <xs:attribute name="ExtensibleLanguage" default="R">
          <xs:simpleType>
           <xs:restriction base="xs:string">
            <xs:enumeration value="R"/>
           </xs:restriction>
          </xs:simpleType>
        </xs:attribute>
        <xs:attribute name="MiningFunction" type="MiningFunctionType" use="optional"/>
      </xs:extension>
    </xs:complexContent>
  </xs:complexType>

 <xs:complexType name="RBuildNodeType">
  <xs:complexContent>
   <xs:extension base="ExtensibleBuildNodeType">
    <xs:sequence>
      <xs:element name="Models">
        <xs:complexType>
          <xs:sequence>
            <xs:element name="RModel" type="RModelType" minOccurs="0" maxOccurs="unbounded" xdb:defaultTable="R_M_TAB" xdb:SQLInline="false" />
          </xs:sequence>
        </xs:complexType>
      </xs:element>
    </xs:sequence>
   </xs:extension>
  </xs:complexContent>
 </xs:complexType>
 
  <xs:complexType name="RModelType" xdb:maintainDOM="true">
    <xs:complexContent>
      <xs:extension base="ModelType">
        <xs:sequence>
          <xs:element name="BuildFunctions">
            <xs:complexType>
              <xs:sequence>
                <xs:element name="Settings" minOccurs="0">
                  <xs:complexType>
                    <xs:sequence>
                      <xs:element name="ModelSettingODM" maxOccurs="unbounded" type="ModelSettingODMType" minOccurs="0"/>
                    </xs:sequence>
                    <xs:attribute name="RowWeightColumn" use="optional" type="xs:string"/>
                  </xs:complexType>
                </xs:element>
              </xs:sequence>
              <xs:attribute name="PrimaryFunction" use="required" type="xs:string"/>
            </xs:complexType>
          </xs:element>
          <xs:element name="ScoreFunctions" minOccurs="0">
            <xs:complexType>
              <xs:attribute name="PrimaryFunction" use="required" type="xs:string"/>
              <xs:attribute name="SecondaryFunction" use="optional" type="xs:string"/>
            </xs:complexType>
          </xs:element>
          <xs:element name="DetailFunction" minOccurs="0">
            <xs:complexType>
              <xs:sequence>
                <xs:element name="Output">
                  <xs:complexType>
                    <xs:sequence>
                      <xs:element name="Column" maxOccurs="unbounded">
                        <xs:complexType>
                          <xs:attribute name="Name" use="required" type="xs:string"/>
                          <xs:attribute name="Type" use="required" type="MiningDataType"/>
                          <xs:attribute name="Length" use="optional" type="xs:integer"/>
                        </xs:complexType>
                      </xs:element>
                    </xs:sequence>
                  </xs:complexType>
                </xs:element>
              </xs:sequence>
              <xs:attribute name="PrimaryFunction" use="required" type="xs:string"/>
            </xs:complexType>
          </xs:element>
        </xs:sequence>
      </xs:extension>
    </xs:complexContent>
  </xs:complexType>
</xs:schema>';


    DBMS_XMLSCHEMA.registerSchema(
      'http://xmlns.oracle.com/odmr11/odmr.xsd',
      schemadoc => schema1||schema2||schema3||schema4||schema5||schema6||schema7,
      local => FALSE,
      gentypes => TRUE,
      genbean => FALSE,
      gentables => TRUE,
      enablehierarchy => DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE,
      owner => 'ODMRSYS');
    DBMS_OUTPUT.PUT_LINE('Registration of Data Miner Workflow XML Schema success.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Registration of Data Miner Workflow XML Schema is not required for Binary XML.');
  END IF;
END;
/

SET DEFINE ON

EXECUTE dbms_output.put_line('Finished install of xml schema. ' || systimestamp);
