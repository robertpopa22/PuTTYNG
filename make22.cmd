@echo off
echo.

REM Anchor to the script's own directory so the build works from any caller cwd
cd /d "%~dp0putty"
IF %ERRORLEVEL% NEQ 0 (echo putty source folder missing - run PuTTYNG.ps1 first && exit /b 1)

echo Starting
SET "_VSGEN=Visual Studio 17 2022"
if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" (
	SET "_VSPATHBASE=C:\Program Files\Microsoft Visual Studio\2022\Community"
)
if exist "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\VsDevCmd.bat" (
	SET "_VSPATHBASE=C:\Program Files\Microsoft Visual Studio\2022\Professional"
)
if exist "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat" (
	SET "_VSPATHBASE=C:\Program Files\Microsoft Visual Studio\2022\Enterprise"
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\Common7\Tools\VsDevCmd.bat" (
	SET "_VSPATHBASE=C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools"
	SET "_VSGEN=Visual Studio 18 2026"
)

echo.
call "%_VSPATHBASE%\Common7\Tools\VsDevCmd.bat" -arch=amd64 -host_arch=amd64
echo.
if exist "%_VSPATHBASE%\Common7\Tools\vsdevcmd\ext\vcvars.bat" call "%_VSPATHBASE%\Common7\Tools\vsdevcmd\ext\vcvars.bat"
echo.
if "%_VSGEN%"=="Visual Studio 18 2026" goto :nmake

echo configuring with %_VSGEN%...
cmake -G "%_VSGEN%" -A x64 .
IF %ERRORLEVEL% NEQ 0 (echo Error during configuration && exit /b %ERRORLEVEL% )
echo.
echo Building...
cmake --build . --config Release --target putty
IF %ERRORLEVEL% NEQ 0 (echo Error during building && exit /b %ERRORLEVEL% )
echo.
echo Renaming...
rename Release\putty.exe PuTTYNG.exe
echo Finished
echo.
goto :eof

:nmake
REM Build Tools SKUs are not always discoverable by the Visual Studio CMake
REM generator; NMake ships with every VC toolset and needs no discovery.
REM A leftover cache from another generator makes CMake refuse to configure.
if exist CMakeCache.txt del /q CMakeCache.txt
if exist CMakeFiles rmdir /s /q CMakeFiles
echo configuring with NMake (VS Build Tools)...
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release .
IF %ERRORLEVEL% NEQ 0 (echo Error during configuration && exit /b %ERRORLEVEL% )
echo.
echo Building...
cmake --build . --target putty
IF %ERRORLEVEL% NEQ 0 (echo Error during building && exit /b %ERRORLEVEL% )
echo.
echo Renaming...
if not exist Release mkdir Release
copy /y putty.exe Release\PuTTYNG.exe >nul
echo Finished
echo.