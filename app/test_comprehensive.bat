@echo off
echo ========================================
echo Cricket Scoreboard - Comprehensive Test
echo ========================================
echo.

echo Step 1: Cleaning project...
flutter clean
if %errorlevel% neq 0 (
    echo ERROR: Flutter clean failed
    pause
    exit /b 1
)

echo.
echo Step 2: Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Flutter pub get failed
    pause
    exit /b 1
)

echo.
echo Step 3: Running static analysis...
flutter analyze
if %errorlevel% neq 0 (
    echo ERROR: Flutter analyze found issues
    pause
    exit /b 1
)

echo.
echo Step 4: Running tests...
flutter test
if %errorlevel% neq 0 (
    echo ERROR: Tests failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo All checks passed successfully!
echo ========================================
echo.
echo The Cricket Scoreboard app is ready to run.
echo You can now use:
echo   flutter run                    (main app)
echo   flutter run lib/main_debug.dart (debug version)
echo   flutter run lib/main_test.dart  (test version)
echo.
pause