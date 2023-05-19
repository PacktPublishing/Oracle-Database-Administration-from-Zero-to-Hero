-- drops all public synonyms where table owner = ODMRSYS 
set serveroutput on
set verify off

EXECUTE dbms_output.put_line('Drop public synonyms created by ODMRSYS. ' || systimestamp);

DECLARE
w_synonym varchar2(30);
w_owner varchar2(30); 
w_table_name varchar2(30);
countObjects integer := 0;
countObjectsDropped integer := 0;
countObjectsFailedToDrop integer := 0;
sql_text varchar2(256);
Dynamic_Cursor integer; 
dummy integer; 
v_err_msg  VARCHAR2(4000);

--select owner, synonym_name, table_owner, table_name from DBA_SYNONYMS
--where table_owner = 'ODMRSYS'
cursor synonym_cursor is
select synonym_name, table_owner, table_name from DBA_SYNONYMS
where table_owner = 'ODMRSYS' 
order by synonym_name;
BEGIN
 DBMS_OUTPUT.ENABLE(NULL);

open synonym_cursor;
fetch synonym_cursor into w_synonym,w_owner,w_table_name;
while synonym_cursor%FOUND loop
BEGIN
  sql_text := 'drop public synonym ' || w_synonym  || ' FORCE' ;
  DBMS_OUTPUT.PUT_LINE
     (sql_text ); 
  Dynamic_Cursor := dbms_sql.open_cursor;
  dbms_sql.parse(Dynamic_Cursor, sql_text, dbms_sql.native);
  dummy := dbms_sql.execute(Dynamic_Cursor);
  dbms_sql.close_cursor(Dynamic_Cursor);
  countObjectsDropped := countObjectsDropped + 1;      
EXCEPTION
WHEN OTHERS THEN
        v_err_msg := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK(), 1, 4000);
        DBMS_OUTPUT.PUT_LINE ('Drop failed: ' || 'Synonym: "' ||   
        w_synonym || '"  Table Name: ' || w_table_name || ' Error: ' || v_err_msg );
        countObjectsFailedToDrop := countObjectsFailedToDrop + 1;
        dbms_sql.close_cursor(Dynamic_Cursor);
END;

   countObjects := countObjects + 1;
fetch synonym_cursor into w_synonym,w_owner,w_table_name;
end loop;
close synonym_cursor;

     DBMS_OUTPUT.PUT_LINE
       ('Total Number of Objects: ' || countObjects );  
     DBMS_OUTPUT.PUT_LINE
       ('Total Number of Objects Dropped: ' || countObjectsDropped ); 
     DBMS_OUTPUT.PUT_LINE
       ('Total Number of Objects Failed to Drop: ' || countObjectsFailedToDrop ); 
END;
/

EXECUTE dbms_output.put_line('Finished dropping public synonyms created by ODMRSYS. ' || systimestamp);
