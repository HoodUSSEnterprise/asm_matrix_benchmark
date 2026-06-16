/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:02:24
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 19:51:44
@FilePath: \asm_matrix_benchmark\include\matrix_cpp.h
@Description: matrix C++ head file
*************************************************************/
#ifndef MATRIX_CPP_H
#define MATRIX_CPP_H

#include <iostream>
#include <vector>

class MatrixInt
{
private:
    size_t rows;
    size_t cols;
    std::vector<int> data;
    void initialize(size_t r, size_t c);
    void cleanup();

public:
    MatrixInt();
    MatrixInt(size_t r, size_t c);
    MatrixInt(const int *arr, size_t r, size_t c);
    MatrixInt(const MatrixInt &other);
    ~MatrixInt();

    MatrixInt add_matrix(MatrixInt m1, MatrixInt m2);

    MatrixInt sub_matrix(MatrixInt m1, MatrixInt m2);

    MatrixInt mul_matrix(MatrixInt m1, MatrixInt m2);

    MatrixInt scale_matrix(MatrixInt m1, int m2);

    void print_matrix();
};

#endif // MATRIX_CPP_H