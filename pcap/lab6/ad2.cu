/*2) Write a CUDA program that takes a string Sin as input and one integer value N and produces
an output string , Sout, in parallel by concatenating input string Sin, N times as shown below.
Input:
Sin = “Hello” N = 3
Ouput:
Sout = “HelloHelloHello”
Note: Every thread copies the same character from the Input string S, N times to the re-
quired position.
*/

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

__global__ void copystr(char *str, char * r_str, int len)
{
   int tid = threadIdx.x; int i; int pos = tid;


   for(i=0; i<len; i++)
   {
      r_str[pos] = str[tid];
      pos = pos + len;
   } 
}

int main(void)
{
   char str[100];
   printf("enter a string: ");
   scanf("%s", str);
   int len = sizeof(str)/sizeof(char);
   char *d_str, *d_rstr;
   cudaMalloc((void **)&d_str, len*sizeof(char));
   cudaMalloc((void **)&d_rstr, len*sizeof(char));
   cudaMemcpy(d_str, str, len*sizeof(char), cudaMemcpyHostToDevice);
   copystr<<<1, len>>>(d_str, d_rstr, len);
   char rstr[len];
   cudaMemcpy(rstr, d_rstr, len*sizeof(char), cudaMemcpyDeviceToHost);
   printf("output string: %s\n", rstr);
   cudaFree(d_str);
   cudaFree(d_rstr);
   return 0;
}