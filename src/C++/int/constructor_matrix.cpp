/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:38:25
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:56:23
@FilePath: \asm_matrix_benchmark\src\C++\int\constructor_matrix.cpp
@Description: constructor matrix
*************************************************************/

#include "matrix_int_cpp.h"
#include <cstring>

/***********************************************************
@description: Default constructor, creates an empty matrix (0 rows, 0 columns)
@return {*}
*************************************************************/
MatrixInt::MatrixInt() : rows(0), cols(0), data() {}

/***********************************************************
@description: Constructor with row and column parameters, creates a matrix of specified size and initializes all elements to 0
@param {size_t} r
@param {size_t} c
@param {r *} c
@return {*}
*************************************************************/
MatrixInt::MatrixInt(size_t r, size_t c) : rows(r), cols(c), data(r * c, 0) {}

/***********************************************************
@description: Constructor from a 1D array, fills the matrix in row-major order
@param {int} *arr
@param {size_t} r
@param {size_t} c
@param {r *} c
@return {*}
*************************************************************/
MatrixInt::MatrixInt(const int *arr, size_t r, size_t c) : rows(r), cols(c), data(r * c, 0)
{
    // Copy from raw pointer if non-null; otherwise all zeros
    if (arr)
    {
        for (size_t i = 0; i < r * c; i++)
        {
            data[i] = arr[i];
        }
    }
}

/***********************************************************
@description:Copy constructor, performs a deep copy of another matrix object
@param {MatrixInt} &other
@return {*}
*************************************************************/
MatrixInt::MatrixInt(const MatrixInt &other) : rows(other.rows), cols(other.cols), data(other.data) {}

/***********************************************************
@description:Move constructor, transfers resources from another matrix (efficient, avoids deep copying)
@param {MatrixInt} &
@return {*}
*************************************************************/
MatrixInt::MatrixInt(MatrixInt &&other) noexcept
    : rows(other.rows), cols(other.cols), data(std::move(other.data))
{
    // Reset source to empty state after stealing its data
    other.rows = 0;
    other.cols = 0;
}

/***********************************************************
@description:Copy assignment operator, performs a deep copy assignment from another matrix
@return {*}
*************************************************************/
MatrixInt &MatrixInt::operator=(const MatrixInt &other)
{
    if (this != &other)
    {
        rows = other.rows;
        cols = other.cols;
        data = other.data;
    }
    return *this;
}

/***********************************************************
@description:Move assignment operator, transfers resources from another matrix (efficient, avoids deep copying)
@return {*}
*************************************************************/
MatrixInt &MatrixInt::operator=(MatrixInt &&other) noexcept
{
    if (this != &other)
    {
        rows = other.rows;
        cols = other.cols;
        data = std::move(other.data);
        // Reset source to empty state after stealing its data
        other.rows = 0;
        other.cols = 0;
    }
    return *this;
}

/***********************************************************
@description:Overloaded function call operator (non-const version), accesses matrix element by row and column index, supports modification
@param {size_t} i
@param {size_t} j
@return {*}
*************************************************************/
int &MatrixInt::operator()(size_t i, size_t j)
{
    return data[i * cols + j];
}

/***********************************************************
@description:Overloaded function call operator (const version), accesses matrix element by row and column index, read-only
@param {size_t} i
@param {size_t} j
@return {*}
*************************************************************/
const int &MatrixInt::operator()(size_t i, size_t j) const
{
    return data[i * cols + j];
}
