/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-04-13                                                          
/* Purpose: Grundsteinlegung des Datenmodelles für ZABonline (Wavemaker)    
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im IBExpert erstellt worden              
/* - Ein möglicher Connect zur Produktionsdatenbank sollte geschlossen werden   
/******************************************************************************/
/* History: 2013-04-13
/*          Diverse Werkzeug für die Installation
/*          Simple Hibernate-Schnittstelle für die DB 
/******************************************************************************/

/******************************************************************************/
/*        Following SET SQL DIALECT is just for the Database Comparer         
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

/* An dieser Stelle muss die Client-DLL (Pfad und Name) überprüft werden      */
SET CLIENTLIB 'C:\Users\Alfred\Programme\Firebird_2_5\bin\fbclient.dll';

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */
CREATE DATABASE '127.0.0.1:ZABONLINEEMBEDDED' USER 'SYSDBA' PASSWORD 'masterkey' PAGE_SIZE 4096 DEFAULT CHARACTER SET WIN1252 COLLATION WIN1252;
/******************************************************************************/
/*                                  Exceptions                                   
/******************************************************************************/

CREATE EXCEPTION DELETE_NOT_ALLOWED 'Anforderung zum Löschen abgelehnt!';

COMMIT WORK;
/******************************************************************************/
/*                                  Tools                                   
/******************************************************************************/



/* SPs */

SET TERM ^ ;

CREATE OR ALTER PROCEDURE SP_CREATE_ADMIN_CATALOG_TABLE (
  ATABLENAME varchar(24),
  ACOMMENT VARCHAR(254) DEFAULT 'ZABonline')
RETURNS (
  success smallint)
AS
declare variable sql_stmt varchar(2000);
declare variable relation_name varchar(24);
declare variable cat_comment varchar(254);
BEGIN
  relation_name = Upper(ATABLENAME);
  cat_comment = ACOMMENT;

  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME=:relation_name)) then
  begin
    success = 0;
  end
  else
  begin
    sql_stmt = 'CREATE TABLE ' || :relation_name || ' (
    ID           INTEGER NOT NULL,
    CAPTION      VARCHAR(254) NOT NULL,
    DESCRIPTION  VARCHAR(2000),
    CRE_USER     VARCHAR(32) NOT NULL,
    CRE_DATE     TIMESTAMP NOT NULL,
    CHG_USER     VARCHAR(32),
    CHG_DATE     TIMESTAMP
)';
    execute statement sql_stmt;
    
    sql_stmt = 'COMMENT ON TABLE ' || :relation_name || ' IS ''Katalog: ' || :relation_name || ' für ' || :cat_comment || ' (created by SP_CREATE_CATALOG_TABLE)''';
    execute statement sql_stmt;
    
    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.ID IS ''Primärschlüssel''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.CAPTION IS ''Bezeichnung''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.DESCRIPTION IS ''Beschreibung''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.CRE_USER IS ''Erstellt von''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.CRE_DATE IS ''Erstellt am''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.CHG_USER IS ''Geändert von''';
    execute statement sql_stmt;

    sql_stmt = 'COMMENT ON COLUMN ' || :relation_name || '.CHG_DATE IS ''Geändert am''';    
    execute statement sql_stmt;    
          
    sql_stmt = 'ALTER TABLE ' || :relation_name || ' ADD CONSTRAINT PK_' || :relation_name ||' PRIMARY KEY (ID)';      
    execute statement sql_stmt;
       
    sql_stmt = 'CREATE UNIQUE INDEX ALT_' || :relation_name || ' ON ' || :relation_name || '(CAPTION)';
    execute statement sql_stmt;  
    
    sql_stmt = 'COMMENT ON INDEX ALT_' || :relation_name || ' IS ''(created by SP_CREATE_CATALOG_TABLE)''';
    execute statement sql_stmt;
    
    sql_stmt = 'create or alter view ' || 'V_' || :relation_name || ' as select * from ' || :ATABLENAME;
    execute statement sql_stmt; 
    
    sql_stmt = 'COMMENT ON VIEW ' || 'V_' || :relation_name || ' IS ''Userview für die Tabelle ' || :ATABLENAME || ' (created by SP_CREATE_ADMIN_CATALOG_TABLE)''';
    execute statement sql_stmt; 
                    
    success = 1;  
  end      

  suspend;
END^

COMMENT ON PROCEDURE SP_CREATE_ADMIN_CATALOG_TABLE IS
'Erstellt einen Admin-Katalog'^

CREATE OR ALTER PROCEDURE SP_GET_COLUMNLIST(
  ATABLENAME varchar(31),
  ASEPARATOR varchar(1) = ',',
  ADO_CR smallint = 1)
returns(
  columnlist varchar(2000))
as
declare variable field_name varchar(31);
begin
  columnlist = '';
  
  for
  select 
    Trim(RDB$FIELD_NAME)
  from 
    RDB$RELATION_FIELDS 
  where 
    UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME)
  order by
    RDB$FIELD_POSITION   
  into 
    :field_name
  do
  begin
    if (exists(select 1 from RDB$TYPES where RDB$TYPE_NAME=:field_name)) then
      field_name = '"' || :field_name || '"';
  
    if (columnlist <> '') then
    begin
      columnlist = columnlist || :ASEPARATOR || ' ';
      if (ADO_CR = 1) then
        columnlist = columnlist || ascii_char(13);
    end  
      
    columnlist = columnlist || :field_name;  
  end 
  
  suspend; 
end^

COMMENT ON PROCEDURE SP_GET_COLUMNLIST IS
'Ermittelt eine Spaltenliste einer gegebenen Tabelle'^

CREATE OR ALTER PROCEDURE SP_GET_PRIMKEYLIST (
    atablename varchar(31),
    aseparator varchar(1) = ',',
    ado_cr smallint = 1)
returns (
    count_pk_fields integer,
    columnlist varchar(2000))
as
declare variable field_name varchar(31);
declare variable pk_index_name varchar(31);
begin
  count_pk_fields = 0;
  columnlist = '';
  
  select
    RDB$INDEX_NAME
  from
    RDB$RELATION_CONSTRAINTS
  where
    RDB$RELATION_NAME=:ATABLENAME
    and
    RDB$CONSTRAINT_TYPE='PRIMARY KEY'
  into
    :pk_index_name;

  select 
    count(RDB$FIELD_NAME) 
  from 
    RDB$INDEX_SEGMENTS 
  where 
    UPPER(RDB$INDEX_NAME)=UPPER(:pk_index_name) 
  into 
    :count_pk_fields;
  
  if ((count_pk_fields is null) or (count_pk_fields = 0)) then
  begin
    suspend;
    Exit;
  end
  
  for
  select 
    Trim(RDB$FIELD_NAME) 
  from 
    RDB$INDEX_SEGMENTS 
  where 
    UPPER(RDB$INDEX_NAME)=UPPER(:pk_index_name) 
  into 
    :field_name
  do  
  begin
    if (exists(select 1 from RDB$TYPES where RDB$TYPE_NAME=:field_name)) then
      field_name = '"' || :field_name || '"';
  
    if (columnlist <> '') then
    begin
      columnlist = columnlist || :ASEPARATOR || ' ';
      if (ADO_CR = 1) then
        columnlist = columnlist || ascii_char(13);
    end  
      
    columnlist = columnlist || :field_name;  
  end   
  
  suspend;
end^

COMMENT ON PROCEDURE SP_GET_PRIMKEYLIST IS
'Ermittelt eine Spaltenliste der Primärschlüssel'^  

CREATE OR ALTER PROCEDURE SP_GRANT_ROLE_TO_OBJECT(
  AROLE varchar(254),
  AROLETYPE varchar(32),
  AOBJECT varchar(32))
returns(
  success smallint)
as
declare variable sql_stmt varchar(2000);
begin
  success = 0;

  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME=:AOBJECT)) then
  begin   
    /* Die eigentümliche Formatierung des DDL-Codes sorgt für ein einfach lesbares Format des fertigen Triggercodes in der DB */
    if (Upper(AROLETYPE) = 'EXECUTE') then
    begin
      sql_stmt = 'GRANT ' || AROLETYPE || ' ON PROCEDURE ' || AOBJECT || ' TO ' || AROLE;
    end
    else
    begin
      sql_stmt = 'GRANT ' || AROLETYPE || ' ON ' || AOBJECT || ' TO ' || AROLE;
    end
    
    execute statement sql_stmt;
      
    success = 1;  
  end
  else
  begin
    if (Upper(AROLETYPE) = 'EXECUTE') then
    begin
      if (exists(select 1 from RDB$PROCEDURES where RDB$PROCEDURE_NAME=:AOBJECT)) then
      begin
        sql_stmt = 'GRANT ' || AROLETYPE || ' ON PROCEDURE ' || AOBJECT || ' TO ' || AROLE;
        
        execute statement sql_stmt;
    
        success = 1;      
      end
    end
  end
    
  suspend;
end^

COMMENT ON PROCEDURE SP_GRANT_ROLE_TO_OBJECT IS
'Setzt Ausführungsrecht eines DB-Objektes für eine Rolle'^

CREATE OR ALTER PROCEDURE SP_CREATE_SIMPLE_INDEX (
  AINDEXEDCOLUMN varchar(24),
  ATABLENAME varchar(24))
RETURNS (
  success smallint)  
AS
declare variable index_name varchar(31);
declare variable sql_stmt varchar(2000);
declare variable table_name varchar(31);
declare variable indexed_column varchar(31);
BEGIN
  table_name = Trim(ATABLENAME);
  indexed_column = Trim(AINDEXEDCOLUMN);

  index_name = 'IDX_' || :table_name || '_SD';
   
  if (exists(select 1 from RDB$INDICES where RDB$INDEX_NAME=:index_name)) then
  begin
    success = 0;
  end
  else
  begin
    sql_stmt = 'CREATE INDEX ' || :index_name || ' ON ' || :table_name || '(' || :indexed_column || ')';
    execute statement sql_stmt;  
    
    sql_stmt = 'COMMENT ON INDEX ' || :index_name || ' IS ''(created by SP_CREATE_SIMPLE_INDEX)''';
    execute statement sql_stmt;    

    success = 1;
  end
  
  suspend;
END^

COMMENT ON PROCEDURE SP_CREATE_SIMPLE_INDEX IS
'Erstellt einen einfachen Einspalten-Index erstellen'^

/* Katalog: COMMON_IDX_COLUMNS komplett über SP erstellen */
execute procedure SP_CREATE_ADMIN_CATALOG_TABLE 'COMMON_IDX_COLUMNS'^

CREATE OR ALTER PROCEDURE SP_CREATE_ALL_SIMPLE_INDEX (
    aownername varchar(31) = 'INSTALLER')
returns (
    success smallint,
    tablename varchar(31),
    indexedcolumn varchar(31))
as
declare variable count_columns integer;
BEGIN
  select count(1) from V_COMMON_IDX_COLUMNS into :count_columns;
  
  if ((count_columns is null) or (count_columns = 0)) then
  begin
    success = 0;
    Exit;
  end 

  for 
  select 
    Trim(RDB$RELATION_NAME) 
  from 
    RDB$RELATIONS
  where
    RDB$VIEW_SOURCE is null
  and
    RDB$OWNER_NAME=:AOWNERNAME
  into
    :tablename
  do
  begin   
    for 
    select
      Trim(CAPTION)
    from
      V_COMMON_IDX_COLUMNS
    into
      :indexedcolumn
    do
    begin
      if (exists(select 1 from RDB$RELATION_FIELDS where RDB$FIELD_NAME=:indexedcolumn and RDB$RELATION_NAME=:tablename)) then
      begin
        select success from SP_CREATE_SIMPLE_INDEX(:indexedcolumn, :tablename) into :success;
        suspend; 
      end 
    end       
  end      
END^

COMMENT ON PROCEDURE SP_CREATE_ALL_SIMPLE_INDEX IS
'Erstellt alle Einspalten-Indexe'^

/* Katalog: USERVIEW_SOURCES komplett über SP erstellen */
execute procedure SP_CREATE_ADMIN_CATALOG_TABLE 'USERVIEW_SOURCES'^
                          
CREATE OR ALTER PROCEDURE SP_CREATE_USER_VIEW(
  ATABLENAME VARCHAR(32),
  AREGISTRER_SOURCE smallint = 1,
  ADOGRANT_ZAB_ROLES smallint = 1,
  AORDER_BY_PRIM smallint = 0)
RETURNS (
  success smallint)  
AS
declare variable sql_stmt varchar(2000);
declare variable relation_name varchar(32);
declare variable softdel_field varchar(32);
declare variable columnlist varchar(2000);
declare variable interfacelist varchar(2000);
declare variable implementationlist varchar(2000);
declare variable pk_columnlist varchar(2000);
declare variable pk_columncount integer;
begin
  success = 0;
  relation_name = 'V_' || :ATABLENAME;
  softdel_field = 'SOFTDEL';
  sql_stmt = '';
  interfacelist = '';
  implementationlist = '';

  select Trim(columnlist) from SP_GET_COLUMNLIST(:ATABLENAME) into :columnlist;
  
  if (Trim(columnlist) <> '') then
  begin
    interfacelist = '(' || :columnlist || ')';
    implementationlist = :columnlist; 
  end
  else
  begin
    interfacelist = '';
    implementationlist = '*';   
  end  
  
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME=:relation_name)) then
  begin   
    if (exists(select 1 from RDB$RELATION_FIELDS where RDB$FIELD_NAME=:softdel_field and RDB$RELATION_NAME=:ATABLENAME)) then
    begin
      sql_stmt = 'create or alter view ' || :relation_name || :interfacelist || ' as select ' || :implementationlist || ' from ' || :ATABLENAME || ' where SOFTDEL=0';
    end
    else
    begin
      sql_stmt = 'create or alter view ' || :relation_name || :interfacelist || ' as select ' || :implementationlist || ' from ' || :ATABLENAME;
    end
  end
  else
  begin
    if (exists(select 1 from RDB$RELATION_FIELDS where RDB$FIELD_NAME=:softdel_field and RDB$RELATION_NAME=:ATABLENAME)) then
    begin
      sql_stmt = 'create or alter view ' || :relation_name || :interfacelist || ' as select ' || :implementationlist || ' from ' || :ATABLENAME || ' where SOFTDEL=0';
    end
    else
    begin
      sql_stmt = 'create or alter view ' || :relation_name || :interfacelist || ' as select ' || :implementationlist || ' from ' || :ATABLENAME;
    end
  end
  
  if (Trim(sql_stmt) = '') then
  begin
    success = 0;
    suspend;
    Exit;
  end
  
  if (AORDER_BY_PRIM = 1) then
  begin 
    select count_pk_fields, Trim(columnlist) from SP_GET_PRIMKEYLIST(:ATABLENAME) into :pk_columncount, pk_columnlist;
    
    if (pk_columncount > 0) then
      sql_stmt = sql_stmt || ' order by ' || :pk_columnlist;     
  end
    
  execute statement sql_stmt;
  
  if (AREGISTRER_SOURCE = 1) then
  begin
    if (not exists(select 1 from V_USERVIEW_SOURCES where CAPTION=:ATABLENAME)) then
      insert into V_USERVIEW_SOURCES(CAPTION, DESCRIPTION) VALUES (:ATABLENAME, :relation_name);
  end    
  
  sql_stmt = 'COMMENT ON VIEW ' || :relation_name || ' IS ''Userview für die Tabelle ' || :ATABLENAME || ' (created by SP_CREATE_USER_VIEW)''';

  execute statement sql_stmt;
  
  if (ADOGRANT_ZAB_ROLES = 1) then
  begin
    select success from SP_GRANT_ROLE_TO_OBJECT('R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'SELECT', :relation_name) into :success;
    select success from SP_GRANT_ROLE_TO_OBJECT('R_WEBCONNECT, R_ZABADMIN', 'UPDATE', :relation_name) into :success;
    select success from SP_GRANT_ROLE_TO_OBJECT('R_WEBCONNECT, R_ZABADMIN', 'INSERT', :relation_name) into :success;
    select success from SP_GRANT_ROLE_TO_OBJECT('R_ZABADMIN', 'DELETE', :relation_name) into :success;
  end
    
  success = 1; 
    
  suspend;
end^

COMMENT ON PROCEDURE SP_CREATE_USER_VIEW IS
'Erstellt eine Userview zu einem Tabellennamen'^

CREATE OR ALTER PROCEDURE SP_CREATE_ALL_USER_VIEWS(
  AORDER_BY_PRIM smallint = 1)
RETURNS (
  success smallint,
  tablename varchar(31),
  userview varchar(31))  
AS
begin
  for
  select
    TRIM(CAPTION),
    TRIM(DESCRIPTION)
  from
    V_USERVIEW_SOURCES
  into
    :tablename,
    :userview
  do
  begin
    select 
      success 
    from
      SP_CREATE_USER_VIEW(:tablename,
        0,
        1,
        :AORDER_BY_PRIM)
     into
       :success;
       
    suspend;   
  end     
end^

COMMENT ON PROCEDURE SP_CREATE_ALL_USER_VIEWS IS
'Erstellt alle registrierten Userviews'^

CREATE OR ALTER PROCEDURE SP_CREATE_SEQUNECE(
  ATABLENAME VARCHAR(32))
RETURNS (
  success smallint)    
AS
declare variable sql_stmt varchar(254);
declare variable relation_name varchar(32);
begin
  success = 0;
  relation_name = 'SEQ_' || :ATABLENAME || '_ID';
  
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME=:relation_name)) then
  begin   
    success = 0;
  end
  else
  begin
    sql_stmt = 'CREATE SEQUENCE ' || :relation_name;
    
    execute statement sql_stmt;
    
    sql_stmt = 'ALTER SEQUENCE ' || :relation_name || ' RESTART WITH 0';
  
    execute statement sql_stmt;
    
    sql_stmt = 'COMMENT ON SEQUENCE ' || :relation_name || ' IS ''Primärschlüssel für die Tabelle ' || :ATABLENAME || ' (created by SP_CREATE_SEQUNECE)''';
  
    execute statement sql_stmt;            
      
    success = 1;  
  end
    
  suspend;
end^

COMMENT ON PROCEDURE SP_CREATE_SEQUNECE IS
'Erstellt eine Sequence zu einem Tabellennamen'^

CREATE OR ALTER PROCEDURE SP_CREATE_TRIGGER_BI (
  ATABLENAME varchar(32),
  ADOSTAMP smallint DEFAULT 1)
returns (
  success smallint)
as
declare variable sql_stmt varchar(2000);
declare variable relation_name varchar(32);
declare variable sequence_name varchar(32);
begin
  success = 0;
  relation_name = :ATABLENAME || '_BI';
  sequence_name = 'SEQ_' || :ATABLENAME || '_ID';
  
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME=:relation_name)) then
  begin   
    success = 0;
  end
  else
  begin
    /* Die eigentümliche Formatierung des DDL-Codes sorgt für ein einfach lesbares Format des fertigen Triggercodes in der DB */
    if (ADOSTAMP = 1) then
    begin
      sql_stmt = 'CREATE TRIGGER ' || :relation_name || ' FOR ' || :ATABLENAME
                 || ' ACTIVE BEFORE INSERT POSITION 0
as
begin
  if (new.id is null) then
    new.id = next value for ' || :sequence_name || ';
  if (new.cre_user is null) then
    new.cre_user = user;
  if (new.cre_date is null) then
    new.cre_date = current_timestamp;
end ';
    end
    else
    begin
      sql_stmt = 'CREATE TRIGGER ' || :relation_name || ' FOR ' || :ATABLENAME
                 || ' ACTIVE BEFORE INSERT POSITION 0
as
begin
  if (new.id is null) then
    new.id = next value for ' || :sequence_name || ';
end ';    
    end
    
    execute statement sql_stmt;
       
    sql_stmt = 'COMMENT ON TRIGGER ' || :relation_name || ' IS ''Before-Insert-Trigger für die Tabelle ' || :ATABLENAME || ' (created by SP_CREATE_TRIGGER_BI)''';
    execute statement sql_stmt;
      
    success = 1;  
  end
    
  suspend;
end^    

COMMENT ON PROCEDURE SP_CREATE_TRIGGER_BI IS
'Erstellt einen Before-Insert-Trigger zu einem Tabellennamen'^

CREATE OR ALTER PROCEDURE SP_CREATE_TRIGGER_BU (
  ATABLENAME varchar(32))
returns (
  success smallint)
as
declare variable sql_stmt varchar(2000);
declare variable relation_name varchar(32);
begin
  success = 0;
  relation_name = :ATABLENAME || '_BU';
  
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME=:relation_name)) then
  begin   
    success = 0;
  end
  else
  begin
    /* Die eigentümliche Formatierung des DDL-Codes sorgt für ein einfach lesbares Format des fertigen Triggercodes in der DB */
    sql_stmt = 'CREATE TRIGGER ' || :relation_name || ' FOR ' || :ATABLENAME
               || ' ACTIVE BEFORE UPDATE POSITION 0
as
begin
  new.chg_user = user;
  new.chg_date = current_timestamp;
end ';
    execute statement sql_stmt;
       
    sql_stmt = 'COMMENT ON TRIGGER ' || :relation_name || ' IS ''Before-Update-Trigger für die Tabelle ' || :ATABLENAME || ' (created by SP_CREATE_TRIGGER_BU)''';
    execute statement sql_stmt;
      
    success = 1;  
  end
    
  suspend;
end^    

COMMENT ON PROCEDURE SP_CREATE_TRIGGER_BU IS
'Erstellt einen Before-Update-Trigger zu einem Tabellennamen'^

CREATE OR ALTER PROCEDURE SP_CREATE_TRIGGER_BD (
  ATABLENAME varchar(32),
  ADONOTDELETE_FIELD varchar(32))
returns (
  success smallint)
as
declare variable sql_stmt varchar(2000);
declare variable relation_name varchar(32);
begin
  success = 0;
  relation_name = :ATABLENAME || '_BD';
    
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME=:relation_name)) then
  begin   
    success = 0;
  end
  else
  begin
    if (exists(select 1 from RDB$RELATION_FIELDS where RDB$FIELD_NAME=:ADONOTDELETE_FIELD and RDB$RELATION_NAME=:ATABLENAME)) then
    begin  
      /* Die eigentümliche Formatierung des DDL-Codes sorgt für ein einfach lesbares Format des fertigen Triggercodes in der DB */
      sql_stmt = 'CREATE TRIGGER ' || :relation_name || ' FOR ' || :ATABLENAME
                 || ' ACTIVE BEFORE DELETE POSITION 0
as
begin
  if (old.' || ADONOTDELETE_FIELD || '=1) then
  begin
    EXCEPTION DELETE_NOT_ALLOWED;
  end
end ';
      execute statement sql_stmt;
       
      sql_stmt = 'COMMENT ON TRIGGER ' || :relation_name || ' IS ''Before-Delete-Trigger für die Tabelle ' || :ATABLENAME || ' (created by SP_CREATE_TRIGGER_BD)''';
      execute statement sql_stmt;
      
      success = 1;
    end
    else
    begin
      success = 0;
    end  
  end
    
  suspend;
end^    

COMMENT ON PROCEDURE SP_CREATE_TRIGGER_BD IS
'Erstellt einen Before-Delete-Trigger zu einem Tabellennamen'^

CREATE OR ALTER PROCEDURE SP_CAPITALIZE (
  ASTRING varchar(2000),
  AINDEX integer,
  ADOLOWER smallint DEFAULT NULL)
returns (
  result varchar(2000)  
)
as
declare variable dummy varchar(2000);
declare variable replace_dummy varchar(2000);
declare variable idx integer;
begin
  dummy = ASTRING;
  
  if (ADOLOWER = 1) then  
  begin
    dummy = Lower(dummy);
  end  
  
  if (AINDEX = 0) then
  begin
    idx = 1;
  end
  else
  begin
    idx = AINDEX;
  end
    
  replace_dummy = Upper(substring(:dummy from idx for 1));
  dummy = overlay(:dummy placing :replace_dummy from idx for 1);
  
  result = dummy;
  
  suspend;
end^

COMMENT ON PROCEDURE SP_CAPITALIZE IS
'Zeichen im String Groß schreiben'^

CREATE OR ALTER PROCEDURE SP_SET_ENTITYNAME (
  AREPLACESTRING varchar(32),
  ASTRING varchar(32),
  ADOUPPER smallint,
  ADUMMY varchar(32) DEFAULT NULL)
returns (
  property varchar(32))
as
declare variable format_string varchar(32);
declare variable sub_string varchar(32);
declare variable replace_string varchar(32);
declare variable is_ready smallint;
declare variable idx integer;
declare variable dummy varchar(32);
begin
  format_string = Lower(Trim(ASTRING));
  sub_string = AREPLACESTRING;
  idx = 0;
  is_ready = 0;
  
  if (ADUMMY is not null) then
  begin
    dummy = ADUMMY;
  end
  else
  begin
    dummy = ' ';
  end
  
  if (dummy = AREPLACESTRING) then
  begin
    property = format_string;
    suspend;
    Exit;
  end 
  
  while (is_ready = 0) do
  begin
    idx = position(:sub_string in :format_string);
    if (idx > 0) then
    begin
      is_ready = 0;
      /* replace_string = ' ' || Upper(substring(:format_string from idx+1 for 1)); */
      if (ADOUPPER = 1) then
      begin
        replace_string = Upper(substring(:format_string from idx+1 for 1));
      end
      else
      begin
        replace_string = substring(:format_string from idx+1 for 1);
      end
      
      format_string = overlay(:format_string placing :replace_string from idx for 2);
    end
    else
    begin
      is_ready = 1;
    end
  end

  /*format_string = replace(:format_string, ' ', '');*/

  property = format_string;
  
  suspend;
end^

COMMENT ON PROCEDURE SP_SET_ENTITYNAME IS
'Feldnamen anpassen'^ 

CREATE OR ALTER PROCEDURE SP_METADATA_TO_JAVA(
  ATABLENAME varchar(32),
  AIS_VIEW smallint,
  AINSTALL_USER varchar(32),
  AFLAG varchar(32),
  APACKAGE varchar(254) DEFAULT 'com.zabonlinedb.data',
  ADBNAME varchar(254) DEFAULT 'ZABonline [WaveMaker]',
  ADBVERSION varchar(64) DEFAULT '000.000.00000')
returns (
  sourcecode varchar(2000))
as
declare variable original_field_name varchar(31);
declare variable field_name varchar(31);
declare variable field_source varchar(31);
declare variable field_length smallint;
declare variable field_scale smallint;
declare variable field_type smallint;
declare variable date_found smallint;
declare variable class_name varchar(2000);
declare variable package_name varchar(254);
declare variable db_name varchar(254);
declare variable db_version varchar(64);
declare variable method_name varchar(254);
declare variable indent_str varchar(254);
begin
  /*
   *
   *   
  OUTPUT 'C:\Users\Alfred\Sourcen\datasheet.java';
  select Trim(sourcecode) from SP_METADATA_TO_JAVA('DATASHEET', 0, 'INSTALLER', 'BEGIN', 'com.zabonlinedb.data', 'ZABonline [WaveMaker]', '000.000.00000');
  select Trim(sourcecode) from SP_METADATA_TO_JAVA('DATASHEET', 0, 'INSTALLER', 'PROPERTY', null,null, null);
  select Trim(sourcecode) from SP_METADATA_TO_JAVA('DATASHEET', 0, 'INSTALLER', 'METHOD', null,null, null);
  select Trim(sourcecode) from SP_METADATA_TO_JAVA('DATASHEET', 0, 'INSTALLER', 'END', null,null, null);
  OUTPUT;
   *
   *
   */

  sourcecode = '';
  date_found = 0;
  class_name = ATABLENAME;
  indent_str = '  ';    
  package_name = APACKAGE;
  db_name = ADBNAME;
  db_version = ADBVERSION;
    
  if (exists(select 1 from RDB$RELATIONS where UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME) and UPPER(RDB$OWNER_NAME)=UPPER(:AINSTALL_USER))) then
  begin
    if (AFLAG = 'END') then
    begin      
      sourcecode = '}';
      suspend;
      Exit;
    end
    
    if (AFLAG = 'BEGIN') then
    begin    
      sourcecode = 'package ' || package_name || ';';      
      suspend;
      sourcecode = '';
      suspend;      
    end
    
    for 
      select 
        RDB$FIELD_NAME,
        RDB$FIELD_SOURCE 
      from 
        RDB$RELATION_FIELDS 
      where 
        UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME) 
      into 
        :original_field_name,
        :field_source 
    do
    begin
      for 
        select
          RDB$FIELD_LENGTH,
          RDB$FIELD_SCALE,
          RDB$FIELD_TYPE   
        from
          RDB$FIELDS
        where
          (UPPER(RDB$FIELD_NAME) = UPPER(:field_source))        
        into
          :field_length,
          :field_scale,
          :field_type
      do
      begin
        /*
         *
         *         
        Datatype: BLOB - Fieldtype: 261
        Datatype: CHAR - Fieldtype: 14
        Datatype: CSTRING - Fieldtype: 40
        Datatype: D_FLOAT - Fieldtype: 11
        Datatype: DOUBLE - Fieldtype: 27
        Datatype: FLOAT - Fieldtype: 10
        Datatype: INT64 - Fieldtype: 16
        Datatype: INTEGER - Fieldtype: 8
        Datatype: QUAD - Fieldtype: 9
        Datatype: SMALLINT - Fieldtype: 7
        Datatype: DATE - Fieldtype: 12
        Datatype: TIME - Fieldtype: 13
        Datatype: TIMESTAMP - Fieldtype: 35
        Datatype: VARCHAR - Fieldtype: 37
        *
        *        
        */
              
        original_field_name = trim(original_field_name);
        select property from SP_SET_ENTITYNAME('_', :original_field_name, 1, null) into :field_name;
        select result from SP_CAPITALIZE(:field_name, 1, 0) into :method_name;          
        
        if (AFLAG = 'BEGIN') then
        begin
          if (field_type in (12, 13, 35)) then
          begin
            if (date_found = 0) then
            begin
              date_found = 1;
              sourcecode = 'import java.util.Date;';
              suspend;
            end
          end       
        end        
              
        if (AFLAG = 'PROPERTY') then
        begin
          if (field_type in (14, 37, 40, 261)) then
          begin
            sourcecode = indent_str || 'private String ' || field_name || ';';
            suspend;
          end         
          
          if (field_type in (11, 27)) then
          begin
            sourcecode = indent_str || 'private Double ' || field_name || ';';
            suspend;
          end          
          
          if (field_type = 10) then
          begin
            sourcecode = indent_str || 'private Float ' || field_name || ';';
            suspend;
          end          

          if (field_type = 16) then
          begin
            sourcecode = indent_str || 'private Long ' || field_name || ';';
            suspend;
          end

          if (field_type = 8) then
          begin
            sourcecode = indent_str || 'private Integer ' || field_name || ';';
            suspend;
          end          

          if (field_type = 9) then
          begin
            sourcecode = '//Unbekannter Feldtype: QUAD - Fieldtype: 9 -> ' || field_name || ';';
            suspend;
          end          
          
          if (field_type = 7) then
          begin
            sourcecode = indent_str || 'private Short ' || field_name || ';';
            suspend;
          end          
          
          if (field_type in (12, 13, 35)) then
          begin
            sourcecode = indent_str || 'private Date ' || field_name || ';';
            suspend;
          end                                                   
        end

        if (AFLAG = 'METHOD') then
        begin
          if (field_type in (14, 37, 40, 261)) then
          begin
            sourcecode = indent_str || 'public String get' || method_name || '(String '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_str || 'public void set' || method_name || '(String '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;               
          end
                   
          if (field_type in (11, 27)) then
          begin
            sourcecode = indent_str || 'public Double get' || method_name || '(Double '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_str || 'public void set' || method_name || '(Double '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;            
          end          
          
          if (field_type = 10) then
          begin
            sourcecode = indent_str || 'public Float get' || method_name || '(Float '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_str || 'public void set' || method_name || '(Float '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;            
          end          

          if (field_type = 16) then
          begin
            sourcecode = indent_str || 'public Long get' || method_name || '(Long '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_str || 'public void set' || method_name || '(Long '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;            
          end

          if (field_type = 8) then
          begin
            sourcecode = indent_str || 'public Integer get' || method_name || '(Integer '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_str || 'public void set' || method_name || '(Integer '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;            
          end          

          if (field_type = 9) then
          begin
            sourcecode = '//Unbekannter Feldtype: QUAD - Fieldtype: 9 -> ' || field_name || ';';
            suspend;
          end          
          
          if (field_type = 7) then
          begin
            sourcecode = indent_str || 'public Short get' || method_name || '(Short '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_str || 'public void set' || method_name || '(Short '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;            
          end          
          
          if (field_type in (12, 13, 35)) then
          begin
            sourcecode = indent_str || 'public Date get' || method_name || '(Date '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'return ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;
            sourcecode = indent_str || 'public void set' || method_name || '(Date '|| field_name ||') {';
            suspend;
            sourcecode = indent_str || indent_str || 'this.' || field_name || ' = ' || field_name || ';';
            suspend;
            sourcecode = indent_str || '}';
            suspend;         
            sourcecode = '';
            suspend;            
          end                            
        end        
      end     
    end
    
    if (AFLAG = 'PROPERTY') then
    begin
      sourcecode = '';
      suspend;
      Exit;
    end  
    
    if (AFLAG = 'BEGIN') then
    begin
      select property from SP_SET_ENTITYNAME('_', :ATABLENAME, 1, null) into :class_name;
      select result from SP_CAPITALIZE(:class_name, 1, 0) into :class_name;
      
      sourcecode = '/**';
      suspend;
      sourcecode = ' * ';
      suspend;          
      sourcecode = ' *  Erstellt: via SP_METADATA_TO_JAVA - Datenbank: ' || db_name || ' - Version: ' || db_version;
      suspend;
      sourcecode = ' *  Erstellt am: ' || current_timestamp;
      suspend;       
      sourcecode = ' *  Entität: ' || class_name;
      suspend;
      sourcecode = ' * ';
      suspend;
      sourcecode = ' */';    
      suspend;
      sourcecode = 'public class ' || class_name || ' {';
      suspend;
      sourcecode = '';
      suspend;
      Exit;
    end    
  end            
end^

COMMENT ON PROCEDURE SP_METADATA_TO_JAVA IS
'Erstellt Entitäten (Java-Sourcecode) für eine Hibernateschnittstelle'^

CREATE OR ALTER PROCEDURE SP_METADATA_TO_XML(
  ATABLENAME varchar(32),
  AIS_VIEW smallint,
  ATABLE_AS_VIEW smallint,
  AINSTALL_USER varchar(32),
  AFLAG varchar(32),
  APACKAGE varchar(254) DEFAULT 'com.zabonlinedb.data',
  ADBNAME varchar(254) DEFAULT 'ZABonline [WaveMaker]',
  ADBVERSION varchar(64) DEFAULT '000.000.00000',
  AHIBERNATEURI varchar(254) DEFAULT '-//Hibernate/Hibernate Mapping DTD 3.0//EN',
  AHIBERNATEMAPDTD varchar(254) DEFAULT 'http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd',
  AIDNAME varchar(264) DEFAULT 'id',
  AGENERATORCLASS varchar(64) DEFAULT 'assigned') 
returns (
  sourcecode varchar(2000))
as
declare variable original_field_name varchar(31);
declare variable field_name varchar(31);
declare variable field_source varchar(31);
declare variable field_length smallint;
declare variable field_scale smallint;
declare variable field_type smallint;                                       
declare variable class_name varchar(2000);
declare variable package_name varchar(254);
declare variable db_name varchar(254);
declare variable db_version varchar(64);
declare variable method_name varchar(254);
declare variable indent_str varchar(254);
declare variable hibernate_uri varchar(254);
declare variable hibernate_map_dtd varchar(254);
declare variable db_source varchar(32);
declare variable pk_index_name varchar(32);
declare variable count_pk_fields integer;
declare variable data_type varchar(64);
declare variable null_flag smallint;
declare variable property_items varchar(64);
declare variable pk_contraint_name varchar(32);
declare variable is_pk smallint;
begin
  /*
   *
   *   
  OUTPUT 'C:\Users\Alfred\Sourcen\datasheet.hbm.xml';
  select Trim(sourcecode) from SP_METADATA_TO_XML('DATASHEET', 0, 1, 'INSTALLER', 'BEGIN', 'com.zabonlinedb.data', 'ZABonline [WaveMaker]', '000.000.00000', '-//Hibernate/Hibernate Mapping DTD 3.0//EN', 'http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd');
  select Trim(sourcecode) from SP_METADATA_TO_XML('DATASHEET', 0, 1, 'INSTALLER', 'PK_PROPERTY');
  select Trim(sourcecode) from SP_METADATA_TO_XML('DATASHEET', 0, 1, 'INSTALLER', 'PROPERTY');
  select Trim(sourcecode) from SP_METADATA_TO_XML('DATASHEET', 0, 1, 'INSTALLER', 'END');
  OUTPUT;
   *
   *
   */
  sourcecode = '';
  class_name = ATABLENAME;
  indent_str = '  ';    
  
  package_name = APACKAGE;
  db_name = ADBNAME;
  db_version = ADBVERSION;
  hibernate_uri = AHIBERNATEURI;
  hibernate_map_dtd = AHIBERNATEMAPDTD;
  
  if (ATABLE_AS_VIEW = 1) then
  begin
    db_source = 'V_' || UPPER(ATABLENAME);
  end
  else
  begin
    db_source = UPPER(ATABLENAME);
  end
   
  if (exists(select 1 from RDB$RELATIONS where UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME) and UPPER(RDB$OWNER_NAME)=UPPER(:AINSTALL_USER))) then
  begin
    if (AFLAG = 'END') then
    begin     
      sourcecode= indent_str || '</class>';
      suspend;
      sourcecode = '</hibernate-mapping>';
      suspend;
      Exit;
    end  
  
    if (AFLAG = 'BEGIN') then
    begin
      select property from SP_SET_ENTITYNAME('_', :ATABLENAME, 1, null) into :class_name;   
      select result from SP_CAPITALIZE(:class_name, 1, 0) into :class_name;

      sourcecode = '<!-- Erstellt: via SP_METADATA_TO_XML - Datenbank: ' || db_name || ' - Version: ' || db_version || ' -->';
      suspend;
      sourcecode = '<!-- Erstellt am: ' || current_timestamp || ' -->';
      suspend;       
      sourcecode = '<!-- Entität: ' || class_name || ' -->';
      suspend;
      sourcecode = '<!DOCTYPE hibernate-mapping PUBLIC "' || hibernate_uri || '" "' || hibernate_map_dtd ||'">';
      suspend;
      sourcecode = '<hibernate-mapping>';
      suspend;
      sourcecode= indent_str || '<class name="'|| package_name || '.' || class_name ||'" table="' || db_source ||'" dynamic-insert="false" dynamic-update="false">';
      suspend;
      Exit;
    end  
        
    select
      RDB$CONSTRAINT_NAME,
      RDB$INDEX_NAME
    from
      RDB$RELATION_CONSTRAINTS
    where
      RDB$RELATION_NAME = :ATABLENAME
      and
      RDB$CONSTRAINT_TYPE = 'PRIMARY KEY'
    into
      :pk_contraint_name,
      :pk_index_name;    
  
    select count(RDB$FIELD_NAME) from RDB$INDEX_SEGMENTS where UPPER(RDB$INDEX_NAME)=UPPER(:pk_index_name) into :count_pk_fields;
    
    if (AFLAG = 'PK_PROPERTY') then
    begin
      if ((count_pk_fields = 0) or (count_pk_fields is null)) then
      begin
        sourcecode = '<!-- Warning: NO PRIMARY KEY PRESENT -->';
        suspend;
        Exit;        
      end
      else
      begin
        if (count_pk_fields > 1) then
        begin
          sourcecode = indent_str || indent_str || '<composite-id name="' || AIDNAME || '" class="' || package_name || '.' || class_name ||'">';
          suspend;
        end
      end
    end
          
    for 
      select 
        RDB$FIELD_NAME,
        RDB$FIELD_SOURCE,
        RDB$NULL_FLAG 
      from 
        RDB$RELATION_FIELDS 
      where 
        UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME) 
      into 
        :original_field_name,
        :field_source,
        :null_flag 
    do
    begin
      for 
        select
          RDB$FIELD_LENGTH,
          RDB$FIELD_SCALE,
          RDB$FIELD_TYPE   
        from
          RDB$FIELDS
        where
          (UPPER(RDB$FIELD_NAME) = UPPER(:field_source))        
        into
          :field_length,
          :field_scale,
          :field_type
      do
      begin 
        /*
         *
         *         
        Datatype: BLOB - Fieldtype: 261
        Datatype: CHAR - Fieldtype: 14
        Datatype: CSTRING - Fieldtype: 40
        Datatype: D_FLOAT - Fieldtype: 11
        Datatype: DOUBLE - Fieldtype: 27
        Datatype: FLOAT - Fieldtype: 10
        Datatype: INT64 - Fieldtype: 16
        Datatype: INTEGER - Fieldtype: 8
        Datatype: QUAD - Fieldtype: 9
        Datatype: SMALLINT - Fieldtype: 7
        Datatype: DATE - Fieldtype: 12
        Datatype: TIME - Fieldtype: 13
        Datatype: TIMESTAMP - Fieldtype: 35
        Datatype: VARCHAR - Fieldtype: 37
        *
        *        
        */
        property_items = '';
        original_field_name = trim(original_field_name);
        select property from SP_SET_ENTITYNAME('_', :original_field_name, 1, null) into :field_name;
        select result from SP_CAPITALIZE(:field_name, 1, 0) into :method_name;                                 
                  
        if (field_type in (14, 37, 40, 261)) then
        begin
          data_type = 'string';          
          property_items = ' length="' || field_length || '"';
        end
                 
        if (field_type in (11, 27)) then
        begin
          data_type = 'double';            
          property_items = ' length="' || field_length || '"';
        end          
        
        if (field_type = 10) then
        begin
          data_type = 'float';            
          property_items = ' length="' || field_length || '"';
        end          

        if (field_type = 16) then
        begin
          data_type = 'long';            
        end

        if (field_type = 8) then
        begin
          data_type = 'integer';            
        end          

        if (field_type = 9) then
        begin
          break;            
        end          
        
        if (field_type = 7) then
        begin
          data_type = 'short';            
        end          
        
        if (field_type in (12, 13, 35)) then
        begin
          data_type = 'date';            
          property_items = ' length="' || field_length || '"';
        end
        
        if (null_flag = 1) then
        begin
          property_items = property_items || ' not-null="true"';
        end
                                 
        if (AFLAG = 'PK_PROPERTY') then
        begin
          if (exists(select 1 from RDB$INDEX_SEGMENTS where UPPER(RDB$INDEX_NAME)=UPPER(:pk_index_name) and UPPER(RDB$FIELD_NAME)=UPPER(:original_field_name))) then
          begin          
            if (count_pk_fields > 1) then
            begin
              sourcecode = indent_str || indent_str || indent_str || '<key-property name="' || field_name || '" type="' || data_type || '">';
              suspend;
              sourcecode = indent_str || indent_str || indent_str || indent_str || '<column name="' || original_field_name || '"/>';
              suspend;
              sourcecode = indent_str || indent_str || indent_str || '</key-property>';
              suspend;
            end
            else
            begin
              if (count_pk_fields = 1) then
              begin
                sourcecode = indent_str || indent_str || indent_str || '<' || AIDNAME || ' name="' || field_name || '" type="' || data_type || '">';
                suspend;
                sourcecode = indent_str || indent_str || indent_str || indent_str || '<column name="' || original_field_name || '"/>';
                suspend;
                sourcecode = indent_str || indent_str || indent_str || indent_str || '<generator class="' || AGENERATORCLASS || '"/>';
                suspend;
                sourcecode = indent_str || indent_str || indent_str || '</' || AIDNAME || '>';
                suspend;
              end 
              else
              begin
                Exit;
              end           
            end
          end        
        end
        
        if (AFLAG = 'PROPERTY') then
        begin
          if (not exists(select 1 from RDB$INDEX_SEGMENTS where UPPER(RDB$INDEX_NAME)=UPPER(:pk_index_name) and UPPER(RDB$FIELD_NAME)=UPPER(:original_field_name))) then
          begin          
            sourcecode = indent_str || indent_str || indent_str || '<property name="' || field_name || '" type="' || data_type || '">';
            suspend;
            if (property_items = '') then
            begin
              sourcecode = indent_str || indent_str || indent_str || indent_str || '<column name="' || original_field_name || '"/>';
            end
            else
            begin
              sourcecode = indent_str || indent_str || indent_str || indent_str || '<column name="' || original_field_name || '"'|| property_items ||'/>';
            end  
            suspend;
            sourcecode = indent_str || indent_str || indent_str || '</property>';
            suspend;       
          end
        end
      end
    end
    
    if (AFLAG = 'PK_PROPERTY') then
    begin
      if (count_pk_fields > 1) then
      begin
        sourcecode = indent_str || indent_str || '</composite-id>';
        suspend;
      end
    end      
  end
end^

COMMENT ON PROCEDURE SP_METADATA_TO_XML IS
'Erstellt Entitäten (XML-Mapfile) für eine Hibernateschnittstelle'^ 

CREATE OR ALTER PROCEDURE SP_METADATA_FOR_CHECKLIST(
  ATABLENAME varchar(32),
  AIS_VIEW smallint,
  ATABLE_AS_VIEW smallint,
  AINSTALL_USER varchar(32),
  AFLAG varchar(32),
  APACKAGE varchar(254) DEFAULT 'com.zabonlinedb.data',
  ADBNAME varchar(254) DEFAULT 'ZABonline [WaveMaker]',
  ADBVERSION varchar(64) DEFAULT '000.000.00000',
  APROJECTDIR varchar(254) DEFAULT '\trunk\WaveMaker 6.4.5GA\projects\ZABonline\',
  AWMVERSION varchar(10) DEFAULT '6.5.2',
  ADBSERVICE varchar(64) DEFAULT 'ZABonlineDB')
returns(
  sourcecode varchar(2000))
as
declare variable original_field_name varchar(31);
declare variable field_name varchar(31);
declare variable field_source varchar(31);
declare variable field_length smallint;
declare variable field_scale smallint;
declare variable field_type smallint;
declare variable class_name varchar(2000);
declare variable package_name varchar(254);
declare variable db_name varchar(254);
declare variable db_version varchar(64);
declare variable method_name varchar(254);
declare variable indent_str varchar(254);
declare variable db_source varchar(32);
declare variable pk_index_name varchar(32);
declare variable count_pk_fields integer;
declare variable data_type varchar(64);
declare variable null_flag smallint;
declare variable property_items varchar(64);
declare variable pk_contraint_name varchar(32);
begin
  /*
   *
   *   
  OUTPUT 'C:\Users\Alfred\Sourcen\datasheet.checklist.txt';
  select Trim(sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'BEGIN', 'com.zabonlinedb.data', 'ZABonline [WaveMaker]', '000.000.00000', '\trunk\WaveMaker 6.4.5GA\projects\ZABonline\', '6.5.2');
  select Trim(sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'SERVICEDEF');
  select Trim(sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'DBSERVICE.SPRING');
  select Trim(sourcecode) from SSP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'PROJECT-MANAGERS');
  select Trim(sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'TYPES');
  select Trim(sourcecode) from SP_METADATA_FOR_CHECKLIST('DATASHEET', 0, 1, 'INSTALLER', 'ENTITY');
  OUTPUT;
   *
   *
   */
                       
  sourcecode = '';
  class_name = ATABLENAME;
  indent_str = '  ';    
  
  package_name = APACKAGE;
  db_name = ADBNAME;
  db_version = ADBVERSION;
  
  if (ATABLE_AS_VIEW = 1) then
  begin
    db_source = 'V_' || UPPER(ATABLENAME);
  end
  else
  begin
    db_source = UPPER(ATABLENAME);
  end
   
  if (exists(select 1 from RDB$RELATIONS where UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME) and UPPER(RDB$OWNER_NAME)=UPPER(:AINSTALL_USER))) then
  begin
    /* alles was zum Anfang gemacht werden soll */
    select property from SP_SET_ENTITYNAME('_', :ATABLENAME, 1, null) into :class_name;   
    select result from SP_CAPITALIZE(:class_name, 1, 0) into :class_name;    
    
    if (AFLAG = 'BEGIN') then
    begin
      sourcecode = 'Checkliste zum Einbinden der Entität in Wavemaker (' || AWMVERSION || ')';
      suspend;
      sourcecode = '===========================================================';
      suspend;      
      sourcecode = 'Erstellt: via SP_METADATA_FOR_CHECKLIST - Datenbank: ' || db_name || ' - Version: ' || db_version;
      suspend;
      sourcecode = 'Ersttellt am: ' || current_timestamp;
      suspend;       
      sourcecode = 'Entität: ' || class_name;
      suspend;
      sourcecode = 'Datenbankservice: ' || ADBSERVICE;
      suspend;
      sourcecode = '';
      suspend;
      sourcecode = '';
      suspend;      
      Exit;
    end     
    
    if (AFLAG = 'ENTITY') then
    begin
      sourcecode = 'Datei: ' || class_name || '.java';
      suspend;
      sourcecode = 'Datei: ' || class_name || '.hbm.xml';
      suspend;    
      if (AWMVERSION = '6.5.2') then
      begin               
        sourcecode = 'Ordner: ' || APROJECTDIR || '\services\' || ADBSERVICE || '\src\' || replace(package_name, '.', '\');
        suspend;
        sourcecode = '';
        suspend;
        sourcecode = indent_str || 'Die beiden Dateien werden in den oben genannten Ordern kopiert.';
        suspend;
        sourcecode = '';        
        suspend;
        sourcecode = '';
        suspend;                   
      end 
      else
      begin
        sourcecode = 'Wichtig: Unbekannte Wavemaker Version (' || AWMVERSION || ')';
        suspend;              
      end          
      Exit;        
    end
    
    if (AFLAG = 'TYPES') then
    begin
      sourcecode = 'Datei: types.js';
      suspend;
      if (AWMVERSION = '6.5.2') then
      begin      
        sourcecode = 'Ordner: ' || APROJECTDIR || '\webapproot\';
        suspend;
        sourcecode = '';
        suspend;
        sourcecode = indent_str || 'Nach dem Einbinden der Dateien, Wavemaker starten und die Datenbankschnittstelle (' || ADBSERVICE || ') sichern (eventuell kleine Änderung vornehmen).';
        suspend;
        sourcecode = indent_str || 'Das Sichern der Datenbankschnittstelle (' || ADBSERVICE || ') wird die notwendigen Daten in die Datei: types.js einfügen.';
        suspend;
        sourcecode = '';        
        suspend;
        sourcecode = '';
        suspend;        
      end 
      else
      begin
        sourcecode = 'Wichtig: Unbekannte Wavemaker Version (' || AWMVERSION || ')';
        suspend;              
      end          
      Exit;    
    end
    
    if (AFLAG = 'SERVICEDEF') then
    begin
      sourcecode = 'Datei: servicedef.xml';
      suspend;
      if (AWMVERSION = '6.5.2') then
      begin
        sourcecode = 'Ordner: ' || APROJECTDIR || '\services\' || ADBSERVICE || '\designtime\';
        suspend;
        sourcecode = '';
        suspend;        
        sourcecode = indent_str || '<dataobjects>';
        suspend;        
        sourcecode = indent_str || indent_str || '<dataobject javaType="' || package_name || '.' || class_name || '" supportsQuickData="true">';
        suspend;                
      end
      else
      begin
        sourcecode = 'Wichtig: Unbekannte Wavemaker Version (' || AWMVERSION || ')';
        suspend;
        Exit;              
      end      
    end
  
    if (AFLAG = 'DBSERVICE.SPRING') then
    begin
      sourcecode = 'Datei: ' || ADBSERVICE || '.spring.xml';
      suspend;
      if (AWMVERSION = '6.5.2') then
      begin      
        sourcecode = 'Ordner: ' || APROJECTDIR || '\services\' || ADBSERVICE || '\src\';
        suspend;
        sourcecode = '';
        suspend;
        sourcecode = indent_str || '<property name="mappingResources">';
        suspend;
        sourcecode = indent_str || indent_str || '<list>';
        suspend;
        sourcecode = indent_str || indent_str || indent_str || '<value>' || replace(package_name, '.', '/') || '/' || class_name || '.hbm.xml</value>';
        suspend;
        sourcecode = '';        
        suspend;
        sourcecode = '';
        suspend;        
      end 
      else
      begin
        sourcecode = 'Wichtig: Unbekannte Wavemaker Version (' || AWMVERSION || ')';
        suspend;              
      end          
      Exit;
    end
    
    if (AFLAG = 'PROJECT-MANAGERS') then
    begin
      sourcecode = 'Datei: project-managers.xml';
      suspend;
      if (AWMVERSION = '6.5.2') then
      begin      
        sourcecode = 'Ordner: ' || APROJECTDIR || '\webapproot\WEB-INF\';
        suspend;        
        sourcecode = '';
        suspend;        
        sourcecode = indent_str || '<entry key="' || ADBSERVICE || '">';
        suspend;        
        sourcecode = indent_str || indent_str || '<list>';
        suspend;        
        sourcecode = indent_str || indent_str || indent_str || '<value>' || package_name || '.' || class_name || '</value>';
        suspend;
        sourcecode = '';        
        suspend;
        sourcecode = '';
        suspend;        
      end
      else
      begin
        sourcecode = 'Wichtig: Unbekannte Wavemaker Version (' || AWMVERSION || ')';
        suspend;              
      end            
      Exit;
    end
    
    select
      RDB$CONSTRAINT_NAME,
      RDB$INDEX_NAME
    from
      RDB$RELATION_CONSTRAINTS
    where
      RDB$RELATION_NAME = :ATABLENAME
      and
      RDB$CONSTRAINT_TYPE = 'PRIMARY KEY'
    into
      :pk_contraint_name,
      :pk_index_name;    
  
    select count(RDB$FIELD_NAME) from RDB$INDEX_SEGMENTS where UPPER(RDB$INDEX_NAME)=UPPER(:pk_index_name) into :count_pk_fields;
    
    for 
      select 
        RDB$FIELD_NAME,
        RDB$FIELD_SOURCE,
        RDB$NULL_FLAG 
      from 
        RDB$RELATION_FIELDS 
      where 
        UPPER(RDB$RELATION_NAME)=UPPER(:ATABLENAME) 
      into 
        :original_field_name,
        :field_source,
        :null_flag 
    do
    begin
      for 
        select
          RDB$FIELD_LENGTH,
          RDB$FIELD_SCALE,
          RDB$FIELD_TYPE   
        from
          RDB$FIELDS
        where
          (UPPER(RDB$FIELD_NAME) = UPPER(:field_source))        
        into
          :field_length,
          :field_scale,
          :field_type
      do
      begin
        /* alles was pro Feld gemacht werden soll */
        /*
         *
         *         
        Datatype: BLOB - Fieldtype: 261
        Datatype: CHAR - Fieldtype: 14
        Datatype: CSTRING - Fieldtype: 40
        Datatype: D_FLOAT - Fieldtype: 11
        Datatype: DOUBLE - Fieldtype: 27
        Datatype: FLOAT - Fieldtype: 10
        Datatype: INT64 - Fieldtype: 16
        Datatype: INTEGER - Fieldtype: 8
        Datatype: QUAD - Fieldtype: 9
        Datatype: SMALLINT - Fieldtype: 7
        Datatype: DATE - Fieldtype: 12
        Datatype: TIME - Fieldtype: 13
        Datatype: TIMESTAMP - Fieldtype: 35
        Datatype: VARCHAR - Fieldtype: 37
        *
        *        
        */
        property_items = '';
        original_field_name = trim(original_field_name);
        select property from SP_SET_ENTITYNAME('_', :original_field_name, 1, null) into :field_name;
        select result from SP_CAPITALIZE(:field_name, 1, 0) into :method_name;                                 
                  
        if (field_type in (14, 37, 40, 261)) then
        begin
          data_type = 'string';          
          property_items = ' typeRef="java.lang.String" isList="false"';
        end
                 
        if (field_type in (11, 27)) then
        begin
          data_type = 'double';            
          property_items = ' typeRef="java.lang.Double" isList="false"';
        end          
        
        if (field_type = 10) then
        begin
          data_type = 'float';            
          property_items = ' typeRef="java.lang.Float" isList="false"';
        end          

        if (field_type = 16) then
        begin
          data_type = 'long';            
          property_items = ' typeRef="java.lang.Long" isList="false"';
        end

        if (field_type = 8) then
        begin
          data_type = 'integer';            
          property_items = ' typeRef="java.lang.Integer" isList="false"';
        end          

        if (field_type = 9) then
        begin
          break;            
        end          
        
        if (field_type = 7) then
        begin
          data_type = 'short';            
          property_items = ' typeRef="java.lang.Short" isList="false"';
        end          
        
        if (field_type in (12, 13, 35)) then
        begin
          data_type = 'date';            
          property_items = ' typeRef="java.util.Date" isList="false"';
        end
        
        if (null_flag = 1) then
        begin
          property_items = property_items || ' allowNull="false"';
        end
        else        
        begin
          property_items = property_items || ' allowNull="true"';
        end

        if (AFLAG = 'SERVICEDEF') then
        begin
          if (exists(select 1 from RDB$INDEX_SEGMENTS where UPPER(RDB$INDEX_NAME)=UPPER(:pk_index_name) and UPPER(RDB$FIELD_NAME)=UPPER(:original_field_name))) then
          begin
            sourcecode = indent_str || indent_str || indent_str || '<element name="' || field_name || '"' || property_items || '>';
            suspend;
            sourcecode = indent_str || indent_str || indent_str || indent_str || '<require>delete</require>';
            suspend;
            sourcecode = indent_str || indent_str || indent_str || indent_str || '<require>read</require>';
            suspend;
            sourcecode = indent_str || indent_str || indent_str || indent_str || '<require>update</require>';
            suspend;
            sourcecode = indent_str || indent_str || indent_str || indent_str || '<require>insert</require>';
            suspend;
            sourcecode = indent_str || indent_str || indent_str || indent_str || '<noChange>delete</noChange>';
            suspend;
            sourcecode = indent_str || indent_str || indent_str || indent_str || '<noChange>read</noChange>';
            suspend;
            sourcecode = indent_str || indent_str || indent_str || indent_str || '<noChange>update</noChange>';
            suspend;
            sourcecode = indent_str || indent_str || indent_str || '</element>';
            suspend;          
          end
          else
          begin
            sourcecode = indent_str || indent_str || indent_str || '<element name="' || field_name || '"' || property_items || '/>';
            suspend;
          end
        end
      end
    end 
    /* alles was zum Schluss gemacht werden soll */
    if (AFLAG = 'SERVICEDEF') then
    begin
      if (AWMVERSION = '6.5.2') then
      begin
        sourcecode = indent_str || indent_str || '</dataobject>';
        suspend;
        sourcecode = '';        
        suspend;
        sourcecode = '';
        suspend;
        Exit;                
      end      
    end    
  end           
end^

COMMENT ON PROCEDURE SP_METADATA_FOR_CHECKLIST IS
'Checkliste um Entitäten (Java-Source / XML-Mapfile) unter Wavemaker einzubinden'^ 

CREATE OR ALTER PROCEDURE SP_CREATE_HIBERNATE_SCRIPT(
  ATABLENAME varchar(32),
  AIS_VIEW smallint,
  ATABLE_AS_VIEW smallint,
  AINSTALL_USER varchar(32),
  ATARGETDIR varchar(254),
  ADBCONNECTPASS varchar(512),
  ACLIENTLIB varchar(254) DEFAULT 'C:\Users\Alfred\Programme\Firebird_2_5\bin\fbclient.dll',
  ACONNECTTO varchar(254) DEFAULT '127.0.0.1:ZABONLINEEMBEDDED',
  ADBCONNECTUSER varchar(32) DEFAULT 'SYSDBA',
  APACKAGE varchar(254) DEFAULT 'com.zabonlinedb.data',
  ADBNAME varchar(254) DEFAULT 'ZABonline [WaveMaker]',
  ADBVERSION varchar(64) DEFAULT '000.000.00000',
  AHIBERNATEURI varchar(254) DEFAULT '-//Hibernate/Hibernate Mapping DTD 3.0//EN',
  AHIBERNATEMAPDTD varchar(254) DEFAULT 'http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd',
  AIDNAME varchar(264) DEFAULT 'id',
  AGENERATORCLASS varchar(64) DEFAULT 'assigned',
  APROJECTDIR varchar(254) DEFAULT '\trunk\WaveMaker 6.4.5GA\projects\ZABonline\',
  AWMVERSION varchar(10) DEFAULT '6.5.3',
  ADBSERVICE varchar(64) DEFAULT 'ZABonlineDB') 
returns (
  sourcecode varchar(2000))
as
declare variable class_name varchar(2000);
begin
  /*
   *
   *
  OUTPUT 'C:\Users\Alfred\Sourcen\create_hibernate_interface.sql';
  select Trim(trailing from sourcecode) from SP_CREATE_HIBERNATE_SCRIPT('DATASHEET', 0, 1, 'INSTALLER', 'C:\Users\Alfred\Sourcen\', 'masterkey');
  OUTPUT;   
   *
   *
   */            

  if (exists(select 1 from RDB$PROCEDURES where UPPER(RDB$PROCEDURE_NAME)=UPPER('SP_DBVERSION'))) then
  begin
    execute statement 'select dbversion from SP_DBVERSION' into :ADBVERSION;
  end

  sourcecode = '/*******************************************************************************';
  suspend;
  sourcecode = '/* Author: ' || current_user;
  suspend;                                                    
  sourcecode = '/* Date: ' || current_timestamp;
  suspend;
  sourcecode = '/* Purpose: Grundsteinlegung des Datenmodelles für ZABonline (Wavemaker)';
  suspend;      
  sourcecode = '/*';
  suspend;                                                                                
  sourcecode = '/*******************************************************************************';
  suspend;
  sourcecode = '/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x';
  suspend;     
  sourcecode = '/* - Das Script ist für die Ausführung im IBExpert erstellt worden';
  suspend;                
  sourcecode = '/* - Ein möglicher Connect zur Produktionsdatenbank sollte geschlossen werden';
  suspend;     
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '/* History: ' || current_timestamp;
  suspend;  
  sourcecode = '/*          Diverse Werkzeug für die Entwicklung und Installation';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '/*        Following SET SQL DIALECT is just for the Database Comparer         */';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = 'SET SQL DIALECT 3;';
  suspend;  
  sourcecode = '';
  suspend;  
  sourcecode = 'SET NAMES WIN1252;';
  suspend;  
  sourcecode = '';
  suspend;  
  sourcecode = '/* An dieser Stelle muss die Client-DLL (Pfad und Name) überprüft werden      */';
  suspend;  
  sourcecode = 'SET CLIENTLIB ''' || ACLIENTLIB || ''';';
  suspend;  
  sourcecode = '';
  suspend;  
  sourcecode = '/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */';
  suspend;  
  sourcecode = 'CONNECT ''' || ACONNECTTO || ''' USER ''' || ADBCONNECTUSER || ''' PASSWORD ''' || ADBCONNECTPASS || ''';';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '/*                                 Hibernate-Interface';
  suspend;                                    
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '';
  suspend;  
  
  select property from SP_SET_ENTITYNAME('_', :ATABLENAME, 1, null) into :class_name;
  select result from SP_CAPITALIZE(:class_name, 1, 0) into :class_name;  
  
  sourcecode = 'OUTPUT ''' || ATARGETDIR || '\' || class_name || '.java'';';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_JAVA(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ''' || :AINSTALL_USER || ''', ''BEGIN'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_JAVA(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ''' || :AINSTALL_USER || ''', ''PROPERTY'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_JAVA(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ''' || :AINSTALL_USER || ''', ''METHOD'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_JAVA(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ''' || :AINSTALL_USER || ''', ''END'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''');';
  suspend;  
  sourcecode = 'OUTPUT;';
  suspend;  
  sourcecode = '';
  suspend;    
  sourcecode = 'OUTPUT ''' || ATARGETDIR || '\' || class_name || '.hbm.xml'';';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_XML(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''BEGIN'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :AHIBERNATEURI || ''', ''' || :AHIBERNATEMAPDTD || ''', ''' || :AIDNAME || ''', ''' || :AGENERATORCLASS || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_XML(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''PK_PROPERTY'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :AHIBERNATEURI || ''', ''' || :AHIBERNATEMAPDTD || ''', ''' || :AIDNAME || ''', ''' || :AGENERATORCLASS || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_XML(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''PROPERTY'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :AHIBERNATEURI || ''', ''' || :AHIBERNATEMAPDTD || ''', ''' || :AIDNAME || ''', ''' || :AGENERATORCLASS || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_TO_XML(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''END'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :AHIBERNATEURI || ''', ''' || :AHIBERNATEMAPDTD || ''', ''' || :AIDNAME || ''', ''' || :AGENERATORCLASS || ''');';
  suspend;  
  sourcecode = 'OUTPUT;';
  suspend;  
  sourcecode = '';
  suspend;  
  sourcecode = 'OUTPUT ''' || ATARGETDIR || '\' || class_name || '.checklist.txt'';';
  suspend;
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''BEGIN'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :APROJECTDIR || ''', ''' || :AWMVERSION || ''', ''' || :ADBSERVICE || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''SERVICEDEF'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :APROJECTDIR || ''', ''' || :AWMVERSION || ''', ''' || :ADBSERVICE || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''DBSERVICE.SPRING'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :APROJECTDIR || ''', ''' || :AWMVERSION || ''', ''' || :ADBSERVICE || ''');';
  suspend;  
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''PROJECT-MANAGERS'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :APROJECTDIR || ''', ''' || :AWMVERSION || ''', ''' || :ADBSERVICE || ''');';
  suspend;
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''TYPES'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :APROJECTDIR || ''', ''' || :AWMVERSION || ''', ''' || :ADBSERVICE || ''');';
  suspend;
  sourcecode = 'select Trim(trailing from sourcecode) from SP_METADATA_FOR_CHECKLIST(''' || :ATABLENAME || ''', '|| :AIS_VIEW || ', ' || :ATABLE_AS_VIEW || ', ''' || :AINSTALL_USER || ''', ''ENTITY'', ''' || :APACKAGE || ''', ''' || :ADBNAME || ''', ''' || :ADBVERSION || ''', '''|| :APROJECTDIR || ''', ''' || :AWMVERSION || ''', ''' || :ADBSERVICE || ''');';
  suspend;      
  sourcecode = 'OUTPUT;';
  suspend;  
  sourcecode = '';
  suspend;  
  sourcecode = 'COMMIT WORK;';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
  sourcecode = '/******************************************************************************/';
  suspend;  
end^

COMMENT ON PROCEDURE SP_CREATE_HIBERNATE_SCRIPT IS
'Erstellt ein Hibernate-Script-Interface für eine Tabelle'^

SET TERM ; ^

COMMIT WORK;
/******************************************************************************/
/*                                 Adminkataloge verfolständigen                                 
/******************************************************************************/

/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'COMMON_IDX_COLUMNS';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'COMMON_IDX_COLUMNS';
execute procedure SP_CREATE_TRIGGER_BU 'COMMON_IDX_COLUMNS';

/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'USERVIEW_SOURCES';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'USERVIEW_SOURCES';
execute procedure SP_CREATE_TRIGGER_BU 'USERVIEW_SOURCES';

COMMIT WORK;
/******************************************************************************/
/*                                 Grants                                 
/******************************************************************************/

/* Users */
GRANT EXECUTE ON PROCEDURE SP_CREATE_ADMIN_CATALOG_TABLE TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_SIMPLE_INDEX TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_ALL_SIMPLE_INDEX TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_GET_COLUMNLIST TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_GET_PRIMKEYLIST TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_GRANT_ROLE_TO_OBJECT TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_USER_VIEW TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_SEQUNECE TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_TRIGGER_BI TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_TRIGGER_BU TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_TRIGGER_BD TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_METADATA_TO_JAVA TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_SET_ENTITYNAME TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CAPITALIZE TO INSTALLER; 
GRANT EXECUTE ON PROCEDURE SP_METADATA_TO_XML TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_METADATA_FOR_CHECKLIST TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_HIBERNATE_SCRIPT TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_ALL_SIMPLE_INDEX TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_ALL_USER_VIEWS TO INSTALLER;

GRANT SELECT, INSERT, UPDATE, DELETE ON V_USERVIEW_SOURCES TO INSTALLER;
GRANT SELECT, INSERT, UPDATE, DELETE ON V_COMMON_IDX_COLUMNS TO INSTALLER; 

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
