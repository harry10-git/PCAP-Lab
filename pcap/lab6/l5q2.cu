/*2. Write a CUDA program that reads a string S and produces the string RS as follows:
Input string S: PCAP
Output string RS: PCAPPCAPCP
Note: Each work item copies required number of characters from S in RS.
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void stringCopy(char *d_s, char *d_rs, int n)
{
    int i = threadIdx.x;
    int j = 0;
    while (j < n)
    {
        d_rs[i*n + j] = d_s[j];
        j++;
    }
}

int main()
{
    char s[100], rs[100];
    char *d_s, *d_rs;
    int n;
    printf("Enter the string: ");
    scanf("%s", s);
    n = strlen(s);
    cudaMalloc((void **)&d_s, n * sizeof(char));
    cudaMalloc((void **)&d_rs, n * n * sizeof(char));
    cudaMemcpy(d_s, s, n * sizeof(char), cudaMemcpyHostToDevice);
    stringCopy<<<1, n>>>(d_s, d_rs, n);
    cudaMemcpy(rs, d_rs, n * n * sizeof(char), cudaMemcpyDeviceToHost);
    printf("Output string: %s\n", rs);
    cudaFree(d_s);
    cudaFree(d_rs);
    return 0;
}