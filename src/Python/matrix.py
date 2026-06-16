###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-16 09:16:25
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-16 13:57:09
# @FilePath: \asm_matrix\src\Python\matrix.py
# @Description: Python file of matrix
###########################################################

from typing import List, Union


class Matrix:

    def __init__(self, rows: int, cols: int, data: List[Union[int, float]]):
        self.rows = rows
        self.cols = cols
        self.data = data

    def __add__(self, other: "Matrix"):
        if other is None or self is None:
            print("Invalid param")
            return None

        if self.rows != other.rows or self.cols != other.cols:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return None

        result = [0 for i in range(self.rows * self.cols)]

        for i in range(self.rows):
            for j in range(self.cols):
                result[i * self.cols + j] = (
                    self.data[i * self.cols + j] + other.data[i * self.cols + j]
                )

        return Matrix(self.rows, self.cols, result)

    def __sub__(self, other):
        if other is None or self is None:
            print("Invalid param")
            return None

        if self.rows != other.rows or self.cols != other.cols:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return None

        result = [0 for i in range(self.rows * self.cols)]

        for i in range(self.rows):
            for j in range(self.cols):
                result[i * self.cols + j] = (
                    self.data[i * self.cols + j] - other.data[i * self.cols + j]
                )

        return Matrix(self.rows, self.cols, result)

    def __mul__(self, other):
        if other is None or self is None:
            print("Invalid param")
            return None

        if self.cols != other.rows:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return None

        result = [0 for i in range(self.rows * self.cols)]

        for i in range(self.rows):
            for j in range(other.cols):
                num = 0
                for k in range(other.rows):
                    num += self.data[i * self.cols + k] * other.data[k * self.cols + j]
                result[i * self.cols + j] = num

        return Matrix(self.rows, self.cols, result)

    def __eq__(self, other):
        if other is None or self is None:
            print("Invalid param")
            return False

        if self.rows != other.rows or self.cols != other.cols:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return False

        for i in range(self.rows):
            for j in range(self.cols):
                if self.data[i * self.cols + j] != other.data[i * self.cols + j]:
                    return False

        return True

    def __str__(self):
        if self is None:
            return "This matrix is None\n"
        else:
            return (
                f"--------------------------------------------\n"
                f"matrix size: ({self.rows}, {self.cols})\n"
                f"matrix data: {self.data}\n"
                f"--------------------------------------------"
            )

    def __iadd__(self, other):
        if other is None or self is None:
            print("Invalid param")
            return None

        if self.rows != other.rows or self.cols != other.cols:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return None

        result = [0 for i in range(self.rows * self.cols)]

        for i in range(self.rows):
            for j in range(self.cols):
                result[i * self.cols + j] = (
                    self.data[i * self.cols + j] + other.data[i * self.cols + j]
                )

        return Matrix(self.rows, self.cols, result)

    def __isub__(self, other):
        if other is None or self is None:
            print("Invalid param")
            return None

        if self.rows != other.rows or self.cols != other.cols:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return None

        result = [0 for i in range(self.rows * self.cols)]

        for i in range(self.rows):
            for j in range(self.cols):
                result[i * self.cols + j] = (
                    self.data[i * self.cols + j] - other.data[i * self.cols + j]
                )

        return Matrix(self.rows, self.cols, result)

    def __imul__(self, other):
        if other is None or self is None:
            print("Invalid param")
            return None

        if self.cols != other.rows:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return None

        result = [0 for i in range(self.rows * self.cols)]

        for i in range(self.rows):
            for j in range(other.cols):
                num = 0
                for k in range(other.rows):
                    num += self.data[i * self.cols + k] * other.data[k * self.cols + j]
                result[i * self.cols + j] = num

        return Matrix(self.rows, self.cols, result)


###########################################################
# @description: Find elem in matrix
# @param {Matrix} m
# @param {Number} v
# @return {*}
###########################################################
def find_elem(m: Matrix, v: Number):
    if m is None or m.data is None:
        print("Invalid param")
        return -1, -1

    for i in range(m.rows):
        for j in range(m.cols):
            if m.data[i * m.cols + j] == v:
                return i, j

    print(f"No find elem {v}")
    return -1, -1


if __name__ == "__main__":
    m = Matrix(2, 2, [1, 2, 3, 4])
    m1 = Matrix(2, 2, [3, 4, 5, 6])
    print(m1)
    row, col = find_elem(m, 2)
    print(row, col)
    m3 = m + m1
    print(m3)
