#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "tablaSimbolos.h"
#include <string.h>
#include <ctype.h>
#include "definiciones.h"
#include <math.h>
#include "aSin.tab.h"


funcion const funciones_reservadas[] = {
    {"sin", sin},
    {"cos", cos},
    {"tan",tan},
    {"exp",exp},
    {"log",log},
    {"sqrt",sqrt},
};

constante const constantes_reservadas[] = {
    {"e", M_E},
    {"pi",M_PI},
};

ts tablaSimbolos;

// Función que carga todas las palabras reservadas, calcula su vu valor (Componente Léxico), y las inserta en la tabla
void insertarPalabrasReservadas(){
    tipoelem E;
    for(int i = 0; i<sizeof(funciones_reservadas)/sizeof(funciones_reservadas[0]); i++){
        E.nombre = (char*)malloc(sizeof(char)*(strlen(funciones_reservadas[i].nombre)+1));
        strcpy(E.nombre,funciones_reservadas[i].nombre);
        E.tipo = TKN_FNC;
        E.valor.fnc = funciones_reservadas[i].accion;
        insertarSimbolo(E);
    }

    for(int i = 0; i<sizeof(constantes_reservadas)/sizeof(constantes_reservadas[1]); i++){
        E.nombre = (char*)malloc(sizeof(char)*(strlen(constantes_reservadas[i].nombre)+1));
        strcpy(E.nombre,constantes_reservadas[i].nombre);
        E.tipo = TKN_CTE;
        E.valor.val = constantes_reservadas[i].valor;
        insertarSimbolo(E);
    }
}

void insertarSimbolo(tipoelem  E){
    insertar(&tablaSimbolos,E);    
}

void crearTablaSimbolos(){
    crear(&tablaSimbolos);
    printf("A\n");
}

unsigned int existe(char * nombre){
    tipoelem E;
    E.nombre = nombre;
    return es_miembro(tablaSimbolos,E);
}



void imprimirTablaSimbolos(){
    inorden(tablaSimbolos);   
}


tipoelem getElem(char * nombre){
    tipoelem E;
    E.tipo = NO_TIPO;
    buscar_nodo(tablaSimbolos,nombre, &E);
    return E;
}

void suprimirElem(char * nombre){
    tipoelem E;
    strcpy(E.nombre,nombre);
    suprimir(&tablaSimbolos,E);
}
void imprimirInordenTipo(ts A, int tipo){
    tipoelem E;
    if(!es_vacio(A)){
        imprimirInordenTipo(izq(A),tipo);
        leer(A,&E);
        if(E.tipo == tipo){
            imprimir_elem(E);
        }
        imprimirInordenTipo(der(A),tipo);
    }
}

void imprimirTipoTablaSimbolos(int tipo){
    imprimirInordenTipo(tablaSimbolos,tipo);
}


void _resetTipoInorden(ts tablaSimbolos, int tipo){
    tipoelem E;
    if(!es_vacio(tablaSimbolos)){
        _resetTipoInorden(izq(tablaSimbolos),tipo);
        leer(tablaSimbolos,&E);
        if(E.tipo == tipo){
            suprimir(&tablaSimbolos,E);
        }
        _resetTipoInorden(tablaSimbolos,tipo);
    }
}

void resetVariables(){
    _resetTipoInorden(tablaSimbolos,TKN_VAR);
}

void resetConstantes(){
    _resetTipoInorden(tablaSimbolos,TKN_CTE);
}

void modificarElem(tipoelem E){
    modificar(tablaSimbolos, E);
}

void destruirTablaSimbolos(){
    destruir(&tablaSimbolos);
}