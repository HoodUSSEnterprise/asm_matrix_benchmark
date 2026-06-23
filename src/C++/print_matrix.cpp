/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:45:21
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 19:21:21
@FilePath: \asm_matrix_benchmark\src\C++\print_matrix.cpp
@Description: print matrix c++ code
*************************************************************/
#include "matrix_cpp.h"

/***********************************************************
@description: print matrix with operator <<
@return {*}
*************************************************************/
std::ostream &operator<<(std::ostream &os, const MatrixInt &m)
{
    os << "--------------------------------------------" << std::endl;
    os << "matrix size: (" << m.rows << ", " << m.cols << ")" << std::endl;
    os << "matrix data:" << std::endl;
    for (size_t i = 0; i < m.rows; ++i)
    {
        for (size_t j = 0; j < m.cols; ++j)
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
