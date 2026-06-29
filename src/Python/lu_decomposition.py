###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-29 12:45:27
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-29 13:13:20
# @FilePath: \asm_matrix_benchmark\src\Python\lu_decomposition.py
# @Description:LU decomposition python code
###########################################################


from typing import List, Union, Tuple, Optional

from .base_matrix import Matrix

_EPS = 1e-12


###########################################################
# @description: LU decomposition (Doolittle) — returns (L, U)
#              L is lower triangular with 1s on diagonal
#              U is upper triangular
# @param {Matrix} m
# @return {Tuple[Matrix, Matrix] | None}
###########################################################
def lu_decomposition(m: "Matrix") -> Optional[Tuple["Matrix", "Matrix"]]:
    if m is None:
        print("Invalid param")
        return None
    if m.rows != m.cols:
        print("LU decomposition requires a square matrix")
        return None

    n = m.rows
    # extract as float list-of-lists
    a: List[List[float]] = [
        [float(m.data[i * n + j]) for j in range(n)] for i in range(n)
    ]

    L: List[List[float]] = [[0.0] * n for _ in range(n)]
    U: List[List[float]] = [[0.0] * n for _ in range(n)]

    for k in range(n):
        # compute U[k][j] for j = k .. n-1
        for j in range(k, n):
            s = sum(L[k][p] * U[p][j] for p in range(k))
            U[k][j] = a[k][j] - s

        # compute L[i][k] for i = k .. n-1
        for i in range(k, n):
            s = sum(L[i][p] * U[p][k] for p in range(k))
            if abs(U[k][k]) < _EPS:
                print("Matrix is singular, LU decomposition failed")
                return None
            L[i][k] = (a[i][k] - s) / U[k][k]

    # flatten L and U into 1-D arrays
    L_data: List[Union[int, float]] = [L[i][j] for i in range(n) for j in range(n)]
    U_data: List[Union[int, float]] = [U[i][j] for i in range(n) for j in range(n)]

    return Matrix(n, n, L_data), Matrix(n, n, U_data)
