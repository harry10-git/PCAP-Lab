#include<stdio.h>
#include<stdlib.h>
#include<string.h>


int main()
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







    return 0;
}