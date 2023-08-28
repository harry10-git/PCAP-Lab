// Write a program in CUDA to process a 1D array containing angles in radians to generate
// sine of the angles in the output array. Use appropriate function.


#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<stdio.h>

__global__ void sine(float *a, float *b, int n)
{
    int id = threadIdx.x;
    if(id<n)
    {
        b[id] = sin(a[id]);
    }
}

int main(void)
{
    int n;
    float *a, *b;
    float *d_a, *d_b;
    printf("Enter the size of the array: ");
    scanf("%d", &n);
    a = (float *)malloc(n*sizeof(float));
    b = (float *)malloc(n*sizeof(float));

    //cuda malloc
    cudaMalloc((void **)&d_a, n*sizeof(float));
    cudaMalloc((void **)&d_b, n*sizeof(float));
   

    printf("Enter the elements of the array: ");
    for(int i=0; i<n; i++)
    {
       scanf("%f", &a[i]);
    }

    cudaMemcpy(d_a, a, n*sizeof(float), cudaMemcpyHostToDevice);
    // call the kernel
    sine<<<n, 1>>>(d_a, d_b, n);

    cudaMemcpy(b, d_b, n*sizeof(float), cudaMemcpyDeviceToHost);
    
    for(int i=0; i<n; i++)
    {
        printf("%f\n", b[i]);
    }
    return 0;


    return 0;
}