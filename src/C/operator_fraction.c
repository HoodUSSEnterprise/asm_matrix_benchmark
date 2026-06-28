/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-28 09:01:24
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-28 09:06:27
@FilePath: \asm_matrix_benchmark\src\C\operator_fraction.c
@Description: operator of fraction c code
*************************************************************/
#include "operator_fraction.h"

/***********************************************************
@description: calc greatest common divisor of x and y
@param {int} x
@param {int} y
@return {*}
*************************************************************/
static int gcd(int x, int y)
{
    return x % y == 0 ? y : gcd(y, x % y);
}

/***********************************************************
@description: add fraction
@param {Fraction} *f1
@param {Fraction} *f2
@return {*}
*************************************************************/
Fraction add_fraction(Fraction *f1, Fraction *f2)
{
    Fraction res = {0, 0};
    // calc x
    res.x = f1->x * f2->y + f2->x * f1->y;
    // calc y
    res.y = f1->y * f2->y;
    // calc greatest common divisor
    int divsor = gcd(res.x, res.y);
    res.x /= divsor;
    res.y /= divsor;
    return res;
}

/***********************************************************
@description: sub fraction
@param {Fraction} *f1
@param {Fraction} *f2
@return {*}
*************************************************************/
Fraction sub_fraction(Fraction *f1, Fraction *f2)
{
    Fraction res = {0, 0};
    // calc x
    res.x = f1->x * f2->y - f2->x * f1->y;
    // calc y
    res.y = f1->y * f2->y;
    // calc greatest common divisor
    int divsor = gcd(res.x, res.y);
    res.x /= divsor;
    res.y /= divsor;
    return res;
}

/***********************************************************
@description: mul fraction
@param {Fraction} *f1
@param {Fraction} *f2
@return {*}
*************************************************************/
Fraction mul_fraction(Fraction *f1, Fraction *f2)
{
    Fraction res = {0, 0};
    // calc x
    res.x = f1->x * f2->x;
    // calc y
    res.y = f1->y * f2->y;
    // calc greatest common divisor
    int divsor = gcd(res.x, res.y);
    res.x /= divsor;
    res.y /= divsor;
    return res;
}

/***********************************************************
@description: div fraction
@param {Fraction} *f1
@param {Fraction} *f2
@return {*}
*************************************************************/
Fraction div_fraction(Fraction *f1, Fraction *f2)
{
    Fraction res = {0, 0};
    // calc x
    res.x = f1->x * f2->y;
    // calc y
    res.y = f1->y * f2->x;
    // calc greatest common divisor
    int divsor = gcd(res.x, res.y);
    res.x /= divsor;
    res.y /= divsor;
    return res;
}