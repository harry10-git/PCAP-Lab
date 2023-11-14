#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

__global__ void findA(char * str, int * d_count)
{
    int tid = threadIdx.x;
    
    if(str[tid] == 'a')
    {
        atomicAdd(d_count,1);
     
    }
}

int main(void)
{
    char str[25];
    char * d_str;

    int count=0 , *d_count;

    printf("string: ");
    scanf("%[^\n]s",str);

    cudaMalloc((void**)&d_str, strlen(str)*sizeof(char));
    cudaMalloc((void**)&d_count, sizeof(int));

    cudaMemcpy(d_str, str, strlen(str)*sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_count, &count, sizeof(int), cudaMemcpyHostToDevice);

    findA<<<1, strlen(str)>>>(d_str, d_count);

    cudaMemcpy(&count, d_count, sizeof(int), cudaMemcpyDeviceToHost);

    printf("num of A's = %d\n", count);

    cudaFree(d_str);
    cudaFree(d_count);

    return 0;
}