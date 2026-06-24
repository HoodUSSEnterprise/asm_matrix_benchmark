# asm_matrix_benchmark

A cross-language matrix operations benchmark comparing performance across **Assembly (NASM)**, **C**, **C++**, and **Python**, supporting **int**, **float**, and **double** data types.

## Overview

This project implements a comprehensive set of matrix operations in multiple languages and provides benchmarking infrastructure to compare their performance. The goal is to measure and visualize the performance differences between low-level (assembly, C/C++) and high-level (Python) implementations.

## Project Structure

```
├── CMakeLists.txt              # Build configuration (C + NASM)
├── include/                    # C/C++ header files (.h)
├── src/
│   ├── C/                      # C implementations (int/float/double)
│   ├── C++/                    # C++ implementations
│   ├── Python/                 # Python matrix module
│   ├── assembly/
│   │   ├── linux/              # NASM assembly (Linux x86-64)
│   │   └── windows/            # NASM assembly (Windows x64) — int & double
│   └── benchmark/              # Benchmark scripts
├── example/                    # Usage examples (C, C++, Python)
├── scripts/                    # Utility scripts
├── build/                      # Build output
├── results.json                # Benchmark results
└── results.png                 # Benchmark visualization
```

## Python Module

The Python module (`src/Python/`) provides a `Matrix` class with all operations:

```python
from python_benchmark import Matrix, transpose, rank, trace

m = Matrix(3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 10])
print(rank(m))    # 3
print(trace(m))   # 16
```

### Python Files

| File | Contents |
|---|---|
| `base_matrix.py` | `Matrix` class (core operators) |
| `concat_matrix.py` | `cat_matrix()` |
| `extract_matrix.py` | `extract_row()`, `extract_col()`, `extract_submatrix()` |
| `find_matrix.py` | `find_elem()` |
| `leading_minors.py` | `leading_minors()` |
| `random_matrix.py` | `random_matrix()` |
| `rank_matrix.py` | `rank()` |
| `replace_matrix.py` | `replace_pos()`, `replace_elem()` |
| `special_matrix.py` | `identity()`, `zeros()`, `ones()` |
| `trace_matrix.py` | `trace()` |
| `transpose_matrix.py` | `transpose()` |

## Building (C + Assembly)

### Prerequisites

- CMake >= 3.10
- C compiler (GCC/Clang/MSVC)
- NASM assembler

### Build

```bash
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

### Executable Targets

| Target | Language | Data Type | Description |
|---|---|---|---|
| `matrix_int` | Assembly (NASM) | `int` | Assembly-accelerated int matrix ops |
| `matrix_intc` | C | `int` | Pure C int matrix ops |
| `matrix_intcpp` | C++ | `int` | C++ int matrix ops |
| `matrix_floatc` | C | `float` | C float matrix ops |
| `matrix_double` | Assembly (NASM) | `double` | Assembly-accelerated double matrix ops |
| `matrix_doublec` | C | `double` | C double matrix ops |

## Benchmarks

Benchmark scripts are in `src/benchmark/`:

- `bench_python.py` — Python performance benchmarks
- `bench_cross.py` — Cross-language comparison
- `build.bat` / `build.sh` — Build helpers

Results are exported to `results.json` and visualized as `results.png`.

## Assembly Implementations

NASM assembly implementations are available for **int** and **double** matrix types on Windows x64, and **int** on Linux x86-64. The double-precision assembly covers all operations listed above, using SSE2 instructions (`movsd`, `addsd`, `subsd`, `mulsd`, `divsd`, `comisd`) for IEEE 754 double arithmetic.

### Supported Assembly Operations (double)

| Category | Operations |
|---|---|
| Arithmetic | `add`, `sub`, `mul`, `scale`, `cat` (concat) |
| Queries | `find`, `compare`, `rank`, `trace` |
| Transforms | `transpose`, `inv`, `LU_decomposition`, `leading_minors` |
| Utilities | `print`, `random`, `special` (identity/diag/eye/zero) |
| Extraction | `extract_row`, `extract_col`, `extract_diag` |
| Replacement | `replace_by_coord`, `replace_by_value` |

## License

MIT License — see [LICENSE](LICENSE).
