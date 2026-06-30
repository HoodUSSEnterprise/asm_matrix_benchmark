/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\transpose_matrix.js
@Description: transpose matrix JavaScript code
*************************************************************/

"use strict";

const { checkMatrix, buildTypedMatrix } = require("./common");

/**
 * Generic transpose operation.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function transposeMatrix(m, type) {
  if (!checkMatrix(m, "m")) {
    return null;
  }

  const data = new Array(m.rows * m.cols);
  for (let i = 0; i < m.rows; i++) {
    for (let j = 0; j < m.cols; j++) {
      data[j * m.rows + i] = m.data[i * m.cols + j];
    }
  }

  return buildTypedMatrix(m.cols, m.rows, data, type);
}

function transpose_matrix_int(m) {
  return transposeMatrix(m, "int");
}

function transpose_matrix_float(m) {
  return transposeMatrix(m, "float");
}

function transpose_matrix_double(m) {
  return transposeMatrix(m, "double");
}

module.exports = {
  transpose_matrix_int,
  transpose_matrix_float,
  transpose_matrix_double,
};
