/************************************************************
 @Author: HoodUSSEnterprise
 @Date: 2026-06-28
 @LastEditors: HoodUSSEnterprise
 @LastEditTime: 2026-06-28
 @FilePath: \asm_matrix_benchmark\example\matrix_double.java
 @Description: example of matrix double Java
*************************************************************/

public class matrix_double
{
    public static void main(String[] args)
    {
        double[] data = {1, 2, 3, 4};
        MatrixDouble v1 = new MatrixDouble(data, 2, 2);
        MatrixDouble v2 = new MatrixDouble(data, 1, 4);
        MatrixDouble v3 = new MatrixDouble(data, 2, 2);

        // add matrix example
        System.out.println("---------------------------------------add matrix---------------------------------------");
        MatrixDouble v = v1.add(v2);
        MatrixDouble m = v1.add(v3);
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
        double[] mulData = {1, 2, 3};
        MatrixDouble mul1 = new MatrixDouble(mulData, 3, 1);
        MatrixDouble mul2 = new MatrixDouble(mulData, 1, 3);
        m = mul1.mul(mul2);
        if (m != null) m.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // scale matrix example
        System.out.println("--------------------------------------scale matrix--------------------------------------");
        double[] scaleData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        MatrixDouble scaleM = new MatrixDouble(scaleData, 2, 5);
        scaleM.print();
        m = scaleM.scale(2);
        if (m != null) m.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // cat matrix example
        System.out.println("---------------------------------------cat matrix---------------------------------------");
        double[] catData1 = {1, 2, 3};
        double[] catData2 = {4, 5, 6, 7, 8, 9};
        MatrixDouble catMatrix1 = new MatrixDouble(catData1, 1, 3);
        MatrixDouble catMatrix2 = new MatrixDouble(catData2, 2, 3);
        m = catMatrix1.cat(catMatrix2, 0);
        if (m != null) m.print();
        MatrixDouble catMatrix3 = new MatrixDouble(catData1, 3, 1);
        MatrixDouble catMatrix4 = new MatrixDouble(catData2, 3, 2);
        m = catMatrix3.cat(catMatrix4, 1);
        if (m != null) m.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // find matrix example
        System.out.println("--------------------------------------find matrix---------------------------------------");
        double[] findData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        MatrixDouble findMatrix = new MatrixDouble(findData, 5, 2);
        findMatrix.print();
        double findElem = 5;
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
        double[] replaceData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        MatrixDouble replaceMatrix = new MatrixDouble(replaceData, 5, 2);
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
        double oldDataD = 7;
        double newDataD = 10;
        if (replaceMatrix.replaceByValue(oldDataD, newDataD))
        {
            replaceMatrix.print();
        }
        else
        {
            System.out.println(oldDataD + " has not in matrix");
        }
        oldDataD = 20;
        if (replaceMatrix.replaceByValue(oldDataD, newDataD))
        {
            replaceMatrix.print();
        }
        else
        {
            System.out.println(oldDataD + " has not in matrix");
        }
        System.out.println("----------------------------------------------------------------------------------------");

        // transpose matrix example
        System.out.println("------------------------------------transpose matrix------------------------------------");
        double[] transposeData = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        MatrixDouble rawMatrix = new MatrixDouble(transposeData, 5, 2);
        rawMatrix.print();
        MatrixDouble transposeMatrix = rawMatrix.transpose();
        if (transposeMatrix != null) transposeMatrix.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // special matrix example
        System.out.println("-------------------------------------special matrix-------------------------------------");
        MatrixDouble identity = MatrixDouble.identity(6);
        if (identity != null) identity.print();
        double[] diagData = {1, 2, 3, 4, 5};
        MatrixDouble diag = MatrixDouble.diag(diagData);
        if (diag != null) diag.print();
        MatrixDouble eye = MatrixDouble.eye(3, 4);
        if (eye != null) eye.print();
        MatrixDouble zero = MatrixDouble.zeros(10, 10);
        if (zero != null) zero.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // rank and trace example
        System.out.println("-------------------------------------rank and trace-------------------------------------");
        double[] rankData = {1, 2, 3, 4, 5, 6, 7, 8, 9};
        MatrixDouble rankMatrix = new MatrixDouble(rankData, 3, 3);
        int rank = rankMatrix.rank();
        if (rank != -1)
        {
            rankMatrix.print();
            System.out.println("matrix rank = " + rank);
        }
        MatrixDouble traceMatrix = new MatrixDouble(rankData, 3, 3);
        double trace = traceMatrix.trace();
        System.out.println("matrix trace = " + trace);
        System.out.println("----------------------------------------------------------------------------------------");

        // compare matrix example
        System.out.println("-------------------------------------compare matrix-------------------------------------");
        double[] compareData1 = {1, 2, 3, 4, 5, 6};
        double[] compareData2 = {6, 5, 4, 3, 2, 1};
        MatrixDouble compareMatrix1 = new MatrixDouble(compareData1, 2, 3);
        MatrixDouble compareMatrix2 = new MatrixDouble(compareData1, 2, 3);
        MatrixDouble compareMatrix3 = new MatrixDouble(compareData2, 2, 3);
        MatrixDouble compareMatrix4 = new MatrixDouble(compareData1, 3, 2);
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
        double[] invData = {1, 2, 3, 0, 4, 5, 1, 0, 6};
        MatrixDouble matrixOrigin = new MatrixDouble(invData, 3, 3);
        MatrixDouble matrixInv = MatrixDouble.inv(matrixOrigin);
        if (matrixInv != null) matrixInv.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // leading minors example
        System.out.println("-------------------------------------leading minors-------------------------------------");
        double[] leadingData = {1, 2, 3, 4, 5, 6, 7, 8, 9};
        MatrixDouble leadingMatrix = new MatrixDouble(leadingData, 3, 3);
        MatrixDouble[] leadingMinors = leadingMatrix.getLeadingMinors();
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
        double[] luData = {1, 2, 3, 0, 4, 5, 1, 0, 6};
        MatrixDouble luMatrix = new MatrixDouble(luData, 3, 3);
        LUResult luRes = luMatrix.luDecomposition();
        if (luRes != null)
        {
            luRes.L.print();
            luRes.U.print();
        }
        System.out.println("----------------------------------------------------------------------------------------");

        // extract matrix example
        System.out.println("-------------------------------------extract matrix--------------------------------------");
        double[] extractData = {1, 2, 3, 4, 5, 6};
        MatrixDouble extractMatrix = new MatrixDouble(extractData, 2, 3);
        extractMatrix.print();
        MatrixDouble extractRow = extractMatrix.extractRow(0);
        if (extractRow != null) extractRow.print();
        MatrixDouble extractCol = extractMatrix.extractCol(1);
        if (extractCol != null) extractCol.print();
        System.out.println("extract diag: ");
        double[] extractDiag = extractMatrix.extractDiag();
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
        MatrixDouble randMatrix1 = MatrixDouble.random(3, 4, null);
        if (randMatrix1 != null) randMatrix1.print();
        double[] randRange = {5, 15};
        MatrixDouble randMatrix2 = MatrixDouble.random(2, 5, randRange);
        if (randMatrix2 != null) randMatrix2.print();
        double[] randRange2 = {20, 10};
        MatrixDouble randMatrix3 = MatrixDouble.random(4, 3, randRange2);
        if (randMatrix3 != null) randMatrix3.print();
        System.out.println("----------------------------------------------------------------------------------------");

        // determinant example
        System.out.println("-------------------------------------determinant-----------------------------------------");
        double[] detData = {1, 2, 3, 4};
        MatrixDouble detMatrix = new MatrixDouble(detData, 2, 2);
        double det = detMatrix.determinant();
        System.out.println("determinant = " + det);
        System.out.println("----------------------------------------------------------------------------------------");
    }
}
