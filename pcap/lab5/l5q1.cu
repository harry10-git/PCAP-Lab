// Write a program in CUDA to add two vectors of length N using
// a) block size as N  b) N threads

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<stdio.h>

__global__ void add(int *a, int *b, int *c)
{
    int i = threadIdx.x;
    c[i] = a[i] + b[i];
}

int main(void)
{
    int n;
    printf("enter value of n: ");
    scanf("%d",&n);

    int size = n * sizeof(int);
    int a[n], b[n], c[n];
    int *d_a, *d_b, *d_c;

    cudaMalloc((void **)&d_a, size);
	cudaMalloc((void **)&d_b, size);
	cudaMalloc((void **)&d_c, size);

    printf("vector 1 : ");
    for(int i=0; i<n; i++)
    {
        scanf("%d",&a[i]);
    }
    printf("vector 2 : ");
    for(int i=0; i<n; i++)
    {
        scanf("%d",&b[i]);
    }
    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
    
    dim3 dimGrid(1,1,1);
    dim3 dimBlock(n,1,1);

    add<<<dimGrid,dimBlock>>>(d_a, d_b, d_c);
    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);
    printf("sum : ");
    for(int i=0; i<n; i++)
    {  
        printf("%d ",c[i]);
    }
    cudaFree(d_a);
    cudaFree(d_b);  
    cudaFree(d_c);
    return 0;
}
