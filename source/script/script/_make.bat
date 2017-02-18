cls

del %2

if "%1"=="" goto Anwendung
if "%2"=="" goto Anwendung

%1 -q -b -e -i batch.sql -m -o %2

goto ENDE1

:Anwendung
echo.
echo    Das Batchprogramm zur Erstellung einer Datenbank wird wie folgt aufgerufen:  
echo.
echo    makedb {isql} {Ziel der Logdatei}
echo.

:ENDE1

CLS
echo.
echo    Die Datenbank wurde erstellt 
echo.