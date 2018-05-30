/******************************************************************************/
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2012-03-17                                                          
/* Purpose: Dieses Script ruft alle vorhandenen Updatescripte auf                                                              
/******************************************************************************/
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung f�r FireBird 2.5.x  
/* - Das Script ist ausschlie�lich f�r die Ausf�hrung im IBExpert erstellt worden            
/* - Ein m�glicher Connect zur ZABonline-DB muss geschlossen werden
/* - Das Datenbankfile muss vorhanden sein
/******************************************************************************/
/* History: 2012-03-17
/*          Erstellung 
/******************************************************************************/

/******************************************************************************/
/*                                  Create Users
/******************************************************************************/

/*
 *
 * 
  Userscript nur einmal einspielen.
  User werden in der Sicherheitsdatenbank angelegt.
  WICHTIG: Das Script erstellt eine Datenbank. Wenn dieses Script �ber das 
    batch.sql-Script aufgerufen wird, muss im create_tools.sql-Script anstatt der
    create database eine connect-Anweisung ausgef�hrt werden. 
    Es empfiehlt sich das create_user.sql-Script separat auszuf�hren.
 *  
input 'create_user.sql';

 
 *
 *
 */
/******************************************************************************/
/*                                  Create Database
/******************************************************************************/

input 'create_tools.sql';
input 'create_hibernate_workaround.sql';
/*
 * 
 * bis auf weiteres zur�ckgestellt
input 'create_json.sql';
*
*
*/ 

input 'create_interface.sql';

input 'create_db.sql';
input 'create_person.sql';
input 'create_testproc_env.sql';
input 'create_factory.sql';
input 'create_admin.sql';
input 'create_find.sql';

input 'create_implementation.sql';

/******************************************************************************/
/*                                  Modify Schema
/*
/* In diesem Abschnitt sollen nur Scripte aufgef�hrt werden die �ndernungen am
/* Datenmodell per SP durchf�hren. z.B.: SP_CREATE_ALL_SIMPLE_INDEXE
/******************************************************************************/

input 'create_simple_indexe.sql';
/*
 * 
 * bis auf weiteres zur�ckgestellt
input 'recreate_user_views.sql';
*
*
*/

input 'create_grant_catalog_properties.sql';

/******************************************************************************/
/*                                  Clean up
/*
/* In diesem Abschnitt sollen nur Scripte aufgef�hrt werden die alle tempor�ren
/* Datenbankobjekte, welche nur f�r die Installation verwendet werden, entfernen
/******************************************************************************/

input 'clean_up.sql';

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/