/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-28
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-28 15:35:19
@FilePath: \asm_matrix_benchmark\src\Java\Fraction.java
@Description: Fraction class for exact integer determinant calculation
*************************************************************/

public class Fraction
{
    public int x; // numerator
    public int y; // denominator

    public Fraction()
    {
        this.x = 0;
        this.y = 1;
    }

    public Fraction(int x)
    {
        this.x = x;
        this.y = 1;
    }

    public Fraction(int x, int y)
    {
        this.x = x;
        this.y = y;
    }

    public static Fraction add(Fraction f1, Fraction f2)
    {
        Fraction res = new Fraction();
        res.x = f1.x * f2.y + f2.x * f1.y;
        res.y = f1.y * f2.y;
        return res;
    }

    public static Fraction sub(Fraction f1, Fraction f2)
    {
        Fraction res = new Fraction();
        res.x = f1.x * f2.y - f2.x * f1.y;
        res.y = f1.y * f2.y;
        return res;
    }

    public static Fraction mul(Fraction f1, Fraction f2)
    {
        Fraction res = new Fraction();
        res.x = f1.x * f2.x;
        res.y = f1.y * f2.y;
        return res;
    }

    public static Fraction div(Fraction f1, Fraction f2)
    {
        Fraction res = new Fraction();
        res.x = f1.x * f2.y;
        res.y = f1.y * f2.x;
        return res;
    }
}
