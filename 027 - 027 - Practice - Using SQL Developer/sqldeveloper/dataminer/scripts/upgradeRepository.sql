WHENEVER SQLERROR EXIT SQL.SQLCODE;
EXECUTE dbms_output.put_line('Start Data Miner Repository DB Object Upgrade.' || systimestamp);



DECLARE
  repos_version VARCHAR2(30);
BEGIN
  SELECT PROPERTY_STR_VALUE INTO repos_version FROM ODMRSYS.ODMR$REPOSITORY_PROPERTIES WHERE PROPERTY_NAME = 'VERSION';
  dbms_output.put_line('Existing Repository version prior to upgrade is: ' || repos_version);
END;
/

@@upgradeRepo11_2_0_1_10To11_2_0_1_11.sql
@@upgradeRepo11_2_0_1_11To11_2_0_1_12.sql
@@upgradeRepo11_2_0_1_12To11_2_0_1_13.sql
@@upgradeRepo11_2_0_1_13To11_2_1_1_1.sql
@@upgradeRepo11_2_1_1_1To11_2_1_1_2.sql
@@upgradeRepo11_2_1_1_2To11_2_1_1_3.sql
@@upgradeRepo11_2_1_1_3To11_2_1_1_4.sql
@@upgradeRepo11_2_1_1_4To11_2_1_1_5.sql
@@upgradeRepo11_2_1_1_5To11_2_1_1_6.sql
@@upgradeRepo11_2_1_1_6To11_2_2_1_1.sql
@@upgradeRepo11_2_2_1_1To12_1_0_1_1.sql
@@upgradeRepo12_1_0_1_1To12_1_0_1_2.sql
@@upgradeRepo12_1_0_1_2To12_1_0_1_3.sql
@@upgradeRepo12_1_0_1_3To12_1_0_1_4.sql
@@upgradeRepo12_1_0_1_4To12_1_0_1_5.sql
@@upgradeRepo12_1_0_1_5To12_1_0_2_1.sql
@@upgradeRepo12_1_0_2_1To12_1_0_2_2.sql
@@upgradeRepo12_1_0_2_2To12_1_0_2_3.sql
@@upgradeRepo12_1_0_2_3To12_1_0_2_4.sql
@@upgradeRepo12_1_0_2_4To12_1_0_2_5.sql
@@upgradeRepo12_1_0_2_5To12_1_0_2_6.sql
@@upgradeRepo12_1_0_2_6To12_2_0_0_0.sql
@@upgradeRepo12_2_0_0_0To12_2_0_0_1.sql
@@upgradeRepo12_2_0_0_1To12_2_0_0_2.sql
@@upgradeRepo12_2_0_0_2To12_2_0_0_3.sql
@@upgradeRepo12_2_0_0_3To12_2_0_0_4.sql
@@upgradeRepo12_2_0_0_4To12_2_0_0_5.sql
@@upgradeRepo12_2_0_0_5To12_2_0_0_6.sql

EXECUTE dbms_output.put_line('End Data Miner Repository DB Object Upgrade.' || systimestamp);
