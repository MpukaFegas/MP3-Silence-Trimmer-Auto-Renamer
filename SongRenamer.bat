@echo off
setlocal enabledelayedexpansion

echo Enter the folder path containing the MP3 files:
set /p folder="> "

if not exist "%folder%" (
    echo Folder not found!
    pause
    exit /b
)

rem Create the folder for renamed copies
set newfolder=%folder%\RenamedSongs
if not exist "%newfolder%" (
    mkdir "%newfolder%"
)

pushd "%folder%"

for %%f in ("*.mp3") do (
    set filename=%%~nf
    set ext=%%~xf

    rem Split at first hyphen
    for /f "tokens=1* delims=-" %%a in ("!filename!") do (
        set artist=%%a
        set song=%%b
    )

    rem Trim spaces
    set artist=!artist:~0,-1!
    set song=!song:~1!

    set newname=!song! - !artist!!ext!

    rem Copy original → rename the copy
    copy "%%f" "%newfolder%\!newname!" >nul
)

popd

echo Finished! Renamed copies saved in: %newfolder%
pause
