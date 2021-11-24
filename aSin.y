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

%token <double> TKN_NUM // Numero double
%token <tipoelem> TKN_FNC // Función
%token <tipoelem> TKN_VAR // Variable
%token <tipoelem> TKN_CTE // Constante
%token <char *> TKN_NOINI // No inicializado

%token TKN_MAS // Operando '+'
%token TKN_MENOS // Operando '-'

%token TKN_MULT // Operando '*'
%token TKN_DIV // Operando '/'

%token TKN_PTOCOMA // Delimitador ';'
%token TKN_SALTO // Salto de linea 
%token TKN_ELEV // Operando '^'
%token TKN_PARIZQ // Paréntesis izquierdo
%token TKN_PARDER // Paréntesis derecho
%token TKN_IGUAL // Operando '='

%token TKN_EXIT // Comando Exit
%token TKN_ADD // Comando Add
%token TKN_HELP // Comando Help
%token TKN_IMPRIMIR // Comando imprimir tabla de símbolos
%token TKN_GETVARS  // Comando para obtener las variables
%token TKN_GETCTES  // Comando para obtener las constantes
%token TKN_RESET // Comando para elminar las variables creadas
%token TKN_LOAD // Comando para cargar un archivo
%token TKN_DEFINIR // Comando para definir una constante

%token <char *> TKN_ARCHIVO // Nombre de un archivo

%type <double> Expresion
%type <double> Expr_Mult
%type <double> Expr_Elev
%type <double> Valor
%type <double> Igualacion

%%

Calculadora_i : Calculadora_i Calculadora {if(yyin == stdin) printf(">> ");};
                | Calculadora {if(yyin == stdin) printf(">> ");};

Calculadora:    TKN_SALTO
                |Expresion TKN_SALTO
                |Expresion TKN_PTOCOMA TKN_SALTO {printf("%lf\n",$1);}
                |Otro TKN_SALTO
                |Otro TKN_PTOCOMA TKN_SALTO  
                |Igualacion TKN_SALTO 
                |Igualacion TKN_PTOCOMA TKN_SALTO {printf("%lf\n",$1);} 
  
Igualacion:     TKN_VAR TKN_IGUAL Expresion {$$ = $3; addElem($1.nombre,$3,TKN_VAR);}
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

Otro: TKN_ADD TKN_ARCHIVO {addFunciones($2);}
    | TKN_IMPRIMIR {imprimirTablaSimbolos();}
    | TKN_GETVARS {imprimirVariables();}
    | TKN_GETCTES {imprimirConstantes();}
    | TKN_HELP {imprimirFuncionalidades();}
    | TKN_EXIT {salir();}
    | TKN_LOAD TKN_ARCHIVO {loadArchivo($2);}
    | TKN_DEFINIR TKN_NOINI Expresion {addElem($2,$3,TKN_CTE);}
    | TKN_RESET {reset();}
;
            

%%

void yyerror(char *s){
    printf("Error %s\n",s);
    yyrestart(yyin);
}

void addFunciones(char * archivo){
    char * aux = (char*)malloc(sizeof(char)*(strlen(archivo)+1));
    strcpy(aux,archivo);
    aux = strtok(aux,".");
    aux = realloc(aux,sizeof(char)*(strlen(aux)+strlen(".txt")+1));
    strcat(aux,".txt");
    char * path = (char*)calloc(sizeof(char),(strlen(archivo)+strlen("./")+1));
    strcpy(path,"./");
    strcat(path,archivo);
    void *libhandle = dlopen(path,RTLD_LAZY);
    if(!libhandle){
        yyerror("dlopen");
    }else{
        tipoelempila E;
        E.tipo = TIPO_LIB;
        E.lib = libhandle;
        nuevoElemStack(E);
        char nombre[MAX];
        FILE *fd;
        if((fd = fopen(aux,"r"))){
            while(fscanf(fd,"%[^\n] ", nombre) != EOF){
                if(!existe(nombre)){
                    tipoelem E;
                    E.nombre = (char*)calloc(sizeof(char),(strlen(nombre)+1));
                    strcpy(E.nombre,nombre);
                    E.tipo = TKN_FNC;
                    E.valor.fnc = (accion_t) dlsym(libhandle,nombre);
                    insertarSimbolo(E);
                }else{
                    yyerror("función ya declarada");
                }
            }
            fclose(fd);
        }else{
            yyerror("fopen");
        }
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
    printf("---------------------------------Comandos rapidos---------------------------------\n");
    printf("||\tHELP --> Muestra las funcionalidades de la aplicacion\t\t\t||\n");
    printf("||\tLOAD <archivo> --> Permite cargar operaciones de un archivo\t\t||\n");
    printf("||\tADD <archivo> --> Permite cargar nuevas funciones apartir de un archivo\t||\n");
    printf("||\tVARIABLES --> Muestra las variables almacenadas\t\t\t\t||\n");
    printf("||\tCONSTANTES --> Muestra las constantes almacenadas\t\t\t||\n");
    printf("||\tDEFINE <nombreConstante> <valorConstante> \t\t\t\t||\n");
    printf("||\tEXIT --> Salir\t\t\t\t\t\t\t\t||\n");
    imprimirTipoTablaSimbolos(TKN_FNC);
}


void destruirLibrerias(){
    destruirStack(TIPO_LIB);
}

void destruirFD(){
    destruirStack(TIPO_FD);
}

void loadArchivo(char * archivo){
    FILE * fd;
    if((fd=fopen(archivo,"r"))){
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
