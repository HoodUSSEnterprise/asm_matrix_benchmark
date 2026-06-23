/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:18
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 19:44:26
@FilePath: \asm_matrix_benchmark\src\C++\replace_matrix.cpp
@Description: replace matrix c++ code
*************************************************************/
#include "matrix_cpp.h"
#include <stdexcept>

/***********************************************************
@description:Replaces the element at the specified (x, y) position with a new value
@param {size_t} x
@param {size_t} y
@param {int} new_value
@return {*}
*************************************************************/
void MatrixInt::replace_pos(size_t x, size_t y, int new_value)
{
    if (x >= rows || y >= cols)
    {
        throw std::invalid_argument("replace_pos: coordinate out of range");
    }
    data[x * cols + y] = new_value;
}

/***********************************************************
@description:Replaces all occurrences of a specific value with a new value throughout the entire matrix
@param {int} old_value
@param {int} new_value
@return {*}
*************************************************************/
void MatrixInt::replace_elem(int old_value, int new_value)
{
    for (size_t i = 0; i < rows * cols; i++)
    {
        if (data[i] == old_value)
        {
            data[i] = new_value;
        }
    }
}
