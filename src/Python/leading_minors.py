###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-22 13:20:40
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-22 13:21:22
# @FilePath: \asm_matrix_benchmark\src\Python\leading_minors.py
# @Description:leading principal minors python code
###########################################################

from typing import List, Union

from .base_matrix import Matrix


def _det2(m: "Matrix") -> Union[int, float]:
    """determinant of a 2x2 submatrix given as flat [a,b,c,d]"""
    return m.data[0] * m.data[3] - m.data[1] * m.data[2]


def _determinant(mat: List[List[Union[int, float]]]) -> Union[int, float]:
    """compute determinant of a square matrix (list of lists)"""
    n = len(mat)
    if n == 1:
        return mat[0][0]

    # copy to avoid mutating original
    a = [row[:] for row in mat]
    det: Union[int, float] = 1

    for i in range(n):
        # find pivot
        pivot = i
        while pivot < n and a[pivot][i] == 0:
            pivot += 1
        if pivot == n:
            return 0
        if pivot != i:
            a[i], a[pivot] = a[pivot], a[i]
            det *= -1

        det *= a[i][i]
        for j in range(i + 1, n):
            if a[j][i] != 0:
                factor = a[j][i] / a[i][i]
                for k in range(i, n):
                    a[j][k] -= factor * a[i][k]

    return det


###########################################################
# @description: compute all leading principal minors
#               of a square matrix
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
    # convert to list-of-lists once
    full = [list(m.data[i * n : (i + 1) * n]) for i in range(n)]
    result: List[Union[int, float]] = []

    for k in range(1, n + 1):
        sub = [row[:k] for row in full[:k]]
        result.append(_determinant(sub))

    return result
