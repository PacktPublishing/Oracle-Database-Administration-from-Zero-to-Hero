-- validated that all objects are valid in ODMRSYS
-- Parameters
-- 1: ALL | JAVA
-- Example:
-- @validateODMRSYS.sql ALL 
-- If there are any invalid objects, raise an exception.
set serveroutput on
set verify off

DEFINE OBJECT_TYPE = &1

EXECUTE dbms_output.put_line('Recompile any invalid objects in ODMRSYS. ' || systimestamp);

--recompile due to sequence of installation and changes
EXECUTE UTL_RECOMP.RECOMP_SERIAL('ODMRSYS');

EXECUTE dbms_output.put_line('Validate ODMRSYS to insure all objects are valid. ' || systimestamp);

DECLARE
objects_cursor number; 
w_search_type varchar2(30) := '&OBJECT_TYPE';
w_object_type varchar2(200);
w_object_name varchar2(200);
w_owner varchar2(200); 
w_status varchar2(50); 
countObjects integer := 0;
ignore INTEGER;
EE_VER  NUMBER; -- 07-13-2021
v_invalid_objects_sql VARCHAR2(1000) :=
'SELECT owner,
       object_type,
       object_name,
       status
FROM   dba_objects
WHERE  status = ''INVALID'' AND
       object_type LIKE :P1 AND
       owner = ''ODMRSYS''
ORDER BY owner, object_type, object_name';

BEGIN
  DBMS_OUTPUT.ENABLE(NULL);
  DBMS_OUTPUT.PUT_LINE (' ' );     
  DBMS_OUTPUT.PUT_LINE ('Invalid ODMRSYS Objects Report ' );    
  DBMS_OUTPUT.PUT_LINE (' ' );     

  objects_cursor := dbms_sql.open_cursor; 
  DBMS_SQL.PARSE(objects_cursor, 
     v_invalid_objects_sql, 
     DBMS_SQL.NATIVE);       
  IF (w_search_type = 'JAVA') THEN
    DBMS_SQL.BIND_VARIABLE(objects_cursor,':P1','JAVA CLASS');
  ELSE       
    DBMS_SQL.BIND_VARIABLE(objects_cursor,':P1','%%');
  END IF;
  DBMS_SQL.DEFINE_COLUMN(objects_cursor, 1, w_owner, 200); 
  DBMS_SQL.DEFINE_COLUMN(objects_cursor, 2, w_object_type, 120); 
  DBMS_SQL.DEFINE_COLUMN(objects_cursor, 3, w_object_name, 120); 
  DBMS_SQL.DEFINE_COLUMN(objects_cursor, 4, w_status, 50); 
  ignore := DBMS_SQL.EXECUTE(objects_cursor); 
  LOOP 
    IF DBMS_SQL.FETCH_ROWS(objects_cursor)>0 THEN 
      -- get column values of the row 
      DBMS_SQL.COLUMN_VALUE (objects_cursor, 1, w_owner);
      DBMS_SQL.COLUMN_VALUE (objects_cursor, 2, w_object_type);
      DBMS_SQL.COLUMN_VALUE (objects_cursor, 3, w_object_name);
      DBMS_SQL.COLUMN_VALUE (objects_cursor, 4, w_status);
      countObjects := countObjects + 1;
      DBMS_OUTPUT.PUT_LINE ('Type: ' || w_object_type || ' Name: ' || w_object_name || ' Status: ' || w_status );     
    ELSE
      EXIT;
    END IF;
  END LOOP;
  --dbms_output.put_line('close cursor');
  dbms_sql.close_cursor(objects_cursor);
  DBMS_OUTPUT.PUT_LINE (' ' );     
  DBMS_OUTPUT.PUT_LINE ('Total Number of Invalid Objects: ' || countObjects );  
  if countObjects > 0 then
    RAISE_APPLICATION_ERROR(-20000, 'Invalid objects detected in ODMRSYS repository account. Review install log.');
  end if;
  
  -- 07-13-2021 start
  SELECT count(*) INTO EE_VER FROM product_component_version WHERE product LIKE '%Enterprise Edition%';
  dbms_output.put_line('EE_VER='||EE_VER);
  IF (EE_VER = 0) THEN
    dbms_output.put_line('UPDATED PARALLEL_QUERY_ON_ALLOWED to FALSE');
    UPDATE ODMRSYS.ODMR$REPOSITORY_PROPERTIES SET PROPERTY_STR_VALUE = 'FALSE' WHERE PROPERTY_NAME = 'PARALLEL_QUERY_ON_ALLOWED';
    dbms_output.put_line('UPDATED IN_MEMORY_ALLOWED to FALSE');
    UPDATE ODMRSYS.ODMR$REPOSITORY_PROPERTIES SET PROPERTY_STR_VALUE = 'FALSE' WHERE PROPERTY_NAME = 'IN_MEMORY_ALLOWED';
    commit;
  END IF;
  -- 07-13-2021 end
END;
/