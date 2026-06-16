@echo off
echo Build this program is %cd%

if not exist build mkdir build
cd build || exit /b 1

:: 使用 MinGW Makefiles
cmake .. -G "MinGW Makefiles" || exit /b 1
mingw32-make || exit /b 1

cd ..
echo Build Complete
pause
