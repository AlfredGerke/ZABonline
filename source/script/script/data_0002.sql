/******************************************************************************/
/* Author:  Alfred Gerke (AGE)
/* Date:    2012-05-10
/* Purpose: Dieses Script setzt eine neu erstellte ZABonline-DB Version 
/*          2.5.x voraus.
/*          Diese Scripte werden zum Testen von SPs verwendet                                                                                                       
/******************************************************************************/
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im ISQL erstellt worden            
/* - Ein Connect zur ZABonline-DB muss hergestellt werden 
/* - Es müssen alle notwendigen Create- und Updatescripte eingespielt worden sein
/******************************************************************************/
/* History: 2012-05-10
/*          Stammdaten für den Abschnitt: Personendaten
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

  key_section = 'ADDRESSBOOK';
  section = 'MIMETYPE';
  ident = 'image/jpeg';
  value_for_ident = 'TRUE';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;
  
  key_section = 'ADDRESSBOOK';
  section = 'MIMETYPE';
  ident = 'image/gif';
  value_for_ident = 'TRUE';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;
  
  key_section = 'ADDRESSBOOK';
  section = 'MIMETYPE';
  ident = 'image/rnd';
  value_for_ident = 'TRUE';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;   
  
  key_section = 'ADDRESSBOOK';
  section = 'MIMETYPE';
  ident = 'application/octet-stream';
  value_for_ident = 'TRUE'; 
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;  

END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */
/******************************************************************************/
/*                                    Insert Stammdata                               
/******************************************************************************/

SET TERM ^ ; /* definiert den Begin eines Ausführungsblockes */
EXECUTE BLOCK AS
DECLARE key_section varchar(128);
DECLARE section varchar(128);
DECLARE ident varchar(128);
DECLARE default_for_ident varchar(255);
DECLARE value_by_ident varchar(255);
DECLARE default_country_id integer;
DECLARE titel_id integer;
DECLARE salutation_id integer;
DECLARE person_id integer;
DECLARE bank_id integer;
DECLARE code DBOBJECTNAME32;
DECLARE desc varchar(2000);
DECLARE do_not_delete DN_BOOLEAN;
BEGIN
  key_section = 'GENERAL';
  section = 'DEFAULT';
  ident = 'COUNTRYCODE';
  default_for_ident = '';
  select RESULT from SP_READSTRING(:key_section, :section, :ident, :default_for_ident) into :value_by_ident;

  select ID from COUNTRY where COUNTRY_CODE=:value_by_ident into :default_country_id; 

  insert into ADDRESS_TYPE (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) values (:default_country_id, 'keine Angabe', '', 1);
  insert into ADDRESS_TYPE (COUNTRY_ID, CAPTION, DESCRIPTION) values (:default_country_id, 'Privat', 'Private Adresse');
  insert into ADDRESS_TYPE (COUNTRY_ID, CAPTION, DESCRIPTION) values (:default_country_id, 'Geschäftlich', 'Geschäftsadresse');
  
  insert into CONTACT_TYPE (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) values (:default_country_id, 'keine Angabe', '', 1);
  insert into CONTACT_TYPE (COUNTRY_ID, CAPTION, DESCRIPTION) values (:default_country_id, 'Privat', 'Private Adresse');
  insert into CONTACT_TYPE (COUNTRY_ID, CAPTION, DESCRIPTION) values (:default_country_id, 'Geschäftlich', 'Geschäftsadresse');
 
  insert into TITEL (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) values (:default_country_id, 'keine Angabe', '', 1);
  
  insert into SALUTATION (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) values (:default_country_id, 'keine Angabe', '', 1);
  insert into SALUTATION (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) values (:default_country_id, 'Herr', 'Sehr geehrter Herr', 1);
  insert into SALUTATION (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) values (:default_country_id, 'Herren', 'Sehr geehrte Herren', 1);
  insert into SALUTATION (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) values (:default_country_id, 'Frau', 'Sehr geehrte Frau', 1);  
  insert into SALUTATION (COUNTRY_ID, CAPTION, DESCRIPTION, DONOTDELETE) values (:default_country_id, 'Damen', 'Sehr geehrte Damen', 1);
  
  select ID from TITEL where CAPTION='keine Angabe' into :titel_id;
  select ID from SALUTATION where CAPTION='keine Angabe' into :salutation_id; 
  
  /* Testdaten für die Personentabele */
  insert into PERSON (TENANT_ID, TAG_ID, MARRIED_TO_ID, TITEL_ID, SALUTATION_ID, PICTURE_ID, FIRSTNAME, NAME1, NAME2, NAME3, IS_MARRIED, MARRIED_SINCE, MARRIAGE_PARTNER_FIRSTNAME, MARRIAGE_PARTNER_NAME1, SALUTATION1, SALUTATION2, DAY_OF_BIRTH, ISPRIVATE, SOFTDEL)
            values (1, NULL, NULL, :titel_id, :salutation_id, NULL, 'Alfred', 'Gerke', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0);
            
  insert into PERSON (TENANT_ID, TAG_ID, MARRIED_TO_ID, TITEL_ID, SALUTATION_ID, PICTURE_ID, FIRSTNAME, NAME1, NAME2, NAME3, IS_MARRIED, MARRIED_SINCE, MARRIAGE_PARTNER_FIRSTNAME, MARRIAGE_PARTNER_NAME1, SALUTATION1, SALUTATION2, DAY_OF_BIRTH, ISPRIVATE, SOFTDEL)
            values (1, NULL, NULL, :titel_id, :salutation_id, NULL, 'Alfred 2', 'Gerke 2', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0);
            
  /* Testdaten für die Banktabelle */            
  INSERT INTO BANK (TENANT_ID, TAG_ID, CAPTION, BLZ, BLZ_FMT, KTO, KTO_FMT, IBAN, BIC, SOFTDEL)
            VALUES (1, NULL, 'Gerke00', 47240047, NULL, 8277436, NULL, NULL, NULL, 0);
            
  INSERT INTO BANK (TENANT_ID, TAG_ID, CAPTION, BLZ, BLZ_FMT, KTO, KTO_FMT, IBAN, BIC, SOFTDEL)
            VALUES (1, NULL, 'Gerke01', 47240047, NULL, 827743601, NULL, NULL, NULL, 0);
            
  /* Testdaten für die Relation Person-Bank */
  select id from PERSON where NAME1='Gerke' into :person_id;
  select id from BANK where CAPTION='Gerke00' into :bank_id;  
  insert into REL_PERSON_BANK(PERSON_ID, BANK_ID) values (:person_id, :bank_id);
  
  select id from BANK where CAPTION='Gerke01' into :bank_id;
  insert into REL_PERSON_BANK(PERSON_ID, BANK_ID) values (:person_id, :bank_id);
  
  select id from PERSON where NAME1='Gerke 2' into :person_id;
  select id from BANK where CAPTION='Gerke01' into :bank_id;            
  insert into REL_PERSON_BANK(PERSON_ID, BANK_ID) values (:person_id, :bank_id);
  
  desc = 'Domaine: Kategoriearten der Tabelle CATEGORY';
  code = 'LABEL';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: Mimetype aus der Tabelle DOCUMENT';
  code = 'MIME_TYPE';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: Mime-Subtype aus der Tabelle DOCUMENT';
  code = 'MIME_SUBTYPE';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: Zugriffsart für die SP SP_UPDATE_DOC_BY_FILE';
  code = 'ACCESS_MODE';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: Zugehörigkeit für die SP SP_UPDATE_DOC_BY_FILE';
  code = 'RELATION_TYPE';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);
  
  desc = 'Domaine: Eindeutiger Dateiname für die Tabelle DOCUMENT';
  code = 'UNIQUE_NAME';
  do_not_delete = 0;
  INSERT INTO DATATYPE (CODE, DESCRIPTION, DONOTDELETE) VALUES(:code, :desc, :do_not_delete);  
              
END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */
/******************************************************************************/
/******************************************************************************/                                  
/******************************************************************************/