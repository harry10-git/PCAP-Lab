#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define N 1024

__global__ void cudaCount(char * str, unsigned int *d_count)
{
    int tid = threadIdx.x;
    if(str[tid] == 'a'){
        atomicAdd(d_count,1);
    }
}

int main()
{
    char str[N];
    char *d_str;

    unsigned int *count, *d_count, *result;
    count = (unsigned int *)malloc(sizeof(unsigned int));
    result = (unsigned int *)malloc(sizeof(unsigned int));
    printf("enter the string: ");
    scanf("%s", str);

    cudaMalloc((void **)&d_str, strlen(str)*sizeof(char));
    cudaMalloc((void **)&d_count, sizeof(unsigned int));


    cudaMemcpy(d_str, str, strlen(str)*sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_count, count, sizeof(unsigned int), cudaMemcpyHostToDevice);

    cudaCount<<<1, strlen(str)>>>(d_str, d_count);
    cudaMemcpy(result, d_count, sizeof(unsigned int), cudaMemcpyDeviceToHost);

    printf("Total occurences of a=%u\n", *result);
    cudaFree(d_str);
    cudaFree(d_count);
    printf("\n");

    return 0;
}
