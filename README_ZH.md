# asm_matrix_benchmark

跨语言矩阵运算基准测试项目，对比 **汇编 (NASM)**、**C**、**C++** 和 **Python** 的矩阵运算性能，支持 **int**、**float** 和 **double** 三种数据类型。

## 概述

本项目用多种语言实现了一套完整的矩阵运算，并提供基准测试框架用于对比性能。目标是衡量和可视化底层语言（汇编、C/C++）与高层语言（Python）之间的性能差异。

## 项目结构

```
├── CMakeLists.txt              # 构建配置 (C + NASM)
├── include/                    # C/C++ 头文件 (.h)
├── src/
│   ├── C/                      # C 实现（int/float/double）
│   ├── C++/                    # C++ 实现
│   ├── Python/                 # Python 矩阵模块
│   ├── assembly/
│   │   ├── linux/              # NASM 汇编 (Linux x86-64)
│   │   └── windows/            # NASM 汇编 (Windows x64) — int & double
│   └── benchmark/              # 基准测试脚本
├── example/                    # 使用示例 (C, C++, Python)
├── scripts/                    # 工具脚本
├── build/                      # 构建输出
├── results.json                # 基准测试结果
└── results.png                 # 基准测试可视化
```

## Python 模块

`src/Python/` 提供了 `Matrix` 类及所有运算：

```python
from python_benchmark import Matrix, transpose, rank, trace

m = Matrix(3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 10])
print(rank(m))    # 3
print(trace(m))   # 16
```

### Python 文件

| 文件 | 内容 |
|---|---|
| `base_matrix.py` | `Matrix` 类（核心运算符） |
| `concat_matrix.py` | `cat_matrix()` 矩阵拼接 |
| `extract_matrix.py` | `extract_row()`, `extract_col()`, `extract_submatrix()` |
| `find_matrix.py` | `find_elem()` 查找元素 |
| `leading_minors.py` | `leading_minors()` 顺序主子式 |
| `random_matrix.py` | `random_matrix()` 随机矩阵 |
| `rank_matrix.py` | `rank()` 矩阵秩 |
| `replace_matrix.py` | `replace_pos()`, `replace_elem()` |
| `special_matrix.py` | `identity()`, `zeros()`, `ones()` |
| `trace_matrix.py` | `trace()` 矩阵迹 |
| `transpose_matrix.py` | `transpose()` 矩阵转置 |

## 构建 (C + 汇编)

### 前置要求

- CMake >= 3.10
- C 编译器 (GCC/Clang/MSVC)
- NASM 汇编器

### 构建

```bash
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

### 可执行目标

| 目标 | 语言 | 数据类型 | 说明 |
|---|---|---|---|
| `matrix_int` | 汇编 (NASM) | `int` | 汇编加速的 int 矩阵运算 |
| `matrix_intc` | C | `int` | 纯 C int 矩阵运算 |
| `matrix_intcpp` | C++ | `int` | C++ int 矩阵运算 |
| `matrix_floatc` | C | `float` | C float 矩阵运算 |
| `matrix_double` | 汇编 (NASM) | `double` | 汇编加速的 double 矩阵运算 |
| `matrix_doublec` | C | `double` | C double 矩阵运算 |

## 基准测试

基准测试脚本位于 `src/benchmark/`：

- `bench_python.py` — Python 性能测试
- `bench_cross.py` — 跨语言对比测试
- `build.bat` / `build.sh` — 构建辅助

结果导出到 `results.json`，可视化为 `results.png`。

## 汇编实现

项目为 **int** 和 **double** 矩阵类型提供了 Windows x64 平台的 NASM 汇编实现，以及 **int** 的 Linux x86-64 实现。double 汇编实现覆盖所有上述运算，使用 SSE2 指令集（`movsd`、`addsd`、`subsd`、`mulsd`、`divsd`、`comisd`）进行 IEEE 754 双精度浮点运算。

### 支持的汇编运算 (double)

| 类别 | 运算 |
|---|---|
| 算术 | `add`, `sub`, `mul`, `scale`, `cat` (拼接) |
| 查询 | `find`, `compare`, `rank`, `trace` |
| 变换 | `transpose`, `inv`, `LU_decomposition`, `leading_minors` |
| 工具 | `print`, `random`, `special` (identity/diag/eye/zero) |
| 提取 | `extract_row`, `extract_col`, `extract_diag` |
| 替换 | `replace_by_coord`, `replace_by_value` |

## 许可证

MIT License — 详见 [LICENSE](LICENSE)。
