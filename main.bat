@echo off

@REM
@REM	* Dioxide Source Code, created by Hppsrc.
@REM	* Version 2.0.0
@REM	* Build 2503052201
@REM
@REM 	* Dioxide is a Zoxide clone made with in Windows Batch and Powershell.
@REM
@REM	* Source code on: https://github.com/hppsrc/dioxide
@REM	* Under the Apache 2.0 License, you are free to use, modify, and distribute this code, subject to the license terms.
@REM

@REM enable dev mode
if "%~n0" == "dev" ( echo on )
for %%a in (%*) do ( if "%%a" == "/dev" ( @echo on ) )

@REM #region VARIABLES

@REM variables
set version=2.0.0
set build=2503052201
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

for %%a in (%*) do ( if "%%a" == "/dev" ( set "arg=DEV" ) )

for %%a in (%*) do ( if "%%a" == "/help" ( set arg=1 ) )
for %%a in (%*) do ( if "%%a" == "/git" ( set arg=2 ) )
for %%a in (%*) do ( if "%%a" == "/b" ( set arg=3 ) )
for %%a in (%*) do ( if "%%a" == "/e" ( set arg=4 ) )
for %%a in (%*) do ( if "%%a" == "/n" ( set arg=5 ) )
for %%a in (%*) do ( if "%%a" == "/disk" ( set arg=6 ) )
for %%a in (%*) do ( if "%%a" == "/version" ( set arg=7 ) )
for %%a in (%*) do ( if "%%a" == "/service" ( set arg=8 ) )
for %%a in (%*) do ( if "%%a" == "/direct" ( GOTO :RunD ) )

for %%a in (%*) do ( if "%%a" == "/fi" ( GOTO :AdminCheck ) )
for %%a in (%*) do ( if "%%a" == "/fi-s" ( GOTO :AdminCheck ) )
for %%a in (%*) do ( if "%%a" == "/reset" ( GOTO :AdminCheck ) )
for %%a in (%*) do ( if "%%a" == "/install" ( GOTO :AdminCheck ) )
for %%a in (%*) do ( if "%%a" == "/uninstall" ( GOTO :AdminCheck ) )
if "%1" == "/na" (
    if "%~dp0" == "%dioxidePath%\bin\" (
        echo Dioxide Error: This command is disabled in the Dioxide installation.
        GOTO :ExitNoCLS
    ) else (
        GOTO :Install
    )
)

:RunCheck
if "%arg%" == "DEV" (
    if "%~dp0" == "%dioxidePath%\bin\" (
		GOTO :Run
	)
	GOTO :AdminCheck
)

if "%arg%" == "0" (
    @REM check if have to run: "dioxide is installed in the path"
    if "%~dp0" == "%dioxidePath%\bin\" ( GOTO :Run )
) else (
    GOTO :Args
)

@REM #region ADMIN CHECK

:AdminCheck
@REM check admin
net session >nul 2>&1
if %errorLevel% == 0 (

    if "%~dp0" == "%dioxidePath%\bin\" ( CALL :AdminCheckRun )
	for %%a in (%*) do ( if "%%a" == "/uninstall" ( GOTO :Uninstall ) )

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
echo If you are having problems you can re-install this version of Dioxide and restore Dioxide data.
echo This may fix any problem with dioxide.
echo.
choice /c YN /n /m "Press Y to continue, N to exit: "
if errorlevel 2 (
    @cls && echo on && title %cd% && GOTO :EOF
) else (
    copy /y "%~s0" "%temp%\dioxide_temp_installer.bat" >nul 2>&1
    echo start "" "%temp%\dioxide_temp_installer.bat" %%* > "%userprofile%\desktop\dioxide_%version%_installer.bat"
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

CALL :PreUse

if "%1"=="" (

    cd /d %userprofile%>nul 2>&1

@REM if arg
) else (

    @REM check if is a path
    if exist "%1" (

        cd /d %1>nul 2>&1

    )  else (

        @REM check ranking
        if exist "%dioxidePath%\service\ranks\%1" (

            for /f "delims=" %%i in ('type "%dioxidePath%\service\ranks\%1"') do (
                cd /d "%%i" >nul 2>&1
            )

        ) else (

            set error=4
            GOTO :Error

        )

    )

)

CALL :PostUse
GOTO :ExitNoCLS

:RunDi
cls
echo Dioxide interactive mode
echo ========================
echo Select an option of the list below:
echo.
powershell -Command "& { $rankFile = Get-Content (Join-Path $env:LOCALAPPDATA 'hppsrc\Dioxide\service\rank'); $rankLines = $rankFile | Where-Object { $_ -ne '' }; $rankings = @{}; for ($i = 0; $i -lt $rankLines.Count; $i += 2) { $rank = $rankLines[$i]; $path = ($rankLines[$i + 1] -split ';')[0]; $rankings[$path] = [int]$rank }; $files = Get-ChildItem (Join-Path $env:LOCALAPPDATA 'hppsrc\Dioxide\service\ranks') | Sort-Object LastWriteTime -Descending; $index = 1; $files | ForEach-Object { $path = Get-Content $_.FullName; $rank = if ($rankings.ContainsKey($path)) { $rankings[$path] } else { 1 }; Write-Host ('{0}.{1} (Usage: {3}) - Path: \"{2}\" ' -f $index, $_.Name, $path, $rank); $index++ }; Write-Host ''; $choice = Read-Host 'Select number'; if ($choice -match '^\d+$') { $selection = [int]$choice - 1; if ($selection -ge 0 -and $selection -lt $files.Count) { $selectedPath = Get-Content $files[$selection].FullName; Set-Content -Path (Join-Path $env:LOCALAPPDATA 'hppsrc\Dioxide\current') -Value $selectedPath -NoNewline } } }"

for /f "delims=" %%i in ('type "%dioxidePath%\current"') do (
    cd /d "%%i" >nul 2>&1
)
cls
GOTO :ExitNoCLS

@REM #region DIOXIDE ACTIONS

:PreUse
start /b "Dioxide Action" cmd /c "pathping 127.0.0.1 -n -q 1 -p 10 >nul && <nul set /p=%cd%> "%dioxidePath%\last""
GOTO :EOF

:PostUse
start /b "Dioxide Action" cmd /c "<nul set /p=%cd%> "%dioxidePath%\current""
if not exist "%dioxidePath%\.service" (
	start /min "Dioxide Service" powershell -ExecutionPolicy Bypass -WindowStyle Hidden -NoExit -Command "& '%dioxidePath%\bin\service.ps1'"
)
GOTO :EOF

@REM #region INSTALL CHECK

:CheckInstall
for %%a in (%*) do ( if "%%a" == "/fi" ( GOTO :Install ) )
for %%a in (%*) do ( if "%%a" == "/fi-s" ( set skip=1 && GOTO :Install ) )

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
    echo If you are not sure, check help using "%~nx0 /help"
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

for %%a in (%*) do ( if "%%a" == "/reset" ( set reset=1 ) )
if defined reset (
    echo RESET FLAG DETECTED.
    echo This will delete dioxide data.
	echo.
)

for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Dioxide" /v "Version"') do set regVersion=%%a
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Dioxide" /v "Build"') do set regBuild=%%a

set notfound=0
if not exist "%dioxidePath%\bin\" ( set notfound=1 )
if not exist "%dioxidePath%\bin\d.bat" ( set notfound=1 )
if not exist "%dioxidePath%\bin\service.ps1" ( set notfound=1 )

if %notfound%==1  (

    echo WARNING: Dioxide files not found!
    echo Dioxide keys are in your system, but the files or some files are not found.
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

for %%a in (%*) do ( if "%%a" == "/reset" ( set reset=1 ) )
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
powershell -Command "& { (Get-Content '%dioxidePath%\bin\d.bat' -tail 63 ) | Out-File '%dioxidePath%\bin\service.ps1'}"
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

if defined skip (
    timeout /t 1
) else (
	pause
)
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
reg delete "HKLM\SOFTWARE\Dioxide" /f >nul
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
    echo You can open it using "%~nx0 /git"
    echo.
    echo    /uninstall     : Uninstall Dioxide
    echo    /install       : Start install process
    echo    /service       : Toggle Dioxide service
    echo    /reset         : Reset Dioxide data
    echo    /disk          : Get disk usage by Dioxide
    echo    /help          : Show this help
    echo    /git           : Open Dioxide github repo
    echo    /fi            : Force install without checks
    @REM echo    /na            : Force no admin install
    echo.
    echo    /b             : Open last directory in explorer
    echo    /e             : Open new cmd in current directory
    echo    /n             : Open new cmd
    echo.
    echo Usage:
    echo.
    echo    d ^<command^>     : Run Dioxide command
    echo    d ^<path^>        : Run Dioxide
    @REM echo    di              : Run Dioxide interactive mode
    echo.
    echo Example:
    echo.
    echo    d /reset /install
    echo    d /help
    echo    d C:\Some\Path
    echo    d folder_name
    echo    d /b

) else if %arg%==2 (
    start https://github.com/hppsrc/dioxide
) else if %arg%==3 (
    if exist "%dioxidePath%\last" (
        for /f "delims=" %%i in ('type "%dioxidePath%\last"') do (
			cd /d "%%i" >nul 2>&1
		)
    ) else (
        echo Dioxide Error: Last path not found.
    )
    GOTO :ExitNoCLS
) else if %arg%==4 (
    start . >nul 2>&1
) else if %arg%==5 (
    start cmd >nul 2>&1
)  else if %arg%==6 (
    echo Loading...
    powershell -Command "& { if (Test-Path '%dioxidePath%') { $size = (Get-ChildItem '%dioxidePath%' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB; Write-Host ('Dioxide is using {0:N2} MB of disk space.' -f $size) } else { Write-Host 'Dioxide Error: Dioxide is not installed.' } }"
) else if %arg%==7 (
    echo Dioxide version %version% ^(%build%^)
) else if %arg%==8 (
	if exist "%dioxidePath%\.service" (
		echo Dioxide Service was enabled
		del /f "%dioxidePath%\.service"
	) else (
		echo Dioxide Service was disabled
		echo > "%dioxidePath%\.service"
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
    echo Dioxide Error: Couldn't find path "%1".
) else if "%error%" == "5" (
    echo Dioxide Error: Admin check failed.
) else (
    echo Dioxide Error: Unknown error.
)

GOTO :ExitNoCLS

@REM #region EXIT

:Exit

@GOTO :EOF && echo on && title %cd% && cls

:ExitNoCLS

@GOTO :EOF && echo on && title %cd%

@REM #region PS SERVICE

# variables
$DIOXIDE_PATH = $ENV:LOCALAPPDATA + "\hppsrc\dioxide"; $SERVICE_PATH = $DIOXIDE_PATH + "\service"

# get curret dir
$current = Get-Content -Path (Join-Path $DIOXIDE_PATH "current") -Raw; $current = $current.ToLower()

# create service path
New-Item -Path $SERVICE_PATH -ItemType "directory" -Force | Out-Null

# create rank file
if (-not (Test-Path (Join-Path $SERVICE_PATH "rank"))) {New-Item -Path $SERVICE_PATH -Name "rank" -ItemType "file" -Value "" | Out-Null }

# read rank file and get line of current path @REM TODO check 1. exact match 2. any match
$rank = Get-Content -Path (Join-Path $SERVICE_PATH "rank") -Raw

# get $current folder date
$creationTime = ((Get-Item $current).CreationTime).ToString("ssmmHHddMMyy")
$rankL = $rank -split "`n" | Select-String -Pattern ([regex]::Escape($current)+";"+$creationTime)

# if declared line, update rank
if ($rankL.LineNumber) {

    # get line and update his value
    $rankLine = $rank -split "`n" | Select-Object -Index ($rankL[0].LineNumber - 2)
    $new = $([int]$rankLine + 1)

    # set new value
    $rankArray = $rank -split "`n"
    $rankArray[$rankL[0].LineNumber - 2] = $new
    $rank = $rankArray -join "`n"
    Set-Content -Path (Join-Path $SERVICE_PATH "rank") -Value $rank

    # remove empty lines
    (Get-Content -Path (Join-Path $SERVICE_PATH "rank")) | Where-Object { $_ -ne "" } | Set-Content -Path (Join-Path $SERVICE_PATH "rank");

# else create new rank file
} else {

    # add current path to rank file, and c:\ to avoid missmatch on pattern
    Add-Content -Path (Join-Path $SERVICE_PATH "rank") -Value "1"; Add-Content -Path (Join-Path $SERVICE_PATH "rank") -Value ($current+";"+$creationTime)

}

# create rank files
$rank = Get-Content -Path (Join-Path $SERVICE_PATH "rank") -Raw
$rankL = $rank -split "`n"

for ($i = 0; $i -lt $rankL.Count; $i++) {
    # get values that are not ints
    if ( -not [int]::TryParse($rankL[$i], [ref]$null)) {
        # parse "path;date" to get path to the pase "C:\path" to get last string
        $path =  $rankL[$i] -split ";"
        $new =  $path[0] -split "\\"
        # if last string is not "" create a file with that name and set content as path
        if ( $new[-1] -ne "" ) {
            $rankPath = Join-Path $SERVICE_PATH "ranks"
            New-Item -ItemType File -Path (Join-Path $rankPath $new[-1]) -Force | Out-Null
            Set-Content -Path (Join-Path $rankPath $new[-1]) -Value ($path[0]) -Force -NoNewline
        }

    }

}