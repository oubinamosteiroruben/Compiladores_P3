%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include <unistd.h>

    #include "tablaSimbolos.h"
    #include "definiciones.h"
    
    #include <dlfcn.h>
    #include <string.h>

    #include "stack.h"

    #define MAX 30

    void yyerror(char *s);
    void addFunciones(char * archivo);
    void asignarVariable(char * nombre, double n);
    void imprimirFunciones();
    void imprimirVariables();
    void imprimirConstantes();
    void destruirLibrerias();

    void destruirLibrerias();
    void loadArchivo(char * archivo);

%}

%define api.value.type union

%start Calculadora_i;

%token <double> TKN_NUM
%token <tipoelem> TKN_FNC
%token <tipoelem> TKN_VAR
%token <tipoelem> TKN_CTE
%token <tipoelem> TKN_NOINI
%token TKN_MAS
%token TKN_MENOS

%token TKN_MULT
%token TKN_DIV

%token TKN_PTOCOMA
%token TKN_SALTO
%token TKN_ELEV
%token TKN_PARIZQ
%token TKN_PARDER
%token TKN_SIN
%token TKN_COS
%token TKN_IGUAL

%token TKN_EXIT
%token TKN_ADD
%token TKN_HELP
%token TKN_IMPRIMIR
%token TKN_GETVARS
%token TKN_GETCTES
%token TKN_RESET
%token TKN_LOAD

%token <tipoArchivo> TKN_ARCHIVO

%type <double> Expresion
%type <double> Expr_Mult
%type <double> Expr_Elev
%type <double> Valor
%type <double> Igualacion

%%

Calculadora_i : Calculadora_i Calculadora;
                | Calculadora;

Calculadora:    TKN_SALTO
                |Expresion TKN_SALTO {printf("RESULTADO FINAL\n");}
                |Expresion TKN_PTOCOMA TKN_SALTO {printf("RESULTADO FINAL: %5.2f\n",$1);}
                |Otro TKN_SALTO {printf("Otra cosa\n");}  
                |Igualacion TKN_SALTO {printf("Igualación\n");}
                |Igualacion TKN_PTOCOMA TKN_SALTO {printf("Igualación ptocoma\n");} 
  
Igualacion: TKN_VAR TKN_IGUAL Expresion {$$ = $3; asignarVariable($1.nombre,$3);}
            |TKN_NOINI TKN_IGUAL Expresion {$$ = $3; asignarVariable($1.nombre,$3);};

Expresion:   Expresion TKN_MAS Expr_Mult {$$ = $1+$3;}
            |Expresion TKN_MENOS Expr_Mult {$$ = $1-$3;}
            |Expr_Mult {$$ = $1; }
;

Expr_Mult:   Expr_Mult TKN_MULT Expr_Elev {$$=$1*$3;}
            |Expr_Mult TKN_DIV Expr_Elev {$$=$1/$3; }
            |Expr_Elev {$$ = $1;}
;

Expr_Elev:  Valor TKN_ELEV Expr_Elev {$$=pow($1,$3);} 
            |Valor {$$ = $1;};

Valor:  TKN_PARIZQ Expresion TKN_PARDER {$$=$2;}
        |TKN_NOINI {yyerror("variable no inicializada"); free($1.nombre); return 0;}
        |TKN_NUM {$$=$1;}
        |TKN_CTE {$$=$1.valor.val;}
        |TKN_VAR {$$=$1.valor.val;}
        |TKN_FNC TKN_PARIZQ Expresion TKN_PARDER {printf("NUM: %lf\n",$1.valor.fnc($3)); $$=$1.valor.fnc($3);}
;

Otro: TKN_ADD TKN_ARCHIVO {printf("archivo: %s\n",$2.valor.nombre);  addFunciones($2.valor.nombre);}
    | TKN_IMPRIMIR {printf("IMPRIMIR\n"); imprimirTablaSimbolos();}
    | TKN_GETVARS {printf("Variables\n"); imprimirVariables();}
    | TKN_GETCTES {printf("Constantes\n"); imprimirConstantes();}
    | TKN_HELP {printf("Help\n"); imprimirFunciones();}
    | TKN_EXIT {printf("Exit\n"); destruirLibrerias(); exit(0);}
    | TKN_LOAD TKN_ARCHIVO {printf("Load archivo: %s\n",$2.valor.nombre); loadArchivo($2.valor.nombre);}
;
            

%%

void yyerror(char *s){
    printf("Error %s\n",s);
}

void addFunciones(char * archivo){
    char * archivoAux = (char*)malloc(sizeof(char)*MAX);
    strcpy(archivoAux,archivo);
    strcpy(archivoAux,strtok(archivoAux, "."));
    strcat(archivoAux,".txt");
    char * path = (char*)malloc(sizeof(char)*MAX);
    strcpy(path,"./");
    strcat(path,archivo);
    void *libhandle = dlopen("./funciones.so",RTLD_LAZY);

    printf("PATH: %s\n",path);
    printf("ARCH AUX: %s\n",archivoAux);
    if(!libhandle){
        yyerror("dlopen");
    }else{
        tipoelempila E;
        printf("eo\n");
        E.tipo = TIPO_LIB;
        printf("aa\n");
        E.lib = libhandle;
        printf("bb\n");
        nuevoElemStack(E);
        printf("Abrió bien");
        char nombre[MAX];
        FILE *fd;
        if(fd = fopen(archivoAux,"r")){
            while(fscanf(fd,"%[^\n] ", nombre) != EOF){
                if(!existe(nombre)){
                    tipoelem * E = (tipoelem *)malloc(sizeof(tipoelem));
                    E->nombre = (char*)malloc(sizeof(char)*(strlen("cuadrado")+1));
                    strcpy(E->nombre,"cuadrado");
                    E->tipo = TKN_FNC;
                    E->valor.fnc = (accion_t) dlsym(libhandle,"cuadrado");
                    printf("PRUEBA CUADRADO: %lf\n",E->valor.fnc(2));
                    insertarSimbolo(*E);
                }else{
                    yyerror("funcion existente");
                }
            }
            fclose(fd);
        }else{
            yyerror("fopen");
        }
        //dlclose(libhandle);
    }
}

void asignarVariable(char * nombre, double n){
    tipoelem E;;
    E.nombre = (char*)malloc(sizeof(char)*(strlen(nombre)+1));
    strcpy(E.nombre,nombre);
    if(existe(nombre)){
        suprimirElem(nombre);
    }
    E.valor.val = n;
    E.tipo = TKN_VAR;
    insertarSimbolo(E);
}

void imprimirVariables(){
    imprimirTipoTablaSimbolos(TKN_VAR);
}

void imprimirConstantes(){
    imprimirTipoTablaSimbolos(TKN_CTE);
}

void imprimirFunciones(){
    imprimirTipoTablaSimbolos(TKN_FNC);
}


void destruirLibrerias(){
    destruirStack(TIPO_LIB);
}

void loadArchivo(char * archivo){
    FILE * fd;
    if(fd=fopen(archivo,"r")){
        tipoelempila E;
        E.tipo = TIPO_FD;
        E.fd = fd;
        nuevoElemStack(E);
        yyin = fd;
    }else{
        yyerror("fopen");
    }
}



