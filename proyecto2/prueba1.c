#include <stdio.h>
#include <stdlib.h>

int main()
{
    char c[1000];
    int y = 0x1f;
    float x = .523e21;
    char c = 'a';
    FILE *fptr;
    if((fptr=fopen("program.txt","r"))==NULL)
    {
        printf("Error opening file");
        exit(1);
    }
    fscanf(fptr,"%[^\n]",c);
    printf("Data from file:\n%s",c);
    fclose(fptr);
    return 0;

}