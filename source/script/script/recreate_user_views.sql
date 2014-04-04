/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-10-19                                                          
/* Purpose: �berarbeitet alle registrierten UserViews
/*          Die registrierten UserViews werden dem Admin-Katalog USERVIEW_SOURCES 
/*          entnommen  
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung f�r FireBird 2.5.x   
/* - Das Script ist f�r die Ausf�hrung im ISQL erstellt worden              
/* - Ein m�glicher Connect zur ZABonline-DB sollte geschlossen werden 
/* - Die Installationstools m�ssen installiert worden sein  
/******************************************************************************/
/* History: 2013-10-19
/*          �berarbeitet alle registrierten UserViews
/******************************************************************************/

/******************************************************************************/
/*        Following SET SQL DIALECT is just for the Database Comparer         
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

SET AUTODDL;

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) �berf�hrt werden */
CONNECT '127.0.0.1:ZABONLINEEMBEDDED' USER 'INSTALLER' PASSWORD 'installer';
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
  script = 'create_user_views.sql';
  description = '�berarbeitet alle registrierten UserViews';
  
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME='UPDATEHISTORY')) then
  begin   
    execute statement 'INSERT INTO UPDATEHISTORY(NUMBER, SUBITEM, SCRIPT, DESCRIPTION) VALUES ( ''' || :number ||''', ''' || :subitem ||''', ''' || :script || ''', ''' || :description || ''');';
  end  

END^        
SET TERM ; ^ /* definiert das Ende eines Ausf�hrungsblockes */

COMMIT WORK;
/******************************************************************************/
/*                                  Einspalten-Indexe                                   
/******************************************************************************/
/* Wenn Log vorhanden, dann zurerst l�schen */
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