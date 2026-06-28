/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-28 09:01:40
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-28 09:01:59
@FilePath: \asm_matrix_benchmark\include\operator_fraction.h
@Description: operator of fraction
*************************************************************/
#ifndef OPERATOR_FRACTION_H
#define OPERATOR_FRACTION_H

#include "base_fraction.h"

/***********************************************************
@description: add fraction
@param {Fraction} *f1
@param {Fraction} *f2
@return {*}
*************************************************************/
Fraction add_fraction(Fraction *f1, Fraction *f2);

/***********************************************************
@description: sub fraction
@param {Fraction} *f1
@param {Fraction} *f2
@return {*}
*************************************************************/
Fraction sub_fraction(Fraction *f1, Fraction *f2);

/***********************************************************
@description: mul fraction
@param {Fraction} *f1
@param {Fraction} *f2
@return {*}
*************************************************************/
Fraction mul_fraction(Fraction *f1, Fraction *f2);

/***********************************************************
@description: div fraction
@param {Fraction} *f1
@param {Fraction} *f2
@return {*}
*************************************************************/
Fraction div_fraction(Fraction *f1, Fraction *f2);

#endif // OPERATOR_FRACTION_H