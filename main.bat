@echo off

@REM Dioxide main script, created by Hppsrc. Get last version on https://github.com/hppsrc/dioxide

@REM enable dev mode
if "%~n0" == "dev" ( echo on )

@REM #region VARIABLES

@REM variables
set version=0.4.0-alpha
set build=250105232
set dioxidePath=%localappdata%\hppsrc\Dioxide
set error=0
set arg=0

@REM #region ARGS JUMP

@REM check args
if "%1" == "" (
    GOTO :RunCheck
)

set "check=%1"
if "%check:~0,1%"=="/" (
    set "arg="
    set "arg=-1"
)

if "%1" == "/help" ( set arg=1 )
if "%1" == "/git" ( set arg=2 )
if "%1" == "/b" ( set arg=3 )
if "%1" == "/e" ( set arg=4 )
if "%1" == "/n" ( set arg=5 )

if "%1" == "/service" ( set arg=99 )

if "%1" == "/install" ( GOTO :AdminCheck )
if "%1" == "/fi" ( GOTO :AdminCheck )
if "%1" == "/reset" ( GOTO :AdminCheck )
if "%1" == "/uninstall" ( GOTO :AdminCheck )

:RunCheck
if "%arg%" == "0" (
    @REM check if have to run: "dioxide is installed in the path"
    if "%~dp0" == "%dioxidePath%\bin\" ( GOTO :Run )
) else (
    GOTO :Args
)

@REM #region ADMIN CHECK

:AdminCheck
@REM cls
@REM check admin
net session >nul 2>&1
if %errorLevel% == 0 (

    if "%~dp0" == "%dioxidePath%\bin\" ( CALL :AdminCheckRun )

    if "%1" == "/uninstall" ( GOTO :Uninstall )

    GOTO :CheckInstall

    set error=5
    GOTO :Error

) else (

    if "%~dp0" == "%dioxidePath%\bin\" ( CALL :AdminCheckRun )

    echo Error: Admin rights required
    echo Restarting with admin rights...

    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %*", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"

    exit

)

:AdminCheckRun
echo You are trying to run an install command on the already installed Dioxide.
echo That's not necessary, but it will reinstall Dioxide.
echo Useful if you are having problems.
echo.
choice /c YN /n /m "Press Y to continue, N to exit: "
if errorlevel 2 (
    GOTO :Exit
) else (
    copy /y "%~s0" "%temp%\dioxide_temp_installer.bat" >nul 2>&1
    echo start "" "%temp%\dioxide_temp_installer.bat" /fi /reset > "%userprofile%\desktop\dioxide_%version%_installer.bat"
    echo.
    echo A copy of the installer was created on your desktop!
    pause
    exit
)

@REM #region RUN

:Run
@REM run d or di
if "%~nx0" == "d.bat" (
    GOTO :RunD
)
if "%~nx0" == "di.bat" (
    GOTO :RunDi
)

set error=1
GOTO :Error

:RunD
@REM if no args, go to userprofile
if "%1"=="" ( 

    CALL :PostUse    
    cd /d %userprofile%>nul 2>&1
    GOTO :ExitNoCLS

@REM if arg
) else (

    @REM check if is a path
    if exist "%1" (

        CALL :PostUse
        cd /d %1>nul 2>&1
        GOTO :ExitNoCLS

    )  else (

        @REM check ranking 
        echo >nul 2>&1

    )
    
)

:RunDi
@REM echo To implement...

GOTO :Args

@REM #region POST USE

:PostUse
start /b "" cmd /c "<nul set /p=%cd%> "%dioxidePath%\last""
@REM start /b "Dioxide Service" "%~f0" /service >nul 2>&1

GOTO :EOF

@REM #region INSTALL CHECK

:CheckInstall
if "%1" == "/fi" ( GOTO :Install )
@REM check if Dioxide is installed
title Installing Dioxide %version% ^(%build%^)
reg query "HKLM\SOFTWARE\Dioxide" >nul 2>&1

if "%errorLevel%" == "0" (

    GOTO :CheckVersion

) else (

    echo Dioxide installation process
    echo.
    echo Dioxide is not installed in your system.
    echo This will install Dioxide %version% in your system.
    echo.
    echo If you are not sure, check help using "%~nx0 --help"
    echo.
    choice /c YN /n /m "Press Y to install, N to exit: "
    if errorlevel 2 (
        GOTO :Exit
    ) else (
        GOTO :Install
    )

)

:CheckVersion
@REM cls
echo Seems like Dioxide is already installed in your system.
echo.

if "%1" == "/reset" ( set reset=1 )
if "%2" == "/reset" ( set reset=1 )
if defined reset (
    echo RESET FLAG DETECTED, BE CAREFUL.
)

for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Dioxide" /v "Version"') do set regVersion=%%a
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Dioxide" /v "Build"') do set regBuild=%%a

if not exist "%dioxidePath%\bin\" (

    echo WARNING: Dioxide files not found!
    echo Dioxide keys are in your system, but the files are not found.
    echo Please, continue the installation process to fix it.
    echo.

)

@REM check if build is lower
if "%regBuild%" == "%build%" (

    echo Dioxide %version% is already installed in your system.
    echo.
    choice /c YN /n /m "Press Y to reinstall, N to exit: "
    if errorlevel 2 (
        GOTO :ExitNoCLS
    ) else (
        GOTO :Install
    )

) else if "%build%" LSS "%regBuild%" (

    echo You are installing an older version of Dioxide.
    echo If you continue, you will go from %regVersion% ^(%regBuild%^) to %version% ^(%build%^)
    echo Also, you might have some unexpected behavior.
    echo.
    choice /c YN /n /m "Press Y to install, N to exit: "
    if errorlevel 2 (
        GOTO :ExitNoCLS
    ) else (
        GOTO :Install
    )

) else if "%build%" GTR "%regBuild%" (

    echo You are installing an newer version of Dioxide.
    echo If you continue, you will go from %regVersion% ^(%regBuild%^) to %version% ^(%build%^)
    echo.

    choice /c YN /n /m "Press Y to install, N to exit: "
    if errorlevel 2 (
        GOTO :ExitNoCLS
    ) else (
        GOTO :Install
    )

)

set error=2
GOTO :Error

@REM #region INSTALL 

:Install
cls

if "%1" == "/reset" ( set reset=1 )
if "%2" == "/reset" ( set reset=1 )
if defined reset (
    echo Resetting Dioxide data...
    rmdir /s /q "%dioxidePath%" >nul 2>&1
)

echo Installing Dioxide %version% ^(%build%^)...
echo.
echo Creating new files... [1/3]

copy /y "%~s0" "%temp%\dioxide.bat" >nul 2>&1
rmdir /s /q "%dioxidePath%\bin\" >nul 2>&1
mkdir "%dioxidePath%\bin\" >nul 2>&1
copy /y "%temp%\dioxide.bat" "%dioxidePath%\bin\d.bat" >nul 2>&1
copy /y "%temp%\dioxide.bat" "%dioxidePath%\bin\di.bat" >nul 2>&1
del "%temp%\dioxide.bat" >nul 2>&1
echo.

echo Creating reg keys... [2/3]
reg add "HKLM\SOFTWARE\Dioxide" /v "Version" /t REG_SZ /d "%version%" /f >nul 
reg add "HKLM\SOFTWARE\Dioxide" /v "Build" /t REG_SZ /d "%build%" /f >nul
echo.

echo Adding to path... [3/3] 
echo step 1/2...
powershell -Command "& { if (-not [Environment]::GetEnvironmentVariable('Path', 'User').contains('Dioxide')) { [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + $env:LOCALAPPDATA + '\hppsrc\Dioxide\bin', 'User'); exit 0 } else { exit 1} }"
echo step 2/2...
powershell -Command "& { if (-not [Environment]::GetEnvironmentVariable('Path', 'Machine').contains('Dioxide')) { [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + $env:LOCALAPPDATA + '\hppsrc\Dioxide\bin', 'Machine'); exit 0 } else { exit 1} }"
echo.

echo =========================

echo.
echo Dioxide installed successfully.
echo.
echo Restart your terminal to use Dioxide.
echo Use "d <path>" to run Dioxide.
echo.

echo =========================

echo.
pause
GOTO :ExitNoCLS

@REM #region UNINSTALL

:Uninstall

echo Dioxide uninstall process
echo.
echo This will uninstall Dioxide %version% ^(%build%^) from your system.
echo.
echo If you are having problems, you can reinstall Dioxide using "%~nx0 /fi /reset"
echo.
choice /c YN /n /m "Press Y to uninstall, N to exit: "
if errorlevel 2 (
    GOTO :Exit
) else (
    cls
)

echo Uninstalling Dioxide %version% ^(%build%^)...
echo.
echo Removing files... [1/3]
rmdir /s /q "%dioxidePath%" >nul 2>&1
echo.

echo Removing reg keys... [2/3]
reg delete "HKLM\SOFTWARE\Dioxide" /v "Version" /f >nul
reg delete "HKLM\SOFTWARE\Dioxide" /v "Build" /f >nul
echo.

echo Removing from path... [3/3]
echo step 1/2...
powershell -Command "& { if ([Environment]::GetEnvironmentVariable('Path', 'User').contains('Dioxide')) { [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'User').Replace($env:LOCALAPPDATA + '\hppsrc\Dioxide\bin', ''), 'User'); exit 0 } else { exit 1} }"
echo step 2/2...
powershell -Command "& { if ([Environment]::GetEnvironmentVariable('Path', 'Machine').contains('Dioxide')) { [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'Machine').Replace($env:LOCALAPPDATA + '\hppsrc\Dioxide\bin', ''), 'Machine'); exit 0 } else { exit 1} }"
echo.

echo =========================
echo.
echo Dioxide uninstalled successfully.
echo.
echo So sad to see you go :(
echo We hope to see you again soon!
echo.
echo =========================

echo.
pause
GOTO :ExitNoCLS

@REM #region ARGS

:Args
if %arg%==1 (

    echo Dioxide %version% ^(%build%^) Help
    echo.
    echo Dioxide is a command line tool to change directories more easily.
    echo Check the github repo at https://github.com/hppsrc/dioxide
    echo You can open it using "%~nx0 --git"
    echo.
    echo    /uninstall     : Uninstall Dioxide
    echo    /install       : Start install process
    echo    /reset         : Reset Dioxide data (can be used after /install, /fi^)
    echo    /help          : Show this help
    echo    /git           : Open Dioxide github repo
    echo    /fi            : Force install without checks
    echo.
    echo    /b             : Open last directory in explorer
    echo    /e             : Open new cmd in current directory
    echo    /n             : Open new cmd
    echo.
    echo Usage:
    echo.
    echo    d ^<command^>     : Run Dioxide command
    echo    d ^<path^>        : Run Dioxide
    echo    di                : Run Dioxide interactive mode
    echo.
    echo Example:
    echo.
    echo    d --help
    echo    d C:\Some\Path
    echo    d /b
    
) else if %arg%==2 (
    start https://github.com/hppsrc/dioxide
) else if %arg%==3 (
    if exist "%dioxidePath%\last" (
        set /p lastPath=<"%dioxidePath%\last"
        cd /d "%lastPath%"
    ) else (
        echo Dioxide Error: Last path not found.
    )
    GOTO :ExitNoCLS
) else if %arg%==4 (
    start . >nul 2>&1
) else if %arg%==5 (
    start cmd >nul 2>&1
) else if %arg%==99 (

    @REM Simple Dioxide explanation
    @REM Using PowerShell, update ranking for paths
    @REM This is a "service", so it will run in the background
    @REM It will update the ranking on every execution

    @REM read last path
    @REM (create and ) update rank file +1 to last path
    @REM create files for ranks 1 to 10

    if "%~n0" NEQ "service" (
        echo Dioxide background service

        echo This is a service to update the ranking of paths.
        echo It will run in the background and update the ranking on every execution.
        echo.
        echo It is not available to run directly.

    )
    
) else (
    set error=3
    GOTO :Error
) 

GOTO :ExitNoCLS

@REM #region ERROR

:Error
if "%error%" == "1" (
    echo Dioxide Error: Dioxide might be corrupted, install it again.
) else if "%error%" == "2" (
    echo Dioxide Error: Error on build check.
) else if "%error%" == "3" (
    echo Dioxide Error: Unknown command "%1".
) else if "%error%" == "4" (
    echo Dioxide Error: Path doesn't exist "%1".
) else if "%error%" == "5" (
    echo Dioxide Error: Admin check failed.
) else (
    echo Dioxide Error: Unknown error.
)

GOTO :ExitNoCLS

@REM #region EXIT

:Exit 

@echo on && title %cd% && cls

:ExitNoCLS

@echo on && title %cd%