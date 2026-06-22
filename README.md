# asm_matrix_benchmark

A cross-language matrix operations benchmark comparing performance across **Assembly (NASM)**, **C**, **C++**, and **Python**.

## Overview

This project implements a comprehensive set of matrix operations in multiple languages and provides benchmarking infrastructure to compare their performance. The goal is to measure and visualize the performance differences between low-level (assembly, C/C++) and high-level (Python) implementations.

## Supported Operations

| Operation | C | C++ | Python | Assembly (Linux) | Assembly (Windows) |
|---|---|---|---|---|---|
| Add | ✓ | ✓ | ✓ | ✓ | ✓ |
| Subtract | ✓ | ✓ | ✓ | ✓ | ✓ |
| Multiply | ✓ | ✓ | ✓ | ✓ | ✓ |
| Scale | ✓ | ✓ | ✓ | ✓ | ✓ |
| Transpose | ✓ | | ✓ | ✓ | ✓ |
| Concatenate | ✓ | | ✓ | ✓ | ✓ |
| Extract submatrix | ✓ | | ✓ | ✓ | |
| Find element | ✓ | | ✓ | ✓ | ✓ |
| Replace by coord | ✓ | | ✓ | ✓ | ✓ |
| Replace by value | ✓ | | ✓ | | |
| Compare | ✓ | | | ✓ | ✓ |
| Print | ✓ | ✓ | ✓ | ✓ | ✓ |
| Random matrix | ✓ | | ✓ | ✓ | |
| Special matrices | ✓ | | ✓ | ✓ | |
| Leading minors | ✓ | | ✓ | ✓ | ✓ |
| Rank | ✓ | | ✓ | ✓ | |
| Trace | ✓ | | ✓ | ✓ | ✓ |
| Inverse | ✓ | | | ✓ | ✓ |
| LU decomposition | ✓ | | | ✓ | ✓ |

## Project Structure

```
├── CMakeLists.txt              # Build configuration (C + NASM)
├── include/                    # C/C++ header files (.h)
├── src/
│   ├── C/                      # C implementations
│   ├── C++/                    # C++ implementations
│   ├── Python/                 # Python matrix module
│   ├── assembly/
│   │   ├── linux/              # NASM assembly (Linux x86-64)
│   │   └── windows/            # NASM assembly (Windows x64)
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
cmake ..
cmake --build .
```

## Benchmarks

Benchmark scripts are in `src/benchmark/`:

- `bench_python.py` — Python performance benchmarks
- `bench_cross.py` — Cross-language comparison
- `build.bat` / `build.sh` — Build helpers

Results are exported to `results.json` and visualized as `results.png`.

## License

MIT License — see [LICENSE](LICENSE).
