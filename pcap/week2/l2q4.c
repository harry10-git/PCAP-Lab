// Write a MPI program to read an integer value in the root process. Root process sends this
// value to Process1, Process1 sends this value to Process2 and so on. Last process sends the
// value back to root process. When sending the value each process will first increment the
// received value by one. Write the program using point to point communication routines.

#include "mpi.h"
#include<stdio.h>

int main(int argc, char * argv[])
{

    int rank, size;
    int num;
    int next = 1;

    MPI_Init(&argc, &argv);
    MPI_Status status;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    if(rank ==0)
    {
         // send next
        // MPI_Ssend(&next,1,MPI_INT,curr,curr,MPI_COMM_WORLD);

        printf("enter a value in root process ");
        scanf("%d",&num);
       
        // send num
        MPI_Send(&num, 1, MPI_INT, next, next,MPI_COMM_WORLD);
    }

    else {
        // recv next from root
         MPI_Recv(&next, 1, MPI_INT, 0, next, MPI_COMM_WORLD ,&status);
        
        // receive the number
        MPI_Recv(&num, 1, MPI_INT, curr-1, curr, MPI_COMM_WORLD ,&status);
        fprintf(stdout,"Rank %d received %d \n",rank,num);
        fflush(stdout);
        
        //increment by one and send forward
        num +=1;
        curr +=1;

        if(curr < size)
        {
            MPI_Send(&num,1,MPI_INT, curr,curr,MPI_COMM_WORLD);
        }
    }





    MPI_Finalize();
    return 0;
}