set serveroutput on
set verify off

EXECUTE dbms_output.put_line('Fix JSON paths to confirm to database data guide format. ' || systimestamp);

DECLARE
  DB_VER VARCHAR2(30);
  v_sql  VARCHAR2(4000);

  FUNCTION FIX_JSONPATH(p_jsonPath IN VARCHAR2) RETURN VARCHAR2
  IS
    START_ARRAY   VARCHAR2(10) := '$.[*].';
    v_jsonName    VARCHAR2(128);
    v_jsonPath    VARCHAR2(4000);
    v_jsonPathNew VARCHAR2(4000);
    v_startIdx    NUMBER := 1;
    v_endIdx      NUMBER := 1;
  BEGIN
    v_jsonPathNew := '';
    v_endIdx := INSTR(p_jsonPath, START_ARRAY, 1, 1);
    IF (v_endIdx > 0) THEN
      v_jsonPath := '$.' || SUBSTR(p_jsonPath, LENGTH(START_ARRAY)+1);
    ELSE
      v_jsonPath := p_jsonPath;
    END IF;
    LOOP
      v_endIdx := INSTR(v_jsonPath, '.', v_startIdx, 1);
      IF (v_endIdx = 0) THEN
        v_jsonName := SUBSTR(v_jsonPath, v_startIdx);
      ELSE
        v_jsonName := SUBSTR(v_jsonPath, v_startIdx, (v_endIdx-v_startIdx));
      END IF;
      IF (v_jsonName = '$') THEN
        v_jsonPathNew := v_jsonName;
      ELSE
        v_jsonName := REGEXP_REPLACE(v_jsonName, '\"+([^\.]+)\"+', '\1'); -- strip enclosing double quotes if any
        IF (REGEXP_COUNT(v_jsonName,'^([a-zA-Z_])+([a-zA-Z0-9_])*$') = 0) THEN -- valid name without double quoted?
          v_jsonName := '"'||v_jsonName||'"'; -- not valid name, so double quote it
        END IF;
        v_jsonPathNew := v_jsonPathNew || '.' || v_jsonName;
      END IF;
      IF (v_endIdx = 0) THEN
        EXIT;
      END IF;
      v_startIdx := v_endIdx + 1;
    END LOOP;
    RETURN v_jsonPathNew;
  END;

BEGIN
  SELECT VERSION INTO DB_VER FROM PRODUCT_COMPONENT_VERSION WHERE PRODUCT LIKE 'Oracle Database%' OR PRODUCT LIKE 'Personal Oracle Database %';
  IF (DB_VER >= '12.2' ) THEN
    FOR e IN (
      SELECT x.WORKFLOW_ID, a.NODE_ID, b.PATH
      FROM ODMRSYS.ODMR$WORKFLOWS x,
         XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            '/WorkflowProcess/Nodes/JSONQuery'
            PASSING x.WORKFLOW_DATA
            COLUMNS NODE_ID    NUMBER       PATH '@Id',
                    ATTRS      XMLType      PATH '*') a,
            XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            'JSONAttributes/JSONAttribute'
            PASSING a.ATTRS
            COLUMNS PATH       VARCHAR2(4000) PATH 'Path/text()') b
      )
    LOOP
      v_sql := '
        UPDATE ODMRSYS.ODMR$WORKFLOWS x
        SET x.WORKFLOW_DATA = updateXML(x.WORKFLOW_DATA,
        ''/WorkflowProcess/Nodes/JSONQuery[@Id="'||e.NODE_ID||'"]/JSONAttributes/JSONAttribute/Path[text()="'||DBMS_XMLGEN.CONVERT(e.PATH)||'"]/text()'', '''||FIX_JSONPATH(e.PATH)||''',
        ''xmlns="http://xmlns.oracle.com/odmr11"'' 
        )
        WHERE WORKFLOW_ID = :1';
      EXECUTE IMMEDIATE v_sql USING e.WORKFLOW_ID;
    END LOOP;
    
    FOR e IN (
      SELECT x.WORKFLOW_ID, a.NODE_ID, b.PATH
      FROM ODMRSYS.ODMR$WORKFLOWS x,
         XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            '/WorkflowProcess/Nodes/JSONQuery'
            PASSING x.WORKFLOW_DATA
            COLUMNS NODE_ID    NUMBER       PATH '@Id',
                    ATTRS      XMLType      PATH '*') a,
            XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            'AggregationElements/AggregationElement/JSONAttribute'
            PASSING a.ATTRS
            COLUMNS PATH       VARCHAR2(4000) PATH 'Path/text()') b
      )
    LOOP
      v_sql := '
        UPDATE ODMRSYS.ODMR$WORKFLOWS x
        SET x.WORKFLOW_DATA = updateXML(x.WORKFLOW_DATA,
        ''/WorkflowProcess/Nodes/JSONQuery[@Id="'||e.NODE_ID||'"]/AggregationElements/AggregationElement/JSONAttribute/Path[text()="'||DBMS_XMLGEN.CONVERT(e.PATH)||'"]/text()'', '''||FIX_JSONPATH(e.PATH)||''',
        ''xmlns="http://xmlns.oracle.com/odmr11"'' 
        )
        WHERE WORKFLOW_ID = :1';
      EXECUTE IMMEDIATE v_sql USING e.WORKFLOW_ID;
    END LOOP;
    
    FOR e IN (
      SELECT x.WORKFLOW_ID, a.NODE_ID, b.PATH
      FROM ODMRSYS.ODMR$WORKFLOWS x,
         XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            '/WorkflowProcess/Nodes/JSONQuery'
            PASSING x.WORKFLOW_DATA
            COLUMNS NODE_ID    NUMBER       PATH '@Id',
                    ATTRS      XMLType      PATH '*') a,
            XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            'AggregationElements/AggregationElement/SubGroupBy/Attributes/JSONAttribute'
            PASSING a.ATTRS
            COLUMNS PATH       VARCHAR2(4000) PATH 'Path/text()') b
      )
    LOOP
      v_sql := '
        UPDATE ODMRSYS.ODMR$WORKFLOWS x
        SET x.WORKFLOW_DATA = updateXML(x.WORKFLOW_DATA,
        ''/WorkflowProcess/Nodes/JSONQuery[@Id="'||e.NODE_ID||'"]/AggregationElements/AggregationElement/SubGroupBy/Attributes/JSONAttribute/Path[text()="'||DBMS_XMLGEN.CONVERT(e.PATH)||'"]/text()'', '''||FIX_JSONPATH(e.PATH)||''',
        ''xmlns="http://xmlns.oracle.com/odmr11"'' 
        )
        WHERE WORKFLOW_ID = :1';
      EXECUTE IMMEDIATE v_sql USING e.WORKFLOW_ID;
    END LOOP;
    
    FOR e IN (
      SELECT x.WORKFLOW_ID, a.NODE_ID, b.PATH
      FROM ODMRSYS.ODMR$WORKFLOWS x,
         XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            '/WorkflowProcess/Nodes/JSONQuery'
            PASSING x.WORKFLOW_DATA
            COLUMNS NODE_ID    NUMBER       PATH '@Id',
                    ATTRS      XMLType      PATH '*') a,
            XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            'GroupingElement/Attributes/JSONAttribute'
            PASSING a.ATTRS
            COLUMNS PATH       VARCHAR2(4000) PATH 'Path/text()') b
      )
    LOOP
      v_sql := '
        UPDATE ODMRSYS.ODMR$WORKFLOWS x
        SET x.WORKFLOW_DATA = updateXML(x.WORKFLOW_DATA,
        ''/WorkflowProcess/Nodes/JSONQuery[@Id="'||e.NODE_ID||'"]/GroupingElement/Attributes/JSONAttribute/Path[text()="'||DBMS_XMLGEN.CONVERT(e.PATH)||'"]/text()'', '''||FIX_JSONPATH(e.PATH)||''',
        ''xmlns="http://xmlns.oracle.com/odmr11"'' 
        )
        WHERE WORKFLOW_ID = :1';
      EXECUTE IMMEDIATE v_sql USING e.WORKFLOW_ID;
    END LOOP;
  
    FOR e IN (
      SELECT x.WORKFLOW_ID, a.NODE_ID, b.PATH
      FROM ODMRSYS.ODMR$WORKFLOWS x,
         XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            '/WorkflowProcess/Nodes/DataSource'
            PASSING x.WORKFLOW_DATA
            COLUMNS NODE_ID    NUMBER       PATH '@Id',
                    ATTRS      XMLType      PATH '*') a,
            XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            'JSONColumns/Attribute/DataGuideInfo/System/DataGuide/Item'
            PASSING a.ATTRS
            COLUMNS PATH       VARCHAR2(4000) PATH 'Path/text()') b
      )
    LOOP
      v_sql := '
        UPDATE ODMRSYS.ODMR$WORKFLOWS x
        SET x.WORKFLOW_DATA = updateXML(x.WORKFLOW_DATA,
        ''/WorkflowProcess/Nodes/DataSource[@Id="'||e.NODE_ID||'"]/JSONColumns/Attribute/DataGuideInfo/System/DataGuide/Item/Path[text()="'||DBMS_XMLGEN.CONVERT(e.PATH)||'"]/text()'', '''||FIX_JSONPATH(e.PATH)||''',
        ''xmlns="http://xmlns.oracle.com/odmr11"'' 
        )
        WHERE WORKFLOW_ID = :1';
      EXECUTE IMMEDIATE v_sql USING e.WORKFLOW_ID;
    END LOOP;
  
    FOR e IN (
      SELECT x.WORKFLOW_ID, a.NODE_ID, b.PATH
      FROM ODMRSYS.ODMR$WORKFLOWS x,
         XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            '/WorkflowProcess/Nodes/DataSource'
            PASSING x.WORKFLOW_DATA
            COLUMNS NODE_ID    NUMBER       PATH '@Id',
                    ATTRS      XMLType      PATH '*') a,
            XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            'JSONColumns/Attribute/DataGuideInfo/Custom/DataGuide/Item'
            PASSING a.ATTRS
            COLUMNS PATH       VARCHAR2(4000) PATH 'Path/text()') b
      )
    LOOP
      v_sql := '
        UPDATE ODMRSYS.ODMR$WORKFLOWS x
        SET x.WORKFLOW_DATA = updateXML(x.WORKFLOW_DATA,
        ''/WorkflowProcess/Nodes/DataSource[@Id="'||e.NODE_ID||'"]/JSONColumns/Attribute/DataGuideInfo/Custom/DataGuide/Item/Path[text()="'||DBMS_XMLGEN.CONVERT(e.PATH)||'"]/text()'', '''||FIX_JSONPATH(e.PATH)||''',
        ''xmlns="http://xmlns.oracle.com/odmr11"'' 
        )
        WHERE WORKFLOW_ID = :1';
      EXECUTE IMMEDIATE v_sql USING e.WORKFLOW_ID;
    END LOOP;
  
    FOR e IN (
      SELECT x.WORKFLOW_ID, a.NODE_ID, b.PATH
      FROM ODMRSYS.ODMR$WORKFLOWS x,
         XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            '/WorkflowProcess/Nodes/CreateTable'
            PASSING x.WORKFLOW_DATA
            COLUMNS NODE_ID    NUMBER       PATH '@Id',
                    ATTRS      XMLType      PATH '*') a,
            XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            'JSONColumns/Attribute/DataGuideInfo/System/DataGuide/Item'
            PASSING a.ATTRS
            COLUMNS PATH       VARCHAR2(4000) PATH 'Path/text()') b
      )
    LOOP
      v_sql := '
        UPDATE ODMRSYS.ODMR$WORKFLOWS x
        SET x.WORKFLOW_DATA = updateXML(x.WORKFLOW_DATA,
        ''/WorkflowProcess/Nodes/CreateTable[@Id="'||e.NODE_ID||'"]/JSONColumns/Attribute/DataGuideInfo/System/DataGuide/Item/Path[text()="'||DBMS_XMLGEN.CONVERT(e.PATH)||'"]/text()'', '''||FIX_JSONPATH(e.PATH)||''',
        ''xmlns="http://xmlns.oracle.com/odmr11"'' 
        )
        WHERE WORKFLOW_ID = :1';
      EXECUTE IMMEDIATE v_sql USING e.WORKFLOW_ID;
    END LOOP;
  
    FOR e IN (
      SELECT x.WORKFLOW_ID, a.NODE_ID, b.PATH
      FROM ODMRSYS.ODMR$WORKFLOWS x,
         XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            '/WorkflowProcess/Nodes/CreateTable'
            PASSING x.WORKFLOW_DATA
            COLUMNS NODE_ID    NUMBER       PATH '@Id',
                    ATTRS      XMLType      PATH '*') a,
            XMLTable(XMLNamespaces(default 'http://xmlns.oracle.com/odmr11'),
            'JSONColumns/Attribute/DataGuideInfo/Custom/DataGuide/Item'
            PASSING a.ATTRS
            COLUMNS PATH       VARCHAR2(4000) PATH 'Path/text()') b
      )
    LOOP
      v_sql := '
        UPDATE ODMRSYS.ODMR$WORKFLOWS x
        SET x.WORKFLOW_DATA = updateXML(x.WORKFLOW_DATA,
        ''/WorkflowProcess/Nodes/CreateTable[@Id="'||e.NODE_ID||'"]/JSONColumns/Attribute/DataGuideInfo/Custom/DataGuide/Item/Path[text()="'||DBMS_XMLGEN.CONVERT(e.PATH)||'"]/text()'', '''||FIX_JSONPATH(e.PATH)||''',
        ''xmlns="http://xmlns.oracle.com/odmr11"'' 
        )
        WHERE WORKFLOW_ID = :1';
      EXECUTE IMMEDIATE v_sql USING e.WORKFLOW_ID;
    END LOOP;
  ELSE
    dbms_output.put_line('Database version is 12.2 or earlier, so no need to fix JSON paths.');
  END IF;
EXCEPTION 
  WHEN OTHERS THEN 
    dbms_output.put_line('Exception in fixjsonpaths.sql routine');
END;        
/
EXECUTE dbms_output.put_line('JSON paths have been fixed to confirm to the database data guide format. ' || systimestamp);
