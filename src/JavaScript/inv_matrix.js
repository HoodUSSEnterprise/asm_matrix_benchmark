/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\inv_matrix.js
@Description: inverse matrix JavaScript code
*************************************************************/

"use strict";

const {
  checkMatrix,
  buildTypedMatrix,
  EPS_FLOAT,
  EPS_DOUBLE,
} = require("./common");
const {
  rank_matrix_int,
  rank_matrix_float,
  rank_matrix_double,
} = require("./rank_trace_matrix");

/**
 * Invert matrix using Gauss-Jordan elimination on [A | I].
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function invMatrix(m, type) {
  if (!checkMatrix(m, "m")) {
    return null;
  }
  if (m.rows !== m.cols) {
    console.error("Matrix must be square!");
    return null;
  }

  const n = m.rows;
  const rank =
    type === "int"
      ? rank_matrix_int(m)
      : type === "float"
        ? rank_matrix_float(m)
        : rank_matrix_double(m);

  if (rank !== n) {
    console.error("Singular matrix has no inverse!");
    return null;
  }

  const eps = type === "int" ? 0 : type === "float" ? EPS_FLOAT : EPS_DOUBLE;

  // Build augmented matrix with 2*n columns.
  const a = new Array(n);
  for (let i = 0; i < n; i++) {
    a[i] = new Array(2 * n).fill(0);
    for (let j = 0; j < n; j++) {
      a[i][j] = Number(m.data[i * n + j]);
    }
    a[i][n + i] = 1;
  }

  for (let col = 0; col < n; col++) {
    let pivot = col;
    for (let i = col + 1; i < n; i++) {
      if (Math.abs(a[i][col]) > Math.abs(a[pivot][col])) {
        pivot = i;
      }
    }

    if (Math.abs(a[pivot][col]) <= eps) {
      console.error("Singular matrix has no inverse!");
      return null;
    }

    if (pivot !== col) {
      const tmp = a[pivot];
      a[pivot] = a[col];
      a[col] = tmp;
    }

    const pivotVal = a[col][col];
    for (let j = 0; j < 2 * n; j++) {
      a[col][j] /= pivotVal;
    }

    for (let i = 0; i < n; i++) {
      if (i === col) {
        continue;
      }
      const factor = a[i][col];
      if (Math.abs(factor) <= eps) {
        continue;
      }
      for (let j = 0; j < 2 * n; j++) {
        a[i][j] -= factor * a[col][j];
      }
    }
  }

  const inv = new Array(n * n);
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      inv[i * n + j] = a[i][n + j];
    }
  }

  return buildTypedMatrix(n, n, inv, type);
}

function inv_matrix_int(m) {
  return invMatrix(m, "int");
}

function inv_matrix_float(m) {
  return invMatrix(m, "float");
}

function inv_matrix_double(m) {
  return invMatrix(m, "double");
}

module.exports = {
  inv_matrix_int,
  inv_matrix_float,
  inv_matrix_double,
};
