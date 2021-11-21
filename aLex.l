%{

    #include <stdio.h>
    #include <stdlib.h>


    #include "aSin.tab.h"
    #include "definiciones.h"
    #include "tablaSimbolos.h"
    #include <string.h>

    int nLines = 0;

    tipoArchivo A;
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
LOAD "load"|"LOAD" 
HELP "help"|"HELP" 
IMPRIMIR "imprimir"|"IMPRIMIR" 
VARIABLES "variables"|"VARIABLES" 
RESET "reset"|"RESET" 
CONSTANTES "constantes"|"CONSTANTES"

IDENTIFICADOR [a-zA-Z_][a-zA-Z0-9_]*

ARCHIVO {IDENTIFICADOR}[.]{IDENTIFICADOR}

%%

{NUMERO} { printf("Encontrado TKN_NUM: %f\n",atof(yytext));
                           yylval.TKN_NUM =atof(yytext); 
                           return(TKN_NUM);}

{LOAD} {printf("Encontrado TKN_LOAD: %s\n",yytext);
       return(TKN_LOAD);}
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
            A.valor.nombre = yytext;
            yylval.TKN_ARCHIVO = A;
            return (TKN_ARCHIVO);}
            
{IDENTIFICADOR} {printf("Encontrado identificador: %s\n",yytext);
                tipoelem E;
                E = getElem(yytext);
                if(E.tipo == NO_TIPO){
                    printf("\nNO EXISTE EN LA TS\n");
                    E.tipo = TKN_NOINI;
                    E.nombre = (char*)malloc(sizeof(char)*(strlen(yytext)+1));
                    strcpy(E.nombre,yytext);
                    yylval.TKN_NOINI = E;
                }else if(E.tipo == TKN_VAR){
                    yylval.TKN_VAR = E;
                    printf("NOMBRE E: %s\n",E.nombre);
                    printf("VAR\n");
                }else if(E.tipo == TKN_FNC){
                    yylval.TKN_FNC = E;
                    printf("FNC\n");
                }else if(E.tipo == TKN_CTE){
                    yylval.TKN_CTE = E;
                    printf("CTE\n");
                }else{
                    // Error
                }
                return E.tipo;
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
.

%%
