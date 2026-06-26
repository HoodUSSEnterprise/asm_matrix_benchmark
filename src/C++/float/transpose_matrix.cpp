/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:04
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:11:06
@FilePath: \asm_matrix_benchmark\src\C++\float\transpose_matrix.cpp
@Description: transpose matrix c++ code
*************************************************************/

#include "matrix_float_cpp.h"

/***********************************************************
@description:Computes the transpose of the matrix.
@return {*}
*************************************************************/
MatrixFloat MatrixFloat::transpose() const
{
    MatrixFloat res(cols, rows);
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
