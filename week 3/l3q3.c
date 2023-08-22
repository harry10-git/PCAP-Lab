// Write a MPI program to read a string. Using N processes (string length is evenly divisible
// by N), find the number of non-vowels in the string. In the root process print number of
// non-vowels found by each process and print the total number of non-vowels.

#include "mpi.h"
#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[])
{
    int rank, size, string_len, non_vows = 0, all_non_vows[10], result = 0, i;
    char str[100], recv_str[10];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0)
    {
        fprintf(stdout, "Enter a string\n");
        fflush(stdout);
        scanf("%s", str);
        // printf("the string is %s\n", str);
        string_len = strlen(str);
    }

     MPI_Bcast(&string_len, 1, MPI_INT, 0, MPI_COMM_WORLD);

   
    MPI_Scatter(str, string_len/size, MPI_CHAR, recv_str, string_len/size,MPI_CHAR, 0, MPI_COMM_WORLD);

    // find number of non vowels
    for (i = 0; i < string_len / size; i++)
    {
        if (recv_str[i] != 'a' && recv_str[i] != 'e' && recv_str[i] != 'i' && recv_str[i] != 'o' && recv_str[i] != 'u')
        {
            non_vows++;
        }
    }

    fprintf(stdout, "non-vowels in rank %d = %d\n",rank,non_vows);

    // gather from all the processes
    MPI_Gather(&non_vows, 1, MPI_INT, all_non_vows, 1, MPI_INT, 0, MPI_COMM_WORLD);

    // find total sum and print in root
    if (rank == 0)
    {
        for (i = 0; i < size; i++)
        {
            result += all_non_vows[i];
        }
        fprintf(stdout, "Total number of non vowels is %d\n", result);
        fflush(stdout);
    }

    MPI_Finalize();

    return 0;
}
