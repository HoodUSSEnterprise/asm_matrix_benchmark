/************************************************************
 @Author: HoodUSSEnterprise
 @Date: 2026-06-28
 @LastEditors: HoodUSSEnterprise
 @LastEditTime: 2026-06-28
 @FilePath: \asm_matrix_benchmark\example\matrix_int.java
 @Description: example of matrix int Java
*************************************************************/

public class matrix_int
{
    public static void main(String[] args)
    {
        int[] data = {1, 2, 3, 4};
        MatrixInt v1 = new MatrixInt(data, 2, 2);
        MatrixInt v2 = new MatrixInt(data, 1, 4);
        MatrixInt v3 = new MatrixInt(data, 2, 2);

        // add matrix example
        System.out.println("---------------------------------------add matrix---------------------------------------");
        MatrixInt v = v1.add(v2);
        MatrixInt m = v1.add(v3);
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
        int[] mulData = {1, 2, 3};
        MatrixInt mul1 = new MatrixInt(mulData, 3, 1);
        MatrixInt mul2 = new MatrixInt(mulData, 1, 3);
        m = mul1.mul(mul2);
        if (m != null) m.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // scale matrix example
        System.out.println("--------------------------------------scale matrix--------------------------------------");
        int[] scaleData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        MatrixInt scale = new MatrixInt(scaleData, 2, 5);
        scale.print();
        m = scale.scale(2);
        if (m != null) m.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // cat matrix example
        System.out.println("---------------------------------------cat matrix---------------------------------------");
        int[] catData1 = {1, 2, 3};
        int[] catData2 = {4, 5, 6, 7, 8, 9};
        MatrixInt catMatrix1 = new MatrixInt(catData1, 1, 3);
        MatrixInt catMatrix2 = new MatrixInt(catData2, 2, 3);
        m = catMatrix1.cat(catMatrix2, 0);
        if (m != null) m.print();
        MatrixInt catMatrix3 = new MatrixInt(catData1, 3, 1);
        MatrixInt catMatrix4 = new MatrixInt(catData2, 3, 2);
        m = catMatrix3.cat(catMatrix4, 1);
        if (m != null) m.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // find matrix example
        System.out.println("--------------------------------------find matrix---------------------------------------");
        int[] findData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        MatrixInt findMatrix = new MatrixInt(findData, 5, 2);
        findMatrix.print();
        int findElem = 5;
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
        int[] replaceData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        MatrixInt replaceMatrix = new MatrixInt(replaceData, 5, 2);
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
        int oldData = 7;
        int newData = 10;
        if (replaceMatrix.replaceByValue(oldData, newData))
        {
            replaceMatrix.print();
        }
        else
        {
            System.out.println(oldData + " has not in matrix");
        }
        oldData = 20;
        if (replaceMatrix.replaceByValue(oldData, newData))
        {
            replaceMatrix.print();
        }
        else
        {
            System.out.println(oldData + " has not in matrix");
        }
        System.out.println("----------------------------------------------------------------------------------------");

        // transpose matrix example
        System.out.println("------------------------------------transpose matrix------------------------------------");
        int[] transposeData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        MatrixInt rawMatrix = new MatrixInt(transposeData, 5, 2);
        rawMatrix.print();
        MatrixInt transposeMatrix = rawMatrix.transpose();
        if (transposeMatrix != null) transposeMatrix.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // special matrix example
        System.out.println("-------------------------------------special matrix-------------------------------------");
        MatrixInt identity = MatrixInt.identity(6);
        if (identity != null) identity.print();
        int[] diagData = {1, 2, 3, 4, 5};
        MatrixInt diag = MatrixInt.diag(diagData);
        if (diag != null) diag.print();
        MatrixInt eye = MatrixInt.eye(3, 4);
        if (eye != null) eye.print();
        MatrixInt zero = MatrixInt.zeros(10, 10);
        if (zero != null) zero.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // rank and trace example
        System.out.println("-------------------------------------rank and trace-------------------------------------");
        int[] rankData = {1, 2, 3, 4, 5, 6, 7, 8, 9};
        MatrixInt rankMatrix = new MatrixInt(rankData, 3, 3);
        int rank = rankMatrix.rank();
        if (rank != -1)
        {
            rankMatrix.print();
            System.out.println("matrix rank = " + rank);
        }
        MatrixInt traceMatrix = new MatrixInt(rankData, 3, 3);
        int trace = traceMatrix.trace();
        if (trace != 0)
        {
            traceMatrix.print();
            System.out.println("matrix trace = " + trace);
        }
        System.out.println("----------------------------------------------------------------------------------------");

        // compare matrix example
        System.out.println("-------------------------------------compare matrix-------------------------------------");
        int[] compareData1 = {1, 2, 3, 4, 5, 6};
        int[] compareData2 = {6, 5, 4, 3, 2, 1};
        MatrixInt compareMatrix1 = new MatrixInt(compareData1, 2, 3);
        MatrixInt compareMatrix2 = new MatrixInt(compareData1, 2, 3);
        MatrixInt compareMatrix3 = new MatrixInt(compareData2, 2, 3);
        MatrixInt compareMatrix4 = new MatrixInt(compareData1, 3, 2);
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
        int[] invData = {1, 2, 3, 0, 4, 5, 1, 0, 6};
        MatrixInt matrixOrigin = new MatrixInt(invData, 3, 3);
        MatrixDouble matrixInv = MatrixInt.inv(matrixOrigin);
        if (matrixInv != null) matrixInv.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // leading minors example
        System.out.println("-------------------------------------leading minors-------------------------------------");
        int[] leadingData = {1, 2, 3, 4, 5, 6, 7, 8, 9};
        MatrixInt leadingMatrix = new MatrixInt(leadingData, 3, 3);
        MatrixInt[] leadingMinors = leadingMatrix.getLeadingMinors();
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
        int[] luData = {1, 2, 3, 0, 4, 5, 1, 0, 6};
        MatrixInt luMatrix = new MatrixInt(luData, 3, 3);
        LUResult luRes = luMatrix.luDecomposition();
        if (luRes != null)
        {
            luRes.L.print();
            luRes.U.print();
        }
        System.out.println("----------------------------------------------------------------------------------------");

        // extract matrix example
        System.out.println("-------------------------------------extract matrix--------------------------------------");
        int[] extractData = {1, 2, 3, 4, 5, 6};
        MatrixInt extractMatrix = new MatrixInt(extractData, 2, 3);
        extractMatrix.print();
        MatrixInt extractRow = extractMatrix.extractRow(0);
        if (extractRow != null) extractRow.print();
        MatrixInt extractCol = extractMatrix.extractCol(1);
        if (extractCol != null) extractCol.print();
        System.out.println("extract diag: ");
        int[] extractDiag = extractMatrix.extractDiag();
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
        MatrixInt randMatrix1 = MatrixInt.random(3, 4, null);
        if (randMatrix1 != null) randMatrix1.print();
        int[] randRange = {5, 15};
        MatrixInt randMatrix2 = MatrixInt.random(2, 5, randRange);
        if (randMatrix2 != null) randMatrix2.print();
        int[] randRange2 = {20, 10};
        MatrixInt randMatrix3 = MatrixInt.random(4, 3, randRange2);
        if (randMatrix3 != null) randMatrix3.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // determinant example
        System.out.println("-------------------------------------determinant-----------------------------------------");
        int[] detData = {1, 2, 3, 4};
        MatrixInt detMatrix = new MatrixInt(detData, 2, 2);
        int det = detMatrix.determinant();
        System.out.println("determinant = " + det);
        System.out.println("----------------------------------------------------------------------------------------");
    }
}
