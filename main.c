#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "tablaSimbolos.h"
#include "lex.yy.c"
#include "aSin.tab.h"

int main(){

    crearTablaSimbolos();
    printf("HOLA\n");

    insertarPalabrasReservadas();

    imprimirTablaSimbolos();
    yyin = stdin;
    int flag;
    //do{
        while(1){
            yyparse();
        }
    //}while(flag == CONTINUA);

    return 0;
}