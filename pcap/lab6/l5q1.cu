// 1. Write a program in CUDA to count the number of times a given word is repeated in a sentence.
// (Use Atomic function)

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

__global__ void cudaRepWords()
{

}


void fill_arr(char str[], int arr[])
{
    
}

int main()
{
    char str[100];
    scanf("%[^\n]s",str);

    int arr[100];

    int *count , *d_count;
    count = (int *)malloc(sizeof(int));
    cudaMalloc((void **)&d_count, sizeof(int));




    return 0;
}