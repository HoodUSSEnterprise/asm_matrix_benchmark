# asm_matrix_benchmark

Cross-language matrix operations benchmark comparing **Assembly (NASM)**, **C**, **C++**, **Java** and **Python** across **int**, **float** and **double** data types.

## Overview

This project implements a comprehensive set of matrix operations in 5 languages and provides a one-click benchmarking infrastructure to measure and visualize performance differences.

## Project Structure

```
├── CMakeLists.txt              # Build configuration (C / C++ / NASM)
├── include/                    # C/C++ headers (.h)
├── src/
│   ├── C/                      # C implementations (int/float/double)
│   ├── C++/
│   │   ├── int/                # C++ MatrixInt
│   │   ├── float/              # C++ MatrixFloat
│   │   └── double/             # C++ MatrixDouble
│   ├── Java/                   # Java Matrix classes
│   ├── Python/                 # Python matrix module
│   └── assembly/
│       ├── linux/              # NASM (Linux x86-64)
│       └── windows/            # NASM (Windows x64)
├── example/                    # Example programs (all 5 languages)
├── out/                        # Compiled Java .class files
├── benchmark/                  # Benchmark scripts & charts
│   ├── bench_cross.py          # One-click cross-language benchmark
│   ├── bench_python.py         # Python micro-benchmark (used by bench_cross)
│   ├── bench_results.json      # Latest results
│   └── bench_comparison.png    # Generated comparison chart
└── build/                      # CMake build output
```

## Supported Languages & Data Types

| Language | int | float | double |
|----------|:---:|:-----:|:------:|
| Assembly (NASM) | ✅ | ✅ | ✅ |
| C | ✅ | ✅ | ✅ |
| C++ | ✅ | ✅ | ✅ |
| Java | ✅ | ✅ | ✅ |
| Python | ✅ | ✅¹ | ✅¹ |

¹ Python `float` is IEEE 754 double-precision; float and double use the same implementation.

## Quick Start — One-Click Benchmark

```bash
# Run all available languages (auto-detects compiled binaries)
python benchmark/bench_cross.py

# Run with specific languages
python benchmark/bench_cross.py --langs asm,c,cpp,java,python

# Custom repeat count
python benchmark/bench_cross.py --repeat 10 --warmup 3
```

Output:
- Console summary table
- `benchmark/bench_results.json`
- `benchmark/bench_comparison.png` (grouped bar chart by data type)

## Building (C / C++ / Assembly)

### Prerequisites

- CMake >= 3.10
- C/C++ compiler (GCC / Clang / MSVC)
- NASM assembler

### Build

```bash
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

### Executable Targets

| Target | Language | Data Type |
|--------|----------|-----------|
| `matrix_int` | Assembly (NASM) | int |
| `matrix_intc` | C | int |
| `matrix_intcpp` | C++ | int |
| `matrix_float` | Assembly (NASM) | float |
| `matrix_floatc` | C | float |
| `matrix_floatcpp` | C++ | float |
| `matrix_double` | Assembly (NASM) | double |
| `matrix_doublec` | C | double |
| `matrix_doublecpp` | C++ | double |

## Java

```bash
# Compile (done automatically by bench_cross.py)
javac -d src/Java src/Java/MatrixInt.java src/Java/MatrixDouble.java src/Java/MatrixFloat.java
javac -cp src/Java -d out example/matrix_int.java example/matrix_float.java example/matrix_double.java

# Run
java -cp out;src/Java matrix_int
```

## Benchmark Methodology

`bench_cross.py` runs each language's example program from start to finish and measures total wall-clock time, including:
- Process startup / JVM / interpreter initialization
- Matrix construction and data initialization
- All operations (add, sub, mul, find, scale, transpose, etc.)
- Output printing

Each combination is repeated N times (default 5) with warmup runs for stable measurements.

## Benchmark Results

![Cross-Language Benchmark Comparison](benchmark/bench_comparison.png)

### Key Findings

| Language | int (s) | float (s) | double (s) |
|----------|:-------:|:---------:|:----------:|
| ASM (NASM) | 0.0266 | 0.0268 | 0.0228 |
| C | 0.0264 | 0.0271 | 0.0287 |
| C++ | 0.0265 | 0.0257 | 0.0252 |
| Java | 0.1179 | 0.1141 | 0.1429 |
| Python | 0.0837 | 0.0832 | 0.0898 |

- **Native compiled languages (ASM, C, C++)** are the fastest, all within ~0.022–0.029&nbsp;s. Modern compilers generate highly efficient code comparable to hand-written assembly for these workloads.
- **Python** is ~3× slower than native (~0.08–0.09&nbsp;s), dominated by interpreter overhead and dynamic typing.
- **Java** is ~4–5× slower (~0.11–0.14&nbsp;s). A significant portion of this overhead comes from JVM startup time, since the benchmark measures full program runtime.
- **ASM double** is slightly faster than ASM int — SSE2 scalar arithmetic (`addsd`, `mulsd`) is simpler than the integer fraction-based arithmetic used for the int matrix type.
- **C++** shows consistent performance across all three types, with a slight edge on float/double operations.

## Python Module

```python
from src.Python import Matrix, transpose, rank, trace

m = Matrix(3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 10])
print(rank(m))    # 3
print(trace(m))   # 16
```

### Python Files

| File | Contents |
|------|----------|
| `base_matrix.py` | `Matrix` class (core operators) |
| `concat_matrix.py` | `cat_matrix()` |
| `determinant_matrix.py` | `determinant()` |
| `extract_matrix.py` | `extract_row()`, `extract_col()`, `extract_submatrix()` |
| `find_matrix.py` | `find_elem()` |
| `inv_matrix.py` | `inv_matrix()` |
| `leading_minors.py` | `leading_minors()` |
| `lu_decomposition.py` | `lu_decomposition()` |
| `random_matrix.py` | `random_matrix()` |
| `rank_matrix.py` | `rank()` |
| `replace_matrix.py` | `replace_pos()`, `replace_elem()` |
| `special_matrix.py` | `identity()`, `zeros()`, `ones()` |
| `trace_matrix.py` | `trace()` |
| `transpose_matrix.py` | `transpose()` |

## Assembly Implementations

NASM assembly is available for **int**, **float** and **double** matrix types on Windows x64, and **int** on Linux x86-64. The double-precision assembly uses SSE2 instructions (`movsd`, `addsd`, `subsd`, `mulsd`, `divsd`, `comisd`) for IEEE 754 arithmetic.

### Supported Assembly Operations

| Category | Operations |
|----------|------------|
| Arithmetic | `add`, `sub`, `mul`, `scale`, `cat` (concat) |
| Queries | `find`, `compare`, `rank`, `trace` |
| Transforms | `transpose`, `inv`, `LU_decomposition`, `leading_minors` |
| Utilities | `print`, `random`, `special` (identity/zeros/ones) |
| Extraction | `extract_row`, `extract_col`, `extract_submatrix` |
| Replacement | `replace_by_coord`, `replace_by_value` |

## License

MIT License — see [LICENSE](LICENSE).
