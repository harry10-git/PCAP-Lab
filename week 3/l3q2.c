// Write a MPI program to read an integer value M and NXM elements into an 1D array in 
// the root process, where N is the number of processes. Root process sends M elements to 
// each process. Each process finds average of M elements it received and sends these average 
// values to root. Root collects all the values and finds the total average. Use collective communication routines.

#include "mpi.h"
#include <stdio.h>

int main(int argc, char *argv[])
{
    int rank, size, N, M, A[100],B[100], i;
    float avg =0 , tot_avg =0, res[10];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(rank == 0)
    {
        fprintf(stdout, "Enter value of M in root\n");
        fflush(stdout);

        scanf("%d", &M);
        N = size;

        fprintf(stdout, "Enter value of %d values in root\n", M*N);
        fflush(stdout);


        for(i=0; i< M*N; i++)
        {
            scanf("%d",&A[i]);
        }
    }

    // broadcast value of M
    MPI_Bcast(&M, 1, MPI_INT, 0, MPI_COMM_WORLD);

    MPI_Scatter(A, M , MPI_INT, B, M, MPI_INT, 0, MPI_COMM_WORLD);

    // calc avg
    for(i=0; i<M; i++)
    {
        avg += B[i];
    }
    avg = avg/M;

    fprintf(stdout, "Avg in rank %d is %f\n", rank, avg);
    fflush(stdout);


    // Gather in root 
    MPI_Gather(&avg, 1, MPI_FLOAT, res, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);
    // find total avg in root
    if(rank == 0)
    {
        for(i=0; i<N; i++)
        {
            tot_avg += res[i];
        }
        tot_avg = tot_avg/N;

        fprintf(stdout, "The total average is %f\n", tot_avg);
        fflush(stdout);
    }

    MPI_Finalize();


    return 0;
}
