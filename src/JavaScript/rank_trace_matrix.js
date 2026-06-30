/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\rank_trace_matrix.js
@Description: rank and trace matrix JavaScript code
*************************************************************/

"use strict";

const {
  checkMatrix,
  gaussianRank,
  EPS_FLOAT,
  EPS_DOUBLE,
  castByType,
} = require("./common");

/**
 * Compute matrix rank under numeric tolerance.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {"int"|"float"|"double"} type
 * @returns {number|null}
 */
function rankMatrix(m, type) {
  if (!checkMatrix(m, "m")) {
    return null;
  }

  let eps = 0;
  if (type === "float") {
    eps = EPS_FLOAT;
  } else if (type === "double") {
    eps = EPS_DOUBLE;
  }

  return gaussianRank(m, eps);
}

/**
 * Compute matrix trace. Matrix must be square.
 * @param {{rows:number, cols:number, data:number[]}} m
 * @param {"int"|"float"|"double"} type
 * @returns {number|null}
 */
function traceMatrix(m, type) {
  if (!checkMatrix(m, "m")) {
    return null;
  }
  if (m.rows !== m.cols) {
    console.error("Matrix must be square!");
    return null;
  }

  let sum = 0;
  for (let i = 0; i < m.rows; i++) {
    sum += m.data[i * m.cols + i];
  }
  return castByType(sum, type);
}

function rank_matrix_int(m) {
  return rankMatrix(m, "int");
}

function trace_matrix_int(m) {
  return traceMatrix(m, "int");
}

function rank_matrix_float(m) {
  return rankMatrix(m, "float");
}

function trace_matrix_float(m) {
  return traceMatrix(m, "float");
}

function rank_matrix_double(m) {
  return rankMatrix(m, "double");
}

function trace_matrix_double(m) {
  return traceMatrix(m, "double");
}

module.exports = {
  rank_matrix_int,
  trace_matrix_int,
  rank_matrix_float,
  trace_matrix_float,
  rank_matrix_double,
  trace_matrix_double,
};
