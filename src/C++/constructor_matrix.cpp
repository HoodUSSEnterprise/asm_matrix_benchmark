/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:38:25
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 19:42:24
@FilePath: \asm_matrix_benchmark\src\C++\constructor_matrix.cpp
@Description: constructor matrix
*************************************************************/
#include "matrix_cpp.h"

MatrixInt::MatrixInt()
    : rows(0), cols(0), data()
{
    initialize(0, 0);
}

MatrixInt::MatrixInt(size_t r, size_t c)
    : rows(r), cols(c), data(r * c, 0)
{
    initialize(r, c);
}

MatrixInt::MatrixInt(const MatrixInt &other)
    : rows(other.rows), cols(other.cols), data(other.data)
{
}

MatrixInt::MatrixInt(const int *arr, size_t r, size_t c)
    : rows(r), cols(c), data(r * c, 0)
{
    initialize(r, c);
    if (arr)
    {
        for (size_t i = 0; i < r * c; ++i)
        {
            data[i] = arr[i];
        }
    }
}

void MatrixInt::initialize(size_t r, size_t c)
{
    rows = r;
    cols = c;
    data.assign(r * c, 0);
}
