/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\add_matrix.js
@Description: add matrix JavaScript code
*************************************************************/

"use strict";

const { checkMatrix, sameShape, buildTypedMatrix } = require("./common");

/**
 * Generic element-wise addition.
 * @param {{rows:number, cols:number, data:number[]}} m1
 * @param {{rows:number, cols:number, data:number[]}} m2
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function addMatrix(m1, m2, type) {
  if (!checkMatrix(m1, "m1") || !checkMatrix(m2, "m2")) {
    return null;
  }
  if (!sameShape(m1, m2)) {
    return null;
  }

  const data = new Array(m1.rows * m1.cols);
  for (let i = 0; i < data.length; i++) {
    data[i] = m1.data[i] + m2.data[i];
  }

  return buildTypedMatrix(m1.rows, m1.cols, data, type);
}

function add_matrix_int(m1, m2) {
  return addMatrix(m1, m2, "int");
}

function add_matrix_float(m1, m2) {
  return addMatrix(m1, m2, "float");
}

function add_matrix_double(m1, m2) {
  return addMatrix(m1, m2, "double");
}

module.exports = {
  add_matrix_int,
  add_matrix_float,
  add_matrix_double,
};
