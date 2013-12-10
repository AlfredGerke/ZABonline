/******************************************************************************/
/* Author:  Alfred Gerke (AGE)
/* Date:    2012-07-23
/* Purpose: Dieses Script setzt eine neu erstellte ZABonline-DB Version 
/*          2.5.x voraus.
/*          Diese Scripte werden zum Testen von SPs verwendet                                                                                                       
/******************************************************************************/
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung f�r FireBird 2.5.x   
/* - Das Script ist f�r die Ausf�hrung im IBExpert erstellt worden            
/* - Ein Connect zur ZABonline-DB muss hergestellt werden 
/* - Es m�ssen alle notwendigen Create- und Updatescripte eingespielt worden sein
/******************************************************************************/
/* History: 2012-07-23
/*          Stammdaten f�r Testproceduren
/******************************************************************************/

/******************************************************************************/
/*                                 Insert into REGISTRY                                  
/******************************************************************************/
SET TERM ^ ; /* definiert den Begin eines Ausf�hrungsblockes */
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
SET TERM ; ^ /* definiert das Ende eines Ausf�hrungsblockes */
/******************************************************************************/
/******************************************************************************/                                  
/******************************************************************************/