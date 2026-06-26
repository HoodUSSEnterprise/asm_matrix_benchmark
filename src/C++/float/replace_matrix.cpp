/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:18
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:06:57
@FilePath: \asm_matrix_benchmark\src\C++\float\replace_matrix.cpp
@Description: replace matrix c++ code
*************************************************************/

#include "matrix_float_cpp.h"
#include <stdexcept>

/***********************************************************
@description:Replaces the element at the specified (x, y) position with a new value
@param {size_t} x
@param {size_t} y
@param {float} new_value
@return {*}
*************************************************************/
void MatrixFloat::replace_pos(size_t x, size_t y, float new_value)
{
    if (x >= rows || y >= cols)
    {
        throw std::invalid_argument("replace_pos: coordinate out of range");
    }
    // Direct indexed assignment to position (x, y)
    data[x * cols + y] = new_value;
}

/***********************************************************
@description:Replaces all occurrences of a specific value with a new value throughout the entire matrix
@param {float} old_value
@param {float} new_value
@return {*}
*************************************************************/
void MatrixFloat::replace_elem(float old_value, float new_value)
{
    // Scan all elements and replace matching values
    for (size_t i = 0; i < rows * cols; i++)
    {
        if (data[i] == old_value)
        {
            data[i] = new_value;
        }
    }
}
