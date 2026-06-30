/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\lu_matrix.js
@Description: LU decomposition JavaScript code
*************************************************************/

"use strict";

const {
  checkMatrix,
  buildTypedMatrix,
  EPS_FLOAT,
  EPS_DOUBLE,
} = require("./common");
const {
  determinant_int,
  determinant_float,
  determinant_double,
} = require("./determinant_matrix");
const {
  get_leading_minors_int,
  get_leading_minors_float,
  get_leading_minors_double,
} = require("./leading_minors");

/**
 * Check if all leading principal minors are non-zero.
 * This follows the C implementation logic before Doolittle decomposition.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {"int"|"float"|"double"} type
 * @returns {boolean}
 */
function hasNonZeroLeadingMinors(m, type) {
  const minors =
    type === "int"
      ? get_leading_minors_int(m)
      : type === "float"
        ? get_leading_minors_float(m)
        : get_leading_minors_double(m);

  if (minors === null) {
    return false;
  }

  for (let i = 0; i < minors.length; i++) {
    const det =
      type === "int"
        ? determinant_int(minors[i])
        : type === "float"
          ? determinant_float(minors[i])
          : determinant_double(minors[i]);

    if (det === null) {
      return false;
    }

    const eps = type === "int" ? 0 : type === "float" ? EPS_FLOAT : EPS_DOUBLE;
    if (Math.abs(det) <= eps) {
      return false;
    }
  }

  return true;
}

/**
 * Doolittle LU decomposition without pivoting.
 * Output matrices use double flavor for numerical stability,
 * consistent with C code where LU outputs MatrixDouble.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {"int"|"float"|"double"} type
 * @returns {{L:{rows:number, cols:number, data:number[]}, U:{rows:number, cols:number, data:number[]}}|null}
 */
function luDecomposition(m, type) {
  if (!checkMatrix(m, "m")) {
    return null;
  }
  if (m.rows !== m.cols) {
    console.error("Matrix must be square!");
    return null;
  }

  if (!hasNonZeroLeadingMinors(m, type)) {
    console.error("Matrix cannot perform LU decomposition without pivoting!");
    return null;
  }

  const n = m.rows;
  const L = new Array(n * n).fill(0);
  const U = new Array(n * n).fill(0);

  for (let i = 0; i < n; i++) {
    L[i * n + i] = 1;
  }

  // Doolittle formula: solve U row i first, then L column i.
  for (let i = 0; i < n; i++) {
    for (let k = i; k < n; k++) {
      let sum = 0;
      for (let j = 0; j < i; j++) {
        sum += L[i * n + j] * U[j * n + k];
      }
      U[i * n + k] = m.data[i * n + k] - sum;
    }

    for (let k = i + 1; k < n; k++) {
      let sum = 0;
      for (let j = 0; j < i; j++) {
        sum += L[k * n + j] * U[j * n + i];
      }
      U[i * n + i] = Number(U[i * n + i]);
      if (Math.abs(U[i * n + i]) <= EPS_DOUBLE) {
        console.error("Singular pivot found in LU decomposition!");
        return null;
      }
      L[k * n + i] = (m.data[k * n + i] - sum) / U[i * n + i];
    }
  }

  return {
    L: buildTypedMatrix(n, n, L, "double"),
    U: buildTypedMatrix(n, n, U, "double"),
  };
}

function LU_Decomposition_int(m) {
  return luDecomposition(m, "int");
}

function LU_Decomposition_float(m) {
  return luDecomposition(m, "float");
}

function LU_Decomposition_double(m) {
  return luDecomposition(m, "double");
}

module.exports = {
  LU_Decomposition_int,
  LU_Decomposition_float,
  LU_Decomposition_double,
};
