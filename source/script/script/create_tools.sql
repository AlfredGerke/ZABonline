/*******************************************************************************
/* Author:  Alfred Gerke (AGE)                                                  
/* Date:    2013-04-13                                                          
/* Purpose: Grundsteinlegung des Datenmodelles für ZABonline (Wavemaker)    
/*                                                                              
/*******************************************************************************
/* - Das Script arbeitet mit Befehlen der SQL-Erweiterung für FireBird 2.5.x   
/* - Das Script ist für die Ausführung im ISQL erstellt worden              
/* - Ein möglicher Connect zur ZABonline-DB sollte geschlossen werden   
/******************************************************************************/
/* History: 2013-04-13
/*          Diverse Werkzeug für die Installation
/*          2014-04-05
/*          Scripte auf ISQL optimiert
/******************************************************************************/
SET SQL DIALECT 3;

SET NAMES WIN1252;

SET AUTODDL;

/* An dieser Stelle muss die IP, der Datenbankpfad, Name der Datanbank sowie Benutzerinformationen (User/Password) überführt werden */
/*CREATE DATABASE '127.0.0.1/32258:ZABONLINEEMBEDDED' USER 'SYSDBA' PASSWORD 'masterkey' PAGE_SIZE 4096 DEFAULT CHARACTER SET WIN1252 COLLATION WIN1252;*/
CONNECT '127.0.0.1/32258:ZABONLINEEMBEDDED' USER 'SYSDBA' PASSWORD 'masterkey';
/******************************************************************************/
/*                                  Exceptions                                   
/******************************************************************************/

CREATE EXCEPTION DELETE_NOT_ALLOWED 'Anforderung zum Löschen abgelehnt!';

COMMIT WORK;
/******************************************************************************/
/*                                  Tools                                   
/******************************************************************************/

SET TERM ^ ;

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

CREATE OR ALTER PROCEDURE SP_CREATE_ADMIN_CATALOG_TABLE (
  ATABLENAME varchar(24),
  ACOMMENT VARCHAR(254) DEFAULT 'ZABonline')
RETURNS (
  success smallint)
AS
declare variable sql_stmt varchar(2000);
declare variable relation_name varchar(24);
declare variable cat_comment varchar(254);
declare variable columnlist varchar(2000);
declare variable interfacelist varchar(2000);
declare variable implementationlist varchar(2000);
BEGIN
  success = 0;
  relation_name = Upper(ATABLENAME);
  cat_comment = ACOMMENT;
  interfacelist = '';
  implementationlist = '';

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

    sql_stmt = 'create or alter view ' || 'V_' || :relation_name || :interfacelist || ' as select ' || :implementationlist || ' from ' || :ATABLENAME;
    execute statement sql_stmt; 
    
    sql_stmt = 'COMMENT ON VIEW ' || 'V_' || :relation_name || ' IS ''Userview für die Tabelle ' || :ATABLENAME || ' (created by SP_CREATE_ADMIN_CATALOG_TABLE)''';
    execute statement sql_stmt; 
                    
    success = 1;  
  end      

  suspend;
END^

COMMENT ON PROCEDURE SP_CREATE_ADMIN_CATALOG_TABLE IS
'Erstellt einen Admin-Katalog'^ 

CREATE OR ALTER PROCEDURE SP_GRANT_ROLE_TO_OBJECT(
  AROLE varchar(254),
  AROLETYPE varchar(32),
  AOBJECT varchar(32),
  ADOADMINOPT smallint = 0)
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
    
    if (ADOADMINOPT = 1) then
      sql_stmt = sql_stmt || ' WITH GRANT OPTION';
      
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
        
        if (ADOADMINOPT = 1) then
          sql_stmt = sql_stmt || ' WITH GRANT OPTION';

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
  success = 0;
  table_name = Trim(ATABLENAME);
  indexed_column = Trim(AINDEXEDCOLUMN);

  index_name = 'IDX_' || :table_name || '_SI';
   
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

/* Katalog: ADM_COMMON_IDX_COLUMNS komplett über SP erstellen */
execute procedure SP_CREATE_ADMIN_CATALOG_TABLE 'ADM_COMMON_IDX_COLUMNS'^

SET TERM ; ^
COMMIT WORK;
SET TERM ^ ;

CREATE OR ALTER PROCEDURE SP_CREATE_ALL_SIMPLE_INDEX (
    aownername varchar(31) = 'INSTALLER')
returns (
    success smallint,
    tablename varchar(31),
    indexedcolumn varchar(31))
as
declare variable count_columns integer;
BEGIN
  select count(1) from V_ADM_COMMON_IDX_COLUMNS into :count_columns;
  
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
      V_ADM_COMMON_IDX_COLUMNS
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

/* Katalog: ADM_USERVIEW_SOURCES komplett über SP erstellen */
execute procedure SP_CREATE_ADMIN_CATALOG_TABLE 'ADM_USERVIEW_SOURCES'^

SET TERM ; ^
COMMIT WORK;
SET TERM ^ ;
                          
CREATE OR ALTER PROCEDURE SP_CREATE_USER_VIEW(
  ATABLENAME VARCHAR(32),
  AREGISTRER_SOURCE smallint = 1,
  ADOGRANT_ZAB_ROLES smallint = 1,
  AORDER_BY_PRIM smallint = 0) /* wenn 1 dann USER_VIEW nur ReadOnly */
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
    if (not exists(select 1 from V_ADM_USERVIEW_SOURCES where CAPTION=:ATABLENAME)) then
      insert into V_ADM_USERVIEW_SOURCES(CAPTION, DESCRIPTION) VALUES (:ATABLENAME, :relation_name);
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

CREATE OR ALTER PROCEDURE SP_CREATE_ALL_USER_VIEWS
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
    V_ADM_USERVIEW_SOURCES
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
        0)
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
  
  if (exists(select 1 from RDB$GENERATORS where RDB$GENERATOR_NAME=:relation_name)) then
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

CREATE OR ALTER PROCEDURE SP_CREATE_SEQUENCE_GETTER(
  ATABLENAME VARCHAR(32))
RETURNS (
  success smallint)    
AS
declare variable sql_stmt varchar(2000);
declare variable relation_name varchar(32);
declare variable seq_name varchar(32);
begin
  success = 0;
  seq_name = 'SEQ_' || :ATABLENAME || '_ID'; 
  relation_name = 'GET_' || :ATABLENAME || '_ID';
  
  if (exists(select 1 from RDB$GENERATORS where RDB$GENERATOR_NAME=:seq_name)) then
  begin
    if (not exists(select 1 from RDB$PROCEDURES where RDB$PROCEDURE_NAME=:relation_name)) then
    begin
      sql_stmt = 'CREATE OR ALTER PROCEDURE ' || :relation_name || '  
returns(
  id integer)      
as
begin
  id = next value for ' || :seq_name || ';

  suspend;
end';
    
    execute statement sql_stmt;
       
    sql_stmt = 'COMMENT ON PROCEDURE ' || :relation_name || ' IS ''Getter für die Sequence ' || :seq_name || ' (created by SP_CREATE_SEQUENCE_GETTER)''';
    execute statement sql_stmt;
      
    select success from SP_GRANT_ROLE_TO_OBJECT('R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', :relation_name) into :success;     
            
    end
    else
    begin
      success = 0;
    end
  end
  else
  begin
    success = 0;
  end
    
  suspend;
end^

COMMENT ON PROCEDURE SP_CREATE_SEQUENCE_GETTER IS
'Erstellt eine Sequence-Zugriffs-SP zu einem Tabellennamen'^

CREATE OR ALTER PROCEDURE SP_CREATE_CATALOG_SETTER(
  ATABLENAME VARCHAR(32))
RETURNS (
  success smallint)    
AS
declare variable sql_stmt varchar(2000);
declare variable relation_name varchar(32);
declare variable view_name varchar(32);
begin
  success = 0;
  view_name = 'V_' || Upper(:ATABLENAME); 
  relation_name = 'SET_' || Upper(:ATABLENAME);
  
  if (exists(select 1 from RDB$RELATIONS where RDB$RELATION_NAME=:view_name)) then
  begin
    if (not exists(select 1 from RDB$PROCEDURES where RDB$PROCEDURE_NAME=:relation_name)) then
    begin
      sql_stmt = 'CREATE OR ALTER PROCEDURE ' || :relation_name || '(
  AId integer,
  ACountryId integer,
  ACaption varchar(254),
  ADesc varchar(2000),
  ADoNotDelete smallint)        
returns(
  success smallint)      
as
begin

  insert
  into
  ' || :view_name || '
  (
    ID,
    COUNTRY_ID,
    CAPTION,
    DESCRIPTION,
    DONOTDELETE
  )
  values
  (
    :AId,
    :ACountryId,
    :ACaption,
    :ADesc,
    :ADoNotDelete
  );
  
  success = 1;

  suspend;
end';
    
      execute statement sql_stmt;
         
      sql_stmt = 'COMMENT ON PROCEDURE ' || :relation_name || ' IS ''Setter für den Katalog ' || :ATABLENAME || ' (created by SP_CREATE_CATALOG_SETTER)''';
      execute statement sql_stmt;
        
      select success from SP_GRANT_ROLE_TO_OBJECT(:relation_name, 'INSERT', :view_name) into :success;
      
      if (success = 1) then
      begin        
        select success from SP_GRANT_ROLE_TO_OBJECT('R_ZABGUEST, R_WEBCONNECT, R_ZABADMIN', 'EXECUTE', :relation_name) into :success;    
      end                     
    end
    else
    begin
      success = 0;
    end
  end
  else
  begin
    success = 0;
  end
    
  suspend;
end^

COMMENT ON PROCEDURE SP_CREATE_CATALOG_SETTER IS
'Erstellt eine Insert-Proc zu einen Katalog'^

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

SET TERM ; ^

COMMIT WORK;
/******************************************************************************/
/*                                 Adminkataloge verfolständigen                                 
/******************************************************************************/

/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'ADM_COMMON_IDX_COLUMNS';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'ADM_COMMON_IDX_COLUMNS';
execute procedure SP_CREATE_TRIGGER_BU 'ADM_COMMON_IDX_COLUMNS';
/* Grants vergeben */
execute procedure SP_GRANT_ROLE_TO_OBJECT 'INSTALLER', 'ALL', 'ADM_COMMON_IDX_COLUMNS';
execute procedure SP_GRANT_ROLE_TO_OBJECT 'INSTALLER', 'ALL', 'V_ADM_COMMON_IDX_COLUMNS';

/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'ADM_USERVIEW_SOURCES';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'ADM_USERVIEW_SOURCES';
execute procedure SP_CREATE_TRIGGER_BU 'ADM_USERVIEW_SOURCES';
/* Grants vergeben */
execute procedure SP_GRANT_ROLE_TO_OBJECT 'INSTALLER', 'ALL', 'ADM_USERVIEW_SOURCES';
execute procedure SP_GRANT_ROLE_TO_OBJECT 'INSTALLER', 'ALL', 'V_ADM_USERVIEW_SOURCES';

/* Katalog: ADM_CATALOGS komplett über SP erstellen */
execute procedure SP_CREATE_ADMIN_CATALOG_TABLE 'ADM_CATALOGS';

/* Sequence anlegen */
execute procedure SP_CREATE_SEQUNECE 'ADM_CATALOGS';
/* Trigger anlegen */
execute procedure SP_CREATE_TRIGGER_BI 'ADM_CATALOGS';
execute procedure SP_CREATE_TRIGGER_BU 'ADM_CATALOGS';
/* Grants vergeben */
execute procedure SP_GRANT_ROLE_TO_OBJECT 'INSTALLER', 'ALL', 'ADM_CATALOGS', 1;
execute procedure SP_GRANT_ROLE_TO_OBJECT 'INSTALLER', 'ALL', 'V_ADM_CATALOGS', 1;

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
GRANT EXECUTE ON PROCEDURE SP_CREATE_ALL_SIMPLE_INDEX TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_ALL_USER_VIEWS TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_SEQUENCE_GETTER TO INSTALLER;
GRANT EXECUTE ON PROCEDURE SP_CREATE_CATALOG_SETTER TO INSTALLER;

/* SPs */
GRANT EXECUTE ON PROCEDURE SP_GRANT_ROLE_TO_OBJECT TO SP_CREATE_SEQUENCE_GETTER;
GRANT EXECUTE ON PROCEDURE SP_GRANT_ROLE_TO_OBJECT TO SP_CREATE_CATALOG_SETTER;

COMMIT WORK;
/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
