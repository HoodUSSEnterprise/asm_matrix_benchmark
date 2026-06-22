###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-22 13:14:14
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-22 13:15:59
# @FilePath: \asm_matrix_benchmark\src\Python\concat_matrix.py
# @Description:concat matrix python code
###########################################################

from typing import List

from .base_matrix import Matrix


###########################################################
# @description: concat two matrix by axis
# @param {Matrix} m1
# @param {Matrix} m2
# @param {int} axis: 0 for row, 1 for col
# @return {*}
###########################################################
def cat_matrix(m1: "Matrix", m2: "Matrix", axis: int) -> "Matrix | None":
    if axis == 0:
        if m1.cols != m2.cols:
            print(
                f"Dimension mismatch! m1({m1.rows}, {m1.rows}) vs m2({m2.cols}, {m2.cols})"
            )
            return None
        data: List[int | float] = [0 for _ in range((m1.rows + m2.rows) * m1.cols)]
        for i in range(m1.rows + m2.rows):
            for j in range(m1.cols):
                if i < m1.rows:
                    data[i * m1.cols + j] = m1.data[i * m1.cols + j]
                else:
                    data[i * m1.cols + j] = m2.data[(i - m1.rows) * m1.cols + j]
        return Matrix(m1.rows + m2.rows, m1.cols, data)

    elif axis == 1:
        if m1.rows != m2.rows:
            print(
                f"Dimension mismatch! m1({m1.rows}, {m1.rows}) vs m2({m2.cols}, {m2.cols})"
            )
            return None
        data: List[int | float] = [0 for _ in range((m1.rows + m2.rows) * m1.cols)]
        res_col = m1.cols + m2.cols
        for i in range(m1.rows):
            for j in range(res_col):
                if j < m1.cols:
                    data[i * res_col + j] = m1.data[i * m1.cols + j]
                else:
                    data[i * res_col + j] = m2.data[i * m2.cols + j - m1.cols]
        return Matrix(m1.rows, res_col, data)
    else:
        print("Wrong params, axis must be 0 or 1")
