#include <mpi.h>
#include <stdio.h>
#include <string.h>
 
int fact(int n) 
{
if (n<=1)
return 1;
else
return n*fact(n-1);
}
 
int main(int argc,char* argv[])
{
int rank, size;
int i = 0;
int k = 0,fac=1,ans[1000],sum=0;
int n;

MPI_Init(&argc, &argv);

MPI_Comm_rank(MPI_COMM_WORLD, &rank);
// Set the error handler to MPI_ERRORS_RETURN

MPI_Errhandler_set(MPI_COMM_WORLD, MPI_ERRORS_RETURN);

MPI_Comm_size(MPI_COMM_WORLD, &size);
 
//Get the error code on broadcasting; purposely fail this
int error;
error = MPI_Bcast(&fac, 1, MPI_INT, 4, MPI_COMM_WORLD);
 
if (error != MPI_SUCCESS) 
{
char s[100];
int len, class1;
MPI_Error_string(error, s, &len);
MPI_Error_class(error, &class1);
fprintf(stderr, "Error description is %s", s);
fflush(stderr);
fprintf(stderr, "Error class is %d", class1);
fflush(stderr);
}

for (i=1;i<=rank+1;i++) 
{
fac = fac*i;
//MPI_Scan(&fac,&ans[i],1,MPI_INT,MPI_SUM,MPI_COMM_WORLD);
}



MPI_Scan(&fac,&k,1,MPI_INT,MPI_SUM,MPI_COMM_WORLD);

if (rank == size-1) 
{
fprintf(stdout,"%d\n",k);
fflush(stdout);
}

MPI_Finalize();
return 0;
}