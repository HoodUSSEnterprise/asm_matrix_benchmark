###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-22 13:00:31
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-22 22:35:45
# @FilePath: \asm_matrix_benchmark\example\matrix_int.py
# @Description: example of matrix
###########################################################
import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from typing import Union, List

from src.Python import Matrix

data: List[Union[int, float]] = [i for i in range(1, 13)]
matrix1 = Matrix(3, 4, data)
matrix2 = Matrix(3, 4, data[::-1])

print(matrix1 + matrix2)
