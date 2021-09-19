@echo off
set __COMPAT_LAYER=WinXP

:: Test if directory contains spaces
set "_here=%~dp0"
if "%_here%" neq "%_here: =_%" (
    call cmd /c "echo Error: SimCity cannot run if there are spaces in its directory path&echo        Move to a different directory and try again&echo.&pause"
    goto :eof
)

:: Copy SimCity files if not yet copied
if not exist "%~dp0..\SC2K\SIMCITY.EXE" call cmd /c "call "%~dp0..\Installer\install.bat" "

:: Patch SimCity if not yet patched
if not exist "%~dp0..\SC2K\SimCity_W10_EntryPoint.exe" (
    "%~dp0BPatch.exe" "%~dp0..\SC2K\SIMCITY.EXE" "%~dp0..\SC2K\SimCity_W10_EntryPoint.exe" --input="%~dp0SimCity_Win10.patch"
)


call "%~dp0..\SC2K\SimCity_W10_EntryPoint.exe"
