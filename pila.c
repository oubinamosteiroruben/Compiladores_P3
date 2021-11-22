#include <stdlib.h>
#include "pila.h"


//////////////////////////////// ESTRUCTURAS DE DATOS

struct celdapila {
	tipoelempila elemento;
	struct celdapila *sig;
};


/////////////////////////////// FUNCIONES

void crear_pila(pila * P) {
	*P = NULL;
}

void _destruir_elemPila(tipoelempila E){
	int tipo = E.tipo;
	printf("tipo: %d\n",tipo);
	switch(E.tipo){
		case TIPO_LIB:
			dlclose(E.lib);
		break;
		case TIPO_FD:
			fclose(E.fd);
		break;
	}
}



void destruir_pila(pila * P) {
	pila aux;
	aux = *P;
	while (aux != NULL) {
		_destruir_elemPila(tope(aux));
		aux = aux->sig;
		free(*P);
		*P = aux;
	}
}

unsigned es_vacia_pila(pila P) {
	return P == NULL;
}

tipoelempila tope(pila P) {
//	if (!es_vacia_pila(P)) {	/*si pila no vacía */
//		return P->elemento;
//	}
	return P->elemento;
}

void push(pila * P, tipoelempila E) {
	pila aux;
	aux = (pila) malloc(sizeof(struct celdapila));
	printf("ii\n");
	aux->elemento = E;
	printf("ii\n");
	aux->sig = *P;
	printf("ii\n");
	*P = aux;
}

void pop(pila * P) {
	pila aux;
	if (!es_vacia_pila(*P)) {	/*si pila no vacía */
		aux = *P;
		*P = (*P)->sig;
		_destruir_elemPila(tope(aux));
		free(aux);
	}
}

