#ifndef DEFINICIONES_H
# define DEFINICIONES_H

#include <stdio.h>

#include <math.h>

#define NO_TIPO 99
#define FALSE 0
#define TRUE 1
#define CONTINUA 2
#define FIN 3

typedef struct {
    char const * nombre;
    double (*accion) (double);
} funcion;

typedef struct{
    char const * nombre;
    double valor;
} constante;

typedef struct{
    union{
        char * nombre;
    }valor;
} archivo;

#endif