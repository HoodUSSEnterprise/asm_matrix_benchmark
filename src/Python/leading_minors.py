###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-23 17:15:08
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-29 13:13:13
# @FilePath: \asm_matrix_benchmark\src\Python\leading_minors.py
# @Description:leading principal minors python code
###########################################################

from typing import List, Union

from .base_matrix import Matrix
from .determinant_matrix import _determinant, determinant

__all__ = [
    "determinant",
    "leading_minors",
    "principal_minor",
]


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
