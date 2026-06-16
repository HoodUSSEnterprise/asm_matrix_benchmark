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

# 库的源文件（从对应平台目录读取）
set(LIB_SOURCES_MATRIX_INT
    src/assembly/${PLATFORM_DIR}/add_matrix_int.asm
    # src/assembly/${PLATFORM_DIR}/find_matrix_int.asm
    # src/assembly/${PLATFORM_DIR}/insert_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/mul_matrix_int.asm
    # src/assembly/${PLATFORM_DIR}/pop_matrix_int.asm
    # src/assembly/${PLATFORM_DIR}/push_back_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/print_matrix_int.asm
    # src/assembly/${PLATFORM_DIR}/remove_matrix_int.asm
    # src/assembly/${PLATFORM_DIR}/replace_matrix_int.asm
    # src/assembly/${PLATFORM_DIR}/reverse_matrix_int.asm
    # src/assembly/${PLATFORM_DIR}/scale_matrix_int.asm
    src/assembly/${PLATFORM_DIR}/sub_matrix_int.asm
)

# 创建库
add_library(matrix_int_lib ${LIB_SOURCES_MATRIX_INT})

target_include_directories(matrix_int_lib PUBLIC include)
target_link_libraries(matrix_int_lib ${EXTRA_LIBS})

# 创建测试可执行文件
add_executable(matrix_int example/matrix_int.c)
target_link_libraries(matrix_int matrix_int_lib)

# set(LIB_SOURCES_MATRIX_DOUBLE
#     src/assembly/${PLATFORM_DIR}/add_matrix_double.asm
#     src/assembly/${PLATFORM_DIR}/find_matrix_double.asm
#     src/assembly/${PLATFORM_DIR}/insert_matrix_double.asm
#     src/assembly/${PLATFORM_DIR}/mul_matrix_double.asm
#     src/assembly/${PLATFORM_DIR}/pop_matrix_double.asm
#     src/assembly/${PLATFORM_DIR}/push_back_matrix_double.asm
#     src/assembly/${PLATFORM_DIR}/remove_matrix_double.asm
#     src/assembly/${PLATFORM_DIR}/replace_matrix_double.asm
#     src/assembly/${PLATFORM_DIR}/reverse_matrix_double.asm
#     src/assembly/${PLATFORM_DIR}/scale_matrix_double.asm
#     src/assembly/${PLATFORM_DIR}/sub_matrix_double.asm
# )

# add_library(matrix_lib_double ${LIB_SOURCES_MATRIX_DOUBLE})
# target_include_directories(matrix_lib_double PUBLIC include)
# target_link_libraries(matrix_lib_double ${EXTRA_LIBS})

# add_executable(matrix_double example/matrix_double.c)
# target_link_libraries(matrix_double matrix_lib_double)

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
