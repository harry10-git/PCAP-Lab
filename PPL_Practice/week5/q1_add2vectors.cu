#include<stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__global__ void vecAdd(int *A, int *B, int *C)
{
    int tid = threadIdx.x;
    C[tid] = A[tid]+ B[tid];
}

int main(void)
{
    int *A,*B,*C;
    int *dA,*dB, *dC;
    int n;
    printf("n: ");
    scanf("%d", &n);
    int size = n *sizeof(int);

    A = (int*)malloc(n*sizeof(int));
    B = (int*)malloc(n*sizeof(int));
    C = (int*)malloc(n*sizeof(int));


    printf("A: ");
    for(int i=0; i<n; i++)
    {
        scanf("%d", (A+i));
    }

    printf("B: ");
    for(int i=0; i<n; i++)
    {
        scanf("%d", (B+i));
    }

    cudaMalloc((void**)&dA,size);
    cudaMalloc((void**)&dB,size);
    cudaMalloc((void**)&dC,size);

    cudaMemcpy(dA,A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(dB,B, size, cudaMemcpyHostToDevice);

    // launch kernel

    vecAdd<<<1,256>>>(dA,dB,dC);

    cudaMemcpy(C,dC, size, cudaMemcpyDeviceToHost);
    
    for(int i=0; i<n; i++)
    {
        printf("%d ",*(C+i));
    }

    cudaFree(dA);
    cudaFree(dB);
    cudaFree(dC);


}

