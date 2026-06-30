/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\determinant_matrix.js
@Description: determinant matrix JavaScript code
*************************************************************/

"use strict";

const {
  checkMatrix,
  gaussianDeterminant,
  EPS_FLOAT,
  EPS_DOUBLE,
  castByType,
} = require("./common");

/**
 * Compute determinant for square matrix.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {"int"|"float"|"double"} type
 * @returns {number|null}
 */
function determinant(m, type) {
  if (!checkMatrix(m, "m")) {
    return null;
  }
  if (m.rows !== m.cols) {
    console.error("Matrix must be square!");
    return null;
  }

  let eps = 0;
  if (type === "float") {
    eps = EPS_FLOAT;
  } else if (type === "double") {
    eps = EPS_DOUBLE;
  }

  const det = gaussianDeterminant(m, eps);
  return castByType(det, type);
}

function determinant_int(m) {
  return determinant(m, "int");
}

function determinant_float(m) {
  return determinant(m, "float");
}

function determinant_double(m) {
  return determinant(m, "double");
}

module.exports = {
  determinant_int,
  determinant_float,
  determinant_double,
};
