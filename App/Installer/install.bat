@echo off
setlocal ENABLEDELAYEDEXPANSION

echo]
echo **************************************************
echo  Searching SimCity CD-ROM
echo **************************************************
echo]
for /f "skip=1 tokens=1,2" %%i in ('wmic logicaldisk get caption^, drivetype') do (
  set scdrive=%%i

  if [%%j]==[5] echo Searching drive %%i ...
  if [%%j]==[5] IF EXIST %%i\WIN95\SC2K\SIMCITY.EXE echo *** Found SC2K on %scdrive%\WIN95\SC2K\ 
  if [%%j]==[5] IF EXIST %%i\WIN95\SC2K\SIMCITY.EXE call :COPY_SC2K "%scdrive%" & goto :EOF
)

echo Did not find a SC2K directory on any drive !!!
echo For an alternative installation method, copy your SC2K directory into App\SC2K

call :ALTERNATIVE

goto :EOF

:COPY_SC2K <drive>
    echo:
    echo **************************************************
    echo  Copying SimCity files
    echo **************************************************
    echo:
    echo Copy files:
    echo   from "%~1\WIN95\SC2K"
    echo   to "%~dp0..\SC2K"
    robocopy "%scdrive%\WIN95\SC2K" "%~dp0..\SC2K" /MIR /njh /njs /ndl /nc /ns
goto :EOF

:ALTERNATIVE
    echo:
    echo **************************************************
    echo  archive.org installation
    echo **************************************************
    echo:
    echo Note that SimCity special edition is available here and here:
    echo     https://archive.org/details/SimCity2000_Special_Edition_Maxis-EA_Eng
    echo     https://archive.org/details/SimCity_2000_Special_Edition_Maxis_Inc._1996
    echo:


   set "answer="
   for %%a in (1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1) do (
       if /i "!answer!" neq "Y"  if /i "!answer!" neq "N" (
           set /P answer="Do you want to install SimCity from archive.org [Y/N]? " || set answer=xxxx
       )
   )
   echo:
   if /i "!answer!" equ "n" exit /b -1


    set downloadmethod=webclient
    call powershell  -NoP -Command "gcm Invoke-WebRequest" >nul 2>&1
    if "%errorlevel%" EQU "0" set downloadmethod=webrequest

    set /p downloadurl=<"%~dp0\simcityurl"

   :: Try downloading SimCity ten times
   for /L %%a in (1,1,1,1,1,1,1,1,1,1) do (
       if not exist "%~dp0\simcity.iso" (
           if "%downloadmethod%" equ "webclient" (
               powershell -NoP -Command "(New-Object Net.WebClient).DownloadFile(\"%downloadurl%\", '%~dp0\simcity.iso-temp')"
           ) else (
               powershell -NoP -Command "Invoke-WebRequest \"%downloadurl%\" -OutFile '%~dp0\simcity.iso-temp'"
           )
       )
       if "!errorlevel!" equ "0" (
           ren "%~dp0\simcity.iso-temp" "%~dp0\simcity.iso" 2>nul
       )
       if not exist "%~dp0\simcity.iso" (
           REM wait one seconds
           ping 127.0.0.1 -n 2 > nul
       )
   )

    "%~dp0\7z.exe" x "%~dp0\simcity.iso" -o"%~dp0\simcity"

    robocopy "%~dp0\simcity\WIN95\SC2K" "%~dp0..\SC2K" /MIR /njh /njs /ndl /nc /ns

    if exist "%~dp0..\SC2K" (
        powershell  -NoP -command "Remove-Item -Recurse -Force '%~dp0\simcity'"
        powershell  -NoP -command "Remove-Item -Force '%~dp0\simcity.iso'"
    )

goto :EOF
