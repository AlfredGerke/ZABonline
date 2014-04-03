/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-04-13                                                          
/* Purpose: Grundsteinlegung des Datenmodelles für ZABonline (Wavemaker)    
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im IBExpert erstellt worden              
/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden   
/******************************************************************************/
/* History: 2013-04-13
/*          Script-Interface für Hibernate-Entitäten
/******************************************************************************/

/******************************************************************************/
/*        Following SET SQL DIALECT is just for the Database Comparer         */
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

/* An dieser Stelle muss die Client-DLL (Pfad und Name) überprüft werden      
SET CLIENTLIB 'C:\Users\Alfred\Programme\Firebird_2_5\bin\fbclient.dll';      */

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */
CONNECT '127.0.0.1:ZABONLINEEMBEDDED' USER 'SYSDBA' PASSWORD 'masterkey';
/******************************************************************************/
/*                                 Hibernate-Interface                                  
/******************************************************************************/

OUTPUT 'C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\model2hibernate\datasheet.java';
select Trim(trailing from sourcecode) from SP_METADATA_TO_JAVA('DATASHEET', 0, 'INSTALLER', 'BEGIN');
select Trim(trailing from sourcecode) from SP_METADATA_TO_JAVA('DATASHEET', 0, 'INSTALLER', 'PROPERTY');
select Trim(trailing from sourcecode) from SP_METADATA_TO_JAVA('DATASHEET', 0, 'INSTALLER', 'METHOD');
select Trim(trailing from sourcecode) from SP_METADATA_TO_JAVA('DATASHEET', 0, 'INSTALLER', 'END');
OUTPUT;

OUTPUT 'C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\model2hibernate\datasheet.hbm.xml';
select Trim(trailing from sourcecode) from SP_METADATA_TO_XML('DATASHEET', 0, 1, 'INSTALLER', 'BEGIN');
select Trim(trailing from sourcecode) from SP_METADATA_TO_XML('DATASHEET', 0, 1, 'INSTALLER', 'PK_PROPERTY');
select Trim(trailing from sourcecode) from SP_METADATA_TO_XML('DATASHEET', 0, 1, 'INSTALLER', 'PROPERTY');
select Trim(trailing from sourcecode) from SP_METADATA_TO_XML('DATASHEET', 0, 1, 'INSTALLER', 'END');
OUTPUT;

OUTPUT 'C:\Users\Alfred\Sourcen\GitHub\ZABonline\source\script\model2hibernate\datasheet.checklist.txt';
select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'BEGIN');
select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'SERVICEDEF');
select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'DBSERVICE.SPRING');
select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'PROJECT-MANAGERS');
select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'TYPES');
select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'ENTITY');
OUTPUT;

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/