@echo off
setlocal
set "SOURCE=\\FESCOFILES\Graphics\Design Files\1 FESCO\1 GRAPHICS\Fonts"
set "DEST=C:\Users\lkeenan\AppData\Roaming\Adobe\Fonts"
if not exist "%SOURCE%\." (
    echo ERROR: Shared font folder is unavailable.
    pause
    exit /b 1
)
if not exist "%DEST%\." mkdir "%DEST%"
if not exist "%DEST%\." (
    echo ERROR: Could not create destination folder.
    pause
    exit /b 1
)
powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $d=Get-Item -LiteralPath $env:DEST -Force; if ($d.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw 'Destination is a symbolic link or junction.' }; if (Get-ChildItem -LiteralPath $env:DEST -Directory -Force -Recurse -ErrorAction Stop | Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint } | Select-Object -First 1) { throw 'Destination contains a symbolic link or junction. Remove the old link before syncing.' }"
if errorlevel 1 (
    echo ERROR: Destination safety check failed. No fonts copied.
    pause
    exit /b 1
)
robocopy "%SOURCE%" "%DEST%" *.ttf *.otf *.ttc /S /XO /R:2 /W:3 /XJ
set "RC=%ERRORLEVEL%"
if %RC% GEQ 8 (
    echo ERROR: Some files could not be copied. Robocopy code %RC%.
    pause
    exit /b %RC%
)
echo Font synchronization complete. Restart Illustrator to test the fonts.
pause
exit /b 0
