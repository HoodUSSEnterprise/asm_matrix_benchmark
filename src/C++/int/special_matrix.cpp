/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:30
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:59:02
@FilePath: \asm_matrix_benchmark\src\C++\int\special_matrix.cpp
@Description: special matrices c++ code
*************************************************************/

#include "matrix_int_cpp.h"
#include <cstdlib>
#include <ctime>

/***********************************************************
@description: creates an identity matrix of size n x n.
@param {size_t} n
@return {*}
*************************************************************/
MatrixInt MatrixInt::identity(size_t n)
{
    MatrixInt res(n, n);
    // Set diagonal elements to 1, all others remain 0
    for (size_t i = 0; i < n; i++)
    {
        res.data[i * n + i] = 1;
    }
    return res;
}

/***********************************************************
@description: creates a zero matrix of specified dimensions with all elements set to 0
@param {size_t} r
@param {size_t} c
@return {*}
*************************************************************/
MatrixInt MatrixInt::zeros(size_t r, size_t c)
{
    // Default constructor already zero-initializes all elements
    return MatrixInt(r, c);
}

/***********************************************************
@description: creates a matrix of specified dimensions with all elements set to 1
@param {size_t} r
@param {size_t} c
@return {*}
*************************************************************/
MatrixInt MatrixInt::ones(size_t r, size_t c)
{
    MatrixInt res(r, c);
    // Set every element to 1
    for (size_t i = 0; i < r * c; i++)
    {
        res.data[i] = 1;
    }
    return res;
}

/***********************************************************
@description: hat creates a matrix of specified dimensions with random integer elements uniformly distributed in the range [low, high)
@param {size_t} r
@param {size_t} c
@param {int} low
@param {int} high
@return {*}
*************************************************************/
MatrixInt MatrixInt::random(size_t r, size_t c, int low, int high)
{
    static bool seeded = false;
    if (!seeded)
    {
        std::srand(static_cast<unsigned>(std::time(nullptr)));
        seeded = true;
    }

    MatrixInt res(r, c);
    int range = high - low;
    // Fill with uniformly distributed random integers in [low, high)
    for (size_t i = 0; i < r * c; i++)
    {
        res.data[i] = low + (range > 0 ? std::rand() % range : 0);
    }
    return res;
}
