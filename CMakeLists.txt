cmake_minimum_required(VERSION 3.10)
project(MyProject)

enable_language(C ASM_NASM)

# 根据平台选择不同的源文件目录
if(WIN32)
    set(PLATFORM_DIR "windows")
    set(CMAKE_ASM_NASM_FLAGS "-f win64 -g")
    set(EXTRA_LIBS "")  # Windows 特定库，如需要可添加
elseif(UNIX AND NOT APPLE)  # Linux
    set(PLATFORM_DIR "linux")
    set(CMAKE_ASM_NASM_FLAGS "-f elf64 -g")
    set(EXTRA_LIBS m pthread dl)  # Linux 特定库
else()
    message(FATAL_ERROR "Unsupported platform: Only Windows and Linux are supported")
endif()

message(STATUS "Building for platform: ${PLATFORM_DIR}")

# 设置编译选项
set(CMAKE_C_FLAGS_DEBUG "-g -O0 -Wall -Wextra")
set(CMAKE_C_FLAGS_RELEASE "-O2 -DNDEBUG")

include_directories(include)

# Assembly code 
set(LIB_SOURCES_MATRIX_INT
    src/assembly/${PLATFORM_DIR}/int/add_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/cat_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/compare_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/determinant_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/extract_col_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/gcd.asm
    src/assembly/${PLATFORM_DIR}/int/add_fraction.asm
    src/assembly/${PLATFORM_DIR}/int/sub_fraction.asm
    src/assembly/${PLATFORM_DIR}/int/mul_fraction.asm
    src/assembly/${PLATFORM_DIR}/int/div_fraction.asm
    src/assembly/${PLATFORM_DIR}/int/extract_diag_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/extract_row_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/find_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/free_leading_minors_int.asm
    src/assembly/${PLATFORM_DIR}/double/free_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/int/free_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/inv_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/leading_minors_int.asm
    src/assembly/${PLATFORM_DIR}/int/lu_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/mul_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/double/print_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/int/print_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/random_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/rank_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/replace_matrix_int_by_coord.asm
    src/assembly/${PLATFORM_DIR}/int/replace_matrix_int_by_value.asm
    src/assembly/${PLATFORM_DIR}/int/scale_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/special_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/sub_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/trace_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/int/transpose_matrix_int.asm
)

# 创建库
add_library(matrix_int_lib ${LIB_SOURCES_MATRIX_INT})

target_include_directories(matrix_int_lib PUBLIC include)
target_link_libraries(matrix_int_lib ${EXTRA_LIBS})

# 创建测试可执行文件
add_executable(matrix_int example/matrix_int.c)
target_link_libraries(matrix_int matrix_int_lib)

# C code
set(LIB_SOURCES_MATRIX_C
    src/C/add_matrix.c
    src/C/cat_matrix.c
    src/C/compare_matrix.c
    src/C/determinant_matrix.c
    src/C/extract_matrix.c
    src/C/find_matrix.c
    src/C/free_matrix.c
    src/C/inv_matrix.c
    src/C/leading_minors.c
    src/C/lu_matrix.c
    src/C/mul_matrix.c
    src/C/operator_fraction.c
    src/C/print_matrix.c
    src/C/random_matrix.c
    src/C/rank_trace_matrix.c
    src/C/replace_matrix.c
    src/C/scale_matrix.c
    src/C/special_matrix.c
    src/C/sub_matrix.c
    src/C/transpose_matrix.c
)

# 创建库
add_library(matrix_int_clib ${LIB_SOURCES_MATRIX_C})

target_include_directories(matrix_int_clib PUBLIC include)
target_link_libraries(matrix_int_clib ${EXTRA_LIBS})

# 创建测试可执行文件
add_executable(matrix_intc example/matrix_int.c)
target_link_libraries(matrix_intc matrix_int_clib)

# C Float 版本 (与 int 在同一组 C 源文件中)
add_executable(matrix_floatc example/matrix_float.c)
target_link_libraries(matrix_floatc matrix_int_clib)

# C Double 版本 (与 int 在同一组 C 源文件中)
add_executable(matrix_doublec example/matrix_double.c)
target_link_libraries(matrix_doublec matrix_int_clib)

# 库的源文件（从对应平台目录读取）
set(LIB_SOURCES_MATRIX_CPP
    src/C++/int/add_matrix.cpp
    src/C++/int/cat_matrix.cpp
    src/C++/int/compare_matrix.cpp
    src/C++/double/constructor_matrix.cpp
    src/C++/int/constructor_matrix.cpp
    src/C++/double/destructor_matrix.cpp
    src/C++/int/destructor_matrix.cpp
    src/C++/int/extract_matrix.cpp
    src/C++/int/find_matrix.cpp
    src/C++/int/inv_matrix.cpp
    src/C++/int/leading_minors.cpp
    src/C++/int/mul_matrix.cpp
    src/C++/double/print_matrix.cpp
    src/C++/int/print_matrix.cpp
    src/C++/int/rank_trace_matrix.cpp
    src/C++/int/replace_matrix.cpp
    src/C++/int/scale_matrix.cpp
    src/C++/int/special_matrix.cpp
    src/C++/int/sub_matrix.cpp
    src/C++/int/transpose_matrix.cpp
)

# 创建 C++ int 库
add_library(matrix_int_cpplib ${LIB_SOURCES_MATRIX_CPP})

target_include_directories(matrix_int_cpplib PUBLIC include)
target_link_libraries(matrix_int_cpplib ${EXTRA_LIBS})

# 创建测试可执行文件
add_executable(matrix_intcpp example/matrix_int.cpp)
target_link_libraries(matrix_intcpp matrix_int_cpplib)

set(LIB_SOURCES_MATRIX_DOUBLE
    src/assembly/${PLATFORM_DIR}/double/add_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/cat_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/compare_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/determinant_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/extract_col_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/extract_diag_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/extract_row_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/find_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/inv_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/leading_minors_double.asm
    src/assembly/${PLATFORM_DIR}/double/lu_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/mul_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/print_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/random_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/rank_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/replace_matrix_double_by_coord.asm
    src/assembly/${PLATFORM_DIR}/double/replace_matrix_double_by_value.asm
    src/assembly/${PLATFORM_DIR}/double/scale_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/special_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/sub_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/trace_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/double/transpose_matrix_double.asm
)

add_library(matrix_double_lib ${LIB_SOURCES_MATRIX_DOUBLE})
target_include_directories(matrix_double_lib PUBLIC include)
target_link_libraries(matrix_double_lib ${EXTRA_LIBS})

add_executable(matrix_double example/matrix_double.c)
target_link_libraries(matrix_double matrix_double_lib)

# Float 版本
set(LIB_SOURCES_MATRIX_FLOAT
    src/assembly/${PLATFORM_DIR}/float/add_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/cat_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/compare_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/determinant_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/extract_col_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/extract_diag_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/extract_row_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/find_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/inv_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/leading_minors_float.asm
    src/assembly/${PLATFORM_DIR}/float/lu_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/mul_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/double/print_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/float/print_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/random_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/rank_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/replace_matrix_float_by_coord.asm
    src/assembly/${PLATFORM_DIR}/float/replace_matrix_float_by_value.asm
    src/assembly/${PLATFORM_DIR}/float/scale_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/special_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/sub_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/trace_matrix_float.asm
    src/assembly/${PLATFORM_DIR}/float/transpose_matrix_float.asm
)

add_library(matrix_float_lib ${LIB_SOURCES_MATRIX_FLOAT})
target_include_directories(matrix_float_lib PUBLIC include)
target_link_libraries(matrix_float_lib ${EXTRA_LIBS})

add_executable(matrix_float example/matrix_float.c)
target_link_libraries(matrix_float matrix_float_lib)
