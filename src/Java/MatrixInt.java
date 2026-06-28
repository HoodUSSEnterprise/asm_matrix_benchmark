/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-28
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-28 15:35:10
@FilePath: \asm_matrix_benchmark\src\Java\MatrixInt.java
@Description: Matrix int Java class
*************************************************************/

public class MatrixInt
{
    private int[] data;
    private int rows;
    private int cols;

    /***********************************************************
    @description: Constructor with row and column parameters (zero-initialized)
    ************************************************************/
    public MatrixInt(int rows, int cols)
    {
        this.rows = rows;
        this.cols = cols;
        this.data = new int[rows * cols];
    }

    /***********************************************************
    @description: Constructor from a 1D array
    ************************************************************/
    public MatrixInt(int[] arr, int rows, int cols)
    {
        this.rows = rows;
        this.cols = cols;
        this.data = new int[rows * cols];
        if (arr != null)
        {
            System.arraycopy(arr, 0, this.data, 0, rows * cols);
        }
    }

    /***********************************************************
    @description: Copy constructor
    ************************************************************/
    public MatrixInt(MatrixInt other)
    {
        this.rows = other.rows;
        this.cols = other.cols;
        this.data = new int[other.rows * other.cols];
        System.arraycopy(other.data, 0, this.data, 0, other.rows * other.cols);
    }

    /***********************************************************
    @description: Get rows
    ************************************************************/
    public int getRows() { return rows; }

    /***********************************************************
    @description: Get cols
    ************************************************************/
    public int getCols() { return cols; }

    /***********************************************************
    @description: Get element at (i, j)
    ************************************************************/
    public int get(int i, int j) { return data[i * cols + j]; }

    /***********************************************************
    @description: Set element at (i, j)
    ************************************************************/
    public void set(int i, int j, int val) { data[i * cols + j] = val; }

    /***********************************************************
    @description: add matrix
    ************************************************************/
    public MatrixInt add(MatrixInt other)
    {
        if (other == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (other.data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (rows != other.rows || cols != other.cols)
        {
            System.out.println("Dimension mismatch! m1(" + cols + ", " + other.cols + ") vs m2(" + rows + ", " + other.rows + ")");
            return null;
        }
        MatrixInt res = new MatrixInt(rows, cols);
        for (int i = 0; i < rows * cols; i++)
        {
            res.data[i] = data[i] + other.data[i];
        }
        return res;
    }

    /***********************************************************
    @description: sub matrix
    ************************************************************/
    public MatrixInt sub(MatrixInt other)
    {
        if (other == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (other.data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (rows != other.rows || cols != other.cols)
        {
            System.out.println("Dimension mismatch! m1(" + cols + ", " + other.cols + ") vs m2(" + rows + ", " + other.rows + ")");
            return null;
        }
        MatrixInt res = new MatrixInt(rows, cols);
        for (int i = 0; i < rows * cols; i++)
        {
            res.data[i] = data[i] - other.data[i];
        }
        return res;
    }

    /***********************************************************
    @description: mul matrix
    ************************************************************/
    public MatrixInt mul(MatrixInt other)
    {
        if (other == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (other.data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (cols != other.rows)
        {
            System.out.println("Dimension mismatch! m1(" + cols + ", " + other.cols + ") vs m2(" + rows + ", " + other.rows + ")");
            return null;
        }
        MatrixInt res = new MatrixInt(rows, other.cols);
        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < other.cols; j++)
            {
                int sum = 0;
                for (int k = 0; k < cols; k++)
                {
                    sum += data[i * cols + k] * other.data[k * other.cols + j];
                }
                res.data[i * res.cols + j] = sum;
            }
        }
        return res;
    }

    /***********************************************************
    @description: scale matrix
    ************************************************************/
    public MatrixInt scale(int scalar)
    {
        MatrixInt res = new MatrixInt(rows, cols);
        for (int i = 0; i < rows * cols; i++)
        {
            res.data[i] = data[i] * scalar;
        }
        return res;
    }

    /***********************************************************
    @description: cat matrix, axis: 1 means horizon, 0 means vertical
    ************************************************************/
    public MatrixInt cat(MatrixInt other, int axis)
    {
        if (other == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (other.data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (axis == 0)
        {
            if (cols != other.cols)
            {
                System.out.println("Dimension mismatch! m1(" + rows + ", " + cols + ") vs m2(" + other.rows + ", " + other.cols + ")");
                return null;
            }
            MatrixInt res = new MatrixInt(rows + other.rows, cols);
            for (int i = 0; i < res.rows; i++)
            {
                for (int j = 0; j < res.cols; j++)
                {
                    if (i < rows)
                    {
                        res.data[i * res.cols + j] = data[i * cols + j];
                    }
                    else
                    {
                        res.data[i * res.cols + j] = other.data[(i - rows) * cols + j];
                    }
                }
            }
            return res;
        }
        else if (axis == 1)
        {
            if (rows != other.rows)
            {
                System.out.println("Dimension mismatch! m1(" + rows + ", " + cols + ") vs m2(" + other.rows + ", " + other.cols + ")");
                return null;
            }
            int resCols = cols + other.cols;
            MatrixInt res = new MatrixInt(rows, resCols);
            for (int i = 0; i < rows; i++)
            {
                for (int j = 0; j < cols; j++)
                {
                    res.data[i * resCols + j] = data[i * cols + j];
                }
                for (int j = 0; j < other.cols; j++)
                {
                    res.data[i * resCols + cols + j] = other.data[i * other.cols + j];
                }
            }
            return res;
        }
        else
        {
            System.out.println("Wrong value, axis must be 0 or 1");
            return null;
        }
    }

    /***********************************************************
    @description: find elem position in matrix
    @return {int[]} {row, col} or null if not found
    ************************************************************/
    public int[] findElem(int elem)
    {
        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < cols; j++)
            {
                if (data[i * cols + j] == elem)
                {
                    return new int[]{i, j};
                }
            }
        }
        return null;
    }

    /***********************************************************
    @description: replace matrix element by coordinate
    @return {boolean} true if successful
    ************************************************************/
    public boolean replaceByCoord(int x, int y, int newData)
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return false;
        }
        // Note: matching C behavior — checks x against cols, y against rows
        if (x >= cols || y >= rows)
        {
            System.out.println("index out of range");
            return false;
        }
        data[x * cols + y] = newData;
        return true;
    }

    /***********************************************************
    @description: replace matrix element by value (replaces all occurrences)
    @return {boolean} true if at least one replacement was made
    ************************************************************/
    public boolean replaceByValue(int oldData, int newData)
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return false;
        }
        int[] pos = findElem(oldData);
        if (pos == null)
        {
            return false;
        }
        while (pos != null)
        {
            data[pos[0] * cols + pos[1]] = newData;
            pos = findElem(oldData);
        }
        return true;
    }

    /***********************************************************
    @description: transpose matrix
    ************************************************************/
    public MatrixInt transpose()
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        MatrixInt res = new MatrixInt(cols, rows);
        for (int i = 0; i < res.rows; i++)
        {
            for (int j = 0; j < res.cols; j++)
            {
                res.data[i * res.cols + j] = data[j * cols + i];
            }
        }
        return res;
    }

    /***********************************************************
    @description: compare two matrices for equality
    ************************************************************/
    public boolean isEqual(MatrixInt other)
    {
        if (other == null || other.data == null)
        {
            System.err.println("Invalid param!");
            return false;
        }
        if (data == null)
        {
            System.err.println("Invalid param!");
            return false;
        }
        if (cols != other.cols || rows != other.rows)
        {
            System.out.println("Dimension mismatch! m1(" + cols + ", " + other.cols + ") vs m2(" + rows + ", " + other.rows + ")");
            return false;
        }
        for (int i = 0; i < rows * cols; i++)
        {
            if (data[i] != other.data[i])
            {
                return false;
            }
        }
        return true;
    }

    /***********************************************************
    @description: compute rank of matrix using Gaussian elimination
    @return {int} rank, or -1 on error
    ************************************************************/
    public int rank()
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return -1;
        }
        if (rows == 0 || cols == 0)
        {
            System.err.println("Invalid param!");
            return -1;
        }
        // copy to double
        double[] tmp = new double[rows * cols];
        for (int i = 0; i < rows * cols; i++)
        {
            tmp[i] = data[i] * 1.0;
        }

        // Gaussian elimination
        int r = 0;
        for (int c = 0; r < rows && c < cols; c++)
        {
            // find pivot
            int pivot = r;
            while (pivot < rows && Math.abs(tmp[pivot * cols + c]) < 1e-6)
            {
                pivot++;
            }
            if (pivot == rows)
            {
                continue;
            }
            // swap rows
            if (pivot != r)
            {
                for (int j = 0; j < cols; j++)
                {
                    double temp = tmp[pivot * cols + j];
                    tmp[pivot * cols + j] = tmp[r * cols + j];
                    tmp[r * cols + j] = temp;
                }
            }
            // eliminate below
            for (int i = r + 1; i < rows; i++)
            {
                double factor = tmp[i * cols + c] / tmp[r * cols + c];
                for (int j = c; j < cols; j++)
                {
                    tmp[i * cols + j] -= factor * tmp[r * cols + j];
                }
            }
            r++;
        }

        // count non-zero rows
        int rankNum = 0;
        for (int i = 0; i < rows; i++)
        {
            boolean flag = false;
            for (int j = 0; j < cols; j++)
            {
                if (Math.abs(tmp[i * cols + j]) >= 1e-6)
                {
                    flag = true;
                    break;
                }
            }
            if (flag) rankNum++;
        }
        return rankNum;
    }

    /***********************************************************
    @description: compute trace of matrix (sum of diagonal elements)
    @return {int} trace
    ************************************************************/
    public int trace()
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return 0;
        }
        if (rows == 0 || cols == 0)
        {
            System.err.println("Invalid param!");
            return 0;
        }
        if (cols != rows)
        {
            System.err.println("It is not a square!");
            return 0;
        }
        int sum = 0;
        for (int i = 0; i < rows; i++)
        {
            sum += data[i * cols + i];
        }
        return sum;
    }

    /***********************************************************
    @description: compute determinant using exact fraction arithmetic
    @return {int} determinant
    ************************************************************/
    public int determinant()
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return 0;
        }
        if (rows == 0 || cols == 0)
        {
            System.err.println("Invalid param!");
            return 0;
        }
        // copy to Fraction array
        Fraction[] fracData = new Fraction[rows * cols];
        for (int i = 0; i < rows * cols; i++)
        {
            fracData[i] = new Fraction(data[i], 1);
        }

        // Gaussian elimination using Fraction arithmetic
        for (int r = 0, c = 0; r < rows && c < cols; c++)
        {
            // find pivot
            int pivot = r;
            while (pivot < rows)
            {
                double val = Math.abs((double)fracData[pivot * cols + c].x / fracData[pivot * cols + c].y);
                if (val >= 1e-6) break;
                pivot++;
            }
            if (pivot == rows)
            {
                return 0;
            }
            // swap rows
            if (pivot != r)
            {
                for (int j = 0; j < cols; j++)
                {
                    Fraction temp = fracData[pivot * cols + j];
                    fracData[pivot * cols + j] = fracData[r * cols + j];
                    fracData[r * cols + j] = temp;
                }
            }
            // eliminate below
            for (int i = r + 1; i < rows; i++)
            {
                Fraction factor = Fraction.div(fracData[i * cols + c], fracData[r * cols + c]);
                for (int j = c; j < cols; j++)
                {
                    Fraction product = Fraction.mul(factor, fracData[r * cols + j]);
                    fracData[i * cols + j] = Fraction.sub(fracData[i * cols + j], product);
                }
            }
            r++;
        }

        // product of diagonal
        Fraction res = new Fraction(1, 1);
        for (int i = 0; i < rows; i++)
        {
            res = Fraction.mul(res, fracData[i * cols + i]);
        }
        return res.x;
    }

    /***********************************************************
    @description: extract a row from matrix
    ************************************************************/
    public MatrixInt extractRow(int index)
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (index > rows - 1)
        {
            System.err.println("Invalid param!");
            return null;
        }
        MatrixInt res = new MatrixInt(1, cols);
        for (int i = 0; i < cols; i++)
        {
            res.data[i] = data[index * cols + i];
        }
        return res;
    }

    /***********************************************************
    @description: extract a column from matrix
    ************************************************************/
    public MatrixInt extractCol(int index)
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (index > cols - 1)
        {
            System.err.println("Invalid param!");
            return null;
        }
        MatrixInt res = new MatrixInt(rows, 1);
        for (int i = 0; i < rows; i++)
        {
            res.data[i] = data[i * cols + index];
        }
        return res;
    }

    /***********************************************************
    @description: extract diagonal elements
    @return {int[]} array of diagonal elements
    ************************************************************/
    public int[] extractDiag()
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        int dataLen = (rows >= cols ? cols : rows);
        int[] diag = new int[dataLen];
        for (int i = 0; i < dataLen; i++)
        {
            diag[i] = data[i * cols + i];
        }
        return diag;
    }

    /***********************************************************
    @description: get leading principal minors
    @return {MatrixInt[]} array of leading principal minors
    ************************************************************/
    public MatrixInt[] getLeadingMinors()
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (rows == 0 || cols == 0)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (cols != rows)
        {
            System.out.println("It's not a square");
            return null;
        }
        MatrixInt[] res = new MatrixInt[rows];
        for (int order = 1; order <= rows; order++)
        {
            res[order - 1] = new MatrixInt(order, order);
            for (int i = 0; i < order; i++)
            {
                for (int j = 0; j < order; j++)
                {
                    res[order - 1].data[i * order + j] = data[i * cols + j];
                }
            }
        }
        return res;
    }

    /***********************************************************
    @description: LU decomposition (returns MatrixDouble L and U)
    @return {LUResult} containing L and U as MatrixDouble
    ************************************************************/
    public LUResult luDecomposition()
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (cols != rows)
        {
            System.out.println("It's not a square");
            return null;
        }
        // check leading minors rank
        MatrixInt[] leadingMinors = getLeadingMinors();
        if (leadingMinors == null)
        {
            System.err.println("function getLeadingMinors has a wrong value");
            return null;
        }
        for (int i = 0; i < leadingMinors.length; i++)
        {
            int r = leadingMinors[i].rank();
            if (r == -1) return null;
            if (r != i + 1)
            {
                System.err.println("This matrix can't lu decomposition");
                return null;
            }
        }

        // L and U as MatrixDouble
        MatrixDouble L = new MatrixDouble(rows, cols);
        MatrixDouble U = new MatrixDouble(rows, cols);

        // init L upper triangle
        for (int i = 0; i < rows; i++)
        {
            for (int j = i; j < cols; j++)
            {
                L.set(i, j, (i == j ? 1.0 : 0.0));
            }
        }

        // u_{1j} = a_{1j}
        for (int i = 0; i < cols; i++)
        {
            U.set(0, i, data[i]);
        }
        // l_{i1} = a_{i1} / u_{11}
        for (int i = 1; i < rows; i++)
        {
            L.set(i, 0, data[i * cols + 0] / U.get(0, 0));
        }

        for (int i = 1; i < rows; i++)
        {
            for (int j = i; j < rows; j++)
            {
                double sum = 0;
                for (int k = 0; k < i; k++)
                {
                    sum += L.get(i, k) * U.get(k, j);
                }
                U.set(i, j, data[i * cols + j] - sum);
            }
            for (int j = i + 1; j < rows; j++)
            {
                double sum = 0;
                for (int k = 0; k < j; k++)
                {
                    sum += L.get(j, k) * U.get(k, i);
                }
                L.set(j, i, (data[j * cols + i] - sum) / U.get(i, i));
            }
        }

        LUResult res = new LUResult();
        res.L = L;
        res.U = U;
        return res;
    }

    /***********************************************************
    @description: inverse of matrix (returns MatrixDouble)
    ************************************************************/
    public static MatrixDouble inv(MatrixInt m)
    {
        if (m == null || m.data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        if (m.cols != m.rows)
        {
            System.out.println("It's not a square");
            return null;
        }
        int r = m.rank();
        if (r == -1) return null;
        if (r != m.cols)
        {
            System.err.println("It not invertible matrix");
            return null;
        }

        // augmented matrix [A | I]
        MatrixDouble aug = new MatrixDouble(m.rows, m.cols * 2);
        for (int i = 0; i < aug.getRows(); i++)
        {
            for (int j = 0; j < aug.getCols(); j++)
            {
                if (j < m.cols)
                {
                    aug.set(i, j, m.data[i * m.cols + j] * 1.0);
                }
                else
                {
                    aug.set(i, j, (j - i == m.rows) ? 1.0 : 0.0);
                }
            }
        }

        // Gauss-Jordan elimination
        for (int rows = 0, cols = 0; rows < aug.getRows(); cols++)
        {
            // find pivot
            int pivot = rows;
            while (pivot < aug.getRows() && Math.abs(aug.get(pivot, cols)) < 1e-6)
            {
                pivot++;
            }
            if (pivot == aug.getRows())
            {
                continue;
            }
            // swap rows
            if (pivot != rows)
            {
                for (int j = 0; j < aug.getCols(); j++)
                {
                    double temp = aug.get(pivot, j);
                    aug.set(pivot, j, aug.get(rows, j));
                    aug.set(rows, j, temp);
                }
            }
            // normalize
            double pivotVal = aug.get(rows, cols);
            for (int j = cols; j < aug.getCols(); j++)
            {
                aug.set(rows, j, aug.get(rows, j) / pivotVal);
            }
            // eliminate all other rows
            for (int i = 0; i < aug.getRows(); i++)
            {
                if (i == rows) continue;
                double factor = aug.get(i, cols) / aug.get(rows, cols);
                for (int j = cols; j < aug.getCols(); j++)
                {
                    aug.set(i, j, aug.get(i, j) - factor * aug.get(rows, j));
                }
            }
            rows++;
        }

        // extract inverse
        MatrixDouble res = new MatrixDouble(m.rows, m.cols);
        for (int i = 0; i < res.getRows(); i++)
        {
            for (int j = 0; j < res.getCols(); j++)
            {
                res.set(i, j, aug.get(i, aug.getCols() - m.cols + j));
            }
        }
        return res;
    }

    // ---- static factory methods ----

    /***********************************************************
    @description: generate identity matrix
    ************************************************************/
    public static MatrixInt identity(int order)
    {
        if (order <= 0)
        {
            System.err.println("Invalid param!");
            return null;
        }
        MatrixInt res = new MatrixInt(order, order);
        for (int i = 0; i < order; i++)
        {
            res.data[i * order + i] = 1;
        }
        return res;
    }

    /***********************************************************
    @description: generate diagonal matrix from array
    ************************************************************/
    public static MatrixInt diag(int[] data)
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        int len = data.length;
        MatrixInt res = new MatrixInt(len, len);
        for (int i = 0; i < len; i++)
        {
            res.data[i * len + i] = data[i];
        }
        return res;
    }

    /***********************************************************
    @description: generate eye matrix (rectangular identity-like)
    ************************************************************/
    public static MatrixInt eye(int rows, int cols)
    {
        if (rows <= 0 || cols <= 0)
        {
            System.err.println("Invalid param!");
            return null;
        }
        MatrixInt res = new MatrixInt(rows, cols);
        int col = (rows >= cols ? cols : rows);
        for (int i = 0; i < col; i++)
        {
            res.data[i * cols + i] = 1;
        }
        return res;
    }

    /***********************************************************
    @description: generate zero matrix
    ************************************************************/
    public static MatrixInt zeros(int rows, int cols)
    {
        if (rows <= 0 || cols <= 0)
        {
            System.err.println("Invalid param!");
            return null;
        }
        return new MatrixInt(rows, cols);
    }

    /***********************************************************
    @description: generate random matrix
    @param {int[]} range optional {min, max} array; null or length 0 for default
    ************************************************************/
    public static MatrixInt random(int rows, int cols, int[] range)
    {
        if (rows <= 0 || cols <= 0)
        {
            System.err.println("Invalid param!");
            return null;
        }
        int maxBoundary = 10;
        int minBoundary = 0;
        int size = (range == null ? 0 : range.length);
        if (size >= 2)
        {
            if (range[0] >= range[1])
            {
                maxBoundary = range[0];
                minBoundary = range[1];
            }
            else
            {
                maxBoundary = range[1];
                minBoundary = range[0];
            }
        }
        else if (size == 1)
        {
            if (range[0] > 0)
            {
                maxBoundary = range[0];
            }
            else if (range[0] == 0)
            {
                maxBoundary = 10;
            }
            else
            {
                maxBoundary = 0;
                minBoundary = range[0];
            }
        }

        MatrixInt res = new MatrixInt(rows, cols);
        for (int i = 0; i < rows * cols; i++)
        {
            res.data[i] = (int)(Math.random() * (maxBoundary - minBoundary + 1)) + minBoundary;
        }
        return res;
    }

    /***********************************************************
    @description: print matrix
    ************************************************************/
    public void print()
    {
        System.out.println("--------------------------------------------");
        System.out.println("matrix size: (" + rows + ", " + cols + ")");
        System.out.println("matrix data:");
        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < cols; j++)
            {
                System.out.print(data[i * cols + j]);
                if (j + 1 < cols)
                {
                    System.out.print(" ");
                }
            }
            System.out.println();
        }
    }
}
