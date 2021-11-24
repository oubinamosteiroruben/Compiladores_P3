%{

    #include <stdio.h>
    #include <stdlib.h>


    #include "aSin.tab.h"
    #include "definiciones.h"
    #include "tablaSimbolos.h"
    #include <string.h>
    #include "stack.h"

    int nLines = 0;

%}


DIGITO [0-9]
FLOATNUM {POINTFLOAT}|{EXPONENTFLOAT}
POINTFLOAT  ({DIGITO})*{FRACTION}|({DIGITO})+[.]
EXPONENTFLOAT ({DIGITO}*|{POINTFLOAT}){EXPONENT}
FRACTION [.]({DIGITO})+
EXPONENT (e|E)[+|-]?({DIGITO})+

INTEGER [1-9]{DIGITO}*|"0"

NUMERO {INTEGER}|{FLOATNUM}

EXIT "exit"|"EXIT" 
ADD "add"|"ADD" 
HELP "help"|"HELP" 
IMPRIMIR "imprimir"|"IMPRIMIR" 
VARIABLES "variables"|"VARIABLES" 
RESET "reset"|"RESET" 
CONSTANTES "constantes"|"CONSTANTES"
LOAD "load"|"LOAD"

DEFINIR "define"|"DEFINE"

IDENTIFICADOR [a-zA-Z_][a-zA-Z0-9_]*

ARCHIVO {IDENTIFICADOR}[.]{IDENTIFICADOR}


%%

{NUMERO} { printf("Encontrado TKN_NUM: %f\n",atof(yytext));
                           yylval.TKN_NUM =atof(yytext); 
                           return(TKN_NUM);}
{LOAD} {printf("Encontrado TKN_LOAD: %s\n",yytext);
        return(TKN_LOAD);}
{ADD} {printf("Encontrado TKN_ADD: %s\n",yytext);
       return(TKN_ADD);}
{IMPRIMIR} {printf("Encontrado TKN_IMPRIMIR: %s\n",yytext);
            return (TKN_IMPRIMIR);}
{EXIT} {printf("Encontrado TKN_EXIT: %s\n",yytext);
            return (TKN_EXIT);}
{HELP} {printf("Encontrado TKN_HELP: %s\n",yytext);
            return (TKN_HELP);}
{VARIABLES} {printf("Encontrado TKN_GETVARS: %s\n",yytext);
            return (TKN_GETVARS);}
{RESET} {printf("Encontrado TKN_RESET: %s\n",yytext);
            return (TKN_RESET);}
{CONSTANTES} {printf("Encontrado TKN_GETCTES: %s\n",yytext);
            return(TKN_GETCTES);}
{ARCHIVO} {printf("Encontrado TKN_ARCHIVO: %s\n",yytext);
            yylval.TKN_ARCHIVO = yytext;
            return (TKN_ARCHIVO);}

{DEFINIR} {printf("Encontrado TKN_DEFINIR: %s\n",yytext);
                    return(TKN_DEFINIR);}
            
{IDENTIFICADOR} {printf("Encontrado identificador: %s\n",yytext);
                tipoelem E;
                if(existe(yytext)){
                    E = getElem(yytext);
                    switch(E.tipo){
                        case TKN_VAR:
                            yylval.TKN_VAR = E;
                            break;
                        case TKN_CTE:
                            yylval.TKN_CTE = E;
                            break;
                        case TKN_FNC:
                            yylval.TKN_FNC = E;
                            break;
                    }
                    return E.tipo;
                }else{
                    printf("No existe en la tabla de símbolos\n");
                    yylval.TKN_NOINI = strdup(yytext);
                    return TKN_NOINI; 
                }
}


"+" {printf("Encontrado TKN_MAS: %s\n",yytext);
     return(TKN_MAS);}

"-" {printf("Encontrado TKN_MENOS: %s\n",yytext);
    return(TKN_MENOS);}

"*" {printf("Encontrado TKN_MULT: %s\n",yytext);
    return(TKN_MULT);}

"/" {printf("Encontrado TKN_DIV: %s\n",yytext);
    return(TKN_DIV);}

"(" {printf("Encontrado TKN_PARIZQ: %s\n",yytext);
    return(TKN_PARIZQ);}

")" {printf("Encontrado TKN_PARDER: %s\n",yytext);
    return(TKN_PARDER);}

"^" {printf("Encontrado TKN_ELEV: %s\n",yytext);
    return(TKN_ELEV);}

";" {printf("Encontrado TKN_PTOCOMA: %s\n",yytext);
    return(TKN_PTOCOMA);}

"=" {printf("Encontrado TKN_IGUAL: %s\n",yytext);
    return(TKN_IGUAL);}
"\n" {nLines++;return(TKN_SALTO);}



<<EOF>>  {  
            eliminarElementoStack(TIPO_FD);
            if(stackVacio(TIPO_FD) == TRUE){
                yyin = stdin;
                yyrestart(yyin);
            }else{
                tipoelempila E = topeStack(TIPO_FD);
                printf("llego aqui\n");
                yyin = E.fd;
            }
        }
%%

