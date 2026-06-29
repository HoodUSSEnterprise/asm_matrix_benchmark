###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-29 12:44:38
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-29 13:13:38
# @FilePath: \asm_matrix_benchmark\src\Python\determinant_matrix.py
# @Description:determinant of matrix python code
###########################################################

from typing import List, Union

from .base_matrix import Matrix

_EPS = 1e-12


###########################################################
# @description: calc determinant
# @param {List} mat
# @param {*} float
# @return {*}
###########################################################
def _determinant(mat: List[List[Union[int, float]]]) -> Union[int, float]:
    """compute determinant of a square matrix (list of lists) via Gaussian elimination"""
    n = len(mat)
    if n == 1:
        return mat[0][0]
    if n == 2:
        return mat[0][0] * mat[1][1] - mat[0][1] * mat[1][0]

    a = [row[:] for row in mat]
    det: Union[int, float] = 1

    for i in range(n):
        pivot = i
        while pivot < n and abs(a[pivot][i]) < _EPS:
            pivot += 1
        if pivot == n:
            return 0
        if pivot != i:
            a[i], a[pivot] = a[pivot], a[i]
            det *= -1

        det *= a[i][i]
        for j in range(i + 1, n):
            if abs(a[j][i]) >= _EPS:
                factor = a[j][i] / a[i][i]
                for k in range(i, n):
                    a[j][k] -= factor * a[i][k]

    return det


###########################################################
# @description: compute determinant of a matrix
# @param {Matrix} m
# @return {int | float}
###########################################################
def determinant(m: "Matrix") -> Union[int, float, None]:
    if m is None:
        print("Invalid param")
        return None
    if m.rows != m.cols:
        print("Determinant requires a square matrix")
        return None

    n = m.rows
    mat = [list(m.data[i * n : (i + 1) * n]) for i in range(n)]
    return _determinant(mat)
