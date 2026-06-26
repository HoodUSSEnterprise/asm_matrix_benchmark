/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:45:21
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:58:43
@FilePath: \asm_matrix_benchmark\src\C++\int\print_matrix.cpp
@Description: print matrix c++ code
*************************************************************/

#include "matrix_int_cpp.h"

/***********************************************************
@description: print matrix with operator <<
@return {*}
*************************************************************/
std::ostream &operator<<(std::ostream &os, const MatrixInt &m)
{
    os << "--------------------------------------------" << std::endl;
    os << "matrix size: (" << m.rows << ", " << m.cols << ")" << std::endl;
    os << "matrix data:" << std::endl;
    // Print elements row by row, space-separated
    for (size_t i = 0; i < m.rows; i++)
    {
        for (size_t j = 0; j < m.cols; j++)
        {
            os << m.data[i * m.cols + j];
            if (j + 1 < m.cols)
            {
                os << ' ';
            }
        }
        os << std::endl;
    }
    return os;
}
