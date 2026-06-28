/************************************************************
 @Author: HoodUSSEnterprise
 @Date: 2026-06-28
 @LastEditors: HoodUSSEnterprise
 @LastEditTime: 2026-06-28
 @FilePath: \asm_matrix_benchmark\src\Java\LUResult.java
 @Description: LU decomposition result (holds L and U as MatrixDouble)
*************************************************************/

public class LUResult
{
    public MatrixDouble L;
    public MatrixDouble U;

    public LUResult()
    {
        this.L = null;
        this.U = null;
    }

    public LUResult(MatrixDouble L, MatrixDouble U)
    {
        this.L = L;
        this.U = U;
    }
}
