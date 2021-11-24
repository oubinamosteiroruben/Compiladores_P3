#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "tablaSimbolos.h"
#include "lex.yy.c"
#include "aSin.tab.h"

extern void imprimirFuncionalidades();

int main(){

    crearTablaSimbolos();

    insertarPalabrasReservadas();

    //imprimirTablaSimbolos();
    imprimirFuncionalidades();
    printf("\n\n");
    yyin = stdin;
    while(1){
        printf(">> ");
        yyparse();
    }

    return 0;
}