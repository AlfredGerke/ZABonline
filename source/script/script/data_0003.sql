/******************************************************************************/
/* Author:  Alfred Gerke (AGE)
/* Date:    2012-07-23
/* Purpose: Dieses Script setzt eine neu erstellte ZABonline-DB Version 
/*          2.5.x voraus.
/*          Diese Scripte werden zum Testen von SPs verwendet                                                                                                       
/******************************************************************************/
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im IBExpert erstellt worden            
/* - Ein Connect zur ZABonline-DB muss hergestellt werden 
/* - Es müssen alle notwendigen Create- und Updatescripte eingespielt worden sein
/******************************************************************************/
/* History: 2012-07-23
/*          Stammdaten für Testproceduren
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

  key_section = 'TEST';
  section = 'STORED_PROCEDURES';
  ident = 'LOOP_COUNT';
  value_for_ident = '10';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;
  
  key_section = 'TEST';
  section = 'STORED_PROCEDURES';
  ident = 'DO_RAISE_EXCEPTION';
  value_for_ident = '0';
  execute procedure SP_WRITESTRING :key_section, :section, :ident, :value_for_ident;  

END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */
/******************************************************************************/
/******************************************************************************/                                  
/******************************************************************************/