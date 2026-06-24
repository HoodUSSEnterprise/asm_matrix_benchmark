/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-17 13:24:03
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-17 14:05:06
@FilePath: \asm_matrix_benchmark\src\C\replace_matrix.c
@Description: replace matrix c code by coord and value
*************************************************************/
#include "replace_matrix.h"

/***********************************************************
@description: replace matrix some data by coordinate
@param {MatrixInt} *m
@param {Point} *pos
@param {int} new_data
@return {*}
 ************************************************************/
bool replace_matrix_int_by_coord(MatrixInt *m, Point *pos, int new_data)
{
    // check m and pos
    if (m == NULL || pos == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // check m->data
    if (m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    size_t x = pos->x;
    size_t y = pos->y;
    // check x and y range
    if (x < 0 || x >= m->cols || y < 0 || y >= m->rows)
    {
        puts("index out of range");
        return 0;
    }
    // replace with new data
    m->data[x * m->cols + y] = new_data;
    return true;
}

/***********************************************************
@description: replace matrix some data by value
@param {MatrixInt} *m
@param {int} old_data
@param {int} new_data
@return {*}
 ************************************************************/
bool replace_matrix_int_by_value(MatrixInt *m, int old_data, int new_data)
{
    // check m
    if (m == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // check m->data
    if (m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // replace value with while loop
    Point pos = {0, 0};
    if (find_elem_int(m, old_data, &pos) == false)
    {
        return false;
    }
    while (find_elem_int(m, old_data, &pos))
    {
        size_t x = pos.x;
        size_t y = pos.y;
        // replace with new data
        m->data[x * m->cols + y] = new_data;
    }
    return true;
}

/***********************************************************
@description: replace matrix double some data by coordinate
@param {MatrixDouble} *m
@param {Point} *pos
@param {double} new_data
@return {*}
************************************************************/
bool replace_matrix_double_by_coord(MatrixDouble *m, Point *pos, double new_data)
{
    // check m and pos
    if (m == NULL || pos == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // check m->data
    if (m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    size_t x = pos->x;
    size_t y = pos->y;
    // check x and y range
    if (x < 0 || x >= m->cols || y < 0 || y >= m->rows)
    {
        puts("index out of range");
        return 0;
    }
    // replace with new data
    m->data[x * m->cols + y] = new_data;
    return true;
}

/***********************************************************
@description: replace matrix double some data by value
@param {MatrixDouble} *m
@param {double} old_data
@param {double} new_data
@return {*}
************************************************************/
bool replace_matrix_double_by_value(MatrixDouble *m, double old_data, double new_data)
{
    // check m
    if (m == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // check m->data
    if (m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // replace value with while loop
    Point pos = {0, 0};
    if (find_elem_double(m, old_data, &pos) == false)
    {
        return false;
    }
    while (find_elem_double(m, old_data, &pos))
    {
        size_t x = pos.x;
        size_t y = pos.y;
        // replace with new data
        m->data[x * m->cols + y] = new_data;
    }
    return true;
}