// Write a MPI Program to read two strings S1 and S2 of same length in the root process.
// Using N processes including the root (string length is evenly divisible by N), produce the
// resultant string as shown below. Display the resultant string in the root process. Use Col-
// lective communication routines.
// Example:
// String S1: string  String S2: length
// Resultant String : slternigntgh

#include "mpi.h"
#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[])
{
    int rank, size, len, chunk,i, ptr=0;
    char str1[100], str2[100], temp1[20], temp2[20], temp[50], ans[100];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if(rank == 0)
    {
        fprintf(stdout, "Enter S1: ");
        fflush(stdout);
        scanf("%s", str1);

        fprintf(stdout, "Enter S2: ");
        fflush(stdout);
        scanf("%s", str2);

        len = strlen(str1);
        chunk = len/size;
    }

    // broadcast chunk 
    MPI_Bcast(&chunk, 1, MPI_INT, 0, MPI_COMM_WORLD);

    // scatter s1 and s2
    MPI_Scatter(str1, chunk, MPI_CHAR, temp1, chunk, MPI_CHAR, 0, MPI_COMM_WORLD);
    MPI_Scatter(str2, chunk, MPI_CHAR, temp2, chunk, MPI_CHAR, 0, MPI_COMM_WORLD);

    for(i =0; i<chunk; i++)
    {
        temp[ptr] = temp1[i];
        temp[ptr+1] = temp2[i];
        ptr += 2;
    }

    // gather in root
    MPI_Gather(temp, chunk*2, MPI_CHAR, ans, chunk*2, MPI_CHAR, 0, MPI_COMM_WORLD);


    if(rank == 0)
    {
        fprintf(stdout, "Final Output:  %s\n", ans);
        fflush(stdout);
    }




    MPI_Finalize();


    return 0;
}