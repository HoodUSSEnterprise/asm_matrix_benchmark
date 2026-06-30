/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\scale_matrix.js
@Description: scale matrix JavaScript code
*************************************************************/

"use strict";

const { checkMatrix, buildTypedMatrix } = require("./common");

/**
 * Multiply all matrix elements by scalar.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {number} scalar
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function scaleMatrix(m, scalar, type) {
  if (
    !checkMatrix(m, "m") ||
    typeof scalar !== "number" ||
    Number.isNaN(scalar)
  ) {
    console.error("Invalid param!");
    return null;
  }

  const data = new Array(m.rows * m.cols);
  for (let i = 0; i < data.length; i++) {
    data[i] = m.data[i] * scalar;
  }

  return buildTypedMatrix(m.rows, m.cols, data, type);
}

function scale_matrix_int(m, scalar) {
  return scaleMatrix(m, scalar, "int");
}

function scale_matrix_float(m, scalar) {
  return scaleMatrix(m, scalar, "float");
}

function scale_matrix_double(m, scalar) {
  return scaleMatrix(m, scalar, "double");
}

module.exports = {
  scale_matrix_int,
  scale_matrix_float,
  scale_matrix_double,
};
