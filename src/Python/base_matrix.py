###########################################################
# @Author: HoodUSSEnterprise
# @Date: 2026-06-22 13:14:45
# @LastEditors: HoodUSSEnterprise
# @LastEditTime: 2026-06-29 13:12:52
# @FilePath: \asm_matrix_benchmark\src\Python\base_matrix.py
# @Description: Python file of matrix
###########################################################

from typing import List, Optional, Union


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
    # @description: operator +
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
                f"Dimension mismatch! m1({self.rows}, {self.cols}) vs m2({other.rows}, {other.cols})"
            )
            return None

        result = [self.data[i] + other.data[i] for i in range(self.rows * self.cols)]

        return Matrix(self.rows, self.cols, result)

    ###########################################################
    # @description: operator -
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
                f"Dimension mismatch! m1({self.rows}, {self.cols}) vs m2({other.rows}, {other.cols})"
            )
            return None

        result = result = [
            self.data[i] - other.data[i] for i in range(self.rows * self.cols)
        ]

        return Matrix(self.rows, self.cols, result)

    ###########################################################
    # @description: operator *
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
                f"Dimension mismatch! m1({self.rows}, {self.cols}) vs m2({other.rows}, {other.cols})"
            )
            return None

        result: List[Union[int, float]] = [0 for _ in range(self.rows * other.cols)]

        for i in range(self.rows):
            for j in range(other.cols):
                num = 0
                for k in range(other.rows):
                    num += self.data[i * self.cols + k] * other.data[k * other.cols + j]
                result[i * other.cols + j] = num

        return Matrix(self.rows, other.cols, result)

    ###########################################################
    # @description: operator =
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
                f"Dimension mismatch! m1({self.rows}, {self.cols}) vs m2({other.rows}, {other.cols})"
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
            rows_str = "\n".join(
                [
                    "  ".join(map(str, self.data[i * self.cols : (i + 1) * self.cols]))
                    for i in range(self.rows)
                ]
            )
            return (
                f"--------------------------------------------\n"
                f"matrix size: ({self.rows}, {self.cols})\n"
                f"matrix data:\n"
                f"{rows_str}\n"
                f"--------------------------------------------"
            )

    ###########################################################
    # @description: operator +=
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
                f"Dimension mismatch! m1({self.rows}, {self.cols}) vs m2({other.rows}, {other.cols})"
            )
            return self

        self.data = [self.data[i] + other.data[i] for i in range(self.rows * self.cols)]

        return self

    ###########################################################
    # @description: operator -=
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
                f"Dimension mismatch! m1({self.rows}, {self.cols}) vs m2({other.rows}, {other.cols})"
            )
            return self

        self.data = [self.data[i] - other.data[i] for i in range(self.rows * self.cols)]

        return self

    ###########################################################
    # @description: operator *=
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
                f"Dimension mismatch! m1({self.rows}, {self.cols}) vs m2({other.rows}, {other.cols})"
            )
            return None

        result: List[Union[int, float]] = [0 for _ in range(self.rows * other.cols)]

        for i in range(self.rows):
            for j in range(other.cols):
                num = 0
                for k in range(other.rows):
                    num += self.data[i * self.cols + k] * other.data[k * other.cols + j]
                result[i * other.cols + j] = num

        self.data = result
        self.cols = other.cols

        return self


def _print_sep(title: str) -> None:
    print(title)


def demo_examples() -> None:
    data: List[int | float] = [1, 2, 3, 4]
    v1 = Matrix(2, 2, data.copy())
    v2 = Matrix(1, 4, data.copy())
    v3 = Matrix(2, 2, data.copy())

    _print_sep(
        "---------------------------------------add matrix---------------------------------------"
    )
    v = v1 + v2
    m = v1 + v3
    print(v)
    print(m)
    _print_sep(
        "----------------------------------------------------------------------------------------"
    )

    _print_sep(
        "---------------------------------------sub matrix---------------------------------------"
    )
    v = v1 - v2
    m = v1 - v3
    print(v)
    print(m)
    _print_sep(
        "----------------------------------------------------------------------------------------"
    )

    _print_sep(
        "---------------------------------------mul matrix---------------------------------------"
    )
    mul_data: List[int | float] = [1, 2, 3]
    mul1 = Matrix(3, 1, mul_data.copy())
    mul2 = Matrix(1, 3, mul_data.copy())
    m = mul1 * mul2
    print(m)
    _print_sep(
        "----------------------------------------------------------------------------------------"
    )

    _print_sep(
        "--------------------------------------scale matrix--------------------------------------"
    )
    scale_data: List[int | float] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    scale = Matrix(2, 5, scale_data.copy())
    print(scale)
    m = scale * 2
    print(m)


if __name__ == "__main__":
    demo_examples()
