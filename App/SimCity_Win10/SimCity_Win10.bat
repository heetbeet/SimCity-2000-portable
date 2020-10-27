@echo off
set __COMPAT_LAYER=WinXP

:: Copy SimCity files if not yet copied
if not exist "%~dp0..\SC2K\SIMCITY.EXE" (
 	call cmd /c "call "%~dp0..\Installer\install.bat" & pause"
)

:: Patch SimCity if not yet patched
if not exist "%~dp0..\SC2K\SimCity_EntryPoint.exe" (
	"%~dp0BPatch.exe" "%~dp0..\SC2K\SIMCITY.EXE" "%~dp0..\SC2K\SimCity_W10_EntryPoint.exe" --input="%~dp0SimCity_Win10.patch"
)


call "%~dp0..\SC2K\SimCity_W10_EntryPoint.exe"
