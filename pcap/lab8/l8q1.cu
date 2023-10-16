#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#define BLOCK_SIZE 32

// Function to convert 2D matrix to CSR format
void convertToCSR(int **matrix, int numRows, int numCols, int **row_ptr, int **col_idx, int **values)
{
    int nnz = 0;
    for (int i = 0; i < numRows; i++)
    {
        for (int j = 0; j < numCols; j++)
        {
            if (matrix[i][j] != 0)
            {
                nnz++;
            }
        }
    }

    *row_ptr = (int *)malloc(sizeof(int) * (numRows + 1));
    *col_idx = (int *)malloc(sizeof(int) * nnz);
    *values = (int *)malloc(sizeof(int) * nnz);

    int index = 0;
    (*row_ptr)[0] = 0;
    for (int i = 0; i < numRows; i++)
    {
        for (int j = 0; j < numCols; j++)
        {
            if (matrix[i][j] != 0)
            {
                (*col_idx)[index] = j;
                (*values)[index] = matrix[i][j];
                index++;
            }
        }
        (*row_ptr)[i + 1] = index;
    }
}

__global__ void csrKernel(int *row_ptr, int *col_idx, int *values, int *x, int *y, int numRows)
{
    int row = blockIdx.x * blockDim.x + threadIdx.x;
    if (row < numRows)
    {
        int row_start = row_ptr[row];
        int row_end = row_ptr[row + 1];
        int sum = 0;
        for (int i = row_start; i < row_end; i++)
        {
            int col = col_idx[i];
            sum += values[i] * x[col];
        }
        y[row] = sum;
    }
}

int main()
{
    int numRows = 3;
    int numCols = 3;

    // Input 2D matrix
    int **matrix = (int **)malloc(numRows * sizeof(int *));
    for (int i = 0; i < numRows; i++)
    {
        matrix[i] = (int *)malloc(numCols * sizeof(int));
    }
    // Example input matrix
    matrix[0][0] = 1;
    matrix[0][1] = 0;
    matrix[0][2] = 2;
    matrix[1][0] = 1;
    matrix[1][1] = 3;
    matrix[1][2] = 5;
    matrix[2][0] = 0;
    matrix[2][1] = 0;
    matrix[2][2] = 9;

    // Convert 2D matrix to CSR format
    int *row_ptr, *col_idx, *values;
    convertToCSR(matrix, numRows, numCols, &row_ptr, &col_idx, &values);

    // Display CSR format on host
    printf("CSR Format:\n");
    for (int i = 0; i <= numRows; i++)
    {
        printf("%d ", row_ptr[i]);
    }
    printf("\n");
    for (int i = 0; i < row_ptr[numRows]; i++)
    {
        printf("%d ", col_idx[i]);
    }
    printf("\n");
    for (int i = 0; i < row_ptr[numRows]; i++)
    {
        printf("%d ", values[i]);
    }
    printf("\n");

    // Input vector
    int x[] = {1, 2, 3};

    // Allocate device memory for CSR arrays and vector x
    int *d_row_ptr, *d_col_idx, *d_values, *d_x, *d_y;
    cudaMalloc((void **)&d_row_ptr, sizeof(int) * (numRows + 1));
    cudaMalloc((void **)&d_col_idx, sizeof(int) * row_ptr[numRows]);
    cudaMalloc((void **)&d_values, sizeof(int) * row_ptr[numRows]);
    cudaMalloc((void **)&d_x, sizeof(int) * numCols);
    cudaMalloc((void **)&d_y, sizeof(int) * numRows);

    // Copy data from host to device
    cudaMemcpy(d_row_ptr, row_ptr, sizeof(int) * (numRows + 1), cudaMemcpyHostToDevice);
    cudaMemcpy(d_col_idx, col_idx, sizeof(int) * row_ptr[numRows], cudaMemcpyHostToDevice);
    cudaMemcpy(d_values, values, sizeof(int) * row_ptr[numRows], cudaMemcpyHostToDevice);
    cudaMemcpy(d_x, x, sizeof(int) * numCols, cudaMemcpyHostToDevice);

    // Define kernel launch configuration
    dim3 dimGrid((numRows + BLOCK_SIZE - 1) / BLOCK_SIZE, 1, 1);
    dim3 dimBlock(BLOCK_SIZE, 1, 1);

    // Launch kernel
    csrKernel<<<dimGrid, dimBlock>>>(d_row_ptr, d_col_idx, d_values, d_x, d_y, numRows);

    // Copy the result back to host
    int y[numRows];
    cudaMemcpy(y, d_y, sizeof(int) * numRows, cudaMemcpyDeviceToHost);

    // Print the result
    printf("Result of Sparse Matrix-Vector Multiplication (CSR format):\n");
    for (int i = 0; i < numRows; i++)
    {
        printf("%d ", y[i]);
    }
    printf("\n");

    // Free host and device memory
    for (int i = 0; i < numRows; i++)
    {
        free(matrix[i]);
    }
    free(matrix);
    free(row_ptr);
    free(col_idx);
    free(values);
    cudaFree(d_row_ptr);
    cudaFree(d_col_idx);
    cudaFree(d_values);
    cudaFree(d_x);
    cudaFree(d_y);

    return 0;
}
