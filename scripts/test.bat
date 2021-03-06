@echo off

rem Check if node and npm are installed
where node >nul 2>nul
if not errorlevel 0 (
    echo NodeJS is not installed. Please install it first.
	exit
)

rem Install missing modules
where sass >nul 2>nul
if not errorlevel 0 (
    npm install -g sass
)
where uglifyjs-folder >nul 2>nul
if not errorlevel 0 (
    npm install -g uglifyjs-folder
)

rem Parse all the sass files
call sass --no-source-map --style=compressed res\assets\scss\index.scss:res\assets\css\index.css >nul 2>&1
call sass --no-source-map --style=compressed res\assets\scss\login.scss:res\assets\css\login.css >nul 2>&1

rem Copy all the js files
call xcopy /s /y res\assets\src\pages res\assets\js >nul 2>&1
call copy res\assets\src\jquery.min.js res\assets\js\jquery.min.js >nul 2>&1
call uglifyjs-folder -y -o res\assets\js\panel.min.js -- res\assets\src\panel\ >nul 2>&1

rem Cleanup (and if non-existant, create) the /test folder
mkdir ".\test\" >nul 2>&1
mkdir ".\test\data\" >nul 2>&1
del ".\test\panel.json" >nul 2>&1

rem Copy the ijo to /test/panel
echo .git\ > exclude.txt
echo \test\ >> exclude.txt
echo \node_modules\ >> exclude.txt
xcopy ".\*" "..\.test-cache\panel\" /exclude:.\exclude.txt /d /h /y /e >nul 2>&1
xcopy "..\.test-cache\panel\*" ".\test\panel\" /d /h /y /e >nul 2>&1
xcopy ".\node_modules\*" ".\test\panel\node_modules\" /d /h /y /e >nul 2>&1
del ".\exclude.txt" >nul 2>&1

rem Ask user if machine needs to be installed
rem set /P machine="Do you need a machine to be installed (y/n): "
rem if "%machine%"=="y" (
rem 	echo "A machine has been intalled."
rem )

pushd ".\test\panel\"
rem Create the /data folder
rmdir /s /q ".\data" >nul 2>&1
mkdir ".\plugins" >nul 2>&1

rem Install the ijo command
call npm install -g >nul 2>&1
popd

rem Start IJO
pushd ".\test"
ijo start
popd