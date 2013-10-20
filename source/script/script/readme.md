Datenbank
=========

Aufbau des Datenmodelles �ber SQL-Scripte und dem IBExpert

**Inhalts�bersicht:**

- Firebird
- IBExpert
- Scripte
- Hibernate
- Zugriffrechte     
- Benutzer

Firebird
--------
Als Datenbank wird Firebird 2.5 verwendet. Diese Version ist notwendig, da in den 
Scripten Sprachelemente verwendet werden, die zum Teil erst mit der Version 2.5 
eingef�hrt wurden. (z.B.: `CREATE USER`)


IBExpert
--------
Die Scripte sind f�r das Script-Interface f�r IBExpert optimiert.      
Folgende Befehle werden immer zu Anfang in jedem Script aufgef�hrt:

* `SET SQL DIALECT 3`
* `SET NAMES WIN1252`
* `SET CLIENTLIB '<Pfadeangabe>\fbclient.dll';` 
* `CONNECT '<IP des Servers>:<Alias>' USER '<Benutzer>' PASSWORD '<password>';` 

Bestimmte Angaben wie IP des Servers oder DB-Alias m�ssen nat�rlich beim klonen 
auf die lokale Umgebung angepasst werden.


Scripte
-------
Die Scripte werden immer in diverse Abschnitte aufgeteilt:

* Kommentarheader (Pflicht)
* Initialisierung der Verbindungsparameter (Pflicht)
* Update-/Versions-Historie (Pflicht)
* Abschnitte f�r DB-Objekte (wenn ben�tigt)
    * Exceptions
    * Domains
    * Sequences
    * Tables
    * Views
    * StoredProcedures
    * Datainput
    * Grants
    * etc.                         
    
Jeder Abschnitt wird in der Regel mit einem `COMMIT WORK` abgeschlossen.    

F�r alle Scripte die Datenbankobjekte f�r die Mitgliederverwaltung erstellen,
wird der Benutzer `INSTALLER` f�r die Verbindungsparameter verwendet.      
Neben den Scripten welche die Mitgliederverwaltung aufbauen, gibt es Scripte welche 
Werkzeuge f�r die Codegenerierung zur Verf�gung stellen. Diese Scripte werden immer 
mit dem Benutzer `SYSDBA` initialisert. 

### Spezielle Scripte
Folgende Scripte richten Werkzeuge f�r die Codegenerierng ein, unterst�tzen die 
Installation, oder stellen grunds�tzliche Funktionalit�ten zur Verf�gung:

* `create_user.sql`: Erstellt alle notwendigen Benutzer
* `create_tools.sql`: Werkzeuge f�r die Codegenerierung
* `create_hibernate_workaround.sql`: Hibernate Script Interface
* `create_json.sql`: JSON-Workaround (in Planung)
* `create_simple_indexe.sql`: Einspalten-Indexe generieren
* `recreate_user_views.sql`: User-Views reorganisieren (wird derzeit nicht ausgef�hrt; unn�tig?)
* `clean_up.sql`: Tempor�re DB-Objekte wieder entfernen

Die Codegenerierung erzeugt derzeit 2/3 der verwendeten DB-Objekte.      
Folgende DB-Objekte werden immer automatisch erstellt:

* Update Views (User-Views)
* Standard Sequences f�r PrimaryKeys
* Standard Kataloge
* Admin Kataloge (notwendig f�r die Installation und Wartung)
* m-n Verbindungen (Relation-Tables)
* Standard Grants (Zugriffsrechte f�r DB-Objekte)
* Standard Trigger (Before-Update, Before-Insert, Before-Delete)
* Einspalten-Indexe (z.B. f�r die Spalte `SOFTDEL`)
* Hibernate-Entities (Sorucen f�r die WaveMaker-Schnittstelle)

  
Hibernate
---------
???

Zugriffrechte
-------------     
???


Benutzer
--------
F�r die Installation und den Betrieb der Mitgliederverwaltung werden zust�tzlich
zum `SYSDBA` zwei weitere Benutzer ben�tigt:

* `INSTALLER`
* `WEBCONNECT`

Die Werkzeuge f�r die Codegenerierung, den grunds�tzlichen Funktionalit�ten und 
des *Hibernate Script Interface* werden mit dem `SYSDBA` installiert.        
Das gesamte Datenmodell f�r die Mitgliederverwaltung wird mit dem Benutzer `INSTALLER` 
eingerichtet.    
Der Benutzer `WEBCONNECT` wird vom Servlet-Container verwendet um eine Connect zur
Datenbank herzustellen. `WEBCONNECT` ist in seinen Rechten stark eingeschr�nkt. So
kann diese Benutzer keinen direkten Zugriff auf die Tabellen herstellen. Daten k�nnen
nur �ber Update Views (User-Views) verwaltet werden.     