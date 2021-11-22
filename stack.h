#ifndef PILALIBFD_H
# define PILALIBFD_H

#include "pila.h"
#include <stdio.h>
#include <stdlib.h>


typedef pila stack;

/**
 * Fija a null el puntero
 */
void crearStack();

/**
 * Libera la memoria de cada celda de la pila
 * @param tipo
 */
void destruirStack(int tipo);

/**
 * Comprueba si la pila está vacía
 * @return 1 si la pila está vacía y 0 en otro caso
 */
unsigned stackVacio(int tipo);

/**
 * Devuelve el elemento tope de la pila. No comprueba 
 * si la pila está vacía, es posible que haya que llamar
 * a es_vacia_pila antes de llamar a estar función.
 * @param tipo
 * @return Tope de la pila
 */
tipoelempila topeStack(int tipo);

/**
 * Introduce un nuevo elemento en el tope de la pila.
 * Importante, al introducir el elemento cambia el puntero
 * de la pila.
 * @param E 
 */
void nuevoElemStack(tipoelempila E);

/**
 * Elimina de la pila el elemento tope.
 * Importante, al introducir el elemento cambia el puntero
 * de la pila.
 * @param tipo
 */
void eliminarElementoStack(int tipo);



#endif				/* __PILA_LIB */
