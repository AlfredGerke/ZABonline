/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-11-25                                                          
/* Purpose: Nachtr�gliche Bearbeitung von Katalogberechtigungen 
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung f�r FireBird 2.5.x   
/* - Das Script ist f�r die Ausf�hrung im ISQL erstellt worden              
/* - Ein m�glicher Connect zur ZABonline-DB sollte geschlossen werden 
/* - Die Installationstools m�ssen installiert worden sein  
/******************************************************************************/
/* History: 2013-11-25
/*          Katalogeigenschaften verschiedenen Datenbankobjekte granten
/*          2014-04-05
/*          Scripte auf ISQL optimiert 
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

SET AUTODDL;

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) �berf�hrt werden */
CONNECT '127.0.0.1/32258:ZABONLINEEMBEDDED' USER 'SYSDBA' PASSWORD 'masterkey';
/******************************************************************************/
/*                                 Insert into UPDATEHISTORY                                  
/******************************************************************************/
SET TERM ^ ; /* definiert den Begin eines Ausf�hrungsblockes */
EXECUTE BLOCK AS
DECLARE number varchar(2000);
DECLARE subitem varchar(2000);
DECLARE script varchar(255);
DECLARE description varchar(2000);
BEGIN
  number = '0';
  subitem = '0';
  script = 'create_grant_catalog_properties.sql';
  description = 'Katalogeigenschaften verschiedenen Datenbankobjekte granten';
  
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME='UPDATEHISTORY')) then
  begin   
    execute statement 'INSERT INTO UPDATEHISTORY(NUMBER, SUBITEM, SCRIPT, DESCRIPTION) VALUES ( ''' || :number ||''', ''' || :subitem ||''', ''' || :script || ''', ''' || :description || ''');';
  end  

END^        
SET TERM ; ^ /* definiert das Ende eines Ausf�hrungsblockes */

COMMIT WORK;
/******************************************************************************/
/*                                  Katalogeingeschaften zu granten                                   
/******************************************************************************/

execute procedure SP_GRANT_CAT_PROPERTIES 'SP_INSERT_CATALOGITEM';

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/