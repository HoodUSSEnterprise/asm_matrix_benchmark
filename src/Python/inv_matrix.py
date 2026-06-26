###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-25 16:46:58
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-26 9:40:40
# @FilePath: \asm_matrix_benchmark\src\Python\inv_matrix.py
# @Description: invertible matrix python code
###########################################################
from math import fabs
from typing import Any, Union

from .base_matrix import Matrix

###########################################################
# @description: invertible matrix
# @param {Matrix} m
# @return {*}
###########################################################
def inv_matrix(m:Matrix) -> Matrix | None:
    
    # check dimension
    if m.rows != m.cols:
        print("Invalid param")
        return None
    
    aug_matrix = [[0 for _ in range( 2 * m.cols)] for _ in range(m.rows)]
    # init aug matrix
    for i in range(m.rows):
        for j in range(2*m.cols):
            if j < m.cols:
                aug_matrix[i][j] = m.data[i][j]
            else:
                aug_matrix[i][j] = 1.0 if j - i == m.rows else 0.0
    
    # use gauss elimination
    row = 0
    col = 0
    while row < m.rows and col < m.cols:
        # find main element
        pivot = row
        while pivot < m.rows and fabs(m.data[pivot][col]) < 1e-6:
            pivot += 1
        
        # that means this column is zero of all
        if pivot == m.rows:
            continue
        
        # exchange lines
        if pivot != row:
            aug_matrix[row], aug_matrix[pivot] = aug_matrix[pivot], aug_matrix[row]
        
        # normalization
        pivot_val = aug_matrix[row][col]
        for j in range(2 * m.cols):
            aug_matrix[row][j] /= pivot_val
        
        # elimination this line
        for i in range(m.rows):
            factor = aug_matrix.data[i][col] / aug_matrix.data[row][col]
            for j in range(cols, 2 * m.cols):
                aug_matrix[i][j] -= factor * aug_matrix[row][j]


                
