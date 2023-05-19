-- creates either binary or OR xml indexes on the workflow column
-- This procedure is run during the initial install of the repository as well as in upgrades.

EXECUTE dbms_output.put_line('Start Creation of XML Document Indexes.' || systimestamp);

-- Create Indexes on XML system generate tables to improve xml query performance
-- Node id indexes
DECLARE
  SYS_TABLE_NAME  VARCHAR2(30);
BEGIN
    -- The binary xml indices are not dropped during a upgrade|migration.
    -- In order to allow this procedure to run during an upgrade, the index is dropped first.
    -- This will allow this index definition to change over time and be applied fresh
    -- each time a upgrade is performed.
    EXECUTE IMMEDIATE 'ALTER user ODMRSYS quota 200M on SYSTEM';
      
    BEGIN
      DBMS_XMLINDEX.DROPPARAMETER('ODMR$WF_XMLINDEX_PARAM');
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;

    BEGIN
      EXECUTE IMMEDIATE 'DROP INDEX ODMRSYS.ODMR$WORKFLOW_XMLINDEX' ;
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    
    DBMS_XMLINDEX.REGISTERPARAMETER('ODMR$WF_XMLINDEX_PARAM',
      'XMLTable ODMR$WF_NODES_IDX XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
            ''/WorkflowProcess/Nodes/*''
            COLUMNS NodeType     VARCHAR2(30)  PATH ''name()'',
                    NodeId       VARCHAR2(30)  PATH ''@Id'',
                    NodeName     VARCHAR2(150) PATH ''@Name'',
                    NodeStatus   VARCHAR2(30)  PATH ''@Status''
       GROUP MODEL_GROUP
       XMLTable ODMR$WF_MODELS_IDX XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
            ''/WorkflowProcess/Nodes/*/Models/*''
            COLUMNS ModelType     VARCHAR2(30)  PATH ''name()'',
                    ModelId       VARCHAR2(30)  PATH ''@Id'',
                    ModelName     VARCHAR2(150) PATH ''@Name'',
                    ModelStatus   VARCHAR2(30)  PATH ''@Status''             
       GROUP LINK
       XMLTable ODMR$WF_LINK_IDX XMLNAMESPACES(DEFAULT ''http://xmlns.oracle.com/odmr11''),
            ''/WorkflowProcess/Links/Link''
            COLUMNS LinkId       VARCHAR2(30) PATH ''@Id'',
                    LinkName     VARCHAR2(30) PATH ''@Name'',
                    LinkFrom     VARCHAR2(30) PATH ''@From'',
                    LinkTo       VARCHAR2(30) PATH ''@To''
    ');
                  
    EXECUTE IMMEDIATE 'CREATE INDEX ODMRSYS.ODMR$WORKFLOW_XMLINDEX ON ODMRSYS.ODMR$WORKFLOWS(WORKFLOW_DATA) INDEXTYPE IS XDB.XMLIndex PARAMETERS(''param ODMR$WF_XMLINDEX_PARAM'')';
    DBMS_OUTPUT.PUT_LINE('Index ODMR$WORKFLOW_XMLINDEX created successfully.');
  
END;
/

EXECUTE dbms_output.put_line('End Creation of XML Document Indexes.' || systimestamp);
