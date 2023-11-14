#include<stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


__global__ void convolution(int *A, int *M, int *R, int N, int M_N)
{
    int tid = threadIdx.x;
    int start = tid -(M_N/2);
    int tot =0;

    for(int i=0; i<M_N; i++)
    {
        int pos = start + i;

        if(pos >= 0 && pos<N)
        {
            tot += A[pos]*M[i];
        }
    }
    printf("tot = %d\n", tot);

    R[tid] = tot;
}




int main(void)
{
    int A[7] = {1,2,3,4,5,6,7};
    int M[5] = {3,4,5,4,3};
    int R[7];

    int N= 7;
    int mask_N = 5;

    int *dA, *dM, *dR;

    cudaMalloc((void**)&dA, N*sizeof(int));
    cudaMalloc((void**)&dM, mask_N*sizeof(int));
    cudaMalloc((void**)&dR, N*sizeof(int));

    cudaMemcpy(dA, A, N*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dM, M, mask_N*sizeof(int), cudaMemcpyHostToDevice);

    // kernel launch
    convolution<<<1,N>>>(dA,dM,dR,N,mask_N);

     cudaMemcpy(R, dR, N*sizeof(int), cudaMemcpyDeviceToHost);


    for(int i=0; i<N; i++)
    {
        printf("%d ", R[i]);
    }

    cudaFree(dA);
    cudaFree(dM);
    cudaFree(dR);





}