/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\find_matrix.js
@Description: find matrix JavaScript code
*************************************************************/

"use strict";

const { checkMatrix, EPS_FLOAT, EPS_DOUBLE } = require("./common");

/**
 * Compare numbers under type-specific rules.
 * @param {number} a
 * @param {number} b
 * @param {"int"|"float"|"double"} type
 * @returns {boolean}
 */
function isEqualValue(a, b, type) {
  if (type === "int") {
    return a === b;
  }
  const eps = type === "float" ? EPS_FLOAT : EPS_DOUBLE;
  return Math.abs(a - b) <= eps;
}

/**
 * Find first matched element in row-major order.
 * Returned point follows C convention: x=row, y=col.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {number} target
 * @param {"int"|"float"|"double"} type
 * @returns {{x:number, y:number}|null}
 */
function findElem(m, target, type) {
  if (
    !checkMatrix(m, "m") ||
    typeof target !== "number" ||
    Number.isNaN(target)
  ) {
    console.error("Invalid param!");
    return null;
  }

  for (let i = 0; i < m.rows; i++) {
    for (let j = 0; j < m.cols; j++) {
      const cur = m.data[i * m.cols + j];
      if (isEqualValue(cur, target, type)) {
        return { x: i, y: j };
      }
    }
  }

  return null;
}

function find_elem_int(m, target) {
  return findElem(m, target, "int");
}

function find_elem_float(m, target) {
  return findElem(m, target, "float");
}

function find_elem_double(m, target) {
  return findElem(m, target, "double");
}

module.exports = {
  find_elem_int,
  find_elem_float,
  find_elem_double,
};
