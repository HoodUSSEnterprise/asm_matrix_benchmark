/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:45:21
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 19:56:00
@FilePath: \asm_matrix_benchmark\src\C++\print_matrix.cpp
@Description: print matrix c++ code
*************************************************************/
#include "matrix_cpp.h"

/***********************************************************
@description:  print matrix function
@return {*}
 ************************************************************/
void MatrixInt::print_matrix()
{
    std::cout << "------------------matrix info------------------" << std::endl;
    std::cout << "matrix size: (" << this->rows << "," << this->cols << ")" << std::endl;
    std::cout << "matrix data:" << std::endl;
    for (size_t i = 0; i < this->rows; ++i)
    {
        for (size_t j = 0; j < this->cols; ++j)
        {
            std::cout << this->data[i * this->cols + j];
            if (j + 1 < this->cols)
            {
                std::cout << ' ';
            }
        }
        std::cout << std::endl;
    }
}