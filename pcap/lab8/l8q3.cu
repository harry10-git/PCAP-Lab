#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>

// CUDA kernel to replace matrix elements
__global__ void replace(int* mat, int* out, int m, int n) {
    int rid = blockIdx.y * blockDim.y + threadIdx.y;
    int cid = blockIdx.x * blockDim.x + threadIdx.x;

    // Check if the thread is within the valid matrix range
    if (rid < m && cid < n) {
        int val = mat[rid * n + cid];
        int binary = 0, bitcount = 0, rev = 0;

        // Check if the element is on the border of the matrix
        if (rid == 0 || rid == m - 1 || cid == 0 || cid == n - 1) {
            rev = val; // If it is, set the reversed value to the original value
        } else {
            // Convert the value to binary and reverse it
            while (val > 0) {
                binary *= 10;
                if (val % 2 == 0)
                    binary += 1;
                val >>= 1;
                bitcount++;
            }

            while (bitcount--) {
                rev = rev * 10 + binary % 10;
                binary /= 10;
            }
        }

        // Store the reversed value in the output matrix
        out[rid * n + cid] = rev;
    }
}

int main() {
    int m, n;
    printf("Enter the dimensions of the matrix: ");
    scanf("%d %d", &m, &n);

    int sizemat = m * n * sizeof(int);
    int *mat = (int*)malloc(sizemat);
    int *out = (int*)malloc(sizemat);

    printf("\nEnter the matrix elements:\n");
    for (int i = 0; i < m * n; i++)
        scanf("%d", mat + i);

    int *d_mat, *d_out;
    cudaMalloc((void**)&d_mat, sizemat);
    cudaMalloc((void**)&d_out, sizemat);

    // Copy input matrix from host to device
    cudaMemcpy(d_mat, mat, sizemat, cudaMemcpyHostToDevice);

    // Define grid and block dimensions for CUDA kernel
    dim3 blockDim(32, 32); // 32x32 threads per block
    dim3 gridDim((n + blockDim.x - 1) / blockDim.x, (m + blockDim.y - 1) / blockDim.y);

    // Launch the CUDA kernel
    replace<<<gridDim, blockDim>>>(d_mat, d_out, m, n);

    // Copy the result matrix from device to host
    cudaMemcpy(out, d_out, sizemat, cudaMemcpyDeviceToHost);

    // Print the resultant matrix
    printf("\nResultant Matrix:\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++)
            printf("\t%d", out[i * n + j]);
        printf("\n");
    }

    // Free allocated memory
    cudaFree(d_mat);
    cudaFree(d_out);
    free(mat);
    free(out);

    return 0;
}
