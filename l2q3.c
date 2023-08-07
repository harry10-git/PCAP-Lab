// Write a MPI program to read N elements of the array in the root process (process 0) where
// N is equal to the total number of processes. The root process sends one value to each of the
// slaves. Let even ranked process finds square of the received element and odd ranked pro-
// cess finds cube of received element. Use Buffered send.

#include "mpi.h"
#include<stdio.h>
#include<math.h>

int main(int argc, char * argv[])
{
    

    MPI_Init(&argc, &argv);
    int rank,size;
    int num;
    MPI_Status status;
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    
    int arr[size];

    int b_size = 100;
    int buffer [b_size];
    MPI_Buffer_attach(buffer, b_size);

    if(rank == 0)
    {
        printf("Enter %d elements in the array start with -1\n",size);
        for(int i=0;i<size;i++)
        {
            scanf("%d",&arr[i]);
        }

        // buffered send
        for(int i=1; i<size; i++)
        {
            MPI_Bsend(&arr[i],1,MPI_INT,i,i,MPI_COMM_WORLD);
        }
    }

    else{
        // recieve
        MPI_Recv(&num,1,MPI_INT,0,rank,MPI_COMM_WORLD,&status);
        if(rank%2 == 0)
        {
        fprintf(stdout,"Rank %d received %d square = %d \n",rank,num, num*num);
        fflush(stdout);
        }
        else{
             fprintf(stdout,"Rank %d received %d cube = %d \n",rank,num, num*num*num);
            fflush(stdout);
        }
        
    }

    MPI_Buffer_detach(buffer, &b_size);
    MPI_Finalize();
    return 0;
}