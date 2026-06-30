/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\print_matrix.js
@Description: print matrix JavaScript code
*************************************************************/

"use strict";

const { checkMatrix } = require("./common");

/**
 * Render matrix into a C-like printable string.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {number} precision
 * @returns {string|null}
 */
function matrixToString(m, precision) {
  if (!checkMatrix(m, "m")) {
    return null;
  }

  const lines = [];
  lines.push("--------------------------------------------");
  lines.push(`matrix size: (${m.rows}, ${m.cols})`);
  lines.push("matrix data:");

  for (let i = 0; i < m.rows; i++) {
    const row = [];
    for (let j = 0; j < m.cols; j++) {
      const value = m.data[i * m.cols + j];
      if (typeof precision === "number") {
        row.push(Number(value).toFixed(precision));
      } else {
        row.push(String(value));
      }
    }
    lines.push(row.join("  "));
  }

  lines.push("--------------------------------------------");
  return lines.join("\n");
}

function print_matrix_int(m) {
  const text = matrixToString(m);
  if (text !== null) {
    console.log(text);
  }
}

function print_matrix_float(m) {
  const text = matrixToString(m, 6);
  if (text !== null) {
    console.log(text);
  }
}

function print_matrix_double(m) {
  const text = matrixToString(m, 6);
  if (text !== null) {
    console.log(text);
  }
}

module.exports = {
  matrixToString,
  print_matrix_int,
  print_matrix_float,
  print_matrix_double,
};
