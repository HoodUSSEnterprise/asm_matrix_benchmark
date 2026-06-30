/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\cat_matrix.js
@Description: cat matrix JavaScript code
*************************************************************/

"use strict";

const { checkMatrix, buildTypedMatrix } = require("./common");

/**
 * Concatenate matrices by axis.
 * axis=0: vertical (same cols)
 * axis=1: horizontal (same rows)
 * @param {{rows:number, cols:number, data:number[]}} m1
 * @param {{rows:number, cols:number, data:number[]}} m2
 * @param {number} axis
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function catMatrix(m1, m2, axis, type) {
  if (!checkMatrix(m1, "m1") || !checkMatrix(m2, "m2")) {
    return null;
  }

  if (axis === 0) {
    if (m1.cols !== m2.cols) {
      console.log(
        `Dimension mismatch! m1(${m1.rows}, ${m1.cols}) vs m2(${m2.rows}, ${m2.cols})`,
      );
      return null;
    }

    const rows = m1.rows + m2.rows;
    const cols = m1.cols;
    const data = m1.data.concat(m2.data);
    return buildTypedMatrix(rows, cols, data, type);
  }

  if (axis === 1) {
    if (m1.rows !== m2.rows) {
      console.log(
        `Dimension mismatch! m1(${m1.rows}, ${m1.cols}) vs m2(${m2.rows}, ${m2.cols})`,
      );
      return null;
    }

    const rows = m1.rows;
    const cols = m1.cols + m2.cols;
    const data = new Array(rows * cols);

    for (let i = 0; i < rows; i++) {
      for (let j = 0; j < m1.cols; j++) {
        data[i * cols + j] = m1.data[i * m1.cols + j];
      }
      for (let j = 0; j < m2.cols; j++) {
        data[i * cols + (m1.cols + j)] = m2.data[i * m2.cols + j];
      }
    }

    return buildTypedMatrix(rows, cols, data, type);
  }

  console.error("Invalid axis! axis must be 0 or 1");
  return null;
}

function cat_matrix_int(m1, m2, axis) {
  return catMatrix(m1, m2, axis, "int");
}

function cat_matrix_float(m1, m2, axis) {
  return catMatrix(m1, m2, axis, "float");
}

function cat_matrix_double(m1, m2, axis) {
  return catMatrix(m1, m2, axis, "double");
}

module.exports = {
  cat_matrix_int,
  cat_matrix_float,
  cat_matrix_double,
};
