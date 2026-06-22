###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-22 13:22:39
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-22 13:23:12
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

    data: List[Union[int, float]] = [
        random.randint(low, high - 1)
        if isinstance(low, int) and isinstance(high, int)
        else random.uniform(low, high)
        for _ in range(rows * cols)
    ]
    return Matrix(rows, cols, data)
