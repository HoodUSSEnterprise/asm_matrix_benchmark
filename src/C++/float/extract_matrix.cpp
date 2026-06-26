/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:10
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:04:19
@FilePath: \asm_matrix_benchmark\src\C++\float\extract_matrix.cpp
@Description: extract matrix c++ code
*************************************************************/

#include "matrix_float_cpp.h"
#include <stdexcept>

/***********************************************************
@description:  Extracts a single row from the matrix as a new 1-row matrix
@param {size_t} row_idx
@return {*}
*************************************************************/
MatrixFloat MatrixFloat::extract_row(size_t row_idx) const
{
    if (row_idx >= rows)
    {
        throw std::invalid_argument("extract_row: index out of range");
    }

    // Copy the entire row into a 1 x cols matrix
    MatrixFloat res(1, cols);
    for (size_t j = 0; j < cols; j++)
    {
        res.data[j] = data[row_idx * cols + j];
    }
    return res;
}

/***********************************************************
@description: Extracts a single col from the matrix as a new 1-row matrix
@param {size_t} col_idx
@return {*}
*************************************************************/
MatrixFloat MatrixFloat::extract_col(size_t col_idx) const
{
    if (col_idx >= cols)
    {
        throw std::invalid_argument("extract_col: index out of range");
    }

    // Copy the entire column into a rows x 1 matrix
    MatrixFloat res(rows, 1);
    for (size_t i = 0; i < rows; i++)
    {
        res.data[i] = data[i * cols + col_idx];
    }
    return res;
}

/***********************************************************
@description: Extracts a submatrix (contiguous block) from the matrix using half-open interval [r_start, r_end) x [c_start, c_end)
@param {size_t} r_start
@param {size_t} r_end
@param {size_t} c_start
@param {size_t} c_end
@return {*}
@throws {std::invalid_argument} If any of the following conditions are met:
        - r_start >= r_end (empty row range)
        - c_start >= c_end (empty column range)
        - r_end > rows (row range exceeds matrix bounds)
        - c_end > cols (column range exceeds matrix bounds)
*************************************************************/
MatrixFloat MatrixFloat::extract_submatrix(size_t r_start, size_t r_end, size_t c_start, size_t c_end) const
{
    if (r_start >= r_end || c_start >= c_end || r_end > rows || c_end > cols)
    {
        throw std::invalid_argument("extract_submatrix: invalid range");
    }

    size_t r_out = r_end - r_start;
    size_t c_out = c_end - c_start;
    MatrixFloat res(r_out, c_out);
    // Copy the contiguous block element by element
    for (size_t i = 0; i < r_out; i++)
    {
        for (size_t j = 0; j < c_out; j++)
        {
            res.data[i * c_out + j] = data[(r_start + i) * cols + (c_start + j)];
        }
    }
    return res;
}
