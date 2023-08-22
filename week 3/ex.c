// Write a MPI program to read N values of the array in the root process. Distribute these N values
// among N processes. Every process finds the square of the value it received. Let every process
// return these value to the root and root process gathers and prints the result. Use collective
// communication routines.
#include "mpi.h"
#include <stdio.h>

int main(int argc, char *argv[])
{

    int rank, size, N, A[10], B[10], c, i;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0)
    {
        N = size;
        fprintf(stdout, "Enter %d values in root \n", N);
        fflush(stdout);

        for (int i = 0; i < N; i++)
        {
            scanf("%d", &A[i]);
        }
    }

    MPI_Scatter(A, 1, MPI_INT, &c, 1, MPI_INT, 0, MPI_COMM_WORLD);

    fprintf(stdout, "Received %d in rank %d\n", c, rank);
    fflush(stdout);

    c = c * c;
    MPI_Gather(&c, 1, MPI_INT, B, 1, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0)
    {
        fprintf(stdout, "Gathering result in Root\n");
        fflush(stdout);

        for (i = 0; i < N; i++)
        {
            fprintf(stdout, "%d \t", B[i]);
            fflush(stdout);
        }
    }

    fprintf(stdout, "\n");
    fflush(stdout);
    MPI_Finalize();

    return 0;
}
