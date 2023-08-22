#include "mpi.h"
#include<stdio.h>
#include <math.h>


int main(int argc , char * argv[])
{
    int x = 5;
    int rank, size;
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    printf("Rank %d = %f \n", rank,pow(x,rank));

    MPI_Finalize();
    return 0;


return 0;
}