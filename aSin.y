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

    void yyerror(char *s);
    void addFunciones(char * archivo);
    void addElem(char * nombre, double n, int tipo);
    void imprimirFuncionalidades();
    void imprimirVariables();
    void imprimirConstantes();
    void destruirLibrerias();
    void destruirFD();
    void loadArchivo(char * archivo);
    void reset();
    void salir();

    extern FILE * yyin;
    extern int yylex(void);
    extern int yylex_destroy(void);
    extern void yyrestart  (FILE * input_file );

%}

%define api.value.type union

%start Calculadora_i;

%token <double> TKN_NUM
%token <tipoelem> TKN_FNC
%token <tipoelem> TKN_VAR
%token <tipoelem> TKN_CTE
%token <char *> TKN_NOINI
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
%token TKN_DEFINIR

%token <char *> TKN_ARCHIVO

%type <double> Expresion
%type <double> Expr_Mult
%type <double> Expr_Elev
%type <double> Valor
%type <double> Igualacion

%%

Calculadora_i : Calculadora_i Calculadora;
                | Calculadora;

Calculadora:    TKN_SALTO
                |Expresion TKN_SALTO
                |Expresion TKN_PTOCOMA TKN_SALTO {printf("%lf\n",$1);}
                |Otro TKN_SALTO
                |Otro TKN_PTOCOMA TKN_SALTO  
                |Igualacion TKN_SALTO 
                |Igualacion TKN_PTOCOMA TKN_SALTO {printf("%lf\n",$1);} 
  
Igualacion: TKN_VAR TKN_IGUAL Expresion {$$ = $3; addElem($1.nombre,$3,TKN_VAR);}
            |TKN_NOINI TKN_IGUAL Expresion {$$ = $3; addElem($1,$3,TKN_VAR);}
            |TKN_CTE TKN_IGUAL Expresion {yyerror("constante usada\n"); return 0;};

Expresion:   Expresion TKN_MAS Expr_Mult {$$ = $1+$3;}
            |Expresion TKN_MENOS Expr_Mult {$$ = $1-$3;}
            |Expr_Mult {$$ = $1; }
;

Expr_Mult:   Expr_Mult TKN_MULT Expr_Elev {$$=$1*$3;}
            |Expr_Mult TKN_DIV Expr_Elev {if($3 > 0 || $3 < 0){ $$=$1/$3;}else{ yyerror("math error"); return 0;}}
            |Expr_Elev {$$ = $1;}
;

Expr_Elev:  Valor TKN_ELEV Expr_Elev {$$=pow($1,$3);} 
            |Valor {$$ = $1;};

Valor:  TKN_PARIZQ Expresion TKN_PARDER {$$=$2;}
        |TKN_NOINI {yyerror("variable no inicializada"); free($1); return 0;}
        |TKN_NUM {$$=$1;}
        |TKN_CTE {$$=$1.valor.val;}
        |TKN_VAR {$$=$1.valor.val;}
        |TKN_FNC TKN_PARIZQ Expresion TKN_PARDER {$$=$1.valor.fnc($3);}
        |TKN_MENOS Expresion {$$=-$2;}
;

Otro: TKN_ADD TKN_ARCHIVO {printf("archivo: %s\n",$2);  addFunciones($2);}
    | TKN_IMPRIMIR {printf("IMPRIMIR\n"); imprimirTablaSimbolos();}
    | TKN_GETVARS {printf("Variables\n"); imprimirVariables();}
    | TKN_GETCTES {printf("Constantes\n"); imprimirConstantes();}
    | TKN_HELP {printf("Help\n"); imprimirFuncionalidades();}
    | TKN_EXIT {printf("Exit\n"); salir();}
    | TKN_LOAD TKN_ARCHIVO {printf("Load archivo: %s\n",$2);  loadArchivo($2);}
    | TKN_DEFINIR TKN_NOINI Expresion {addElem($2,$3,TKN_CTE);}
    | TKN_RESET {reset();}
;
            

%%

void yyerror(char *s){
    printf("Error %s\n",s);
    yyrestart(yyin);
}

void addFunciones(char * archivo){
    printf("ARCHIVO: %s\n",archivo);
    char * aux = (char*)malloc(sizeof(char)*(strlen(archivo)+1));
    strcpy(aux,archivo);
    aux = strtok(aux,".");
    aux = realloc(aux,sizeof(char)*(strlen(aux)+strlen(".txt")+1));
    strcat(aux,".txt");
    char * path = (char*)calloc(sizeof(char),(strlen(archivo)+strlen("./")+1));
    strcpy(path,"./");
    strcat(path,archivo);
    printf("PATH: %s\n",path);
    /*char * archivoAux = (char*)malloc(sizeof(char)*MAX);
    strcpy(archivoAux,archivo);
    strcpy(archivoAux,strtok(archivoAux, "."));
    strcat(archivoAux,".txt");
    char * path = (char*)malloc(sizeof(char)*MAX);
    strcpy(path,"./");
    strcat(path,archivo);*/
    void *libhandle = dlopen(path,RTLD_LAZY);

    printf("PATH: %s\n",path);
    printf("ARCH AUX: %s\n",aux);
    if(!libhandle){
        yyerror("dlopen");
    }else{
        tipoelempila E;
        E.tipo = TIPO_LIB;
        E.lib = libhandle;
        nuevoElemStack(E);
        printf("Abrió bien");
        char nombre[MAX];
        FILE *fd;
        if(fd = fopen(aux,"r")){
            while(fscanf(fd,"%[^\n] ", nombre) != EOF){
                if(!existe(nombre)){
                    tipoelem E;
                    E.nombre = (char*)calloc(sizeof(char),(strlen("cuadrado")+1));
                    strcpy(E.nombre,nombre);
                    E.tipo = TKN_FNC;
                    E.valor.fnc = (accion_t) dlsym(libhandle,nombre);
                    insertarSimbolo(E);
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
    free(path);
    free(aux);
}

void imprimirVariables(){
    imprimirTipoTablaSimbolos(TKN_VAR);
}

void imprimirConstantes(){
    imprimirTipoTablaSimbolos(TKN_CTE);
}

void imprimirFuncionalidades(){
    printf("Comandos rapidos:\n");
    printf("help/HELP --> Muestra las funcionalidades de la aplicacion\n");
    printf("load/LOAD <archivo> --> Permite cargar operaciones de un archivo\n");
    printf("add/ADD <archivo> --> Permite cargar nuevas funciones apartir de un archivo\n");
    printf("variables/VARIABLES --> Muestra las variables almacenadas\n");
    printf("constantes/CONSTANTES --> Muestra las constantes almacenadas\n");
    printf("Funciones: \n");
    imprimirTipoTablaSimbolos(TKN_FNC);
    printf("exit/EXIT --> Salir\n");
}


void destruirLibrerias(){
    destruirStack(TIPO_LIB);
}

void destruirFD(){
    destruirStack(TIPO_FD);
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

void addElem(char * nombre, double n, int tipo){
    printf("NOMBRE VAR: %s\n",nombre);
    tipoelem E;
    E.nombre = nombre;
    E.tipo = tipo;
    E.valor.val = n;
    if(existe(nombre)){
        modificarElem(E);
    }else{
        insertarSimbolo(E);
    }
}


void reset(){
    resetVariables();
}

void salir(){
    yyin = stdin;
    yyrestart(yyin);
    destruirLibrerias(); 
    destruirFD(); 
    destruirTablaSimbolos(); 
    fclose(yyin);
    yylex_destroy();
    exit(0);
}