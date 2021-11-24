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

/**
 * 
 * Imprime todos los simbolos almacenados de un tipo determinado
 * @param tipo
 * */
void imprimirTipoTablaSimbolos(int tipo);

/**
 * 
 * Resetea todas las variables almacenadas en la tabla de símbolos
 * */
void resetVariables();

/**
 * 
 * Resetea todas las constantes declaradas en la tabla de símbolos
 * */

void resetConstantes();

/**
 * 
 * Modificar Elem en la tabla de símbolos
 * @param E
 * 
 * */
void modificarElem(tipoelem E);

/**
 * 
 * Destruir tabla de símbolos
 * */
void destruirTablaSimbolos(); 

#endif