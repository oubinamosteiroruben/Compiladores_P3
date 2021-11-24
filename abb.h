#ifndef ABB_H
# define ABB_H

/**
 * Tipo de dato abstracto para arbol binario con clave de
 * ordenacion y elemento de celda.
 */

///////////////////////////////////////INICIO PARTE MODIFICABLE

typedef struct{
    union{
        char * nombre;
    }valor;
} tipoArchivo;

typedef char * tipoclave;

typedef double (*accion_t) (double);

typedef struct {
    char *nombre;
    int tipo;
    union {
        double val;
        accion_t fnc;      
    } valor;
} tipoelem;


//////////////////////////////////////////FIN PARTE MODIFICABLE

//TIPO OPACO, no sabemos como esta construido celda
// https://es.wikipedia.org/wiki/Puntero_opaco
typedef struct celda *abb;


// Si no tuviesemos importado abb.h en abb.c podriamos
// lograr mas opacidad usando esta definicion para el arbol:
// typedef void *abb;
// Y teniendo en el abb.c la definicion typedef struct celda *abb;
// Tenemos que decidir que preferimos mayor opacidad o menos
// codigo repetido, en este caso hemos optado por lo segundo.
//

/////////////////////////////// FUNCIONES

//FUNCIONES DE CREACIÓN Y DESTRUCCIÓN DEL �?RBOL
/**
 * Crea el arbol vacio.
 * @param A Puntero al arbol. Debe estar inicializado.
 */
void crear(abb *A);

/**
 * Destruye el arbol recursivamente
 * @param A El arbol que queremos destruir
 */
void destruir(abb *A);

//FUNCIONES DE INFORMACIÓN
/**
 * Comprueba si el arbol esta vacio
 * @param A El arbol binario
 */
unsigned es_vacio(abb A);

/**
 * Devuelve el subarbol izquierdo de A
 * @param A - Arbol original
 */
abb izq(abb A);

/**
 * Devuelve el subarbol derecho de A
 * @param A - Arbol original
 */
abb der(abb A);

/**
 * Recupera la informacion de la celda de la raiz del arbol
 * @param A
 * @param E Puntero al nodo que apuntara a la informacion
 */
void leer(abb A, tipoelem *E);

/**
 * Comprueba si el elemento con clave <cl> existe en el arbol <A>
 * @param A
 * @param cl
 */
unsigned es_miembro(abb A, tipoelem E);
//unsigned es_miembro_clave(abb A, tipoclave cl);

/**
 * Busca un nodo con clave <cl> en el arbol y, si existe
 * modifica el puntero <nodo> para que lo apunte.
 * @param A Arbol binario en el que se busca el nodo.
 * @param cl Clave que se buscara.
 * @param nodo Puntero a un tipoelem.
 */
void buscar_nodo(abb A, tipoclave cl, tipoelem *nodo);

//FUNCIONES DE MODIFICACIÓN
/**
 * Inserta un nuevo nodo en el arbol para el elemento E
 * del que toma su clave. Esta clave no debe existir en
 * el arbol.
 * @param A Arbol binario
 * @param E Informacion del nuevo nodo.
 */
void insertar(abb *A, tipoelem E);

/**
 * Suprime el nodo del arbol <A>
 * @param A
 * @param cl
 */
void suprimir(abb *A, tipoelem E);

/**
 * Busca el nodo con clave la del nodo y lo modifica.
 * De esta forma nos aseguramos que no puede modificarse
 * la clave.
 * @param A
 * @param nodo
 */
void modificar(abb A, tipoelem nodo);

/**
 * 
 * Recorrido inorden del arbol indicado
 * @param A
 * */

void inorden(abb A);

/**
 * Imprimir Información de un elemento
 * @param E
 * */

void imprimir_elem(tipoelem E);

#endif