#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "tablaSimbolos.h"
#include <string.h>
#include <ctype.h>
#include "definiciones.h"
#include <math.h>
#include "aSin.tab.h"

// Funciones iniciales

funcion const funciones_reservadas[] = {
    {"sin", sin},
    {"cos", cos},
    {"tan",tan},
    {"exp",exp},
    {"ln",log},
    {"log",log10},
    {"sqrt",sqrt},
};

// Constantes iniciales

constante const constantes_reservadas[] = {
    {"e", M_E},
    {"pi",M_PI},
};

// Tabla de símbolos
ts tablaSimbolos;

// Función que carga todas las palabras reservadas, calcula su vu valor (Componente Léxico), y las inserta en la tabla
void insertarPalabrasReservadas(){
    tipoelem E;
    // Se insertan las funciones
    for(int i = 0; i<sizeof(funciones_reservadas)/sizeof(funciones_reservadas[0]); i++){
        E.nombre = (char*)malloc(sizeof(char)*(strlen(funciones_reservadas[i].nombre)+1));
        strcpy(E.nombre,funciones_reservadas[i].nombre);
        E.tipo = TKN_FNC;
        E.valor.fnc = funciones_reservadas[i].accion;
        insertarSimbolo(E);
    }
    // Se insertan las constantes
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
}

unsigned int existe(char * nombre){
    return es_miembro(tablaSimbolos,nombre);
}


void imprimirTablaSimbolos(){
    printf("----------------------------------Tabla Simbolos----------------------------------\n");
    inorden(tablaSimbolos);   
    printf("----------------------------------------------------------------------------------\n");
}


tipoelem getElem(char * nombre){
    tipoelem E;
    buscar_nodo(tablaSimbolos,nombre, &E);
    return E;
}

void suprimirElem(char * nombre){
    tipoelem E;
    E.nombre = (char*)malloc(sizeof(char)*(strlen(nombre)+1));
    strcpy(E.nombre,nombre);
    suprimir(&tablaSimbolos,E);
    free(E.nombre);
}
void imprimirInordenTipo(ts A, int tipo){
    tipoelem E;
    if(!es_vacio(A)){
        if(!es_vacio(izq(A))){
            imprimirInordenTipo(izq(A),tipo);
        }
        leer(A,&E);
        if(E.tipo == tipo){
            imprimir_elem(E);
        }
        if(!es_vacio(der(A))){
            imprimirInordenTipo(der(A),tipo);
        }
    }
}

void imprimirTipoTablaSimbolos(int tipo){
    switch (tipo)
    {
    case TKN_VAR:
        printf("------------------------------------Variables-------------------------------------\n");
        break;
    case TKN_CTE:
        printf("------------------------------------Constantes------------------------------------\n");
        break;
    case TKN_FNC:
        printf("------------------------------------Funciones-------------------------------------\n");
        break;
    }
    imprimirInordenTipo(tablaSimbolos,tipo);
    printf("----------------------------------------------------------------------------------\n");
}


void _resetTipoInorden(ts t, int tipo){
    tipoelem E;
    if(!es_vacio(t)){
        if(!es_vacio(izq(t))){
            _resetTipoInorden(izq(t),tipo);
        }
        leer(t,&E);
        if(E.tipo == tipo){
            imprimir_elem(E);
            printf("Eliminar: %s\n",E.nombre);
            suprimir(&t,E);
            printf("fjlsjsl\n");
        }
        if(!es_vacio(der(t))){
             _resetTipoInorden(der(t),tipo);
        }
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