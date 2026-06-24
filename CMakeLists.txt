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
    src/assembly/${PLATFORM_DIR}/add_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/cat_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/compare_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/extract_col_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/extract_diag_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/extract_row_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/find_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/inv_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/leading_minors_int.asm
    src/assembly/${PLATFORM_DIR}/lu_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/mul_matrix_int.asm
    # src/assembly/${PLATFORM_DIR}/pop_matrix_int.asm
    # src/assembly/${PLATFORM_DIR}/push_back_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/print_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/print_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/random_matrix_int.asm
    # src/assembly/${PLATFORM_DIR}/remove_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/rank_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/replace_matrix_int_by_coord.asm
    src/assembly/${PLATFORM_DIR}/replace_matrix_int_by_value.asm
    # src/assembly/${PLATFORM_DIR}/reverse_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/scale_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/special_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/sub_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/trace_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/transpose_matrix_int.asm
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
    src/C/extract_matrix.c
    src/C/find_matrix.c
    src/C/inv_matrix.c
    src/C/leading_minors.c
    src/C/lu_matrix.c
    src/C/mul_matrix.c
    # src/C/pop_matrix.c
    # src/C/push_back_matrix.c
    src/C/print_matrix.c
    src/C/random_matrix.c
    # src/C/remove_matrix.c
    src/C/rank_trace_matrix.c
    src/C/replace_matrix.c
    # src/C/reverse_matrix.c
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
    src/C++/add_matrix.cpp
    src/C++/cat_matrix.cpp
    src/C++/compare_matrix.cpp
    src/C++/constructor_matrix.cpp
    src/C++/destructor_matrix.cpp
    src/C++/extract_matrix.cpp
    src/C++/find_matrix.cpp
    src/C++/leading_minors.cpp
    src/C++/mul_matrix.cpp
    src/C++/print_matrix.cpp
    src/C++/rank_trace_matrix.cpp
    src/C++/replace_matrix.cpp
    src/C++/scale_matrix.cpp
    src/C++/special_matrix.cpp
    src/C++/sub_matrix.cpp
    src/C++/transpose_matrix.cpp
)

# 创建库
add_library(matrix_int_cpplib ${LIB_SOURCES_MATRIX_CPP})

target_include_directories(matrix_int_cpplib PUBLIC include)
target_link_libraries(matrix_int_cpplib ${EXTRA_LIBS})

# 创建测试可执行文件
add_executable(matrix_intcpp example/matrix_int.cpp)
target_link_libraries(matrix_intcpp matrix_int_cpplib)

set(LIB_SOURCES_MATRIX_DOUBLE
    src/assembly/${PLATFORM_DIR}/add_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/cat_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/compare_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/extract_col_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/extract_diag_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/extract_row_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/find_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/inv_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/leading_minors_double.asm
    src/assembly/${PLATFORM_DIR}/lu_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/mul_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/print_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/random_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/rank_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/replace_matrix_double_by_coord.asm
    src/assembly/${PLATFORM_DIR}/replace_matrix_double_by_value.asm
    src/assembly/${PLATFORM_DIR}/scale_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/special_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/sub_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/trace_matrix_double.asm
    src/assembly/${PLATFORM_DIR}/transpose_matrix_double.asm
)

add_library(matrix_double_lib ${LIB_SOURCES_MATRIX_DOUBLE})
target_include_directories(matrix_double_lib PUBLIC include)
target_link_libraries(matrix_double_lib ${EXTRA_LIBS})

add_executable(matrix_double example/matrix_double.c)
target_link_libraries(matrix_double matrix_double_lib)

# # Float 版本
# set(LIB_SOURCES_MATRIX_FLOAT
#     src/assembly/${PLATFORM_DIR}/add_matrix_float.asm
#     src/assembly/${PLATFORM_DIR}/find_matrix_float.asm
#     src/assembly/${PLATFORM_DIR}/insert_matrix_float.asm
#     src/assembly/${PLATFORM_DIR}/mul_matrix_float.asm
#     src/assembly/${PLATFORM_DIR}/pop_matrix_float.asm
#     src/assembly/${PLATFORM_DIR}/push_back_matrix_float.asm
#     src/assembly/${PLATFORM_DIR}/remove_matrix_float.asm
#     src/assembly/${PLATFORM_DIR}/replace_matrix_float.asm
#     src/assembly/${PLATFORM_DIR}/reverse_matrix_float.asm
#     src/assembly/${PLATFORM_DIR}/scale_matrix_float.asm
#     src/assembly/${PLATFORM_DIR}/sub_matrix_float.asm
# )

# add_library(matrix_float_lib ${LIB_SOURCES_MATRIX_FLOAT})
# target_include_directories(matrix_float_lib PUBLIC include)
# target_link_libraries(matrix_float_lib ${EXTRA_LIBS})

# add_executable(matrix_float example/matrix_float.c)
# target_link_libraries(matrix_float matrix_float_lib)
