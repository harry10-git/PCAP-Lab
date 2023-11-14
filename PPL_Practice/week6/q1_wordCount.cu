// complete this

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>


__global__ void word_Counts(char * str, int * index, char * word, int * d_count)
{
    int tid = threadIdx.x;
    int word_len = strlen(word);

    int start = tid*2;
    int end = start +1;

    int len = start - end +1;

    if(len != word_len)
    {
        return;
    }

    bool flag = true;
    
    for(int i=0 ; i<word_len; i++)
    {
        if(str[start+i] != word[i])
        {
            flag = false;
            break;
        }
    }

    if(flag)
    {
        atomicAdd(d_count,1);
    }



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




    //////////////
    char * d_str;
    char * d_word;
    int count = 0;
    int *d_count;
    char word[10] = "hii";


    cudaMalloc((void**)&d_str, strlen(str)*sizeof(char));
    cudaMalloc((void**)&d_count, sizeof(int));

    cudaMemcpy(d_str, str,strlen(str)*sizeof(char),cudaMemcpyHostToDevice);
    cudaMemcpy(d_count, &count,sizeof(int),cudaMemcpyHostToDevice);

    int num_words =  (ptr+1)/2;

   
    word_Counts<<<1, num_words>>>(d_str, index, )


}
