/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\replace_matrix.js
@Description: replace matrix JavaScript code
*************************************************************/

"use strict";

const { checkMatrix, castByType, EPS_FLOAT, EPS_DOUBLE } = require("./common");

/**
 * Type-aware equality used by replace-by-value.
 * @param {number} a
 * @param {number} b
 * @param {"int"|"float"|"double"} type
 * @returns {boolean}
 */
function sameValue(a, b, type) {
  if (type === "int") {
    return a === b;
  }
  const eps = type === "float" ? EPS_FLOAT : EPS_DOUBLE;
  return Math.abs(a - b) <= eps;
}

/**
 * Replace one element by coordinates, in-place.
 * Point semantic follows C: x=row, y=col.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {{x:number,y:number}} pos
 * @param {number} newData
 * @param {"int"|"float"|"double"} type
 * @returns {boolean}
 */
function replaceByCoord(m, pos, newData, type) {
  if (
    !checkMatrix(m, "m") ||
    !pos ||
    !Number.isInteger(pos.x) ||
    !Number.isInteger(pos.y) ||
    typeof newData !== "number" ||
    Number.isNaN(newData)
  ) {
    console.error("Invalid param!");
    return false;
  }

  if (pos.x < 0 || pos.x >= m.rows || pos.y < 0 || pos.y >= m.cols) {
    console.error("Index out of range!");
    return false;
  }

  m.data[pos.x * m.cols + pos.y] = castByType(newData, type);
  return true;
}

/**
 * Replace all matched values in-place.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {number} oldData
 * @param {number} newData
 * @param {"int"|"float"|"double"} type
 * @returns {boolean}
 */
function replaceByValue(m, oldData, newData, type) {
  if (
    !checkMatrix(m, "m") ||
    typeof oldData !== "number" ||
    Number.isNaN(oldData) ||
    typeof newData !== "number" ||
    Number.isNaN(newData)
  ) {
    console.error("Invalid param!");
    return false;
  }

  let found = false;
  const casted = castByType(newData, type);

  for (let i = 0; i < m.data.length; i++) {
    if (sameValue(m.data[i], oldData, type)) {
      m.data[i] = casted;
      found = true;
    }
  }

  return found;
}

function replace_matrix_int_by_coord(m, pos, newData) {
  return replaceByCoord(m, pos, newData, "int");
}

function replace_matrix_int_by_value(m, oldData, newData) {
  return replaceByValue(m, oldData, newData, "int");
}

function replace_matrix_float_by_coord(m, pos, newData) {
  return replaceByCoord(m, pos, newData, "float");
}

function replace_matrix_float_by_value(m, oldData, newData) {
  return replaceByValue(m, oldData, newData, "float");
}

function replace_matrix_double_by_coord(m, pos, newData) {
  return replaceByCoord(m, pos, newData, "double");
}

function replace_matrix_double_by_value(m, oldData, newData) {
  return replaceByValue(m, oldData, newData, "double");
}

module.exports = {
  replace_matrix_int_by_coord,
  replace_matrix_int_by_value,
  replace_matrix_float_by_coord,
  replace_matrix_float_by_value,
  replace_matrix_double_by_coord,
  replace_matrix_double_by_value,
};
