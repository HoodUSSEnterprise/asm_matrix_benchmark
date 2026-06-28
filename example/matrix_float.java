/************************************************************
 @Author: HoodUSSEnterprise
 @Date: 2026-06-28
 @LastEditors: HoodUSSEnterprise
 @LastEditTime: 2026-06-28
 @FilePath: \asm_matrix_benchmark\example\matrix_float.java
 @Description: example of matrix float Java
*************************************************************/

public class matrix_float
{
    public static void main(String[] args)
    {
        float[] data = {1, 2, 3, 4};
        MatrixFloat v1 = new MatrixFloat(data, 2, 2);
        MatrixFloat v2 = new MatrixFloat(data, 1, 4);
        MatrixFloat v3 = new MatrixFloat(data, 2, 2);

        // add matrix example
        System.out.println("---------------------------------------add matrix---------------------------------------");
        MatrixFloat v = v1.add(v2);
        MatrixFloat m = v1.add(v3);
        if (v != null) v.print(); else System.out.println("add failed (expected)");
        if (m != null) m.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // sub matrix example
        System.out.println("---------------------------------------sub matrix---------------------------------------");
        v = v1.sub(v2);
        m = v1.sub(v3);
        if (v != null) v.print(); else System.out.println("sub failed (expected)");
        if (m != null) m.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // mul matrix example
        System.out.println("---------------------------------------mul matrix---------------------------------------");
        float[] mulData = {1, 2, 3};
        MatrixFloat mul1 = new MatrixFloat(mulData, 3, 1);
        MatrixFloat mul2 = new MatrixFloat(mulData, 1, 3);
        m = mul1.mul(mul2);
        if (m != null) m.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // scale matrix example
        System.out.println("--------------------------------------scale matrix--------------------------------------");
        float[] scaleData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        MatrixFloat scaleM = new MatrixFloat(scaleData, 2, 5);
        scaleM.print();
        m = scaleM.scale(2);
        if (m != null) m.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // cat matrix example
        System.out.println("---------------------------------------cat matrix---------------------------------------");
        float[] catData1 = {1, 2, 3};
        float[] catData2 = {4, 5, 6, 7, 8, 9};
        MatrixFloat catMatrix1 = new MatrixFloat(catData1, 1, 3);
        MatrixFloat catMatrix2 = new MatrixFloat(catData2, 2, 3);
        m = catMatrix1.cat(catMatrix2, 0);
        if (m != null) m.print();
        MatrixFloat catMatrix3 = new MatrixFloat(catData1, 3, 1);
        MatrixFloat catMatrix4 = new MatrixFloat(catData2, 3, 2);
        m = catMatrix3.cat(catMatrix4, 1);
        if (m != null) m.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // find matrix example
        System.out.println("--------------------------------------find matrix---------------------------------------");
        float[] findData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        MatrixFloat findMatrix = new MatrixFloat(findData, 5, 2);
        findMatrix.print();
        float findElem = 5;
        int[] pos = findMatrix.findElem(findElem);
        if (pos != null)
        {
            System.out.println("find elem");
            System.out.println("Position is (" + pos[0] + ", " + pos[1] + ")");
        }
        else
        {
            System.out.println("No find elem : " + findElem);
        }
        findElem = 11;
        pos = findMatrix.findElem(findElem);
        if (pos != null)
        {
            System.out.println("find elem");
            System.out.println("Position is (" + pos[0] + ", " + pos[1] + ")");
        }
        else
        {
            System.out.println("No find elem : " + findElem);
        }
        System.out.println("----------------------------------------------------------------------------------------");

        // replace matrix example
        System.out.println("-------------------------------------replace matrix-------------------------------------");
        float[] replaceData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        MatrixFloat replaceMatrix = new MatrixFloat(replaceData, 5, 2);
        int replaceX = 10, replaceY = 2;
        if (replaceMatrix.replaceByCoord(replaceX, replaceY, 10))
        {
            replaceMatrix.print();
        }
        else
        {
            System.out.println("(" + replaceX + ", " + replaceY + ") has out of index range");
        }
        replaceX = 0; replaceY = 0;
        if (replaceMatrix.replaceByCoord(replaceX, replaceY, 10))
        {
            replaceMatrix.print();
        }
        else
        {
            System.out.println("(" + replaceX + ", " + replaceY + ") has out of index range");
        }
        float oldDataF = 7;
        float newDataF = 10;
        if (replaceMatrix.replaceByValue(oldDataF, newDataF))
        {
            replaceMatrix.print();
        }
        else
        {
            System.out.println(oldDataF + " has not in matrix");
        }
        oldDataF = 20;
        if (replaceMatrix.replaceByValue(oldDataF, newDataF))
        {
            replaceMatrix.print();
        }
        else
        {
            System.out.println(oldDataF + " has not in matrix");
        }
        System.out.println("----------------------------------------------------------------------------------------");

        // transpose matrix example
        System.out.println("------------------------------------transpose matrix------------------------------------");
        float[] transposeData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        MatrixFloat rawMatrix = new MatrixFloat(transposeData, 5, 2);
        rawMatrix.print();
        MatrixFloat transposeMatrix = rawMatrix.transpose();
        if (transposeMatrix != null) transposeMatrix.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // special matrix example
        System.out.println("-------------------------------------special matrix-------------------------------------");
        MatrixFloat identity = MatrixFloat.identity(6);
        if (identity != null) identity.print();
        float[] diagData = {1, 2, 3, 4, 5};
        MatrixFloat diag = MatrixFloat.diag(diagData);
        if (diag != null) diag.print();
        MatrixFloat eye = MatrixFloat.eye(3, 4);
        if (eye != null) eye.print();
        MatrixFloat zero = MatrixFloat.zeros(10, 10);
        if (zero != null) zero.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // rank and trace example
        System.out.println("-------------------------------------rank and trace-------------------------------------");
        float[] rankData = {1, 2, 3, 4, 5, 6, 7, 8, 9};
        MatrixFloat rankMatrix = new MatrixFloat(rankData, 3, 3);
        int rank = rankMatrix.rank();
        if (rank != -1)
        {
            rankMatrix.print();
            System.out.println("matrix rank = " + rank);
        }
        MatrixFloat traceMatrix = new MatrixFloat(rankData, 3, 3);
        float trace = traceMatrix.trace();
        System.out.println("matrix trace = " + trace);
        System.out.println("----------------------------------------------------------------------------------------");

        // compare matrix example
        System.out.println("-------------------------------------compare matrix-------------------------------------");
        float[] compareData1 = {1, 2, 3, 4, 5, 6};
        float[] compareData2 = {6, 5, 4, 3, 2, 1};
        MatrixFloat compareMatrix1 = new MatrixFloat(compareData1, 2, 3);
        MatrixFloat compareMatrix2 = new MatrixFloat(compareData1, 2, 3);
        MatrixFloat compareMatrix3 = new MatrixFloat(compareData2, 2, 3);
        MatrixFloat compareMatrix4 = new MatrixFloat(compareData1, 3, 2);
        if (compareMatrix1.isEqual(compareMatrix2))
            System.out.println("Two matrix equals\n");
        else
            System.out.println("Two matrix not equals\n");
        if (compareMatrix1.isEqual(compareMatrix3))
            System.out.println("Two matrix equals\n");
        else
            System.out.println("Two matrix not equals\n");
        if (compareMatrix1.isEqual(compareMatrix4))
            System.out.println("Two matrix equals\n");
        else
            System.out.println("Two matrix not equals\n");
        System.out.println("----------------------------------------------------------------------------------------");

        // invertible matrix example
        System.out.println("-------------------------------------invertible matrix-------------------------------------");
        float[] invData = {1, 2, 3, 0, 4, 5, 1, 0, 6};
        MatrixFloat matrixOrigin = new MatrixFloat(invData, 3, 3);
        MatrixFloat matrixInv = MatrixFloat.inv(matrixOrigin);
        if (matrixInv != null) matrixInv.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // leading minors example
        System.out.println("-------------------------------------leading minors-------------------------------------");
        float[] leadingData = {1, 2, 3, 4, 5, 6, 7, 8, 9};
        MatrixFloat leadingMatrix = new MatrixFloat(leadingData, 3, 3);
        MatrixFloat[] leadingMinors = leadingMatrix.getLeadingMinors();
        if (leadingMinors != null)
        {
            for (int i = 0; i < leadingMinors.length; i++)
            {
                leadingMinors[i].print();
            }
        }
        System.out.println("----------------------------------------------------------------------------------------");

        // lu decomposition example
        System.out.println("-------------------------------------lu decomposition-------------------------------------");
        float[] luData = {1, 2, 3, 0, 4, 5, 1, 0, 6};
        MatrixFloat luMatrix = new MatrixFloat(luData, 3, 3);
        LUResult luRes = luMatrix.luDecomposition();
        if (luRes != null)
        {
            luRes.L.print();
            luRes.U.print();
        }
        System.out.println("----------------------------------------------------------------------------------------");

        // extract matrix example
        System.out.println("-------------------------------------extract matrix--------------------------------------");
        float[] extractData = {1, 2, 3, 4, 5, 6};
        MatrixFloat extractMatrix = new MatrixFloat(extractData, 2, 3);
        extractMatrix.print();
        MatrixFloat extractRow = extractMatrix.extractRow(0);
        if (extractRow != null) extractRow.print();
        MatrixFloat extractCol = extractMatrix.extractCol(1);
        if (extractCol != null) extractCol.print();
        System.out.println("extract diag: ");
        float[] extractDiag = extractMatrix.extractDiag();
        if (extractDiag != null)
        {
            for (int i = 0; i < extractDiag.length; i++)
            {
                System.out.print(extractDiag[i] + " ");
            }
            System.out.println();
        }
        System.out.println("----------------------------------------------------------------------------------------");

        // random matrix example
        System.out.println("-------------------------------------random matrix---------------------------------------");
        MatrixFloat randMatrix1 = MatrixFloat.random(3, 4, null);
        if (randMatrix1 != null) randMatrix1.print();
        float[] randRange = {5, 15};
        MatrixFloat randMatrix2 = MatrixFloat.random(2, 5, randRange);
        if (randMatrix2 != null) randMatrix2.print();
        float[] randRange2 = {20, 10};
        MatrixFloat randMatrix3 = MatrixFloat.random(4, 3, randRange2);
        if (randMatrix3 != null) randMatrix3.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // determinant example
        System.out.println("-------------------------------------determinant-----------------------------------------");
        float[] detData = {1, 2, 3, 4};
        MatrixFloat detMatrix = new MatrixFloat(detData, 2, 2);
        double det = detMatrix.determinant();
        System.out.println("determinant = " + det);
        System.out.println("----------------------------------------------------------------------------------------");
    }
}
