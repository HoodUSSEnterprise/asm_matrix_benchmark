/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:36:46
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 19:35:04
@FilePath: \asm_matrix_benchmark\src\C++\find_matrix.cpp
@Description: find matrix c++ code
*************************************************************/

#include "matrix_cpp.h"

/***********************************************************
@description:Searches for the first occurrence of a specified value in the matrix using row-major order
@param {int} value
@return {*}
*************************************************************/
std::pair<int, int> MatrixInt::find_elem(int value) const
{
    for (size_t i = 0; i < rows; i++)
    {
        for (size_t j = 0; j < cols; j++)
        {
            if (data[i * cols + j] == value)
            {
                return std::pair<int, int>(static_cast<int>(i), static_cast<int>(j));
            }
        }
    }
    return std::pair<int, int>(-1, -1);
}
