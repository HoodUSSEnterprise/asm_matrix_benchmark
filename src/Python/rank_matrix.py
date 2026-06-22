###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-22 13:14:20
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-22 13:16:10
# @FilePath: \asm_matrix_benchmark\src\Python\rank_matrix.py
# @Description: rank of matrix python code
###########################################################

from .base_matrix import Matrix


###########################################################
# @description: compute the rank of a matrix
# @param {Matrix} m
# @return {int}
###########################################################
def rank(m: "Matrix") -> int:
    if m is None:
        print("Invalid param")
        return -1

    rows, cols = m.rows, m.cols
    mat = [list(m.data[i * cols : (i + 1) * cols]) for i in range(rows)]

    rank_val = 0
    for col in range(cols):
        pivot = -1
        for row in range(rank_val, rows):
            if mat[row][col] != 0:
                pivot = row
                break

        if pivot == -1:
            continue

        mat[rank_val], mat[pivot] = mat[pivot], mat[rank_val]

        for row in range(rank_val + 1, rows):
            if mat[row][col] != 0:
                factor = mat[row][col] / mat[rank_val][col]
                for j in range(col, cols):
                    mat[row][j] -= factor * mat[rank_val][j]

        rank_val += 1

    return rank_val
