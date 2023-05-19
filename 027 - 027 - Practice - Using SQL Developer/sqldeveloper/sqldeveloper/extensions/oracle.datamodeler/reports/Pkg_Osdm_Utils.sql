create or replace PACKAGE PKG_OSDM_UTILS AS

single_table_prefix  CONSTANT VARCHAR2(30) := 'osdmSingleTable';
all_tables_prefix    CONSTANT VARCHAR2(30) := 'osdmAllTables';
single_entity_prefix CONSTANT VARCHAR2(30) := 'osdmSingleEntity';
all_entities_prefix  CONSTANT VARCHAR2(30) := 'osdmAllEntities';
single_st_prefix     CONSTANT VARCHAR2(30) := 'osdmSingleStructuredType';
all_st_prefix        CONSTANT VARCHAR2(30) := 'osdmAllStructuredTypes';
single_ct_prefix     CONSTANT VARCHAR2(30) := 'osdmSingleCollectionType';
all_ct_prefix        CONSTANT VARCHAR2(30) := 'osdmAllCollectionTypes';
single_dt_prefix     CONSTANT VARCHAR2(30) := 'osdmSingleDistinctType';
all_dt_prefix        CONSTANT VARCHAR2(30) := 'osdmAllDistinctTypes';
all_domains_prefix   CONSTANT VARCHAR2(30) := 'osdmAllDomains';
all_cr_prefix        CONSTANT VARCHAR2(30) := 'osdmAllChangeRequests';
all_mr_prefix        CONSTANT VARCHAR2(30) := 'osdmAllMeasurements';
glossary_prefix      CONSTANT VARCHAR2(30) := 'osdmGlossary';

PROCEDURE Generate_Report(v_rep_id           IN NUMBER,
                          v_obj_ovid         IN VARCHAR2,
                          v_mode             IN NUMBER,
                          v_reports_dir      IN VARCHAR2,
                          v_report_name      IN VARCHAR2,
                          reportTemplate     IN REPORT_TEMPLATE,
                          objects            IN OBJECTS_LIST,
                          v_raw_xml         OUT BFILE, 
                          v_status          OUT NUMBER, 
                          osddm_reports_dir OUT VARCHAR2,
                          v_diagrams        OUT SYS_REFCURSOR,
                          v_diagrams_svg    OUT SYS_REFCURSOR);

FUNCTION Gather_Constraint_Details_XML(col_attr_ovid IN VARCHAR2,namespace IN VARCHAR2) RETURN CLOB;

FUNCTION Gather_Domain_Constraints_XML(domain_ovid VARCHAR2) RETURN CLOB;

FUNCTION Gather_Constraint_Details_HTML(col_attr_ovid VARCHAR2) RETURN CLOB;

FUNCTION Gather_Domain_Constraints_HTML (domain_ovid VARCHAR2) RETURN CLOB;

END PKG_OSDM_UTILS;
/