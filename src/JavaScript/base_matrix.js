/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\base_matrix.js
@Description: base constructors and simple matrix helpers for JavaScript
*************************************************************/

"use strict";

const {
  createMatrix,
  cloneMatrix,
  castByType,
  checkMatrix,
} = require("./common");

/**
 * Create an int matrix from row/col/data.
 * @param {number} rows
 * @param {number} cols
 * @param {number[]} data
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function matrix_int(rows, cols, data) {
  if (!Array.isArray(data)) {
    console.error("Invalid param!");
    return null;
  }
  return createMatrix(
    rows,
    cols,
    data.map((v) => castByType(v, "int")),
  );
}

/**
 * Create a float matrix from row/col/data.
 * @param {number} rows
 * @param {number} cols
 * @param {number[]} data
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function matrix_float(rows, cols, data) {
  if (!Array.isArray(data)) {
    console.error("Invalid param!");
    return null;
  }
  return createMatrix(
    rows,
    cols,
    data.map((v) => castByType(v, "float")),
  );
}

/**
 * Create a double matrix from row/col/data.
 * @param {number} rows
 * @param {number} cols
 * @param {number[]} data
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function matrix_double(rows, cols, data) {
  if (!Array.isArray(data)) {
    console.error("Invalid param!");
    return null;
  }
  return createMatrix(
    rows,
    cols,
    data.map((v) => castByType(v, "double")),
  );
}

/**
 * Deep-copy matrix so callers can avoid accidental aliasing.
 * @param {{rows:number, cols:number, data:number[]}|null} m
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function copy_matrix(m) {
  if (!checkMatrix(m, "m")) {
    return null;
  }
  return cloneMatrix(m);
}

module.exports = {
  matrix_int,
  matrix_float,
  matrix_double,
  copy_matrix,
};
