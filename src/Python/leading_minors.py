###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-23 17:15:08
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-23 17:18:06
# @FilePath: \asm_matrix_benchmark\src\Python\leading_minors.py
# @Description:leading principal minors python code
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


###########################################################
# @description: compute the k-th leading principal minor
#              (determinant of top-left k×k submatrix)
# @param {Matrix} m
# @param {int} k
# @return {int | float}
###########################################################
def principal_minor(m: "Matrix", k: int) -> Union[int, float, None]:
    if m is None:
        print("Invalid param")
        return None
    if m.rows != m.cols:
        print("Principal minor requires a square matrix")
        return None
    if k < 1 or k > m.rows:
        print(f"k must be in [1, {m.rows}], got {k}")
        return None

    n = m.rows
    full = [list(m.data[i * n : (i + 1) * n]) for i in range(n)]
    sub = [row[:k] for row in full[:k]]
    return _determinant(sub)


###########################################################
# @description: compute all leading principal minors of a square matrix
# @param {Matrix} m
# @return {List} list of minors for k=1..n
###########################################################
def leading_minors(m: "Matrix") -> List[Union[int, float]] | None:
    if m is None:
        print("Invalid param")
        return None
    if m.rows != m.cols:
        print("Leading minors require a square matrix")
        return None

    n = m.rows
    full = [list(m.data[i * n : (i + 1) * n]) for i in range(n)]
    result: List[Union[int, float]] = []

    for k in range(1, n + 1):
        sub = [row[:k] for row in full[:k]]
        result.append(_determinant(sub))

    return result
