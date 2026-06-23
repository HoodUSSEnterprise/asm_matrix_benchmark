###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-23 17:15:02
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-23 17:18:15
# @FilePath: \asm_matrix_benchmark\src\Python\random_matrix.py
# @Description:random matrix python code
###########################################################


import random
from typing import List, Union

from .base_matrix import Matrix


###########################################################
# @description: create rows×cols random matrix
# @param {int} rows
# @param {int} cols
# @param {Union} low  : minimum value (inclusive)
# @param {Union} high : maximum value (exclusive)
# @return {Matrix}
###########################################################
def random_matrix(
    rows: int, cols: int, low: Union[int, float] = 0, high: Union[int, float] = 10
) -> "Matrix | None":
    if rows <= 0 or cols <= 0:
        print("Dimensions must be positive")
        return None

    if isinstance(low, int) and isinstance(high, int):
        data: List[Union[int, float]] = [
            random.randint(low, high - 1) for _ in range(rows * cols)
        ]
    else:
        data = [random.uniform(low, high) for _ in range(rows * cols)]

    return Matrix(rows, cols, data)


###########################################################
# @description: create rows×cols random integer matrix
# @param {int} rows
# @param {int} cols
# @param {int} low  : minimum value (inclusive)
# @param {int} high : maximum value (exclusive)
# @return {Matrix}
###########################################################
def random_integer(
    rows: int, cols: int, low: int = 0, high: int = 10
) -> "Matrix | None":
    if rows <= 0 or cols <= 0:
        print("Dimensions must be positive")
        return None

    data: List[Union[int, float]] = [
        random.randint(low, high - 1) for _ in range(rows * cols)
    ]
    return Matrix(rows, cols, data)


###########################################################
# @description: create rows×cols random float matrix
# @param {int} rows
# @param {int} cols
# @param {float} low  : minimum value (inclusive)
# @param {float} high : maximum value (exclusive)
# @return {Matrix}
###########################################################
def random_float(
    rows: int, cols: int, low: float = 0.0, high: float = 1.0
) -> "Matrix | None":
    if rows <= 0 or cols <= 0:
        print("Dimensions must be positive")
        return None

    data: List[Union[int, float]] = [
        random.uniform(low, high) for _ in range(rows * cols)
    ]
    return Matrix(rows, cols, data)


###########################################################
# @description: create n×n random symmetric matrix
# @param {int} n
# @param {Union} low  : minimum value (inclusive)
# @param {Union} high : maximum value (exclusive)
# @return {Matrix}
###########################################################
def random_symmetric(
    n: int, low: Union[int, float] = 0, high: Union[int, float] = 10
) -> "Matrix | None":
    if n <= 0:
        print("Size must be positive")
        return None

    data: List[Union[int, float]] = [0 for _ in range(n * n)]

    if isinstance(low, int) and isinstance(high, int):
        for i in range(n):
            for j in range(i, n):
                val = random.randint(low, high - 1)
                data[i * n + j] = val
                if i != j:
                    data[j * n + i] = val
    else:
        for i in range(n):
            for j in range(i, n):
                val = random.uniform(low, high)
                data[i * n + j] = val
                if i != j:
                    data[j * n + i] = val

    return Matrix(n, n, data)


###########################################################
# @description: create n×n random diagonal matrix
# @param {int} n
# @param {Union} low  : minimum value (inclusive)
# @param {Union} high : maximum value (exclusive)
# @return {Matrix}
###########################################################
def random_diagonal(
    n: int, low: Union[int, float] = 0, high: Union[int, float] = 10
) -> "Matrix | None":
    if n <= 0:
        print("Size must be positive")
        return None

    data: List[Union[int, float]] = [0 for _ in range(n * n)]

    if isinstance(low, int) and isinstance(high, int):
        for i in range(n):
            data[i * n + i] = random.randint(low, high - 1)
    else:
        for i in range(n):
            data[i * n + i] = random.uniform(low, high)

    return Matrix(n, n, data)
