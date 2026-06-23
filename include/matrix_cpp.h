/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:02:24
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 17:45:04
@FilePath: \asm_matrix_benchmark\include\matrix_cpp.h
@Description: matrix C++ head file
*************************************************************/
#pragma once

#include <iostream>
#include <utility>
#include <vector>

class MatrixInt
{
private:
    size_t rows;
    size_t cols;
    std::vector<int> data;

public:
    // constructors / destructor
    MatrixInt();
    MatrixInt(size_t r, size_t c);
    MatrixInt(const int *arr, size_t r, size_t c);
    MatrixInt(const MatrixInt &other);
    MatrixInt(MatrixInt &&other) noexcept;
    ~MatrixInt();

    // assignment
    MatrixInt &operator=(const MatrixInt &other);
    MatrixInt &operator=(MatrixInt &&other) noexcept;

    // element access
    int &operator()(size_t i, size_t j);
    const int &operator()(size_t i, size_t j) const;

    // getters
    size_t get_rows() const { return rows; }
    size_t get_cols() const { return cols; }

    // arithmetic operators
    MatrixInt operator+(const MatrixInt &other) const;
    MatrixInt operator-(const MatrixInt &other) const;
    MatrixInt operator*(const MatrixInt &other) const;
    MatrixInt operator*(int scalar) const;
    friend MatrixInt operator*(int scalar, const MatrixInt &m);

    // compound assignment
    MatrixInt &operator+=(const MatrixInt &other);
    MatrixInt &operator-=(const MatrixInt &other);
    MatrixInt &operator*=(const MatrixInt &other);
    MatrixInt &operator*=(int scalar);

    // comparison
    bool operator==(const MatrixInt &other) const;
    bool operator!=(const MatrixInt &other) const;

    // output
    friend std::ostream &operator<<(std::ostream &os, const MatrixInt &m);

    // matrix operations
    MatrixInt transpose() const;
    MatrixInt cat(const MatrixInt &other, int axis) const;

    // find / replace
    std::pair<int, int> find_elem(int value) const;
    void replace_pos(size_t x, size_t y, int new_value);
    void replace_elem(int old_value, int new_value);

    // extract submatrix
    MatrixInt extract_row(size_t row_idx) const;
    MatrixInt extract_col(size_t col_idx) const;
    MatrixInt extract_submatrix(size_t r_start, size_t r_end, size_t c_start, size_t c_end) const;

    // linear algebra
    size_t rank() const;
    int trace() const;
    std::vector<MatrixInt> leading_minors() const;

    // static factories
    static MatrixInt identity(size_t n);
    static MatrixInt zeros(size_t r, size_t c);
    static MatrixInt ones(size_t r, size_t c);
    static MatrixInt random(size_t r, size_t c, int low = 0, int high = 10);
};
