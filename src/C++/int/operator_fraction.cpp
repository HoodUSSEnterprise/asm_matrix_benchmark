/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-27 19:40:53
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-27 20:03:52
@FilePath: \asm_matrix_benchmark\src\C++\int\operator_fraction.cpp
@Description: operation of fraction
*************************************************************/

#include "matrix_int_cpp.h"

static int gcd(int x, int y)
{
    return x % y == 0 ? y : gcd(y, x % y);
}

/***********************************************************
@description: add fraction
@return {*}
*************************************************************/
Fraction Fraction::operator+(const Fraction &other) const
{
    // calc numerator
    int up = x * other.y + other.x * y;
    // calc denominator
    int down = y * other.y;
    // calc greatest common divisor
    int divisor = gcd(up, down);
    up /= divisor;
    down /= divisor;
    return Fraction(up, down);
}

/***********************************************************
@description: sub fraction
@return {*}
*************************************************************/
Fraction Fraction::operator-(const Fraction &other) const
{
    // calc numerator
    int up = x * other.y - other.x * y;
    // calc denominator
    int down = y * other.y;
    // calc greatest common divisor
    int divisor = gcd(up, down);
    up /= divisor;
    down /= divisor;
    return Fraction(up, down);
}

/***********************************************************
@description: mul
@return {*}
*************************************************************/
Fraction Fraction::operator*(const Fraction &other) const
{
    // calc numerator
    int up = x * other.x;
    // calc denominator
    int down = y * other.y;
    // calc greatest common divisor
    int divisor = gcd(up, down);
    up /= divisor;
    down /= divisor;
    return Fraction(up, down);
}

/***********************************************************
@description: div fraction
@return {*}
*************************************************************/
Fraction Fraction::operator/(const Fraction &other) const
{
    // calc numerator
    int up = x * other.y;
    // calc denominator
    int down = y * other.x;
    // calc greatest common divisor
    int divisor = gcd(up, down);
    up /= divisor;
    down /= divisor;
    return Fraction(up, down);
}

/***********************************************************
@description: +=
@return {*}
*************************************************************/
Fraction &Fraction::operator+=(const Fraction &other)
{
    // calc numerator
    int up = x * other.y + other.x * y;
    // calc denominator
    int down = y * other.y;
    // calc greatest common divisor
    int divisor = gcd(up, down);
    up /= divisor;
    down /= divisor;
    x = up;
    y = down;
    return *this;
}

/***********************************************************
@description: -=
@return {*}
*************************************************************/
Fraction &Fraction::operator-=(const Fraction &other)
{
    // calc numerator
    int up = x * other.y - other.x * y;
    // calc denominator
    int down = y * other.y;
    // calc greatest common divisor
    int divisor = gcd(up, down);
    up /= divisor;
    down /= divisor;
    x = up;
    y = down;
    return *this;
}

/***********************************************************
@description: *=
@return {*}
*************************************************************/
Fraction &Fraction::operator*=(const Fraction &other)
{
    // calc numerator
    int up = x * other.x;
    // calc denominator
    int down = y * other.y;
    // calc greatest common divisor
    int divisor = gcd(up, down);
    up /= divisor;
    down /= divisor;
    x = up;
    y = down;
    return *this;
}

/***********************************************************
@description: /=
@return {*}
*************************************************************/
Fraction &Fraction::operator/=(const Fraction &other)
{
    // calc numerator
    int up = x * other.y;
    // calc denominator
    int down = y * other.x;
    // calc greatest common divisor
    int divisor = gcd(up, down);
    up /= divisor;
    down /= divisor;
    x = up;
    y = down;
    return *this;
}

/***********************************************************
@description: =
@return {*}
*************************************************************/
Fraction &Fraction::operator=(const Fraction &other)
{
    if (this != &other)
    {
        x = other.x;
        y = other.y;
    }
    return *this;
}

/***********************************************************
@description: =
@return {*}
*************************************************************/
Fraction &Fraction::operator=(Fraction &&other) noexcept
{
    if (this != &other)
    {
        x = other.x;
        y = other.y;
        other.x = 0;
        other.y = 0;
    }
    return *this;
}