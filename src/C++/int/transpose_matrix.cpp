/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:04
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:59:13
@FilePath: \asm_matrix_benchmark\src\C++\int\transpose_matrix.cpp
@Description: transpose matrix c++ code
*************************************************************/

#include "matrix_int_cpp.h"

/***********************************************************
@description:Computes the transpose of the matrix.
@return {*}
*************************************************************/
MatrixInt MatrixInt::transpose() const
{
    MatrixInt res(cols, rows);
    // Swap rows and cols: element (i,j) goes to (j,i)
    for (size_t i = 0; i < rows; i++)
    {
        for (size_t j = 0; j < cols; j++)
        {
            res.data[j * rows + i] = data[i * cols + j];
        }
    }
    return res;
}
