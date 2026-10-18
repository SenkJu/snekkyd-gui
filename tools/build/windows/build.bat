@echo off
setlocal
cd /d "%~dp0"
curl --fail --location --retry 3 https://www.angusj.com/resourcehacker/resource_hacker.zip --output resource_hacker.zip
if errorlevel 1 exit /b 1
7z e -y resource_hacker.zip
if errorlevel 1 exit /b 1
7z a -y snekkyd-gui.7z scapp.exe ..\..\..\public\*
if errorlevel 1 exit /b 1
copy /b /y 7zSD.sfx + sfx_config.txt + snekkyd-gui.7z "decompiler_sfx.exe"
if errorlevel 1 exit /b 1
ResourceHacker.exe -script rh_script.txt
if errorlevel 1 exit /b 1
if not exist "Snekky Decompiler.exe" exit /b 1
