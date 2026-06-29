###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-25 16:46:58
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-29 13:13:05
# @FilePath: \asm_matrix_benchmark\src\Python\inv_matrix.py
# @Description: invertible matrix python code
###########################################################
from math import fabs

from typing import Union, List

from .base_matrix import Matrix
from .rank_matrix import rank


###########################################################
# @description: invertible matrix
# @param {Matrix} m
# @return {*}
###########################################################
def inv_matrix(m: Matrix) -> Matrix | None:

    # check dimension
    if m.rows != m.cols:
        print("Invalid param")
        return None

    if rank(m) != m.rows:
        print("It's not a invertible matrix")
        return None

    aug_matrix = [[0.0 for _ in range(2 * m.cols)] for _ in range(m.rows)]
    # init aug matrix
    for i in range(m.rows):
        for j in range(2 * m.cols):
            if j < m.cols:
                aug_matrix[i][j] = m.data[i * m.cols + j]
            else:
                aug_matrix[i][j] = 1.0 if j - i == m.rows else 0.0

    # use gauss elimination
    row = 0
    col = 0
    while row < m.rows and col < m.cols:
        # find main element
        pivot = row
        while pivot < m.rows and fabs(aug_matrix[pivot][col]) < 1e-6:
            pivot += 1

        # that means this column is zero of all
        if pivot == m.rows:
            col += 1
            continue

        # exchange lines
        if pivot != row:
            aug_matrix[row], aug_matrix[pivot] = aug_matrix[pivot], aug_matrix[row]

        # normalization
        pivot_val = aug_matrix[row][col]
        for j in range(2 * m.cols):
            aug_matrix[row][j] /= pivot_val

        # elimination this line
        for i in range(m.rows):
            if i == row:
                continue

            factor = aug_matrix[i][col] / aug_matrix[row][col]
            for j in range(col, 2 * m.cols):
                aug_matrix[i][j] -= factor * aug_matrix[row][j]

        row += 1

    # extract res
    res_data: List[Union[int, float]] = [0 for _ in range(m.rows * m.cols)]

    for i in range(m.rows):
        for j in range(m.cols):
            res_data[i * m.cols + j] = aug_matrix[i][j + m.cols]

    return Matrix(m.rows, m.cols, res_data)
