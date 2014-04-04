/******************************************************************************/
/* Author:  Alfred Gerke (AGE)
/* Date:    2013-06-22
/* Purpose: Dieses Script setzt eine neu erstellte ZABonline-DB Version 
/*          2.5.x voraus.
/*          Diese Scripte werden zum Testen von SPs verwendet                                                                                                       
/******************************************************************************/
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im ISQL erstellt worden            
/* - Ein Connect zur ZABonline-DB muss hergestellt werden 
/* - Es müssen alle notwendigen Create- und Updatescripte eingespielt worden sein
/******************************************************************************/
/* History: 2013-06-22
/*          Entwicklungsdaten für Abfragen aller Art
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
  
  /*
   *
   *   
  key_section = 'STATISTIK';  
  ident = 'FIND';  
  section = 'COUNT_BY_SIMPLE_ATTEMPT';
  value_for_ident = '5';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;
   *
   *
   */      
  
END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */
/******************************************************************************/
/*                                 Insert into CATEGORY                                  
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
DECLARE do_not_delete BOOLEAN;
BEGIN

  key_section = 'GENERAL';
  section = 'DEFAULT';
  ident = 'COUNTRYCODE';
  default_for_ident = '';
  select RESULT from SP_READSTRING(:key_section, :section, :ident, :default_for_ident) into :value_by_ident;

  select ID from COUNTRY where COUNTRY_CODE=:value_by_ident into :default_country_id; 

  INSERT INTO CATEGORY (COUNTRY_ID, LABEL, CAPTION, DESCRIPTION)
                VALUES (:default_country_id, 'FIND', 'Suchdialog', 'Informationen zu Arbeiten mit dem/der Suchedialog/-Page');
                  
END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */
/******************************************************************************/
/******************************************************************************/                                  
/******************************************************************************/