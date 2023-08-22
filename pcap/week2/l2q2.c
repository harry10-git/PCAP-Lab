// Write a MPI program where the master process (process 0) sends a number to each of the
// slaves and the slave processes receive the number and prints it. Use standard send.
#include "mpi.h"
#include<stdio.h>

int main(int argc, char * argv[])
{
    int rank,size;
    int num;

    MPI_Init(&argc, &argv);

    MPI_Status status;
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(rank == 0)
    {
        printf("Enter a number in master process ");
        scanf("%d",&num);
        // send from master process
        for(int i=1 ; i<size; i++)
        {
            MPI_Send(&num,1,MPI_INT,i,99,MPI_COMM_WORLD);
        }
        
    }

    else{
      
            MPI_Recv(&num,1,MPI_INT,0,99,MPI_COMM_WORLD,&status);
            fprintf(stdout,"Rank %d received %d from master\n",rank,num);
            fflush(stdout);
        
    }


    MPI_Finalize();
    return 0;
}