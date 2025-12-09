@echo off
setlocal enabledelayedexpansion

:: Ask folder location directly
set /p input_folder="Enter the folder containing the mp3 files: "

:: Ask if user wants custom output folder
set /p custom_output="Do you want to provide a custom output folder?(No make a folder "crop" inside [Y/N]: "

if /i "%custom_output%"=="Y" (
    set /p output_folder="Enter the folder where the processed files will be saved: "
) else (
    set "output_folder=%input_folder%\_crop"
)

if not exist "%output_folder%" mkdir "%output_folder%"

:: Ask if the user wants to rename files
set /p rename_choice="Do you want to rename the mp3 files (Song - Artist)? [Y/N]: "

:: Count total mp3 files
set /a total=0
for %%f in ("%input_folder%\*.mp3") do set /a total+=1
echo Total tracks found: %total%
echo.

:: Initialize processed counter
set /a processed=0

:: Process mp3 files
for %%f in ("%input_folder%\*.mp3") do (
    set /a processed+=1
    echo Processing: %%~nxf

    :: Show red counter below
    powershell -Command "Write-Host 'Track !processed! of %total%' -ForegroundColor Red"

    ffmpeg -y -i "%%f" -af "silenceremove=start_periods=1:start_threshold=-28dB:start_duration=1.5:stop_periods=-1:stop_threshold=-28dB:stop_duration=1.5" "%output_folder%\%%~nxf"

    :: Rename if chosen
    if /i "%rename_choice%"=="Y" (
        set "filename=%%~nxf"
        for /f "tokens=1* delims=-" %%a in ("!filename!") do (
            set "artist=%%a"
            set "song=%%b"
            set "artist=!artist:~0!"
            set "song=!song:~1!"
            if "!song!"=="" (
                set "newname=!filename!"
            ) else (
                set "newname=!song! - !artist!%%~xf"
            )
            ren "%output_folder%\%%~nxf" "!newname!"
        )
    )
)

echo.
echo Done! Processed %processed% of %total% tracks.
echo Output folder: %output_folder%
pause
