/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 20:10:32
@LastEditors: GitHubCopilot
@LastEditTime: 2026-06-29 20:10:32
@FilePath: \asm_matrix_benchmark\src\JavaScript\index.js
@Description: JavaScript matrix module entry
*************************************************************/

"use strict";

module.exports = {
  ...require("./base_matrix"),
  ...require("./add_matrix"),
  ...require("./sub_matrix"),
  ...require("./mul_matrix"),
  ...require("./scale_matrix"),
  ...require("./transpose_matrix"),
  ...require("./cat_matrix"),
  ...require("./extract_matrix"),
  ...require("./find_matrix"),
  ...require("./replace_matrix"),
  ...require("./compare_matrix"),
  ...require("./random_matrix"),
  ...require("./special_matrix"),
  ...require("./rank_trace_matrix"),
  ...require("./determinant_matrix"),
  ...require("./leading_minors"),
  ...require("./lu_matrix"),
  ...require("./inv_matrix"),
  ...require("./print_matrix"),
};
