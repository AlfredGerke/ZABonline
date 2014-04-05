/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-03-12                                                          
/* Purpose: Grundsteinlegung des Datenmodelles f�r ZABonline (Wavemaker)    
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung f�r FireBird 2.5.x   
/* - Das Script ist f�r die Ausf�hrung im ISQL erstellt worden              
/* - Ein m�glicher Connect zur ZABonline-DB sollte geschlossen werden   
/******************************************************************************/
/* History: 2013-03-12
/*          Benutzer anlegen
/*          2014-04-05
/*          Scripte auf ISQL optimiert
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

SET AUTODDL;

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) �berf�hrt werden */
CREATE DATABASE '127.0.0.1:ZABONLINEEMBEDDED' USER 'SYSDBA' PASSWORD 'masterkey' PAGE_SIZE 4096 DEFAULT CHARACTER SET WIN1252 COLLATION WIN1252;
/******************************************************************************/
/*                                   User                                   
/******************************************************************************/

CREATE USER WEBCONNECT
PASSWORD 'webconnect' 
FIRSTNAME 'Online' 
MIDDLENAME 'Mitglieder' 
LASTNAME 'Verwaltung';
    
CREATE USER INSTALLER
PASSWORD 'installer' 
FIRSTNAME 'Application' 
MIDDLENAME 'Database' 
LASTNAME 'Model';

COMMIT WORK;
/******************************************************************************/
/*                                   Datenbank l�schen                                   
/******************************************************************************/

SHELL DEL C:\Users\Alfred\Sourcen\db\firebird\zabonline\zab_online.fdb
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/