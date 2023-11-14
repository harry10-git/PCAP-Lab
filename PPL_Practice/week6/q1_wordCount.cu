// complete this

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>


__global__ void word_Counts(char * str, int * index, char * word)
{
    int tid = threadIdx.x;
    int word_len = strlen(word);

    int start = tid*2;
    int end = start +1;



}


int main(void)
{
    char str[100];

    scanf("%[^\n]s",str);


    int index[20];
    int ptr = 1;

    index[0] =0;

    for(int i=0; i<strlen(str); i++)
    {
        if(str[i]==' ')
        {
            index[ptr] = i-1;
            ptr++;

            index[ptr] = i+1;
            ptr++;

        
        }
    }

    index[ptr] = strlen(str)-1;

    for(int i=0; i<=ptr; i++)
    {
        printf("%d ", index[i]);
    }



}