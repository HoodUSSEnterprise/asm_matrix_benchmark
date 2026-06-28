/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-27 19:39:03
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-27 19:39:39
@FilePath: \asm_matrix_benchmark\src\C++\int\destructor_fraction.cpp
@Description: destructor of fraction
*************************************************************/
#include "matrix_int_cpp.h"

Fraction::~Fraction()
{
    x = 0;
    y = 0;
}