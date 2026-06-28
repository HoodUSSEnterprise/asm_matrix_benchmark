/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-27 19:32:36
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-27 19:40:12
@FilePath: \asm_matrix_benchmark\src\C++\int\constructor_fraction.cpp
@Description: fraction constructor function
*************************************************************/

#include "matrix_int_cpp.h"

/***********************************************************
@description: Default constructor, creates an zero fraction
@return {*}
*************************************************************/
Fraction::Fraction() : x(0), y(1) {}

/***********************************************************
@description: Constructor with one number, create an integer
@param {int} x
@return {*}
*************************************************************/
Fraction::Fraction(int x) : x(x), y(1) {}

/***********************************************************
@description: Constructor with two number, create a fraction
@param {int} x
@param {int} y
@return {*}
*************************************************************/
Fraction::Fraction(int x, int y) : x(x), y(y) {}

/***********************************************************
@description: Copy constructor, performs a deep copy of another fraction object
@param {Fraction} &other
@return {*}
*************************************************************/
Fraction::Fraction(const Fraction &other) : x(other.x), y(other.y) {}

/***********************************************************
@description: Move constructor, transfers resources from another fraction
@param {Fraction} &
@return {*}
*************************************************************/
Fraction::Fraction(Fraction &&other) noexcept : x(other.x), y(other.y) {}