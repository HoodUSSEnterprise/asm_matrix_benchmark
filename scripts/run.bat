@echo off
echo run this program is %cd%

python example/matrix_int.py || exit /b 1

echo Run Complete
pause