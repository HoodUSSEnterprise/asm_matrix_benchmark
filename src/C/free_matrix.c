/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-25 16:29:18
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-25 16:44:38
@FilePath: \asm_matrix_benchmark\src\C\free_matrix.c
@Description: free matrix c code
*************************************************************/
#include "free_matrix.h"

/***********************************************************
@description: free matrix int
@param {MatrixInt} *
@return {*}
*************************************************************/
void free_matrix_int(MatrixInt **m)
{
    // check param
    if (m == NULL || (*m) == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return;
    }
    else
    {
        free((*m)->data);
        free(*m);
        *m = NULL;
    }
}

/***********************************************************
@description: free matrix float
@param {MatrixFloat} *
@return {*}
*************************************************************/
void free_matrix_float(MatrixFloat **m)
{
    // check param
    if (m == NULL || (*m) == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return;
    }
    else
    {
        free((*m)->data);
        free(*m);
        *m = NULL;
    }
}

/***********************************************************
@description: free matrix double
@param {MatrixDouble} *
@return {*}
*************************************************************/
void free_matrix_double(MatrixDouble **m)
{
    // check param
    if (m == NULL || (*m) == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return;
    }
    else
    {
        free((*m)->data);
        free(*m);
        *m = NULL;
    }
}

/***********************************************************
@description: free leading principal minor int
@param {Leading_Minors_Int} *
@return {*}
*************************************************************/
void free_leading_minors_int(Leading_Minors_Int **l)
{
    // check param
    if (l == NULL || (*l) == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return;
    }
    else
    {
        for (size_t i = 0; i < (*l)->len; i++)
        {
            free((*l)->matrix_data[i].data);
        }
        free((*l)->matrix_data);
        free(*l);
        *l = NULL;
    }
}

/***********************************************************
@description: free leading principal minor float
@param {Leading_Minors_Float} *
@return {*}
*************************************************************/
void free_leading_minors_float(Leading_Minors_Float **l)
{
    // check param
    if (l == NULL || (*l) == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return;
    }
    else
    {
        for (size_t i = 0; i < (*l)->len; i++)
        {
            free((*l)->matrix_data[i].data);
        }
        free((*l)->matrix_data);
        free(*l);
        *l = NULL;
    }
}

/***********************************************************
@description: free leading principal minor double
@param {Leading_Minors_Double} *
@return {*}
*************************************************************/
void free_leading_minors_double(Leading_Minors_Double **l)
{
    // check param
    if (l == NULL || (*l) == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return;
    }
    else
    {
        for (size_t i = 0; i < (*l)->len; i++)
        {
            free((*l)->matrix_data[i].data);
        }
        free((*l)->matrix_data);
        free(*l);
        *l = NULL;
    }
}