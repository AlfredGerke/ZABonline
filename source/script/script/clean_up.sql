/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-10-19                                                          
/* Purpose: R�umt nach der Installation im Datenmodell auf
/*          Alle tempr�ren DB-Objecte, welche nur f�r die Installation verwendet
/*          werden, werden entfernt
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung f�r FireBird 2.5.x   
/* - Das Script ist f�r die Ausf�hrung im IBExpert erstellt worden              
/* - Ein m�glicher Connect zur ZABonline-DB sollte geschlossen werden 
/* - Die Installationstools m�ssen installiert worden sein  
/******************************************************************************/
/* History: 2013-10-19
/*          R�umt nach der Installation im Datenmodell auf
/******************************************************************************/

/******************************************************************************/
/*        Following SET SQL DIALECT is just for the Database Comparer         
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

/* An dieser Stelle muss die Client-DLL (Pfad und Name) �berpr�ft werden      
SET CLIENTLIB 'C:\Users\Alfred\Programme\Firebird_2_5\bin\fbclient.dll';      */

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) �berf�hrt werden */
CONNECT '127.0.0.1:ZABONLINEEMBEDDED' USER 'SYSDBA' PASSWORD 'masterkey';
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
  script = 'clean_up.sql';
  description = 'R�umt nach der Installation im Datenmodell auf';
  
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME='UPDATEHISTORY')) then
  begin   
    execute statement 'INSERT INTO UPDATEHISTORY(NUMBER, SUBITEM, SCRIPT, DESCRIPTION) VALUES ( ''' || :number ||''', ''' || :subitem ||''', ''' || :script || ''', ''' || :description || ''');';
  end  

END^        
SET TERM ; ^ /* definiert das Ende eines Ausf�hrungsblockes */

COMMIT WORK;
/******************************************************************************/
/*                                  DB-Objecte entfernen                                   
/******************************************************************************/


/******************************************************************************/
/******************************************************************************/
/******************************************************************************/