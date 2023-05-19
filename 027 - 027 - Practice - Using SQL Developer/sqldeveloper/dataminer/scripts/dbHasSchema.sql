WHENEVER SQLERROR EXIT SQL.SQLCODE;

EXECUTE dbms_output.put_line('Check Existance of ODMRSYS USER: ' || systimestamp);


declare
user_exist integer;
begin
    SELECT COUNT(*) INTO user_exist from  dba_users where username = 'ODMRSYS';
    if (user_exist > 0) then
        RAISE_APPLICATION_ERROR(-20000, 'Drop Repository failed, ODMRSYS is not dropped');
    end if;
END;
/

EXECUTE dbms_output.put_line('Finished Check Existance of ODMRSYS USER: ' || systimestamp);


