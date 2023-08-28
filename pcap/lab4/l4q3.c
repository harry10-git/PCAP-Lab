// Write a MPI program to read a 3 X 3 matrix. Enter an element to be searched in the root
// process. Find the number of occurrences of this element in the matrix using three processes.

#include <stdio.h>
#include "mpi.h"
int main(int argc, char *argv[])
{

    int mat[3][3], row[3];
    int rank,size, find, row_found =0, tot_found;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(rank == 0)
    {
        fprintf(stdout,"enter 9 vals for 3X3 matrix\n");
        for(int i=0; i<3; i++)
        {
            for(int j=0; j<3; j++)
            {
                scanf("%d",&mat[i][j]);
            }
        }

        fflush(stdout);
        fprintf(stdout, "Enter the number to search: ");
        scanf("%d", &find);
    }

    // broadcast number to find
    MPI_Bcast(&find, 1, MPI_INT, 0, MPI_COMM_WORLD);

    // scatter the rows
    MPI_Scatter(mat, 3, MPI_INT, row, 3, MPI_INT, 0, MPI_COMM_WORLD);

    // find in each row
    for(int i=0; i<3; i++)
    {
        if(row[i] == find)
            row_found++;
    }

    // Reduce in root
    MPI_Reduce(&row_found, &tot_found, 1, MPI_INT, MPI_SUM, 0 , MPI_COMM_WORLD);

    if(rank == 0)
    {
        printf("Number of times found = %d\n", tot_found);
    }


    


    

    MPI_Finalize();
    return 0;
}