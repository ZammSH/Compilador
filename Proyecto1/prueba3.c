#include <stdio.h>
#include <stdlib.h>
typedef struct PERSONA{
    int id;
    char nombre[30];
    char apaterno[30];
    char amaterno[30];
    int telefono[30];
    int correo[30];
}PERSONA;

typedef struct NODO{
    PERSONA *person;
    struct NODO* sig;
    struct NODO* ant;
}NODO;

typedef struct{
	NODO *ini;
	NODO *fin;
}Lista;
//funciones
NODO* CrearNodo(PERSONA *persona);
PERSONA* Inicializar();
Lista InicializarLista();
void InsertarInicio(Lista *lis, PERSONA *person);
void InsertarFinal(Lista *lis, PERSONA *person);
//void InsertarPosicion(Lista *lis,unsigned p, unsigned x);
void EliminarNodoInicio(Lista *lis);
void EliminarNodoFinal(Lista *lis);
void EliminarNodoPosicion(Lista *lis, unsigned p);
void ImprimirListaInicio(Lista *lis, PERSONA *person);
void ImprimirListaFin(Lista *lis, PERSONA *person);
void GuardarLista(Lista *lis, PERSONA *person);
void LeerLista(Lista *lis);

int main()
{
   unsigned int opc, p;
   Lista lis;
   lis = InicializarLista();
   PERSONA *person;

    do{
         printf("Menu\n");
        printf("1-Insertar un registro al inicio.\n");
        printf("2-Insertar un registro al final.\n");
        printf("3-Insertar un registro en x posicion.\n");
        printf("4-Eliminar un registro al inicio.\n");
        printf("5-Eliminar un registro al final.\n");
        printf("6-Eliminar un registro en x posicion.\n");
        printf("7-Imprimir agenda de inicio a fin.\n");
        printf("8-Imprimir agenda de fin a inicio.\n");
        printf("9-Guardar agenda.\n");
        printf("10-Leer agenda.\n");
        printf("11-Salir.\n");
        printf("\nIngrese una opcion: ");
        scanf("%i",&opc);
        switch(opc)
        {
            case 1:
            {
                fflush(stdin);
                printf("Insertar un registro al inicio\n");
                person = Inicializar();
                InsertarInicio(&lis, person);

                break;
            }
            case 2:
            {
                fflush(stdin);
                printf("");
                person = Inicializar();
                InsertarFinal(&lis, person);
                break;
            }
            case 3:
            {
                fflush(stdin);
                printf("");
                break;
            }
            case 4:
            {
                printf("Eliminar un registro al inicio.");
                EliminarNodoInicio(&lis);
                break;
            }
            case 5:
            {
                printf("Eliminar un registro del final.");
                EliminarNodoFinal(&lis);
                break;
            }
            case 6:
            {
                printf("Ingresa el valor que deseas eliminar");
                scanf("%i",&p);
                EliminarNodoPosicion(&lis, p);
                break;
            }
            case 7:
            {
                printf("Imprimir agenda de inicio a fin.");
                ImprimirListaInicio(&lis, person);
                break;
            }
            case 8:
            {
                printf("Imprimir agenda de fin a inicio.");
                ImprimirListaFin(&lis, person);
                break;
            }
            case 9:
            {
                printf("Guardar Lista");
                GuardarLista(&lis, person);
                break;
            }
            case 10:
            {
                printf("Leer agenda");
                LeerLista(&lis);
                break;
            }
            default:
            {
                break;
            }

        }
    }while(opc< 11);


    return 0;
}
NODO* CrearNodo(PERSONA* persona)
{
    NODO *ptr;
    ptr = (NODO*) malloc(sizeof(NODO));
    if (ptr == NULL)
    {
        printf("Error al reservar memoria.");
        return 0;
    }
    ptr->sig = NULL;
    ptr->ant = NULL;
    ptr->person = persona;
    return ptr;
}
PERSONA* Inicializar()
{
    PERSONA *person;
    person = (PERSONA *) malloc(sizeof(PERSONA));
    if (person == NULL)
    {
        printf("Error al asignar memoria para el registro");
        return 0;
    }
    printf("Nombre: \n");
    scanf("%s", &person->nombre); fflush(stdin);
    printf("Apellido Paterno: \n");
    scanf("%s", &person->apaterno); fflush(stdin);
    printf("Apellido Materno: \n");
    scanf("%s", &person->amaterno); fflush(stdin);
    printf("Correo: \n");
    scanf("%s", &person->correo); fflush(stdin);
    printf("Telefono: \n");
    scanf("%s", &person->telefono); fflush(stdin);
    return person;

}
Lista InicializarLista(){
	Lista lis;

	lis.ini = NULL;
	lis.fin = NULL;

	return lis;
}
void InsertarInicio(Lista *lis, PERSONA *persona)
{
   NODO *ptr = CrearNodo(persona);

    if(lis->ini != NULL)
    {
        ptr->sig = lis->ini;
        (lis->ini)->ant = ptr;
        lis->ini = ptr;
    }
    else
    {
        lis->ini = lis->fin = ptr;
    }
}

void InsertarFinal(Lista *lis, PERSONA *persona)
{
    NODO *ptr = CrearNodo(persona);

    if(lis->ini != NULL)
    {
        ptr->ant = lis->fin;
        (lis->fin)->sig = ptr;
        lis->fin = ptr;
    }
    else
    {
        lis->ini = lis->fin = ptr;
    }
}
/*void InsertarPosicion(Lista *lis,unsigned p, unsigned x)
{
    NODO *ptr, *aux;
	int i = 0;

	if(lis != NULL)
    {
		aux = lis->ini;
		while(aux != NULL && i < p)
		{
			aux = aux->sig;
			i++;
		}
		if(p == 0)
			InsertarInicio(lis, x);
		else{
			if(aux == NULL)
				InsertarFinal(lis, x);
			else{
				ptr = creaNodo(x);
				ptr->ant = aux->ant;
				ptr->sig = aux;
				(aux->ant)->sig = ptr;
				aux->ant = ptr;
			}
		}
	}
	else
		lis->ini = lis->fin = CrearNodo(x);
}*/
void EliminarNodoInicio(Lista *lis)
{
    NODO *ptr;

	if(lis->ini != NULL){
		ptr = lis->ini;
		lis->ini = (lis->ini)->sig;
		free(ptr);

		if(lis->ini == NULL)
			lis->fin = NULL;
	}
	else
		printf("Error al eliminar. Lista vacia\n");
}
void EliminarNodoFinal(Lista *lis)
{
    NODO *ptr;

	if(lis->fin != NULL){
		ptr = lis->fin;
		lis->fin = (lis->fin)->ant;
		free(ptr);

		if(lis->fin == NULL)
			lis->ini = NULL;
	}
	else
		printf("Error al eliminar. Lista vacia\n");
}
void EliminarNodoPosicion(Lista *lis, unsigned p)
{
    NODO *aux;
	int i = 0;

	if(lis->ini != NULL){
		aux = lis->ini;
		while(aux->sig != NULL && i < p){
			aux = aux->sig;
			i++;
		}
		if(p == 0)
			EliminarNodoInicio(lis);
		else{
			if(aux->sig == NULL)
				EliminarNodoFinal(lis);
			else{
				(aux->ant)->sig = aux->sig;
				(aux->sig)->ant = aux->ant;
				free(aux);
			}
		}
	}
	else
		printf("Error al eliminar. Lista vacia\n");
}
void ImprimirListaInicio(Lista *lis, PERSONA *person)
{
 	NODO *aux = lis->ini;
    if(lis == NULL){
        printf("La lista se encuentra vacia. \n");
    }
    else
    {
        aux = lis;
        do{
            aux = aux->person;
            printf("Nombre: %s\n", person->nombre);
            printf("Apellido Paterno: %s\n", person->apaterno);
            printf("Apellido Materno: %s\n", person->amaterno);
            printf("Correo: %s\n", person->correo);
            printf("Telefono: %s\n", person->telefono);
            aux = aux->sig;
        }while (aux != NULL);
    }

}
void ImprimirListaFin(Lista *lis, PERSONA *person)
{
   NODO *aux = lis->fin;
    if(lis == NULL){
        printf("La lista se encuentra vacia. \n");
    }
    else
    {
        aux = lis;
        do{
            aux = aux->person;
            printf("Nombre: %s\n", person->nombre);
            printf("Apellido Paterno: %s\n", person->apaterno);
            printf("Apellido Materno: %s\n", person->amaterno);
            printf("Correo: %s\n", person->correo);
            printf("Telefono: %s\n", person->telefono);
            aux = aux->ant;
        }while (aux != NULL);
    }
}
void GuardarLista(Lista *lis, PERSONA *person)
{
    NODO *aux;
    FILE *Archivo;
    Archivo=fopen("Registros.txt","w");
    if(Archivo!=NULL)
    {
        aux =lis;
        do
        {

            fprintf(Archivo,"\nNombre: ");
            fputs(aux->person->nombre,Archivo);

            fprintf(Archivo,"\nApellido Paterno: ");
            fputs(aux->person->apaterno,Archivo);

            fprintf(Archivo,"\nApellido Materno: ");
            fputs(aux->person->amaterno,Archivo);

            fprintf(Archivo,"\nNumero: %.0f");
            fputs(aux->person->telefono,Archivo);

            fprintf(Archivo,"\nCorreo: ");
            fputs(aux->person->correo,Archivo);

            aux=aux->sig;
        } while (aux!=NULL);
        fclose(Archivo);
        printf("\nArchivo Guardado");
    }
    else
      printf("Error: no se pudo crear el archivo. \n");
}
void LeerLista(Lista *lis)
{
    int total;
    char lista[100][100];
    FILE *Archivo;
    Archivo = fopen("Registros.txt", "r");
    if(Archivo != NULL)
    {
        printf("\nSe abrio el archivo");

        // Lectura del archivo.
        int k = 0;
        while(!feof(Archivo))
        {
            fgets(&lista[k][0],100,Archivo);
            printf("\n%s",&lista[k][0]);
        }
        total = k;
        fclose(Archivo);
    }
    else
    {
        printf("\nNo se abrio el archivo");
    }
    // Mostrar el contenido del archivo en pantalla
    for(int k = 0; k < total; k++)
    {
        printf("\n1. %s",&lista[k][0]);
    }
}
