

#include "stack.h"

stack pLib;
stack pFd;

void crearStack(){
    crear_pila(&pLib);
    crear_pila(&pFd);
}

void nuevoElemStack(tipoelempila E){
    switch (E.tipo)
    {
    case TIPO_LIB:
        push(&pLib,E);
        break;
    case TIPO_FD:
        push(&pFd,E);
        break;
    default:
        printf("tipo no válido");
        break;
    }
}

void destruirStack(int tipo){
    switch (tipo)
    {
    case TIPO_LIB:
        destruir_pila(&pLib);
        break;
    case TIPO_FD:
        destruir_pila(&pFd);
        break;
    default:
        break;
    }
}

void eliminarElementoStack(int tipo){
    switch (tipo)
    {
    case TIPO_LIB:
        pop(&pLib);
        break;
    case TIPO_FD:
        pop(&pFd);
        break;
    default:
        break;
    }
}

unsigned stackVacio(int tipo){
    switch (tipo)
    {
    case TIPO_LIB:
        return es_vacia_pila(pLib);
        break;
    case TIPO_FD:
        return es_vacia_pila(pFd);
    default:
        return 1;
        break;
    }
}

tipoelempila topeStack(int tipo){
    tipoelempila E;
    switch (tipo)
    {
    case TIPO_LIB:
        return tope(pLib);
        break;
    case TIPO_FD:
        return tope(pFd);
        break;
    default:
        return E;
        break;
    }
}