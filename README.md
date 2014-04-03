***(in Progress...)***

ZABonline
=========

Einarbeitung in die Erstellung von Web-Anwendungen am Beispiel einer Mitgliederverwaltung

**Inhaltsübersicht:**

- Zielvorgabe
- Wavemaker
- Firebird
- Hibernate
- Versionen
- Funktionsumfang von ZABonline
- zusätzliche Entwicklungsumgebungen


Zielvorgabe
-----------

Das Ziel dieses Projektes ist es, anhand eines realen Beispiels, Erfahrungen im 
Aufbau einer Web-Anwendung zu sammeln.    
    
Folgende Punkte sind dabei besonders zu beachten:

* ZABonline solle eine klassische J2EE-Anwendung werden 
* Client-Code soll browser-zentriert ablaufen 
* Der Browser ist immer Plattform für die Anwendung
* Es sollen hosted Code und packaged Code zum Einsatz kommen
* Es soll ein Mobile-Interface geben (7- und 10-Zoll)
* Am Ende soll eine funktionsfähige Mitgliederverwaltung stehen   

Da dieses Projekt zum erlernen von neuen Techniken dient, ist ein Termin für ein
erstes Release derzeit nicht vorgesehen. In der näheren Zukunft werden Milestones 
definiert, welche einen kleinen Ausblick auf die Entwicklungsrichtung geben sollen.


Wavemaker
---------
Als zentrales Werkzeug für die Entwicklung des Clients und der Einbindung von 
Webservices sowie dem Aufbau des Servers wird [Wavemaker](http://http://www.wavemaker.com/ "WaveMaker") verwendet. Beim Server handelt es sich 
um einen Tomcat-Server. Allerdings unterstützt Wavemaker auch andere Server. 
Anwendung welche mit Wavemaker erstellt werden sind grundsätzlich in jeder Standard J2EE-Umgebung lauffähig.
Um die Entwicklung des Servers zu vereinfachen wird Eclipse (JUNO) eingesetzt.   

Hauptgründe warum Wavemaker gewählt wurde:

* Wird kontinuierlich weiterentwickelt
* Mobile Interfaces können entwickelt werden
* Drag und Drop für die Erstellung des Clients
* Weitestgehende automatisierung der Kommunikation zwischen Client und Browser
* Dojo wird als JavaScript-Library eingesetzt
* Unterstützt sehr gut browser-zentrierten Code
 

Firebird
--------
Als Datenbank wird Firebird eingesetzt. Da Wavemaker sehr flexibel ist, was den 
Einsatz von Datenbanken angeht, wurde sich für Firebird entschieden. Sehr gute Erfahrungen 
aus mehreren Projekten der letzten Jahre haben zur Wahl dieser Datenbank als Back-End geführt.
Die Verbindung zur Datenbank wird über die JDBC-Treiber JayBird von Firebird hergestellt.    

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
ist in seinen Rechten stark eingeschränkt. 

Folgende primäre Einschränkungen sind zu beachten:

* Kein Zugriff auf Tabellen
* Kein Löschrecht
* Keinen Zugriff auf DDL
 
Daten werden über speziellen Views, Standard-Views genannt, bearbeitet. Standardviews 
bieten die Möglichkeit auf ein Select, Update und Insert. Es wird kein Delete
zugelassen, vielmehr besitzt jedes Schema ein Deleteflag.         
  

Hibernate
---------
In WaveMaker wird Hibernate als ORM-Layer eingesetzt. Tabellen werden in Java-Entitäten 
übersetzt und mit einer *.hbm.xml-Beschreibungsdatei zusammen wird die Kommunikation 
mit Daten in einer DB hergestellt. In WaveMaker kann über einen einfachen Assistenten
das gesamte Datenmodell in Entitäten übersetzt werden. Allerdings lassen sich keine 
einzelnen Tabellen separat übersetzen. Es gibt zwar die Möglichkeit eine Entität 
von Hand zu erstellen, dies kann aber je nach Umfang der Tabelle erheblich an Zeit 
kosten.    
Um das Problem zu lösen wird eine Sammlung von SPs (StoredProcedures) eingeführt,
die es ermöglichen über einen SQL-Script-Editor aus der Datenbank eine beliebige
Tabelle in eine Java-Entität zu übersetzen.  

Über folgendes Script kann eine Java-Entität erstellt werden:  

* [Hibernate Script Interface](source/script/script/create_hibernate_script_interface.sql "Script-Inteface - Erstellt eine beliebige Java-Entität")   
  

Versionen
---------

* Wavemaker 6.6.0
* Firebird 2.5
* JayBird 2.2.4 (jdbc)
* Java 1.6 (von Wavemaker vorgegeben)
* Dojo 1.6 (von Wavemaker vorgegeben)
* Eclipse (JUNO) (Entwicklung des Servers)

Funktionsumfang von ZABonline
-----------------------------

Administration:    

* Benutzer
* Benutzerrollen
* Mandanten 
* Benutzerdefinierte Datenblätter
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
* Suchen (über alle Aspekte eines Mandanten)

Allgemein:    

* Notizen

Module:    

* Stammdaten
* Buchhaltung
* Abrechnung
* Online-banking
* Leistungsdaten
* Vorgangsverwaltung


zusätzliche Entwicklungsumgebungen
----------------------------------

* [Eclipse](http://www.eclipse.org/webtools/ "Eclipse - Java EE IDE for Web Developers")
* [PSPad](http://http://www.pspad.com/de/ "PSPad – der ultimative Editor für Softwareentwickler")
* [ISQL](http://www.firebirdsql.org/manual/isql-interactive.html/ "ISQL-Commandlinetool")
* [FlameRobin](http://www.flamerobin.org/ "GUI für Datenbankentwruft/-entwicklung")

## Eclipse
Die Java-Sourcen können in einem eigenen Editor von Wavemaker bearbeitet werden. Je 
umfangreicher sich allerdings der Servercode gestaltet, um so mühseliger ist die 
Verwendung dieses Editors. Als gute Alternative hat sich Eclipse (Juno) erwiesen.
Das Projekt ließ sich problemlos anlegen, bearbeiten und kompilieren. Es ist allerdings
darauf zu achten, das mit dem JRE 6 gearbeitet wird, da diese Runtime von Wavemaker
verlangt wird. Sicherlich lassen sich auch andere Entwicklungstool wie z. B. NetBeans
verwenden.

## PSPad
Die JavaScript-Sourcen können wie die Java-Sourcen in einem eigenen Editor von Wavemaker 
bearbeitet werden. Allerdings hat es sich gezeigt das die Anwendung eines externen 
Editors für JavaScript-Sourcen von Vorteil ist. Dabei hat sich der PSPad als eine 
gute Alternative angeboten. Der Texteditor ist speziell für Softwareentwickler 
geeignet und unterstützt diverse Programmiersprachen. Natürlich kann jeder andere 
Editor ebenfalls zur Anwendung kommen.   

## ISQL
ISQL ist Teil der Firebird-Installation und dient der Administration der Datenbank. 
ISQL ist ein Commandlinetool, welches für Einzel- und/oder Batchoperationen verwendet werden kann.
Besonders die Verarbeitung von Scripten als Batch lässt sich gut mit ISQL realiseren.

## FlameRobin     
Wenn man auf ein Commandlinetool für die Entwicklung der Datenbank verzichten will, bietet sich
FlameRobin an. Es ist ein Plattform übergreifendes Tool, welches (fast) alle Befehle, welche über den
ISQL verarbeitet werden können, in einer GUI anbietet. FlameRobin ist OpenSource und kann ohne Bedenken 
eingesetzt werden.

