###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-22 13:20:44
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-22 13:21:31
# @FilePath: \asm_matrix_benchmark\src\Python\special_matrix.py
# @Description:special matrices python code
###########################################################

from typing import List, Union

from .base_matrix import Matrix


###########################################################
# @description: create n×n identity matrix
# @param {int} n
# @return {Matrix}
###########################################################
def identity(n: int) -> "Matrix | None":
    if n <= 0:
        print("Size must be positive")
        return None

    data: List[Union[int, float]] = [0 for _ in range(n * n)]
    for i in range(n):
        data[i * n + i] = 1

    return Matrix(n, n, data)


###########################################################
# @description: create rows×cols zero matrix
# @param {int} rows
# @param {int} cols
# @return {Matrix}
###########################################################
def zeros(rows: int, cols: int) -> "Matrix | None":
    if rows <= 0 or cols <= 0:
        print("Dimensions must be positive")
        return None

    data: List[Union[int, float]] = [0 for _ in range(rows * cols)]
    return Matrix(rows, cols, data)


###########################################################
# @description: create rows×cols ones matrix
# @param {int} rows
# @param {int} cols
# @return {Matrix}
###########################################################
def ones(rows: int, cols: int) -> "Matrix | None":
    if rows <= 0 or cols <= 0:
        print("Dimensions must be positive")
        return None

    data: List[Union[int, float]] = [1 for _ in range(rows * cols)]
    return Matrix(rows, cols, data)
