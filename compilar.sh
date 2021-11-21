#!/bin/bash
bison -d aSin.y
flex aLex.l
gcc main.c aSin.tab.c tablaSimbolos.c abb.c -lm -lfl -ldl -o exe