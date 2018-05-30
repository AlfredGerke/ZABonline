/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-11-25                                                          
/* Purpose: Nachträgliche Bearbeitung von Katalogberechtigungen 
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im ISQL erstellt worden              
/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden 
/* - Die Installationstools müssen installiert worden sein  
/******************************************************************************/
/* History: 2013-11-25
/*          Katalogeigenschaften verschiedenen Datenbankobjekte granten
/*          2014-04-05
/*          Scripte auf ISQL optimiert 
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

SET AUTODDL;

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */
CONNECT '127.0.0.1/32258:ZABONLINEEMBEDDED' USER 'SYSDBA' PASSWORD 'masterkey';
/******************************************************************************/
/*                                 Insert into UPDATEHISTORY                                  
/******************************************************************************/
SET TERM ^ ; /* definiert den Begin eines Ausführungsblockes */
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
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */

COMMIT WORK;
/******************************************************************************/
/*                                  Katalogeingeschaften zu granten                                   
/******************************************************************************/

execute procedure SP_GRANT_CAT_PROPERTIES 'SP_INSERT_CATALOGITEM';

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/