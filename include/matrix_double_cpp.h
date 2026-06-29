/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-25 16:55:25
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:09:45
@FilePath: \asm_matrix_benchmark\include\matrix_double_cpp.h
@Description:matrix double C++ head file
*************************************************************/

#pragma once

#include <iostream>
#include <utility>
#include <vector>

class MatrixDouble
{
private:
    size_t rows;
    size_t cols;
    std::vector<double> data;

public:
    // constructors / destructor
    MatrixDouble();
    MatrixDouble(size_t r, size_t c);
    MatrixDouble(const double *arr, size_t r, size_t c);
    MatrixDouble(const MatrixDouble &other);
    MatrixDouble(MatrixDouble &&other) noexcept;
    ~MatrixDouble();

    // assignment
    MatrixDouble &operator=(const MatrixDouble &other);
    MatrixDouble &operator=(MatrixDouble &&other) noexcept;

    // element access
    double &operator()(size_t i, size_t j);
    const double &operator()(size_t i, size_t j) const;

    // getters
    size_t get_rows() const { return rows; }
    size_t get_cols() const { return cols; }

    // arithmetic operators
    MatrixDouble operator+(const MatrixDouble &other) const;
    MatrixDouble operator-(const MatrixDouble &other) const;
    MatrixDouble operator*(const MatrixDouble &other) const;
    MatrixDouble operator*(double scalar) const;
    friend MatrixDouble operator*(double scalar, const MatrixDouble &m);

    // compound assignment
    MatrixDouble &operator+=(const MatrixDouble &other);
    MatrixDouble &operator-=(const MatrixDouble &other);
    MatrixDouble &operator*=(const MatrixDouble &other);
    MatrixDouble &operator*=(double scalar);

    // comparison
    bool operator==(const MatrixDouble &other) const;
    bool operator!=(const MatrixDouble &other) const;

    // output
    friend std::ostream &operator<<(std::ostream &os, const MatrixDouble &m);

    // matrix operations
    MatrixDouble transpose() const;
    MatrixDouble cat(const MatrixDouble &other, int axis) const;

    // find / replace
    std::pair<int, int> find_elem(double value) const;
    void replace_pos(size_t x, size_t y, double new_value);
    void replace_elem(double old_value, double new_value);

    // extract submatrix
    MatrixDouble extract_row(size_t row_idx) const;
    MatrixDouble extract_col(size_t col_idx) const;
    MatrixDouble extract_submatrix(size_t r_start, size_t r_end, size_t c_start, size_t c_end) const;

    // linear algebra
    size_t rank() const;
    double trace() const;
    std::vector<MatrixDouble> leading_minors() const;
    MatrixDouble inv_matrix() const;
    std::vector<MatrixDouble> LU_Decomposition();

    // static factories
    static MatrixDouble identity(size_t n);
    static MatrixDouble zeros(size_t r, size_t c);
    static MatrixDouble ones(size_t r, size_t c);
    static MatrixDouble random(size_t r, size_t c, double low = 0, double high = 10);
};
