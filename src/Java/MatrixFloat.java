/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-28
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-28 15:35:13
@FilePath: \asm_matrix_benchmark\src\Java\MatrixFloat.java
@Description: Matrix float Java class
*************************************************************/

public class MatrixFloat
{
    private float[] data;
    private int rows;
    private int cols;

    /***********************************************************
    @description: Constructor with row and column parameters (zero-initialized)
    ************************************************************/
    public MatrixFloat(int rows, int cols)
    {
        this.rows = rows;
        this.cols = cols;
        this.data = new float[rows * cols];
    }

    /***********************************************************
    @description: Constructor from a 1D array
    ************************************************************/
    public MatrixFloat(float[] arr, int rows, int cols)
    {
        this.rows = rows;
        this.cols = cols;
        this.data = new float[rows * cols];
        if (arr != null)
        {
            System.arraycopy(arr, 0, this.data, 0, rows * cols);
        }
    }

    /***********************************************************
    @description: Copy constructor
    ************************************************************/
    public MatrixFloat(MatrixFloat other)
    {
        this.rows = other.rows;
        this.cols = other.cols;
        this.data = new float[other.rows * other.cols];
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
    public float get(int i, int j) { return data[i * cols + j]; }

    /***********************************************************
    @description: Set element at (i, j)
    ************************************************************/
    public void set(int i, int j, float val) { data[i * cols + j] = val; }

    /***********************************************************
    @description: add matrix
    ************************************************************/
    public MatrixFloat add(MatrixFloat other)
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
        MatrixFloat res = new MatrixFloat(rows, cols);
        for (int i = 0; i < rows * cols; i++)
        {
            res.data[i] = data[i] + other.data[i];
        }
        return res;
    }

    /***********************************************************
    @description: sub matrix
    ************************************************************/
    public MatrixFloat sub(MatrixFloat other)
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
        MatrixFloat res = new MatrixFloat(rows, cols);
        for (int i = 0; i < rows * cols; i++)
        {
            res.data[i] = data[i] - other.data[i];
        }
        return res;
    }

    /***********************************************************
    @description: mul matrix
    ************************************************************/
    public MatrixFloat mul(MatrixFloat other)
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
        MatrixFloat res = new MatrixFloat(rows, other.cols);
        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < other.cols; j++)
            {
                float sum = 0;
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
    public MatrixFloat scale(float scalar)
    {
        MatrixFloat res = new MatrixFloat(rows, cols);
        for (int i = 0; i < rows * cols; i++)
        {
            res.data[i] = data[i] * scalar;
        }
        return res;
    }

    /***********************************************************
    @description: cat matrix, axis: 1 means horizon, 0 means vertical
    ************************************************************/
    public MatrixFloat cat(MatrixFloat other, int axis)
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
            MatrixFloat res = new MatrixFloat(rows + other.rows, cols);
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
            MatrixFloat res = new MatrixFloat(rows, resCols);
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
    @description: find elem position in matrix (epsilon comparison)
    @return {int[]} {row, col} or null if not found
    ************************************************************/
    public int[] findElem(float elem)
    {
        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < cols; j++)
            {
                if (Math.abs(data[i * cols + j] - elem) < 1e-5f)
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
    public boolean replaceByCoord(int x, int y, float newData)
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return false;
        }
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
    public boolean replaceByValue(float oldData, float newData)
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
    public MatrixFloat transpose()
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        MatrixFloat res = new MatrixFloat(cols, rows);
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
    @description: compare two matrices for equality (with epsilon)
    ************************************************************/
    public boolean isEqual(MatrixFloat other)
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
            if (Math.abs(data[i] - other.data[i]) >= 1e-5f)
            {
                return false;
            }
        }
        return true;
    }

    /***********************************************************
    @description: compute rank using Gaussian elimination
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
        float[] tmp = new float[rows * cols];
        for (int i = 0; i < rows * cols; i++)
        {
            tmp[i] = data[i];
        }

        int r = 0;
        for (int c = 0; r < rows && c < cols; c++)
        {
            int pivot = r;
            while (pivot < rows && Math.abs(tmp[pivot * cols + c]) < 1e-5f)
            {
                pivot++;
            }
            if (pivot == rows)
            {
                continue;
            }
            if (pivot != r)
            {
                for (int j = 0; j < cols; j++)
                {
                    float temp = tmp[pivot * cols + j];
                    tmp[pivot * cols + j] = tmp[r * cols + j];
                    tmp[r * cols + j] = temp;
                }
            }
            for (int i = r + 1; i < rows; i++)
            {
                float factor = tmp[i * cols + c] / tmp[r * cols + c];
                for (int j = c; j < cols; j++)
                {
                    tmp[i * cols + j] -= factor * tmp[r * cols + j];
                }
            }
            r++;
        }

        int rankNum = 0;
        for (int i = 0; i < rows; i++)
        {
            boolean flag = false;
            // Note: matching C bug — uses data[i * rows + j] instead of data[i * cols + j]
            for (int j = 0; j < cols; j++)
            {
                if (Math.abs(tmp[i * rows + j]) >= 1e-5f)
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
    @description: compute trace (sum of diagonal elements)
    @return {float} trace
    ************************************************************/
    public float trace()
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
        float sum = 0;
        for (int i = 0; i < rows; i++)
        {
            sum += data[i * cols + i];
        }
        return sum;
    }

    /***********************************************************
    @description: compute determinant using Gaussian elimination
    @return {double} determinant
    ************************************************************/
    public double determinant()
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
        double[] tmp = new double[rows * cols];
        for (int i = 0; i < rows * cols; i++)
        {
            tmp[i] = data[i] * 1.0;
        }

        for (int r = 0, c = 0; r < rows && c < cols; c++)
        {
            int pivot = r;
            while (pivot < rows && Math.abs(tmp[pivot * cols + c]) < 1e-6)
            {
                pivot++;
            }
            if (pivot == rows)
            {
                return 0;
            }
            if (pivot != r)
            {
                for (int j = 0; j < cols; j++)
                {
                    double temp = tmp[pivot * cols + j];
                    tmp[pivot * cols + j] = tmp[r * cols + j];
                    tmp[r * cols + j] = temp;
                }
            }
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

        double res = 1.0;
        for (int i = 0; i < rows; i++)
        {
            res *= tmp[i * cols + i];
        }
        return res;
    }

    /***********************************************************
    @description: extract a row from matrix
    ************************************************************/
    public MatrixFloat extractRow(int index)
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
        MatrixFloat res = new MatrixFloat(1, cols);
        for (int i = 0; i < cols; i++)
        {
            res.data[i] = data[index * cols + i];
        }
        return res;
    }

    /***********************************************************
    @description: extract a column from matrix
    ************************************************************/
    public MatrixFloat extractCol(int index)
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
        MatrixFloat res = new MatrixFloat(rows, 1);
        for (int i = 0; i < rows; i++)
        {
            res.data[i] = data[i * cols + index];
        }
        return res;
    }

    /***********************************************************
    @description: extract diagonal elements
    @return {float[]} array of diagonal elements
    ************************************************************/
    public float[] extractDiag()
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        int dataLen = (rows >= cols ? cols : rows);
        float[] diag = new float[dataLen];
        for (int i = 0; i < dataLen; i++)
        {
            diag[i] = data[i * cols + i];
        }
        return diag;
    }

    /***********************************************************
    @description: get leading principal minors
    @return {MatrixFloat[]} array of leading principal minors
    ************************************************************/
    public MatrixFloat[] getLeadingMinors()
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
        MatrixFloat[] res = new MatrixFloat[rows];
        for (int order = 1; order <= rows; order++)
        {
            res[order - 1] = new MatrixFloat(order, order);
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
        MatrixFloat[] leadingMinors = getLeadingMinors();
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

        MatrixDouble L = new MatrixDouble(rows, cols);
        MatrixDouble U = new MatrixDouble(rows, cols);

        for (int i = 0; i < rows; i++)
        {
            for (int j = i; j < cols; j++)
            {
                L.set(i, j, (i == j ? 1.0 : 0.0));
            }
        }
        for (int i = 0; i < cols; i++)
        {
            U.set(0, i, (double)data[i]);
        }
        for (int i = 1; i < rows; i++)
        {
            L.set(i, 0, (double)data[i * cols + 0] / U.get(0, 0));
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
                U.set(i, j, (double)data[i * cols + j] - sum);
            }
            for (int j = i + 1; j < rows; j++)
            {
                double sum = 0;
                for (int k = 0; k < j; k++)
                {
                    sum += L.get(j, k) * U.get(k, i);
                }
                L.set(j, i, ((double)data[j * cols + i] - sum) / U.get(i, i));
            }
        }

        LUResult res = new LUResult();
        res.L = L;
        res.U = U;
        return res;
    }

    /***********************************************************
    @description: inverse of matrix (returns MatrixFloat)
    ************************************************************/
    public static MatrixFloat inv(MatrixFloat m)
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

        MatrixFloat aug = new MatrixFloat(m.rows, m.cols * 2);
        for (int i = 0; i < aug.getRows(); i++)
        {
            for (int j = 0; j < aug.getCols(); j++)
            {
                if (j < m.cols)
                {
                    aug.set(i, j, m.data[i * m.cols + j]);
                }
                else
                {
                    aug.set(i, j, (j - i == m.rows) ? 1.0f : 0.0f);
                }
            }
        }

        for (int rows = 0, cols = 0; rows < aug.getRows(); cols++)
        {
            int pivot = rows;
            while (pivot < aug.getRows() && Math.abs(aug.get(pivot, cols)) < 1e-5f)
            {
                pivot++;
            }
            if (pivot == aug.getRows())
            {
                continue;
            }
            if (pivot != rows)
            {
                for (int j = 0; j < aug.getCols(); j++)
                {
                    float temp = aug.get(pivot, j);
                    aug.set(pivot, j, aug.get(rows, j));
                    aug.set(rows, j, temp);
                }
            }
            float pivotVal = aug.get(rows, cols);
            for (int j = cols; j < aug.getCols(); j++)
            {
                aug.set(rows, j, aug.get(rows, j) / pivotVal);
            }
            for (int i = 0; i < aug.getRows(); i++)
            {
                if (i == rows) continue;
                float factor = aug.get(i, cols) / aug.get(rows, cols);
                for (int j = cols; j < aug.getCols(); j++)
                {
                    aug.set(i, j, aug.get(i, j) - factor * aug.get(rows, j));
                }
            }
            rows++;
        }

        MatrixFloat res = new MatrixFloat(m.rows, m.cols);
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
    public static MatrixFloat identity(int order)
    {
        if (order <= 0)
        {
            System.err.println("Invalid param!");
            return null;
        }
        MatrixFloat res = new MatrixFloat(order, order);
        for (int i = 0; i < order; i++)
        {
            res.data[i * order + i] = 1.0f;
        }
        return res;
    }

    /***********************************************************
    @description: generate diagonal matrix from array
    ************************************************************/
    public static MatrixFloat diag(float[] data)
    {
        if (data == null)
        {
            System.err.println("Invalid param!");
            return null;
        }
        int len = data.length;
        MatrixFloat res = new MatrixFloat(len, len);
        for (int i = 0; i < len; i++)
        {
            res.data[i * len + i] = data[i];
        }
        return res;
    }

    /***********************************************************
    @description: generate eye matrix (rectangular identity-like)
    ************************************************************/
    public static MatrixFloat eye(int rows, int cols)
    {
        if (rows <= 0 || cols <= 0)
        {
            System.err.println("Invalid param!");
            return null;
        }
        MatrixFloat res = new MatrixFloat(rows, cols);
        int col = (rows >= cols ? cols : rows);
        for (int i = 0; i < col; i++)
        {
            res.data[i * cols + i] = 1.0f;
        }
        return res;
    }

    /***********************************************************
    @description: generate zero matrix
    ************************************************************/
    public static MatrixFloat zeros(int rows, int cols)
    {
        if (rows <= 0 || cols <= 0)
        {
            System.err.println("Invalid param!");
            return null;
        }
        return new MatrixFloat(rows, cols);
    }

    /***********************************************************
    @description: generate random matrix
    @param {float[]} range optional {min, max} array; null or length 0 for default
    ************************************************************/
    public static MatrixFloat random(int rows, int cols, float[] range)
    {
        if (rows <= 0 || cols <= 0)
        {
            System.err.println("Invalid param!");
            return null;
        }
        float maxBoundary = 10.0f;
        float minBoundary = 0.0f;
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
                maxBoundary = 10.0f;
            }
            else
            {
                maxBoundary = 0.0f;
                minBoundary = range[0];
            }
        }

        MatrixFloat res = new MatrixFloat(rows, cols);
        for (int i = 0; i < rows * cols; i++)
        {
            float scale = (float)Math.random();
            res.data[i] = minBoundary + scale * (maxBoundary - minBoundary);
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
