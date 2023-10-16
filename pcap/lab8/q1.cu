/* Write a program in CUDA to perform parallel Sparse Matrix - Vector multiplication using com-
pressed sparse row (CSR) storage format. Represent the input sparse matrix in CSR format in the
host code. */

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

// function to multiply sparse matrix and vector from below code
__global__ void sparse_matrix_vector_multiplication(int *row_ptr, int *col_index, int *vec, int *result, int n, int m)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int j = blockIdx.y * blockDim.y + threadIdx.y;
    int k, l;
    if (i < n && j < m)
    {
        for (k = row_ptr[i]; k < row_ptr[i + 1]; k++)
        {
            l = col_index[k];
            result[i] += vec[l] * col_index[k];
        }
    }
}



int main(void)
{
    // take matrix input and convert it to csr
    int n, m, i, j, k, l, count = 0;
    printf("Enter the number of rows and columns of the matrix: ");
    scanf("%d %d", &n, &m);
    int *mat = (int *)malloc(n * m * sizeof(int));
    printf("Enter the matrix: ");
    for (i = 0; i < n; i++)
    {
        for (j = 0; j < m; j++){
            scanf("%d", &mat[i * m + j]);
        }
    }

    // print the matrix
    printf("The matrix is: \n");
    for (i = 0; i < n; i++){
        for (j = 0; j < m; j++){
            printf("%d ", mat[i * m + j]);
        }
        printf("\n");
    }

    // convert to csr, calcluate col_index and row_ptr
    int *col_index = (int *)malloc(n * m * sizeof(int));
    int *row_ptr = (int *)malloc((n + 1) * sizeof(int));
    row_ptr[0] = 0;
    for (i = 0; i < n; i++){
        for (j = 0; j < m; j++){
            if (mat[i * m + j] != 0){
                col_index[count] = j;
                count++;
            }
        }
        row_ptr[i + 1] = count;
    }

    // display col_index and row_ptr
    printf("The col_index is: \n");
    for (i = 0; i < count; i++){
        printf("%d ", col_index[i]);
    }
    printf("\n");
    printf("The row_ptr is: \n");
    for (i = 0; i < n + 1; i++){
        printf("%d ", row_ptr[i]);
    }
    printf("\n");

    // take vector input
    int *vec = (int *)malloc(m * sizeof(int));
    printf("Enter the vector: ");
    for (i = 0; i < m; i++){
        scanf("%d", &vec[i]);
    }


    // launch kernel to multiply sparse matrix and vector
    int *result = (int *)malloc(n * sizeof(int));
    int *d_row_ptr, *d_col_index, *d_vec, *d_result;
    cudaMalloc((void **)&d_row_ptr, (n + 1) * sizeof(int));
    cudaMalloc((void **)&d_col_index, count * sizeof(int));
    cudaMalloc((void **)&d_vec, m * sizeof(int));
    cudaMalloc((void **)&d_result, n * sizeof(int));
    cudaMemcpy(d_row_ptr, row_ptr, (n + 1) * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_col_index, col_index, count * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_vec, vec, m * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_result, result, n * sizeof(int), cudaMemcpyHostToDevice);
    dim3 block(32, 32);
    dim3 grid((n + block.x - 1) / block.x, (m + block.y - 1) / block.y);
    sparse_matrix_vector_multiplication<<<grid, block>>>(d_row_ptr, d_col_index, d_vec, d_result, n, m);
    cudaMemcpy(result, d_result, n * sizeof(int), cudaMemcpyDeviceToHost);

    // print the result
    printf("The result is: \n");
    for (i = 0; i < n; i++){
        printf("%d ", result[i]);
    }
    printf("\n");
    
            


}