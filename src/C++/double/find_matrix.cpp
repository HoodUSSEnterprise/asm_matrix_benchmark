/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:36:46
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:54:58
@FilePath: \asm_matrix_benchmark\src\C++\double\find_matrix.cpp
@Description: find matrix c++ code
*************************************************************/

#include "matrix_double_cpp.h"

/***********************************************************
@description:Searches for the first occurrence of a specified value in the matrix using row-major order
@param {double} value
@return {*}
*************************************************************/
std::pair<int, int> MatrixDouble::find_elem(double value) const
{
    // Scan in row-major order for the first occurrence
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
    // Return (-1, -1) if not found
    return std::pair<int, int>(-1, -1);
}
