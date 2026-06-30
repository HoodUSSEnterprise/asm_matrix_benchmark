/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\extract_matrix.js
@Description: extract matrix JavaScript code
*************************************************************/

"use strict";

const { checkMatrix, buildTypedMatrix } = require("./common");

/**
 * Extract one row as a 1 x cols matrix.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {number} index
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function extractRow(m, index, type) {
  if (!checkMatrix(m, "m") || !Number.isInteger(index)) {
    console.error("Invalid param!");
    return null;
  }
  if (index < 0 || index >= m.rows) {
    console.error("Index out of range!");
    return null;
  }

  const data = new Array(m.cols);
  for (let j = 0; j < m.cols; j++) {
    data[j] = m.data[index * m.cols + j];
  }
  return buildTypedMatrix(1, m.cols, data, type);
}

/**
 * Extract one column as a rows x 1 matrix.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {number} index
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function extractCol(m, index, type) {
  if (!checkMatrix(m, "m") || !Number.isInteger(index)) {
    console.error("Invalid param!");
    return null;
  }
  if (index < 0 || index >= m.cols) {
    console.error("Index out of range!");
    return null;
  }

  const data = new Array(m.rows);
  for (let i = 0; i < m.rows; i++) {
    data[i] = m.data[i * m.cols + index];
  }
  return buildTypedMatrix(m.rows, 1, data, type);
}

/**
 * Extract main diagonal values as a plain array.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @returns {number[]|null}
 */
function extractDiag(m) {
  if (!checkMatrix(m, "m")) {
    return null;
  }

  const n = Math.min(m.rows, m.cols);
  const diag = new Array(n);
  for (let i = 0; i < n; i++) {
    diag[i] = m.data[i * m.cols + i];
  }
  return diag;
}

function extract_row_int(m, index) {
  return extractRow(m, index, "int");
}

function extract_col_int(m, index) {
  return extractCol(m, index, "int");
}

function extract_diag_int(m) {
  return extractDiag(m);
}

function extract_row_float(m, index) {
  return extractRow(m, index, "float");
}

function extract_col_float(m, index) {
  return extractCol(m, index, "float");
}

function extract_diag_float(m) {
  return extractDiag(m);
}

function extract_row_double(m, index) {
  return extractRow(m, index, "double");
}

function extract_col_double(m, index) {
  return extractCol(m, index, "double");
}

function extract_diag_double(m) {
  return extractDiag(m);
}

module.exports = {
  extract_row_int,
  extract_col_int,
  extract_diag_int,
  extract_row_float,
  extract_col_float,
  extract_diag_float,
  extract_row_double,
  extract_col_double,
  extract_diag_double,
};
