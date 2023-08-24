// Write a MPI program using N processes to find 1! + 2! +…..+N!. Use scan. Also, handle
// different errors using error handling routines.

#include <stdio.h>
#include "mpi.h"
int main(int argc, char *argv[])
{
    int rank, size, sum, prod, fact, len;
    int err1, err2;
    char errstring[50];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Errhandler_set(MPI_COMM_WORLD, MPI_ERRORS_RETURN);

    prod = rank + 1;
    MPI_Scan(&prod, &fact, 1, MPI_INT, MPI_PROD, MPI_COMM_WORLD);

    MPI_Scan(&fact, &sum, 1, MPI_INT, MPI_SUM , MPI_COMM_WORLD);

    if (rank == size -1)
    {
        printf("totol sum is %d\n", sum);
    }

    MPI_Finalize();
    return 0;
}
