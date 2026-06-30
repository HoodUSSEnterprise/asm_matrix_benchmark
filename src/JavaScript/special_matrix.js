/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\special_matrix.js
@Description: special matrix JavaScript code
*************************************************************/

"use strict";

const { buildTypedMatrix, castByType } = require("./common");

/**
 * Build identity matrix (n x n).
 * @param {number} n
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function identityMatrix(n, type) {
  if (!Number.isInteger(n) || n <= 0) {
    console.error("Invalid param!");
    return null;
  }

  const data = new Array(n * n).fill(0);
  for (let i = 0; i < n; i++) {
    data[i * n + i] = 1;
  }
  return buildTypedMatrix(n, n, data, type);
}

/**
 * Build diagonal matrix from vector.
 * @param {number[]} diag
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function diagMatrix(diag, type) {
  if (!Array.isArray(diag) || diag.length === 0) {
    console.error("Invalid param!");
    return null;
  }

  const n = diag.length;
  const data = new Array(n * n).fill(0);
  for (let i = 0; i < n; i++) {
    data[i * n + i] = castByType(Number(diag[i]), type);
  }
  return buildTypedMatrix(n, n, data, type);
}

/**
 * Build all-zero matrix.
 * @param {number} rows
 * @param {number} cols
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function zeroMatrix(rows, cols, type) {
  if (
    !Number.isInteger(rows) ||
    !Number.isInteger(cols) ||
    rows <= 0 ||
    cols <= 0
  ) {
    console.error("Invalid param!");
    return null;
  }
  return buildTypedMatrix(rows, cols, new Array(rows * cols).fill(0), type);
}

/**
 * Build eye matrix with size rows x cols.
 * Main diagonal entries are 1, others are 0.
 * @param {number} rows
 * @param {number} cols
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function eyeMatrix(rows, cols, type) {
  if (
    !Number.isInteger(rows) ||
    !Number.isInteger(cols) ||
    rows <= 0 ||
    cols <= 0
  ) {
    console.error("Invalid param!");
    return null;
  }

  const data = new Array(rows * cols).fill(0);
  const n = Math.min(rows, cols);
  for (let i = 0; i < n; i++) {
    data[i * cols + i] = 1;
  }
  return buildTypedMatrix(rows, cols, data, type);
}

function identity_matrix_int(n) {
  return identityMatrix(n, "int");
}

function diag_matrix_int(diag) {
  return diagMatrix(diag, "int");
}

function eye_matrix_int(rows, cols) {
  return eyeMatrix(rows, cols, "int");
}

function zero_matrix_int(rows, cols) {
  return zeroMatrix(rows, cols, "int");
}

function identity_matrix_float(n) {
  return identityMatrix(n, "float");
}

function diag_matrix_float(diag) {
  return diagMatrix(diag, "float");
}

function eye_matrix_float(rows, cols) {
  return eyeMatrix(rows, cols, "float");
}

function zero_matrix_float(rows, cols) {
  return zeroMatrix(rows, cols, "float");
}

function identity_matrix_double(n) {
  return identityMatrix(n, "double");
}

function diag_matrix_double(diag) {
  return diagMatrix(diag, "double");
}

function eye_matrix_double(rows, cols) {
  return eyeMatrix(rows, cols, "double");
}

function zero_matrix_double(rows, cols) {
  return zeroMatrix(rows, cols, "double");
}

module.exports = {
  identity_matrix_int,
  diag_matrix_int,
  eye_matrix_int,
  zero_matrix_int,
  identity_matrix_float,
  diag_matrix_float,
  eye_matrix_float,
  zero_matrix_float,
  identity_matrix_double,
  diag_matrix_double,
  eye_matrix_double,
  zero_matrix_double,
};
