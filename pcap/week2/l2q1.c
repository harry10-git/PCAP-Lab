// Write a MPI program using synchronous send. The sender process sends a word to the
// receiver. The second process receives the word, toggles each letter of the word and sends
// it back to the first process. Both processes use synchronous send operations.
#include "mpi.h"
#include<stdio.h>
#include<string.h>

int main(int argc, char * argv[])
{
    int rank;
    int len;
    char str[100];

    MPI_Init(&argc, &argv);
    MPI_Status status;
    MPI_Comm_rank(MPI_COMM_WORLD, & rank);

    if(rank == 0)
    {
       printf("Enter a word in master process: ");
       scanf("%s",str);

        len = strlen(str);
        // send length
        MPI_Ssend(&len, 1, MPI_INT, 1,0,MPI_COMM_WORLD);

        MPI_Ssend(str,len,MPI_CHAR,1,1,MPI_COMM_WORLD);

        // receive in P0
        MPI_Recv(str,len,MPI_CHAR,1,2,MPI_COMM_WORLD,&status);
        fprintf(stdout,"Received toggled word in P0: %s\n",str);
    }

    else{
        MPI_Recv(&len, 1, MPI_INT, 0,0,MPI_COMM_WORLD, &status);
        fprintf(stdout,"Received len of %d in P1\n",len);

         MPI_Recv(str, len, MPI_CHAR, 0,1,MPI_COMM_WORLD, &status);
         fprintf(stdout,"Received word =  %s in P1\n",str);

         // toggle string
        for (int i = 0; str[i]!='\0'; i++)
  	   {
  	    if(str[i] >= 'A' && str[i] <= 'Z') 
              str[i] = str[i] + 32; 
              
              
        else if(str[i] >= 'a' && str[i] <= 'z')
            str[i] = str[i] - 32;	
  	   }

       //sending toggled string to P0
        MPI_Ssend(str,len,MPI_CHAR, 0,2,MPI_COMM_WORLD);
 	

    }
 

    MPI_Finalize();
    return 0;
}