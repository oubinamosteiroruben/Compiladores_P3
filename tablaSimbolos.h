#ifndef TABLASIMBOLOS_H
# define TABLASIMBOLOS_H

#include "abb.h"

typedef abb ts;
/**
 * Función que insertará las palabras reservadas en la tabla de símbolos
 */
void insertarPalabrasReservadas();

/**
 *
 * @param E : elemento que se va a insertar en la tabla
 */
void insertarSimbolo(tipoelem E);

/**
 * Se inicializa una tabla de símbolos
 * */

void crearTablaSimbolos();


/**
 * @param nombre: elemento que se va a buscar
 * @return devuelve si es true (1) o false (0)
 * */
unsigned int existe(char * nombre);


/**
 * 
 * Imprime los valores de la tabla de símbolos
 * */
void imprimirTablaSimbolos();


/**
 * 
 * Recupera un elemento de la tabla de símbolos apartir de su nombre
 * @param nombre: nombre del elemento solicitado
 * */
tipoelem getElem(char * nombre);


/**
 * 
 * @param E: Elemento que se va a suprimir
 * */
void suprimirElem(char * nombre);

void imprimirTipoTablaSimbolos(int tipo);

#endif