/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\leading_minors.js
@Description: leading minors JavaScript code
*************************************************************/

"use strict";

const { checkMatrix, buildTypedMatrix } = require("./common");

/**
 * Build the top-left k x k principal submatrix.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {number} k
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function topLeftMinor(m, k, type) {
  const data = new Array(k * k);
  for (let i = 0; i < k; i++) {
    for (let j = 0; j < k; j++) {
      data[i * k + j] = m.data[i * m.cols + j];
    }
  }
  return buildTypedMatrix(k, k, data, type);
}

/**
 * Return all leading principal minors as matrix list:
 * [1x1, 2x2, ..., nxn].
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {"int"|"float"|"double"} type
 * @returns {Array<{rows:number, cols:number, data:number[]}>|null}
 */
function getLeadingMinors(m, type) {
  if (!checkMatrix(m, "m")) {
    return null;
  }
  if (m.rows !== m.cols) {
    console.error("Matrix must be square!");
    return null;
  }

  const list = [];
  for (let k = 1; k <= m.rows; k++) {
    const minor = topLeftMinor(m, k, type);
    if (minor === null) {
      return null;
    }
    list.push(minor);
  }
  return list;
}

function get_leading_minors_int(m) {
  return getLeadingMinors(m, "int");
}

function get_leading_minors_float(m) {
  return getLeadingMinors(m, "float");
}

function get_leading_minors_double(m) {
  return getLeadingMinors(m, "double");
}

module.exports = {
  get_leading_minors_int,
  get_leading_minors_float,
  get_leading_minors_double,
};
