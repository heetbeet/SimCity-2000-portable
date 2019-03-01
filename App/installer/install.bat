REM no need to run bspatch as administrator
set __COMPAT_LAYER=RUNASINVOKER

@echo off
setlocal

echo]
echo **************************************************
echo Searching SimCity CD-ROM
echo **************************************************
for /f "skip=1 tokens=1,2" %%i in ('wmic logicaldisk get caption^, drivetype') do (
  set scdrive=%%i
  REM I'm too dumb for nested statements
  if [%%j]==[5] echo Searching drive %%i ...
  if [%%j]==[5] IF EXIST %%i\WIN95\SC2K\NUL echo * Found SC2K on %scdrive%\WIN95\SC2K\ 
  if [%%j]==[5] IF EXIST %%i\WIN95\SC2K\NUL GOTO COPY_SC2K
)
echo Did not find a SC2K directory on any drive !!!
echo Alternatively copy your SC2K directory to App\SC2K and run this file again.

GOTO PATCH_SC2K

:COPY_SC2K
	echo]
	echo **************************************************
	echo Copying SimCity files
	echo **************************************************
	echo Copy files from %scdrive%\WIN95\SC2K\ to %~dp0..\SC2K\
	robocopy %scdrive%\WIN95\SC2K\ %~dp0..\SC2K\ /MIR

:PATCH_SC2K
	echo]
	echo **************************************************
	echo Applying SIMCITY.exe patch
	echo **************************************************
	REM RUNASINVOKER no need to run as administrator
	%~dp0\bspatch.exe %~dp0..\SC2K\SIMCITY.exe %~dp0..\SC2K\SIMCITY_PATCHED.exe %~dp0\SIMCITY.patch

:ENDBAT
echo Goodbye and note that SimCity special edition is available here and here:
echo     https://archive.org/details/SimCity2000_Special_Edition_Maxis-EA_Eng
echo     https://archive.org/details/SimCity_2000_Special_Edition_Maxis_Inc._1996

endlocal