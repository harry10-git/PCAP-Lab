/*
Write a program in CUDA to read MXN matrix A and replace 1 st row of this matrix by same
elements, 2 nd row elements by square of each element and 3 rd row elements by cube of each element
and so on.
*/

#include <stdio.h>
#include <cuda_runtime.h>

#define BLOCK_SIZE 32

__global__ void processMatrix(int *A, int *B, int numRows, int numCols)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < numRows && col < numCols)
    {
        int index = row * numCols + col;
        int element = A[index];
        int power = row + 1; // Power for the current row

        if(power == 1)
        {
             B[index] = element;
        }

        // Replace elements based on the row number
        else if (power == 2)
        {
            B[index] = element * element; // Square for even rows
        }
        else if (power == 3)
        {
            B[index] = element * element * element; // Cube for odd rows
        }
    }
}

int main()
{
    int numRows = 3; // Number of rows
    int numCols = 4; // Number of columns

    // Input matrix A
    int A[numRows][numCols] = {
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {9, 10, 11, 12}
    };

    // Allocate device memory for matrix A and B
    int *d_A, *d_B;
    cudaMalloc((void **)&d_A, sizeof(int) * numRows * numCols);
    cudaMalloc((void **)&d_B, sizeof(int) * numRows * numCols);

    // Copy matrix A from host to device
    cudaMemcpy(d_A, A, sizeof(int) * numRows * numCols, cudaMemcpyHostToDevice);

    // Define kernel launch configuration
    dim3 dimGrid((numCols + BLOCK_SIZE - 1) / BLOCK_SIZE, (numRows + BLOCK_SIZE - 1) / BLOCK_SIZE, 1);
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE, 1);

    // Launch kernel
    processMatrix<<<dimGrid, dimBlock>>>(d_A, d_B, numRows, numCols);

    // Copy the result matrix B from device to host
    int B[numRows][numCols];
    cudaMemcpy(B, d_B, sizeof(int) * numRows * numCols, cudaMemcpyDeviceToHost);

    // Print the result matrix B
    printf("Result Matrix B:\n");
    for (int i = 0; i < numRows; i++)
    {
        for (int j = 0; j < numCols; j++)
        {
            printf("%d ", B[i][j]);
        }
        printf("\n");
    }

    // Free device memory
    cudaFree(d_A);
    cudaFree(d_B);

    return 0;
}



