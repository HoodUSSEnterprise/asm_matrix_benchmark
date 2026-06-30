/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\mul_matrix.js
@Description: mul matrix JavaScript code
*************************************************************/

"use strict";

const { checkMatrix, buildTypedMatrix } = require("./common");

/**
 * Generic matrix multiplication (row-major).
 * @param {{rows:number, cols:number, data:number[]}} m1
 * @param {{rows:number, cols:number, data:number[]}} m2
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function mulMatrix(m1, m2, type) {
  if (!checkMatrix(m1, "m1") || !checkMatrix(m2, "m2")) {
    return null;
  }
  if (m1.cols !== m2.rows) {
    console.log(
      `Dimension mismatch! m1(${m1.rows}, ${m1.cols}) vs m2(${m2.rows}, ${m2.cols})`,
    );
    return null;
  }

  const rows = m1.rows;
  const cols = m2.cols;
  const inner = m1.cols;
  const data = new Array(rows * cols).fill(0);

  // Triple loop is kept intentionally to stay faithful to the C baseline.
  for (let i = 0; i < rows; i++) {
    for (let j = 0; j < cols; j++) {
      let sum = 0;
      for (let k = 0; k < inner; k++) {
        sum += m1.data[i * m1.cols + k] * m2.data[k * m2.cols + j];
      }
      data[i * cols + j] = sum;
    }
  }

  return buildTypedMatrix(rows, cols, data, type);
}

function mul_matrix_int(m1, m2) {
  return mulMatrix(m1, m2, "int");
}

function mul_matrix_float(m1, m2) {
  return mulMatrix(m1, m2, "float");
}

function mul_matrix_double(m1, m2) {
  return mulMatrix(m1, m2, "double");
}

module.exports = {
  mul_matrix_int,
  mul_matrix_float,
  mul_matrix_double,
};
