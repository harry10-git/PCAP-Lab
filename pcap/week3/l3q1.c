// Write a MPI program to read N values in the root process. Root process sends one value to 
// each process. Every process receives it and finds the factorial of that number and returns it 
// to the root process. Root process gathers the factorial and finds sum of it. Use N number 
// of processes

#include "mpi.h"
#include <stdio.h>

int findFactorial(int num)
{
    int factorial = 1;
    for(int j=1; j<=num; j++)
    {
        factorial = factorial * j;
    }

    return factorial;
}

int main(int argc, char *argv[])
{

    int rank, size, N, A[10], B[10], i, fact;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(rank == 0)
    {
        N = size;
        fprintf(stdout, "Enter %d nums in root \n",N);
        fflush(stdout);

        for(i=0; i<N; i++)
        {
            scanf("%d",&A[i]);
        }  
    }

    MPI_Scatter(A, 1, MPI_INT, &fact, 1, MPI_INT, 0, MPI_COMM_WORLD);
    fprintf(stdout, "Received %d in rank %d\n", fact, rank);
    fflush(stdout);

    fact = findFactorial(fact);

    MPI_Gather(&fact, 1, MPI_INT, B, 1, MPI_INT, 0, MPI_COMM_WORLD);
    if(rank ==0)
    {
         fprintf(stdout, "Gathering result in Root\n");
        fflush(stdout);

        for (i = 0; i < N; i++)
        {
            fprintf(stdout, "%d \t", B[i]);
            fflush(stdout);
        }
    }

    MPI_Finalize();
    return 0;
}
