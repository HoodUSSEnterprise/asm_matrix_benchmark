###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-22 13:14:11
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-22 13:15:35
# @FilePath: \asm_matrix_benchmark\src\Python\transpose_matrix.py
# @Description:transpose matrix python code
###########################################################

from typing import List, Union

from .base_matrix import Matrix


###########################################################
# @description: transpose of a matrix (return new matrix)
# @param {Matrix} m
# @return {Matrix}
###########################################################
def transpose(m: "Matrix") -> "Matrix | None":
    if m is None:
        print("Invalid param")
        return None

    row = m.cols
    col = m.rows
    result: List[Union[int, float]] = [0 for _ in range(row * col)]

    for i in range(row):
        for j in range(col):
            result[i * col + j] = m.data[j * m.cols + i]

    return Matrix(row, col, result)
