// column sum in 4X4 matix
/*
1 2 3 4
1 2 3 1
1 1 1 1
2 1 2 1
*/
#include <stdio.h>
#include "mpi.h"
int main(int argc, char *argv[])
{
    int mat[4][4], res[4][4], row[4], new_row[4];
    int rank, size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0)
    {
        printf("Enter a 4 X 4 matrix\n");

        for (int i = 0; i < 4; i++)
        {
            for (int j = 0; j < 4; j++)
            {
                scanf("%d", &mat[i][j]);
            }
        }
    }

    // scatter rows
    MPI_Scatter(mat, 4, MPI_INT, row, 4, MPI_INT, 0, MPI_COMM_WORLD);

    for (int i = 0; i < 4; i++)
    {
        MPI_Scan(&row[i], &new_row[i], 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
    }
    
    // gather in root
    MPI_Gather(new_row, 4, MPI_INT, res, 4, MPI_INT, 0, MPI_COMM_WORLD);

    if(rank == 0)
    {
        printf("-- Printing Output --\n");
        for(int i=0; i<4; i++)
        {
            for(int j=0; j<4; j++)
            {
                printf("%d ",res[i][j]);
            }printf("\n");
        }
        printf("\n");
    }

    MPI_Finalize();
    return 0;
}