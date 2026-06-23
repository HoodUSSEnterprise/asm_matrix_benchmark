/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:36:45
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 19:30:59
@FilePath: \asm_matrix_benchmark\src\C++\compare_matrix.cpp
@Description: compare matrix c++ code
*************************************************************/

#include "matrix_cpp.h"

/***********************************************************
@description:Equality comparison operator, checks if two matrices have the same dimensions and identical elements
@return {*}
*************************************************************/
bool MatrixInt::operator==(const MatrixInt &other) const
{
    if (rows != other.rows || cols != other.cols)
    {
        return false;
    }
    for (size_t i = 0; i < rows * cols; ++i)
    {
        if (data[i] != other.data[i])
        {
            return false;
        }
    }
    return true;
}

/***********************************************************
@description:Inequality comparison operator, checks if two matrices are different
@return {*}
*************************************************************/
bool MatrixInt::operator!=(const MatrixInt &other) const
{
    return !(*this == other);
}
