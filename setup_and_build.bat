@echo off
echo ============================================
echo   CommandGUI - Auto Build Script (26.1.2)
echo ============================================
echo.

:: Check if gradle wrapper jar exists, if not create it
if exist "gradle\wrapper\gradle-wrapper.jar" goto :build

echo [INFO] Creating Gradle Wrapper...

:: Try using existing gradle first
where gradle >nul 2>&1
if %ERRORLEVEL% equ 0 (
    gradle wrapper --gradle-version 9.4.0
    goto :build
)

:: Download gradle-wrapper.jar directly via PowerShell
echo [INFO] Downloading gradle-wrapper.jar...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/gradle/gradle/raw/v9.4.0/gradle/wrapper/gradle-wrapper.jar' -OutFile 'gradle\wrapper\gradle-wrapper.jar'"
if not exist "gradle\wrapper\gradle-wrapper.jar" (
    echo [ERROR] Could not get gradle-wrapper.jar
    echo Please install Gradle from https://gradle.org/releases/
    echo Then run: gradle wrapper --gradle-version 9.4.0
    pause
    exit /b 1
)

:build
echo.
echo [INFO] Building CommandGUI mod for Minecraft 26.1.2...
echo.
call gradlew.bat jar

if %ERRORLEVEL% equ 0 (
    echo.
    echo ============================================
    echo   BUILD SUCCESSFUL!
    echo   File: build\libs\commandgui-1.0.0.jar
    echo   Copy it to .minecraft\mods\
    echo ============================================
) else (
    echo.
    echo [ERROR] Build failed! Check output above.
)
pause
