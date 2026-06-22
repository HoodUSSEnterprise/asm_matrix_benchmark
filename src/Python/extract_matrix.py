###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-22 13:20:38
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-22 13:21:04
# @FilePath: \asm_matrix_benchmark\src\Python\extract_matrix.py
# @Description:extract submatrix python code
###########################################################

from typing import List, Union

from .base_matrix import Matrix


###########################################################
# @description: extract a row from matrix as new Matrix (1×n)
# @param {Matrix} m
# @param {int} row_idx
# @return {Matrix}
###########################################################
def extract_row(m: "Matrix", row_idx: int) -> "Matrix | None":
    if m is None:
        print("Invalid param")
        return None
    if row_idx < 0 or row_idx >= m.rows:
        print(f"Row index {row_idx} out of range [0, {m.rows - 1}]")
        return None

    start = row_idx * m.cols
    data = m.data[start : start + m.cols]
    return Matrix(1, m.cols, data)


###########################################################
# @description: extract a column from matrix as new Matrix (m×1)
# @param {Matrix} m
# @param {int} col_idx
# @return {Matrix}
###########################################################
def extract_col(m: "Matrix", col_idx: int) -> "Matrix | None":
    if m is None:
        print("Invalid param")
        return None
    if col_idx < 0 or col_idx >= m.cols:
        print(f"Column index {col_idx} out of range [0, {m.cols - 1}]")
        return None

    data: List[Union[int, float]] = [
        m.data[i * m.cols + col_idx] for i in range(m.rows)
    ]
    return Matrix(m.rows, 1, data)


###########################################################
# @description: extract a submatrix block
# @param {Matrix} m
# @param {int} r_start : row start (inclusive)
# @param {int} r_end   : row end (exclusive)
# @param {int} c_start : col start (inclusive)
# @param {int} c_end   : col end (exclusive)
# @return {Matrix}
###########################################################
def extract_submatrix(
    m: "Matrix", r_start: int, r_end: int, c_start: int, c_end: int
) -> "Matrix | None":
    if m is None:
        print("Invalid param")
        return None

    if r_start < 0 or r_end > m.rows or r_start >= r_end:
        print(f"Invalid row range [{r_start}, {r_end})")
        return None
    if c_start < 0 or c_end > m.cols or c_start >= c_end:
        print(f"Invalid col range [{c_start}, {c_end})")
        return None

    rows_out = r_end - r_start
    cols_out = c_end - c_start
    data: List[Union[int, float]] = [0 for _ in range(rows_out * cols_out)]

    for i in range(rows_out):
        for j in range(cols_out):
            data[i * cols_out + j] = m.data[(r_start + i) * m.cols + (c_start + j)]

    return Matrix(rows_out, cols_out, data)
