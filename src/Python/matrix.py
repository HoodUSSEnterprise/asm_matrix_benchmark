###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-16 09:16:25
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-16 15:31:41
# @FilePath: \asm_matrix_benchmark\src\Python\matrix.py
# @Description: Python file of matrix
###########################################################

from typing import Any, List, Optional, Union


class Matrix:

    ###########################################################
    # @description: init matrix
    # @param {*} self
    # @param {int} rows
    # @param {int} cols
    # @param {List} data
    # @param {*} float
    # @return {*}
    ###########################################################
    def __init__(self, rows: int, cols: int, data: List[Union[int, float]]):
        self.rows = rows
        self.cols = cols
        self.data = data  # we use 1-dim array to save data

    ###########################################################
    # @description: opreator +
    # @param {*} self
    # @param {*} other
    # @return {*}
    ###########################################################
    def __add__(self, other: "Matrix | None") -> Optional["Matrix"]:
        if other is None:
            print("Invalid param")
            return None

        if self.rows != other.rows or self.cols != other.cols:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return None

        result = [self.data[i] + other.data[i] for i in range(self.rows * self.cols)]

        return Matrix(self.rows, self.cols, result)

    ###########################################################
    # @description: opreator -
    # @param {*} self
    # @param {*} other
    # @return {*}
    ###########################################################
    def __sub__(self, other: "Matrix | None") -> Optional["Matrix"]:
        if other is None:
            print("Invalid param")
            return None

        if self.rows != other.rows or self.cols != other.cols:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return None

        result = result = [
            self.data[i] - other.data[i] for i in range(self.rows * self.cols)
        ]

        return Matrix(self.rows, self.cols, result)

    ###########################################################
    # @description: opreator *
    # @param {*} self
    # @param {*} other
    # @return {*}
    ###########################################################
    def __mul__(self, other: "Matrix| int | float | None") -> Optional["Matrix"]:
        if other is None:
            print("Invalid param")
            return None

        if isinstance(other, int | float):
            result: List[Union[int, float]] = [
                self.data[i] * other for i in range(self.rows * self.cols)
            ]
            return Matrix(self.rows, self.cols, result)

        if self.cols != other.rows:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return None

        result: List[Union[int, float]] = [0 for _ in range(self.rows * self.cols)]

        for i in range(self.rows):
            for j in range(other.cols):
                num = 0
                for k in range(other.rows):
                    num += self.data[i * self.cols + k] * other.data[k * self.cols + j]
                result[i * self.cols + j] = num

        return Matrix(self.rows, other.cols, result)

    ###########################################################
    # @description: opreator =
    # @param {*} self
    # @param {object} other
    # @return {*}
    ###########################################################
    def __eq__(self, other: object) -> bool:
        if other is None or not isinstance(other, Matrix):
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

    ###########################################################
    # @description: print matrix
    # @param {*} self
    # @return {*}
    ###########################################################
    def __str__(self: "Matrix | None"):
        if self is None:
            return "This matrix is None\n"
        else:
            return (
                f"--------------------------------------------\n"
                f"matrix size: ({self.rows}, {self.cols})\n"
                f"matrix data: {self.data}\n"
                f"--------------------------------------------"
            )

    ###########################################################
    # @description: opreator +=
    # @param {*} self
    # @param {*} other
    # @return {*}
    ###########################################################
    def __iadd__(self, other: "Matrix | None"):
        if other is None:
            print("Invalid param")
            return self

        if self.rows != other.rows or self.cols != other.cols:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return self

        self.data = [self.data[i] + other.data[i] for i in range(self.rows * self.cols)]

        return self

    ###########################################################
    # @description: opreator -=
    # @param {*} self
    # @param {*} other
    # @return {*}
    ###########################################################
    def __isub__(self, other: "Matrix | None"):
        if other is None:
            print("Invalid param")
            return self

        if self.rows != other.rows or self.cols != other.cols:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return self

        self.data = [self.data[i] - other.data[i] for i in range(self.rows * self.cols)]

        return self

    ###########################################################
    # @description: opreator *=
    # @param {*} self
    # @param {*} other
    # @return {*}
    ###########################################################
    def __imul__(self, other: "Matrix |int | float | None"):
        if other is None:
            print("Invalid param")
            return None

        if isinstance(other, int | float):
            result: List[Union[int, float]] = [
                self.data[i] * other for i in range(self.rows * self.cols)
            ]
            return Matrix(self.rows, self.cols, result)

        if self.cols != other.rows:
            print(
                f"Dimension mismatch! m1({self.rows}, {other.rows}) vs m2({self.cols}, {other.cols})"
            )
            return None

        result: List[Union[int, float]] = [0 for _ in range(self.rows * self.cols)]

        for i in range(self.rows):
            for j in range(other.cols):
                num = 0
                for k in range(other.rows):
                    num += self.data[i * self.cols + k] * other.data[k * self.cols + j]
                result[i * self.cols + j] = num

        self.data = result
        self.cols = other.cols

        return self

    ###########################################################
    # @description: transport of a matrix
    # @param {*} self
    # @return {*}
    ###########################################################
    def transport(self):
        row = self.cols
        col = self.rows
        result: List[Union[int, float]] = [0 for _ in range(row * col)]

        for i in range(row):
            for j in range(col):
                result[i * col + j] = self.data[j * self.cols + i]

        self.data = result
        self.rows = col
        self.cols = row


###########################################################
# @description: find elem in matrix
# @param {Any} m
# @param {Union} v
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


###########################################################
# @description: replace the specific position value
# @param {*} m
# @param {int} x_label : row index
# @param {int} y_label : col index
# @param {Union} new_value
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
# @description:
# @param {*} m
# @param {Union} old_value
# @param {Union} new_value
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


if __name__ == "__main__":
    m = Matrix(2, 2, [1, 2, 3, 4])
    m1 = Matrix(2, 2, [3, 4, 5, 6])
    print(m1)
    row, col = find_elem(m, 2)
    print(row, col)
    m3 = m + m1
    print(m3)
