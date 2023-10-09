// Vector multiplication using com-pressed sparse row (CSR) storage format.

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>       


int main(void)
{
    int row =3, col =3;
    int mat[3][3]= {{0,0,9}, {0,5,0}, {2,0,1}};


    // convert to csr
    int i,j;
    int col_index[row*col];
    int col_ptr =0;

    for(i=0; i<row; i++)
    {
        for(j=0; j<col; j++)
        {
            if(mat[i][j] != 0)
            {
                col_index[col_ptr++] = j; 
            }
        }
    }
    for(i=0; i<col_ptr; i++)
    {
        printf("%d ", col_index[i]);
    }
    printf("\n");

    // finding row_ptr
    int count =-1, flag = 0;
    int row_ptr[row];
    int row_index = 0;
    
    for(i=0; i<row; i++)
    {
        for(j=0; j<col ;j++)
        {
            if(mat[i][j] != 0)
            {
                count +=1;
            }

            if(flag == 0 && mat[i][j] !=0)
            {
                row_ptr[row_index++] = count;
                flag = 1;
            }
            
        }
        flag = 0;
    }

    for(i=0; i<row_index; i++)
    {
        printf("%d ", row_ptr[i]);
    }
    printf("\n");



}