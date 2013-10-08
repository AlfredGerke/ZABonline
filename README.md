***(in Progress)***

ZABonline
=========

Einarbeitung in die Erstellung von Web-Anwendungen am Beispiel einer Mitgliederverwaltung

**Inhalts�bersicht:**

- Zielvorgabe
- Wavemaker
- Firebird
- Versionen
- Funktionsumfang von ZABonline


Zielvorgabe
-----------

Das Ziel dieses Projektes ist es, anhand eines realen Beispiels, Erfahrungen im 
Aufbau einer Web-Anwendung zu sammeln.    
    
Folgende Punkte sind dabei besonders zu beachten:

* ZABonline solle eine klassische J2EE-Anwendung werden 
* Client-Code soll browser-zentriert ablaufen 
* Der Browser ist immer Plattform f�r die Anwendung
* Es sollen hosted Code und packaged Code zum Einsatz kommen
* Es soll ein Mobile-Interface geben (7- und 10-Zoll)
* Am Ende soll eine funktionsf�hige Mitgliederverwaltung stehen   

Da dieses Projekt zum erlernen von neuen Techniken dient, ist ein Termin f�r ein
erstes Release derzeit nicht vorgesehen. In der n�heren Zukunft werden Milestones 
definiert, welche einen kleinen Ausblick auf die Entwicklungsrichtung geben sollen.


Wavemaker
---------
Als zentrales Werkzeug f�r die Entwicklung des Clients und der Einbindung von 
Webservices sowie dem Aufbau des Servers wird Wavemaker verwendet. Beim Server handelt es sich 
um einen Tomcat-Server. Allerdings unterst�tzt Wavemaker auch andere Server. 
Anwendung welche mit Wavemaker erstellt werden sind grunds�tzlich in jeder Standard J2EE-Umgebung lauff�hig.
Um die Entwicklung des Servers zu vereinfachen wird Eclipse (JUNO) eingesetzt.   

Hauptgr�nde warum Wavemaker gew�hlt wurde:

* Wird kontinuierlich weiterentwickelt
* Mobile Interfaces k�nnen entwickelt werden
* Drag und Drop f�r die Erstellung des Clients
* Weitestgehende automatisierung der Kommunikation zwischen Client und Browser
* Dojo wird als JavaScript-Library eingesetzt
* Unterst�tzt sehr gut browser-zentrierten Code
 

Firebird
--------
Als Datenbank wird Firebird eingesetzt. Da Wavemaker sehr flexibel ist, was den 
Einsatz von Datenbanken angeht, wurde sich f�r Firebird entschieden. Sehr gute Erfahrungen 
aus mehreren Projekten der letzten Jahre haben zur Wahl dieser Datenbank als Back-End gef�hrt.
Die Verbindung zur Datenbank wird �ber die JDBC-Treiber JayBird von Firebird hergestellt.    

Die Verbindungsparameter lauten wie folgt: 

        Username=WEBCONNECT
        Password=WEBCONNECT
        RDBMS=Other
        Connection URL=jdbc:firebirdsql:localhost/3050:ZABONLINEEMBEDDED?roleName=R_WEBCONNECT
        Table Filter=.*
        Schema Filter=.*
        Driver Class=org.firebirdsql.jdbc.FBDriver
        Dialect=org.hibernate.dialect.FirebirdDialect
        Revese Naming Strategy=com.wavemaker.tools.data.reveng.DefaultRevengNamingStrategy

Der Server meldet sich nicht mit einem Admin-Account an der DB an. Der Benutzer `WEBCONNECT`
ist in seinen Rechten stark eingeschr�nkt. 

Folgende prim�re Einschr�nkungen sind zu beachten:

* Kein Zugriff auf Tabellen
* Kein L�schrecht
* Keinen Zugriff auf DDL
 
Daten werden �ber speziellen Views, Standard-Views genannt, bearbeitet. Standardviews 
bieten die M�glichkeit auf ein Select, Update und Insert. Es wird kein Delete
zugelassen, vielmehr besitzt jedes Schema ein Deleteflag.         
  

Versionen
---------

* Wavemaker 6.5.3
* Firebird 2.5
* JayBird 2.2.3 (jdbc)
* Java 1.6 (von Wavemaker vorgegeben)
* Dojo 1.6 (von Wavemaker vorgegeben)
* Eclipse (JUNO) (Entwicklung des Servers)

Funktionsumfang von ZABonline
-----------------------------

Administration:    

* Benutzer
* Benutzerrollen
* Mandanten 
* Benutzerdefinierte Felder
* Benutzerdefinierte Tabellen

Mitgliederverwaltung:    

* Adressen
    * Personendaten
    * Adressdaten
    * Kontaktdaten
    * Bankinformationen
    * Allgemeine Informationen
    * Foto
* Betrieb
    * Betrieb
    * Betriebsdaten
    * Adressdaten
    * Kontaktdaten
    * Bankinformationen
    * Allgemeine Informationen
    * Foto
* Mitglied
* Akte

Controlling:    

* Mandantenverwaltung
* Vorgangsverwaltung
* Wiedervorlagen (automatisch)
* Suchen (�ber alle Aspekte eines Mandanten)

Allgemein:    

* Notizen

Module:    

* Stammdaten
* Buchhaltung
* Abrechnung
* Online-banking
* Leistungsdaten
* Vorgangsverwaltung