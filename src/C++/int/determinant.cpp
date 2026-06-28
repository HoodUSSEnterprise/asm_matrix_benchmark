/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-27 19:57:35
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-27 20:23:57
@FilePath: \asm_matrix_benchmark\src\C++\int\determinant.cpp
@Description: determinant of MatrixInt, use fraction to store data
*************************************************************/
#include "matrix_int_cpp.h"
#include <cmath>
#include <stdexcept>

/***********************************************************
@description: return fabs of fraction
@return {*}
*************************************************************/
double Fraction::myFabs()
{
    return fabs(x) * 1.0 / fabs(y);
}

/***********************************************************
@description: return real value of fraction, type int
@return {*}
*************************************************************/
int Fraction::real_valuei()
{
    if (x < y || x % y != 0)
    {
        throw std::invalid_argument("This is not an integer, and using it will result in loss of precision");
    }
    else
    {
        return x / y;
    }
}

/***********************************************************
@description: return real value of fraction, type double
@return {*}
*************************************************************/
double Fraction::real_valued()
{
    return x * 1.0 / y;
}

int MatrixInt::determinant()
{
    // check is or not square matrix
    if (rows != cols)
    {
        throw std::invalid_argument("determinant: square matrix required");
    }

    // init data with fraction
    std::vector<std::vector<Fraction>> data(rows);

    for (int i = 0; i < rows; i++)
    {
        data[i].resize(cols);
        for (size_t j = 0; j < cols; j++)
        {
            data[i][j] = Fraction(this->data[i * cols + j]);
        }
    }

    for (size_t r = 0, col = 0; col < cols && r < rows; col++)
    {
        // Find pivot: first row (at or below current) with non-zero entry in this column
        size_t pivot = r;
        while (pivot < rows && data[pivot][col].myFabs() < 1e-12)
        {
            pivot++;
        }
        if (pivot == rows)
        {
            return 0;
        }

        // Swap pivot row up to current rank position
        std::swap(data[r], data[pivot]);

        // Eliminate rows below using the pivot row
        for (size_t i = r + 1; i < rows; i++)
        {
            if (data[i][col].myFabs() >= 1e-12)
            {
                Fraction factor = data[i][col] / data[r][col];
                for (size_t j = col; j < cols; j++)
                {
                    data[i][j] -= factor * data[r][j];
                }
            }
        }
        r++;
    }

    // The product of diagonal elements is the value of the determinant
    Fraction res = Fraction(1, 1);
    for (size_t i = 0; i < cols; i++)
    {
        res *= data[i][i];
    }
    return res.real_valuei();
}