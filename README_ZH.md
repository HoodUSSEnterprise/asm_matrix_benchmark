# asm_matrix_benchmark

跨语言矩阵运算基准测试项目，对比 **汇编 (NASM)**、**C**、**C++** 和 **Python** 的矩阵运算性能。

## 概述

本项目用多种语言实现了一套完整的矩阵运算，并提供基准测试框架用于对比性能。目标是衡量和可视化底层语言（汇编、C/C++）与高层语言（Python）之间的性能差异。

## 支持的操作

| 操作 | C | C++ | Python | 汇编 (Linux) | 汇编 (Windows) |
|---|---|---|---|---|---|
| 加法 | ✓ | ✓ | ✓ | ✓ | ✓ |
| 减法 | ✓ | ✓ | ✓ | ✓ | ✓ |
| 乘法 | ✓ | ✓ | ✓ | ✓ | ✓ |
| 数乘 | ✓ | ✓ | ✓ | ✓ | ✓ |
| 转置 | ✓ | | ✓ | ✓ | ✓ |
| 拼接 | ✓ | | ✓ | ✓ | ✓ |
| 提取子矩阵 | ✓ | | ✓ | ✓ | |
| 查找元素 | ✓ | | ✓ | ✓ | ✓ |
| 按坐标替换 | ✓ | | ✓ | ✓ | ✓ |
| 按值替换 | ✓ | | ✓ | | |
| 比较 | ✓ | | | ✓ | ✓ |
| 打印 | ✓ | ✓ | ✓ | ✓ | ✓ |
| 随机矩阵 | ✓ | | ✓ | ✓ | |
| 特殊矩阵 | ✓ | | ✓ | ✓ | |
| 顺序主子式 | ✓ | | ✓ | ✓ | ✓ |
| 秩 | ✓ | | ✓ | ✓ | |
| 迹 | ✓ | | ✓ | ✓ | ✓ |
| 逆矩阵 | ✓ | | | ✓ | ✓ |
| LU 分解 | ✓ | | | ✓ | ✓ |

## 项目结构

```
├── CMakeLists.txt              # 构建配置 (C + NASM)
├── include/                    # C/C++ 头文件 (.h)
├── src/
│   ├── C/                      # C 实现
│   ├── C++/                    # C++ 实现
│   ├── Python/                 # Python 矩阵模块
│   ├── assembly/
│   │   ├── linux/              # NASM 汇编 (Linux x86-64)
│   │   └── windows/            # NASM 汇编 (Windows x64)
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
cmake ..
cmake --build .
```

## 基准测试

基准测试脚本位于 `src/benchmark/`：

- `bench_python.py` — Python 性能测试
- `bench_cross.py` — 跨语言对比测试
- `build.bat` / `build.sh` — 构建辅助

结果导出到 `results.json`，可视化为 `results.png`。

## 许可证

MIT License — 详见 [LICENSE](LICENSE)。
