/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-10-19                                                          
/* Purpose: Überarbeitet alle registrierten UserViews
/*          Die registrierten UserViews werden dem Admin-Katalog USERVIEW_SOURCES 
/*          entnommen  
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im ISQL erstellt worden              
/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden 
/* - Die Installationstools müssen installiert worden sein  
/******************************************************************************/
/* History: 2013-10-19
/*          Überarbeitet alle registrierten UserViews
/******************************************************************************/

/******************************************************************************/
/*        Following SET SQL DIALECT is just for the Database Comparer         
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

SET AUTODDL;

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */
CONNECT '127.0.0.1:ZABONLINEEMBEDDED' USER 'INSTALLER' PASSWORD 'installer';
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
  script = 'create_user_views.sql';
  description = 'Überarbeitet alle registrierten UserViews';
  
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME='UPDATEHISTORY')) then
  begin   
    execute statement 'INSERT INTO UPDATEHISTORY(NUMBER, SUBITEM, SCRIPT, DESCRIPTION) VALUES ( ''' || :number ||''', ''' || :subitem ||''', ''' || :script || ''', ''' || :description || ''');';
  end  

END^        
SET TERM ; ^ /* definiert das Ende eines Ausführungsblockes */

COMMIT WORK;
/******************************************************************************/
/*                                  Einspalten-Indexe                                   
/******************************************************************************/
/* Wenn Log vorhanden, dann zurerst löschen */
SHEll DEL C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\log\alterusrviews.log;

OUTPUT 'C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\log\alterusrviews.log';
  select
    success, 
    tablename, 
    userview 
  from
    SP_CREATE_ALL_USER_VIEWS(1);
OUTPUT;   

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/