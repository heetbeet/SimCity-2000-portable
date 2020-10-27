@echo off
setlocal

echo]
echo **************************************************
echo  Searching SimCity CD-ROM
echo **************************************************
echo]
for /f "skip=1 tokens=1,2" %%i in ('wmic logicaldisk get caption^, drivetype') do (
  set scdrive=%%i
  REM I'm too dumb for nested statements
  if [%%j]==[5] echo Searching drive %%i ...
  if [%%j]==[5] IF EXIST %%i\WIN95\SC2K\SIMCITY.EXE echo *** Found SC2K on %scdrive%\WIN95\SC2K\ 
  if [%%j]==[5] IF EXIST %%i\WIN95\SC2K\SIMCITY.EXE call :COPY_SC2K "%scdrive%" & call :ENDBAT & goto :EOF
)

echo Did not find a SC2K directory on any drive !!!
echo For an alternative installation method, copy your SC2K directory into App\SC2K

call :ENDBAT

goto :EOF

:COPY_SC2K <drive>
	echo]
	echo **************************************************
	echo  Copying SimCity files
	echo **************************************************
	echo]
	echo Copy files:
	echo   from "%~1\WIN95\SC2K"
	echo   to "%~dp0..\SC2K"
	robocopy "%scdrive%\WIN95\SC2K" "%~dp0..\SC2K" /MIR /njh /njs /ndl /nc /ns
goto :EOF

:ENDBAT
	echo]
	echo **************************************************
	echo  End of Installation script
	echo **************************************************
	echo]
	echo Note that SimCity special edition is available here and here:
	echo     https://archive.org/details/SimCity2000_Special_Edition_Maxis-EA_Eng
	echo     https://archive.org/details/SimCity_2000_Special_Edition_Maxis_Inc._1996
	echo]
goto :EOF
