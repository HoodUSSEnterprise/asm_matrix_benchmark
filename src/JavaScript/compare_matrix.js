/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\compare_matrix.js
@Description: compare matrix JavaScript code
*************************************************************/

"use strict";

const { checkMatrix, sameShape, EPS_FLOAT, EPS_DOUBLE } = require("./common");

/**
 * Compare two matrix values by numeric kind.
 * @param {number} a
 * @param {number} b
 * @param {"int"|"float"|"double"} type
 * @returns {boolean}
 */
function equalValue(a, b, type) {
  if (type === "int") {
    return a === b;
  }
  const eps = type === "float" ? EPS_FLOAT : EPS_DOUBLE;
  return Math.abs(a - b) <= eps;
}

/**
 * Generic matrix equality check.
 * @param {{rows:number, cols:number, data:number[]}} m1
 * @param {{rows:number, cols:number, data:number[]}} m2
 * @param {"int"|"float"|"double"} type
 * @returns {boolean}
 */
function isEqualMatrix(m1, m2, type) {
  if (!checkMatrix(m1, "m1") || !checkMatrix(m2, "m2")) {
    return false;
  }
  if (!sameShape(m1, m2)) {
    return false;
  }

  for (let i = 0; i < m1.data.length; i++) {
    if (!equalValue(m1.data[i], m2.data[i], type)) {
      return false;
    }
  }
  return true;
}

function is_equal_matrix_int(m1, m2) {
  return isEqualMatrix(m1, m2, "int");
}

function is_equal_matrix_float(m1, m2) {
  return isEqualMatrix(m1, m2, "float");
}

function is_equal_matrix_double(m1, m2) {
  return isEqualMatrix(m1, m2, "double");
}

module.exports = {
  is_equal_matrix_int,
  is_equal_matrix_float,
  is_equal_matrix_double,
};
