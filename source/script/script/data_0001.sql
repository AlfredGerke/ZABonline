/******************************************************************************/
/* Author:  Alfred Gerke (AGE)
/* Date:    2012-03-17
/* Purpose: Dieses Script setzt eine neu erstellte ZABonline-DB Version 
/*          2.5.x voraus.
/*          Diese Scripte werden zum Testen von SPs verwendet                                                                                                       
/******************************************************************************/
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im IBExpert erstellt worden            
/* - Ein Connect zur ZABonline-DB muss hergestellt werden 
/* - Es müssen alle notwendigen Create- und Updatescripte eingespielt worden sein
/******************************************************************************/
/* History: 2012-03-17
/*          Erst Daten in das Datenmodell einbringen
/******************************************************************************/

/******************************************************************************/
/*                                 Insert into REGISTRY                                  
/******************************************************************************/
SET TERM ^ ; /* definiert den Begin eines Ausführungsblockes */
EXECUTE BLOCK AS
DECLARE key_section varchar(128);
DECLARE section varchar(128);
DECLARE ident varchar(128);
DECLARE value_for_ident varchar(255);
BEGIN
  key_section = 'GENERAL';
  section = 'DBMODEL';
  ident = 'VERSION';
  value_for_ident = '0';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;
  
  key_section = 'GENERAL';
  section = 'DEFAULT';
  ident = 'DO_FORMAT_DBVERSION';
  value_for_ident = '1';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;  
  
  key_section = 'GENERAL';
  section = 'DEFAULT';
  ident = 'COUNTRYCODE';
  value_for_ident = 'DEU';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;
  
  key_section = 'GENERAL';
  section = 'DEFAULT';
  ident = 'DEFAULTCURRENCY';
  value_for_ident = 'EUR';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;  
  
  /* Stand 2013-02-11: wegen Probleme mit JavaService-Exception-Messages eingeführt;
  /*                   nach Problembehebung mit JavaService-Exception-Messages nicht weiter verwendet */
  key_section = 'WORKAROUND';
  section = 'EXCEPTION_HANDLING';
  ident = 'DO_NOT_RAISE';
  value_for_ident = '1';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident; 
  
  key_section = 'ADDRESSBOOK';
  section = 'CHECK';
  ident = 'ALLOW_DUPLICATES';
  value_for_ident = '1';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;
  
  key_section = 'GENERAL'; 
  section = 'UNIQUENAME';
  ident = 'FIXPART';
  value_for_ident = 'unique';  
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;
  
  key_section = 'GENERAL'; 
  section = 'UNIQUENAME';  
  ident = 'SUBSTITUE';
  value_for_ident = '_';  
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;
  
  key_section = 'GENERAL'; 
  section = 'SP_TOUCHSESSION';  
  ident = 'DO_REGISTER_CLOSED_SESSION';
  value_for_ident = '1';  
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;  

END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */
/******************************************************************************/
/*                                    Insert general Data                               
/******************************************************************************/

SET TERM ^ ; /* definiert den Begin eines Ausführungsblockes */
EXECUTE BLOCK AS
DECLARE role_id integer;
DECLARE tenant_id integer;  
DECLARE key_section varchar(128);
DECLARE section varchar(128);
DECLARE ident varchar(128);
DECLARE default_for_ident varchar(255);
DECLARE value_by_ident varchar(255);
DECLARE default_country_id integer;
DECLARE code DBOBJECTNAME32;
DECLARE desc varchar(2000);
DECLARE do_not_delete BOOLEAN;
BEGIN

  key_section = 'GENERAL';
  section = 'DEFAULT';
  ident = 'COUNTRYCODE';
  default_for_ident = '';
  select RESULT from SP_READSTRING(:key_section, :section, :ident, :default_for_ident) into :value_by_ident;
  
  INSERT INTO COUNTRY(COUNTRY_CODE, COUNTRY_CAPTION, CURRENCY_CODE, CURRENCY_CAPTION, DESCRIPTION, DONOTDELETE) values ('DEU', 'Deutschland', 'EUR', 'Euro', 'Installationsstandard', 1);
  
  select ID from COUNTRY where COUNTRY_CODE=:value_by_ident into :default_country_id;
  
  code = '+49';
  desc = 'Deutschland';
  INSERT INTO AREA_CODE (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) VALUES (:default_country_id, :code, :desc, 1);

  /* Administrator */
  INSERT INTO ROLES (CAPTION, DESCRIPTION, IS_ADMIN, DONOTDELETE) VALUES ('Admin', 'Administrator', 1, 1);
  
  select ID from ROLES where CAPTION='Admin' into :role_id;          
  
  INSERT INTO TENANT (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) VALUES (:default_country_id, 'Admin', 'Administrator', 1);
  
  select ID from TENANT where CAPTION='Admin' into :tenant_id;
  
  INSERT INTO USERS (ROLE_ID, TENANT_ID, USERNAME, "PASSWORD", FIRST_NAME, NAME, EMAIL, ALLOW_LOGIN, DONOTDELETE) VALUES (:role_id, :tenant_id, 'admin', 'c7ad44cbad762a5da0a452f9e854fdc1e0e7a52a38015f23f3eab1d80b931dd472634dfac71cd34ebc35d16ab7fb8a90c81f975113d6c7538dc69dd8de9077ec', 'Alfred', 'Gerke', 'info@software-aus-erwitte.de', 1, 1);
    
  /* Eingeschränkter Benutzer */
  INSERT INTO ROLES (CAPTION, DESCRIPTION, IS_ADMIN, SETUP, MEMBERS, ACTIVITY_RECORDING, SEPA, BILLING, IMPORT, REFERENCE_DATA, REPORTING, MISC, FILERESOURCE, DONOTDELETE) VALUES ('Work', 'Sachbearbeiter', 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0);
  
  select ID from ROLES where CAPTION='Work' into :role_id;
  
  INSERT INTO TENANT (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) VALUES (:default_country_id, 'Soest', 'Entwicklung Soest', 0);
  
  select ID from TENANT where CAPTION='Soest' into :tenant_id;
  
  INSERT INTO USERS (ROLE_ID, TENANT_ID, USERNAME, "PASSWORD", FIRST_NAME, NAME, EMAIL, ALLOW_LOGIN, DONOTDELETE) VALUES (:role_id, :tenant_id, 'Test', 'c6ee9e33cf5c6715a1d148fd73f7318884b41adcb916021e2bc0e800a5c5dd97f5142178f6ae88c8fdd98e1afb0ce4c8d2c54b5f37b30b7da1997bb33b0b8a31', 'Test', 'User', 'entwicklung@software-aus-erwitte.de', 1, 0);  
  
  desc = 'Unbekannter Datentype';
  do_not_delete = 1;
  code = 'UNKNWON';  
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Standard Datentyp';
  code = 'BLOB';
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Standard Datentyp';
  code = 'CHAR';
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Standard Datentyp';
  code = 'DATE';
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Standard Datentyp';
  code = 'DECIMAL';
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Standard Datentyp';
  code = 'DOUBLE PRECISION';
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Standard Datentyp';
  code = 'FLOAT';
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Standard Datentyp';
  code = 'INTEGER';
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Standard Datentyp';
  code = 'NUMERIC';
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Standard Datentyp';
  code = 'SMALLINT';
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Standard Datentyp';
  code = 'TIME';
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Standard Datentyp';
  code = 'TIMESTAMP';
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Standard Datentyp';
  code = 'VARCHAR';
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: 0 = False / 1 = True / Default 0';
  code = 'BOOLEAN';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: Benutzername aus CURRENT_USER';
  code = 'USERNAME';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: Caption mit max. 254 Zeichen';
  code = 'CAPTION254';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: Caption mit max. 64 Zeichen';
  code = 'CAPTION64';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: DB-Objekt mit max. 15 Zeichen';
  code = 'DBOBJECTNAME15';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: DB-Objekt mit max. 24 Zeichen';
  code = 'DBOBJECTNAME24';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: DB-Objekt mit max. 32 Zeichen';
  code = 'DBOBJECTNAME32';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete); 
  
  code = '0';
  desc = 'count=1;; json={"kind": 0, <?>: <?>}';
  INSERT INTO JSON_KIND (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) VALUES (:default_country_id, :code, :desc, 1);
  
  code = '1';
  desc = 'count=2;; json={"kind": 1, "publish": "<?>", "message": "<?>"}';
  INSERT INTO JSON_KIND (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) VALUES (:default_country_id, :code, :desc, 1);

  code = '2';
  desc = 'count=2;; json={"kind": 2, "publish": "<?>", "list": [{"message": "<?>"}, {"message": "<?>"}]}';
  INSERT INTO JSON_KIND (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) VALUES (:default_country_id, :code, :desc, 1);
  
  code = '3';
  desc = 'count=2;; json={"kind": 3, "publish": "<?>", "message": "<?>"}';
  INSERT INTO JSON_KIND (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) VALUES (:default_country_id, :code, :desc, 1);
  
  code = '4';
  desc = 'count=2;; json={"kind": 4, "publish": "<?>", "message": "<?>", "uniquename": "<?>"}';
  INSERT INTO JSON_KIND (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) VALUES (:default_country_id, :code, :desc, 1);
  
  code = '1000';
  desc = 'count=4;; json={"kind": 1000,  "mode": 0, "find": "<?>", "callback": "<?>"}';
  INSERT INTO JSON_KIND (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) VALUES (:default_country_id, :code, :desc, 1);
  
  code = '1001';
  desc = 'count=5;; json={"kind": 1001, "mode": 0, "find": "<?>", "label": "<?>", "callback": "<?>"}';
  INSERT INTO JSON_KIND (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) VALUES (:default_country_id, :code, :desc, 1);  
  
  code = 'SOFTDEL';
  desc = 'Deleteflag für Tabellen';  
  INSERT INTO V_ADM_COMMON_IDX_COLUMNS (CAPTION, DESCRIPTION) VALUES (:code, :desc);  
END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */
/******************************************************************************/
/******************************************************************************/                                  
/******************************************************************************/