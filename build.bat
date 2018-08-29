@echo off

if "%1"=="" (
    set makefile=makefile.txt
) else (
    set makefile=%1
)

if not exist "%makefile%" (
    echo Could not find file %makefile%.
    goto eof
)

echo Preparing to build app from relative path...

echo Creating path compatability...
powershell -executionpolicy bypass -file buildtools\changePaths.ps1 -makefile "%makefile%"

echo Creating app.html...
echo. > app.html

echo Adding header to app.html...
type aluminium\header.html >> app.html

echo Adding raw importers to app.html...
type app\res\rawimport.html >> app.html

echo Adding source header to app.html...
type aluminium\sourceheader.html >> app.html

echo Adding Cobalt to app.html...
type aluminium\cobalt.js >> app.html

echo Adding Alumiuium to app.html...
type aluminium\aluminium.js >> app.html

echo Adding script opener to app.html...
type aluminium\script.html >> app.html

echo Reading %makefile%...

for /F "usebackq tokens=*" %%A in ("makefileChangePaths.txt") do (
    if "%%A" NEQ "" (
        for %%i in (%%A) do (
            if "%%~xi"==".al" (
                echo Adding %%A to app.html...

                powershell -executionpolicy bypass -file buildtools\changeSymbols.ps1 -scriptfile "%%A"
                type escapeSymbols.al >> app.html
                del escapeSymbols.al
            )
        )
    )
)

echo End of reading %makefile%.

echo Adding res opener to app.html...
type aluminium\res.html >> app.html

echo Reading %makefile%...

for /F "usebackq tokens=*" %%A in ("makefileChangePaths.txt") do (
    if "%%A" NEQ "" (
        for %%i in (%%A) do (
            if "%%~xi"==".co" (
                echo Adding %%A to app.html...
                
                powershell -executionpolicy bypass -file buildtools\changeSymbols.ps1 -scriptfile "%%A"
                type escapeSymbols.al >> app.html
                del escapeSymbols.al
            )
        )
    )
)

echo End of reading %makefile%.

echo Adding jQuery opener to app.html...
type aluminium\jquery.html >> app.html

echo Adding jQuery to app.html...
type aluminium\jquery.js >> app.html

echo Adding footer to app.html...
type aluminium\footer.html >> app.html

echo Deleting temporary files...
del makefileChangePaths.txt

echo Finished building.

:eof