#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "tablaSimbolos.h"
#include "lex.yy.c"
#include "aSin.tab.h"

int main(){

    crearTablaSimbolos();

    insertarPalabrasReservadas();

    imprimirTablaSimbolos();
    yyin = stdin;
    while(1){
        yyparse();
    }

    return 0;
}