###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-29 13:22:33
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-29 13:53:57
# @FilePath: \asm_matrix_benchmark\example\matrix_int.py
# @Description:example of matrix int Python
###########################################################

import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../src")))
from typing import Union, List

from Python import (
    Matrix,
    cat_matrix,
    # determinant,  # temporarily disabled (assembly issues)
    extract_col,
    extract_row,
    extract_submatrix,
    find_elem,
    identity,
    inv_matrix,
    leading_minors,
    lu_decomposition,
    ones,
    random_matrix,
    rank,
    replace_elem,
    replace_pos,
    trace,
    transpose,
    zeros,
)


def sep(title: str) -> None:
    print(title)


# ---------------------------------------------------------------------------
data: List[Union[int, float]] = [1, 2, 3, 4]
v1 = Matrix(2, 2, data.copy())
v2 = Matrix(1, 4, data.copy())
v3 = Matrix(2, 2, data.copy())

sep(
    "---------------------------------------add matrix---------------------------------------"
)
m = v1 + v3
print(m)
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "---------------------------------------sub matrix---------------------------------------"
)
m = v1 - v3
print(m)
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "---------------------------------------mul matrix---------------------------------------"
)
mul_data: List[Union[int, float]] = [1, 2, 3]
mul1 = Matrix(3, 1, mul_data.copy())
mul2 = Matrix(1, 3, mul_data.copy())
m = mul1 * mul2
print(m)
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "--------------------------------------scale matrix--------------------------------------"
)
scale_data: List[Union[int, float]] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
scale = Matrix(2, 5, scale_data.copy())
print(scale)
m = scale * 2
print(m)
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "---------------------------------------cat matrix---------------------------------------"
)
cat_data1: List[Union[int, float]] = [1, 2, 3]
cat_data2: List[Union[int, float]] = [4, 5, 6, 7, 8, 9]
cat1 = Matrix(1, 3, cat_data1.copy())
cat2 = Matrix(2, 3, cat_data2.copy())
m = cat_matrix(cat1, cat2, 0)
print(m)
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "--------------------------------------find matrix---------------------------------------"
)
find_data: List[Union[int, float]] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
find_m = Matrix(5, 2, find_data.copy())
print(find_m)
p = find_elem(find_m, 5)
if p != (-1, -1):
    print(f"find elem 5 at {p}")
else:
    print("No find elem 5")
p = find_elem(find_m, 11)
if p != (-1, -1):
    print(f"find elem 11 at {p}")
else:
    print("No find elem 11")
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "-------------------------------------replace matrix-------------------------------------"
)
replace_data: List[Union[int, float]] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
replace_m = Matrix(5, 2, replace_data.copy())
replace_pos(replace_m, 0, 0, 99)
print(replace_m)
replace_elem(replace_m, 7, 77)
print(replace_m)
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "------------------------------------transpose matrix------------------------------------"
)
transpose_data: List[Union[int, float]] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
raw = Matrix(5, 2, transpose_data.copy())
print(raw)
t = transpose(raw)
print(t)
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "-------------------------------------special matrix-------------------------------------"
)
I = identity(4)
print(I)
Z = zeros(3, 4)
print(Z)
O = ones(2, 3)
print(O)
R = random_matrix(3, 3, 0, 10)
print(R)
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "-------------------------------------rank and trace-------------------------------------"
)
rt_data: List[Union[int, float]] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
rt_m = Matrix(3, 3, rt_data.copy())
print(rt_m)
print(f"matrix rank = {rank(rt_m)}")
print(f"matrix trace = {trace(rt_m)}")
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "-------------------------------------compare matrix-------------------------------------"
)
comp1_data: List[Union[int, float]] = [1, 2, 3, 4, 5, 6]
comp2_data: List[Union[int, float]] = [6, 5, 4, 3, 2, 1]
cmp1 = Matrix(2, 3, comp1_data.copy())
cmp2 = Matrix(2, 3, comp1_data.copy())
cmp3 = Matrix(2, 3, comp2_data.copy())
print("Two matrix equals" if cmp1 == cmp2 else "Two matrix not equals")
print("Two matrix equals" if cmp1 == cmp3 else "Two matrix not equals")
print("Two matrix not equals" if cmp1 != cmp3 else "Two matrix equals")
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "-------------------------------------invertible matrix-------------------------------------"
)
inv_data: List[Union[int, float]] = [1, 2, 3, 0, 4, 5, 1, 0, 6]
inv_m = Matrix(3, 3, inv_data.copy())
inv = inv_matrix(inv_m)
if inv is not None:
    print(inv)
sep(
    "----------------------------------------------------------------------------------------"
)

# determinant temporarily disabled (assembly issues)
# sep(
#     "-------------------------------------determinant-----------------------------------------"
# )
# det_data1: List[Union[int, float]] = [1, 2, 3, 4]
# det_m1 = Matrix(2, 2, det_data1.copy())
# print(det_m1)
# print(f"det = {determinant(det_m1)}")
# det_data2: List[Union[int, float]] = [1, 2, 3, 0, 4, 5, 1, 0, 6]
# det_m2 = Matrix(3, 3, det_data2.copy())
# print(det_m2)
# print(f"det = {determinant(det_m2)}")
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "-------------------------------------leading minors-------------------------------------"
)
lead_data: List[Union[int, float]] = [1, 2, 3, 4, 5, 6, 7, 8, 10]
lead_m = Matrix(3, 3, lead_data.copy())
print(lead_m)
minors = leading_minors(lead_m)
if minors is not None:
    print(f"leading minors: {minors}")
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "-------------------------------------lu decomposition-------------------------------------"
)
lu_data: List[Union[int, float]] = [1, 2, 3, 0, 4, 5, 1, 0, 6]
lu_m = Matrix(3, 3, lu_data.copy())
print(lu_m)
lu_res = lu_decomposition(lu_m)
if lu_res is not None:
    L, U = lu_res
    print("L matrix:")
    print(L)
    print("U matrix:")
    print(U)
sep(
    "----------------------------------------------------------------------------------------"
)

sep(
    "-------------------------------------extract submatrix----------------------------------"
)
ext_data: List[Union[int, float]] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
ext_m = Matrix(3, 4, ext_data.copy())
print(ext_m)
row = extract_row(ext_m, 1)
if row is not None:
    print(row)
col = extract_col(ext_m, 2)
if col is not None:
    print(col)
block = extract_submatrix(ext_m, 0, 2, 1, 3)
if block is not None:
    print(block)
sep(
    "----------------------------------------------------------------------------------------"
)
