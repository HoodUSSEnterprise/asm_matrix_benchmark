###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-22 13:14:21
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-22 13:16:28
# @FilePath: \asm_matrix_benchmark\src\Python\trace_matrix.py
# @Description:trace of matrix python code
###########################################################

from typing import Union

from .base_matrix import Matrix


###########################################################
# @description: compute the trace of a matrix (sum of diagonal)
# @param {Matrix} m
# @return {int | float}
###########################################################
def trace(m: "Matrix") -> Union[int, float, None]:
    if m is None:
        print("Invalid param")
        return None

    if m.rows != m.cols:
        print("Trace requires a square matrix")
        return None

    result: Union[int, float] = 0
    for i in range(m.rows):
        result += m.data[i * m.cols + i]

    return result
