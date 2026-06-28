#!/usr/bin/env bash

echo "Compile and run this Java program is $(pwd)"

mkdir -p out

# Compile source files
javac -d out -sourcepath src/Java src/Java/Fraction.java src/Java/LUResult.java src/Java/MatrixInt.java src/Java/MatrixFloat.java src/Java/MatrixDouble.java || exit 1

# Compile example test files
javac -d out -sourcepath src/Java:example example/matrix_int.java example/matrix_float.java example/matrix_double.java || exit 1

# Run tests
echo ""
echo "========== MatrixInt Test =========="
java -cp out matrix_int || exit 1
echo ""

echo "========== MatrixFloat Test =========="
java -cp out matrix_float || exit 1
echo ""

echo "========== MatrixDouble Test =========="
java -cp out matrix_double || exit 1
echo ""

echo "Run Complete"
