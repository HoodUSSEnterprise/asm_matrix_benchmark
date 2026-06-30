/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\common.js
@Description: shared helper utilities for JavaScript matrix implementation
*************************************************************/

"use strict";

// Numeric tolerances follow the C implementation style.
const EPS_FLOAT = 1e-5;
const EPS_DOUBLE = 1e-6;

/**
 * Create a matrix object in row-major layout.
 * @param {number} rows
 * @param {number} cols
 * @param {number[]} data
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function createMatrix(rows, cols, data) {
  if (
    !Number.isInteger(rows) ||
    !Number.isInteger(cols) ||
    rows <= 0 ||
    cols <= 0
  ) {
    console.error("Invalid param!");
    return null;
  }
  if (!Array.isArray(data) || data.length !== rows * cols) {
    console.error("Invalid param!");
    return null;
  }
  return {
    rows,
    cols,
    data: data.slice(),
  };
}

/**
 * Clone matrix deeply so downstream operations can remain pure.
 * @param {{rows:number, cols:number, data:number[]}|null} m
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function cloneMatrix(m) {
  if (!isValidMatrix(m)) {
    return null;
  }
  return {
    rows: m.rows,
    cols: m.cols,
    data: m.data.slice(),
  };
}

/**
 * Check matrix shape and data validity.
 * @param {any} m
 * @returns {boolean}
 */
function isValidMatrix(m) {
  return (
    !!m &&
    Number.isInteger(m.rows) &&
    Number.isInteger(m.cols) &&
    m.rows > 0 &&
    m.cols > 0 &&
    Array.isArray(m.data) &&
    m.data.length === m.rows * m.cols
  );
}

/**
 * Verify matrix and print C-like error messages.
 * @param {any} m
 * @param {string} name
 * @returns {boolean}
 */
function checkMatrix(m, name) {
  if (!isValidMatrix(m)) {
    console.error("Invalid param!", name);
    return false;
  }
  return true;
}

/**
 * Check same shape for element-wise operations.
 * @param {{rows:number, cols:number}} m1
 * @param {{rows:number, cols:number}} m2
 * @returns {boolean}
 */
function sameShape(m1, m2) {
  if (m1.rows !== m2.rows || m1.cols !== m2.cols) {
    console.log(
      `Dimension mismatch! m1(${m1.rows}, ${m1.cols}) vs m2(${m2.rows}, ${m2.cols})`,
    );
    return false;
  }
  return true;
}

/**
 * Convert value according to numeric flavor.
 * @param {number} value
 * @param {"int"|"float"|"double"} type
 * @returns {number}
 */
function castByType(value, type) {
  if (type === "int") {
    // Truncate to mimic C integer assignment behavior.
    return value < 0 ? Math.ceil(value) : Math.floor(value);
  }
  // JavaScript uses Number for both float and double semantics.
  return Number(value);
}

/**
 * Build a matrix and cast every element by type.
 * @param {number} rows
 * @param {number} cols
 * @param {number[]} data
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function buildTypedMatrix(rows, cols, data, type) {
  const casted = data.map((v) => castByType(v, type));
  return createMatrix(rows, cols, casted);
}

/**
 * Resolve random range boundaries from C-like arguments.
 * C behavior:
 * - size=0: [0, 10]
 * - size=1: if r0>0 => [0, r0], if r0==0 => [0,10], else [r0,0]
 * - size>=2: [min(r0,r1), max(r0,r1)]
 * @param {number[]|undefined|null} range
 * @param {number|undefined|null} size
 * @param {"int"|"float"|"double"} type
 * @returns {{min:number, max:number}}
 */
function parseRange(range, size, type) {
  const r = Array.isArray(range) ? range : [];
  const n = Number.isInteger(size) ? size : r.length;

  let minBoundary = 0;
  let maxBoundary = type === "int" ? 10 : 10.0;

  if (n === 0) {
    return { min: minBoundary, max: maxBoundary };
  }

  const r0 = Number(r[0] ?? 0);
  if (n === 1) {
    if (r0 > 0) {
      return { min: 0, max: r0 };
    }
    if (r0 === 0) {
      return { min: 0, max: maxBoundary };
    }
    return { min: r0, max: 0 };
  }

  const r1 = Number(r[1] ?? 0);
  return {
    min: Math.min(r0, r1),
    max: Math.max(r0, r1),
  };
}

/**
 * Compute matrix rank by Gaussian elimination with partial pivoting.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {number} eps
 * @returns {number}
 */
function gaussianRank(m, eps) {
  const rows = m.rows;
  const cols = m.cols;
  const a = [];

  for (let i = 0; i < rows; i++) {
    const row = [];
    for (let j = 0; j < cols; j++) {
      row.push(Number(m.data[i * cols + j]));
    }
    a.push(row);
  }

  let rank = 0;
  let pivotCol = 0;

  while (rank < rows && pivotCol < cols) {
    let pivot = rank;
    for (let i = rank + 1; i < rows; i++) {
      if (Math.abs(a[i][pivotCol]) > Math.abs(a[pivot][pivotCol])) {
        pivot = i;
      }
    }

    if (Math.abs(a[pivot][pivotCol]) <= eps) {
      pivotCol += 1;
      continue;
    }

    if (pivot !== rank) {
      const tmp = a[pivot];
      a[pivot] = a[rank];
      a[rank] = tmp;
    }

    for (let i = rank + 1; i < rows; i++) {
      const factor = a[i][pivotCol] / a[rank][pivotCol];
      a[i][pivotCol] = 0;
      for (let j = pivotCol + 1; j < cols; j++) {
        a[i][j] -= factor * a[rank][j];
      }
    }

    rank += 1;
    pivotCol += 1;
  }

  return rank;
}

/**
 * Determinant by Gaussian elimination with partial pivoting.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {number} eps
 * @returns {number}
 */
function gaussianDeterminant(m, eps) {
  const n = m.rows;
  const a = [];

  for (let i = 0; i < n; i++) {
    const row = [];
    for (let j = 0; j < n; j++) {
      row.push(Number(m.data[i * n + j]));
    }
    a.push(row);
  }

  let sign = 1;

  for (let col = 0; col < n; col++) {
    let pivot = col;
    for (let i = col + 1; i < n; i++) {
      if (Math.abs(a[i][col]) > Math.abs(a[pivot][col])) {
        pivot = i;
      }
    }

    if (Math.abs(a[pivot][col]) <= eps) {
      return 0;
    }

    if (pivot !== col) {
      const tmp = a[pivot];
      a[pivot] = a[col];
      a[col] = tmp;
      sign *= -1;
    }

    for (let i = col + 1; i < n; i++) {
      const factor = a[i][col] / a[col][col];
      a[i][col] = 0;
      for (let j = col + 1; j < n; j++) {
        a[i][j] -= factor * a[col][j];
      }
    }
  }

  let det = sign;
  for (let i = 0; i < n; i++) {
    det *= a[i][i];
  }
  return det;
}

module.exports = {
  EPS_FLOAT,
  EPS_DOUBLE,
  createMatrix,
  cloneMatrix,
  isValidMatrix,
  checkMatrix,
  sameShape,
  castByType,
  buildTypedMatrix,
  parseRange,
  gaussianRank,
  gaussianDeterminant,
};
