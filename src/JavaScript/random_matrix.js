/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\random_matrix.js
@Description: random matrix JavaScript code
*************************************************************/

"use strict";

const { buildTypedMatrix, parseRange } = require("./common");

/**
 * Generate random matrix values under C-like range rules.
 * @param {number} rows
 * @param {number} cols
 * @param {number[]|undefined|null} range
 * @param {number|undefined|null} size
 * @param {"int"|"float"|"double"} type
 * @returns {{rows:number, cols:number, data:number[]}|null}
 */
function randomMatrix(rows, cols, range, size, type) {
  if (
    !Number.isInteger(rows) ||
    !Number.isInteger(cols) ||
    rows <= 0 ||
    cols <= 0
  ) {
    console.error("Invalid param!");
    return null;
  }

  const boundaries = parseRange(range, size, type);
  const min = boundaries.min;
  const max = boundaries.max;
  const data = new Array(rows * cols);

  for (let i = 0; i < data.length; i++) {
    if (type === "int") {
      const span = Math.floor(max - min + 1);
      data[i] = Math.floor(Math.random() * span) + min;
    } else {
      data[i] = min + Math.random() * (max - min);
    }
  }

  return buildTypedMatrix(rows, cols, data, type);
}

function random_matrix_int(rows, cols, range, size) {
  return randomMatrix(rows, cols, range, size, "int");
}

function random_matrix_float(rows, cols, range, size) {
  return randomMatrix(rows, cols, range, size, "float");
}

function random_matrix_double(rows, cols, range, size) {
  return randomMatrix(rows, cols, range, size, "double");
}

module.exports = {
  random_matrix_int,
  random_matrix_float,
  random_matrix_double,
};
