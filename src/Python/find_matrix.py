###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-22 13:08:20
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-22 13:09:16
# @FilePath: \asm_matrix_benchmark\src\Python\find_matrix.py
# @Description: find matrix python code
###########################################################
from typing import Any, Union

from .base_matrix import Matrix


###########################################################
# @description: find elem in matrix
# @param {Any} m
# @param {Union} v
# @param {*} float
# @return {*}
###########################################################
def find_elem(m: Any, v: Union[int, float]) -> tuple[int, int]:
    if m is None or not isinstance(m, Matrix):
        print("Invalid param")
        return -1, -1

    for i in range(m.rows):
        for j in range(m.cols):
            if m.data[i * m.cols + j] == v:
                return i, j

    print(f"No find elem {v}")
    return -1, -1
