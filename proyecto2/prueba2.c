#include <stdio.h>
int main()
{
char Linea[100];
  char letra1;
  int i;
  //Para capturar un caracter o una linea de texto podemos usar
  // las siguientes funciones:
  printf("\nEscriba una letra: ");
  scanf("%c",&letra1);
  printf("El caracter capturado es: %c",letra1);
  //getchar();
  fflush(stdin);
  printf("\nEscriba otra letra: ");
  letra1=getchar();
  printf("El caracter capturado es: %c",letra1);
  printf("\nEscriba una linea de texto: ");
  gets(Linea);
  //printf("\nEl texto es:\n%s",Linea);

  printf("\nEl texto es:\n");
  i=0;
  while(Linea[i]!='\0')
      { putchar(Linea[i]);
        i++;
        }
  printf("\nEscriba una linea de texto: ");
  scanf("%s",Linea);
  printf("\nEl texto es:\n%s",Linea);/* */
 }
