#!/bin/bash
bison -d aSin.y
flex aLex.l
gcc main.c aSin.tab.c tablaSimbolos.c stack.c abb.c pila.c -lm -lfl -ldl -o exe