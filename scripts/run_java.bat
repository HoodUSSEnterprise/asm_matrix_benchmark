@echo off
echo Compile and run this Java program is %cd%

if not exist out mkdir out

:: Compile source files
javac -d out -sourcepath src/Java src/Java/Fraction.java src/Java/LUResult.java src/Java/MatrixInt.java src/Java/MatrixFloat.java src/Java/MatrixDouble.java || exit /b 1

:: Compile example test files
javac -d out -sourcepath src/Java;example example/matrix_int.java example/matrix_float.java example/matrix_double.java || exit /b 1

:: Run tests
echo.
echo ========== MatrixInt Test ==========
java -cp out matrix_int || exit /b 1
echo.

echo ========== MatrixFloat Test ==========
java -cp out matrix_float || exit /b 1
echo.

echo ========== MatrixDouble Test ==========
java -cp out matrix_double || exit /b 1
echo.

echo Run Complete
pause
