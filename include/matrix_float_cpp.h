/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-26 09:00:04
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:09:54
@FilePath: \asm_matrix_benchmark\include\matrix_float_cpp.h
@Description:
*************************************************************/

#pragma once

#include "matrix_double_cpp.h"
#include <iostream>
#include <utility>
#include <vector>

class MatrixFloat
{
private:
    size_t rows;
    size_t cols;
    std::vector<float> data;

public:
    // constructors / destructor
    MatrixFloat();
    MatrixFloat(size_t r, size_t c);
    MatrixFloat(const float *arr, size_t r, size_t c);
    MatrixFloat(const MatrixFloat &other);
    MatrixFloat(MatrixFloat &&other) noexcept;
    ~MatrixFloat();

    // assignment
    MatrixFloat &operator=(const MatrixFloat &other);
    MatrixFloat &operator=(MatrixFloat &&other) noexcept;

    // element access
    float &operator()(size_t i, size_t j);
    const float &operator()(size_t i, size_t j) const;

    // getters
    size_t get_rows() const { return rows; }
    size_t get_cols() const { return cols; }

    // arithmetic operators
    MatrixFloat operator+(const MatrixFloat &other) const;
    MatrixFloat operator-(const MatrixFloat &other) const;
    MatrixFloat operator*(const MatrixFloat &other) const;
    MatrixFloat operator*(float scalar) const;
    friend MatrixFloat operator*(float scalar, const MatrixFloat &m);

    // compound assignment
    MatrixFloat &operator+=(const MatrixFloat &other);
    MatrixFloat &operator-=(const MatrixFloat &other);
    MatrixFloat &operator*=(const MatrixFloat &other);
    MatrixFloat &operator*=(float scalar);

    // comparison
    bool operator==(const MatrixFloat &other) const;
    bool operator!=(const MatrixFloat &other) const;

    // output
    friend std::ostream &operator<<(std::ostream &os, const MatrixFloat &m);

    // matrix operations
    MatrixFloat transpose() const;
    MatrixFloat cat(const MatrixFloat &other, int axis) const;

    // find / replace
    std::pair<int, int> find_elem(float value) const;
    void replace_pos(size_t x, size_t y, float new_value);
    void replace_elem(float old_value, float new_value);

    // extract submatrix
    MatrixFloat extract_row(size_t row_idx) const;
    MatrixFloat extract_col(size_t col_idx) const;
    MatrixFloat extract_submatrix(size_t r_start, size_t r_end, size_t c_start, size_t c_end) const;

    // linear algebra
    size_t rank() const;
    float trace() const;
    std::vector<MatrixFloat> leading_minors() const;
    MatrixDouble inv_matrix() const;

    // static factories
    static MatrixFloat identity(size_t n);
    static MatrixFloat zeros(size_t r, size_t c);
    static MatrixFloat ones(size_t r, size_t c);
    static MatrixFloat random(size_t r, size_t c, float low = 0, float high = 10);
};
