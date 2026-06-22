###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-22 13:08:22
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-22 13:16:20
# @FilePath: \asm_matrix_benchmark\src\Python\replace_matrix.py
# @Description:replace matrix python code
###########################################################

from typing import Union

from .base_matrix import Matrix
from .find_matrix import find_elem


###########################################################
# @description:  replace matrix by coord
# @return {*}
###########################################################
def replace_pos(
    m: "Matrix", x_label: int, y_label: int, new_value: Union[int, float]
) -> None:
    if x_label < 0 or x_label > m.cols - 1 or y_label < 0 or y_label > m.rows - 1:
        print(f"Invalid coord ({x_label}, {y_label})")
        return

    m.data[x_label * m.cols + y_label] = new_value


###########################################################
# @description: replace matrix by element
# @return {*}
###########################################################
def replace_elem(
    m: "Matrix", old_value: Union[int, float], new_value: Union[int, float]
) -> None:
    if find_elem(m, old_value) != (-1, -1):
        print(f"No find number {old_value}")
        return
    while find_elem(m, old_value) != (-1, -1):
        x, y = find_elem(m, old_value)
        m.data[x * m.cols + y] = new_value
