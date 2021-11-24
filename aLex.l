%{

    #include <stdio.h>
    #include <stdlib.h>


    #include "aSin.tab.h"
    #include "definiciones.h"
    #include "tablaSimbolos.h"
    #include <string.h>
    #include "stack.h"

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

{NUMERO} { yylval.TKN_NUM =atof(yytext); return(TKN_NUM);}
{LOAD} {return(TKN_LOAD);}
{ADD} {return(TKN_ADD);}
{IMPRIMIR} {return (TKN_IMPRIMIR);}
{EXIT} {return (TKN_EXIT);}
{HELP} {return (TKN_HELP);}
{VARIABLES} {return (TKN_GETVARS);}
{RESET} {return (TKN_RESET);}
{CONSTANTES} {return(TKN_GETCTES);}
{ARCHIVO} {yylval.TKN_ARCHIVO = yytext;return (TKN_ARCHIVO);}

{DEFINIR} {return(TKN_DEFINIR);}
            
{IDENTIFICADOR} {
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
                    yylval.TKN_NOINI = strdup(yytext);
                    return TKN_NOINI; 
                }
}


"+" {return(TKN_MAS);}

"-" {return(TKN_MENOS);}

"*" {return(TKN_MULT);}

"/" {return(TKN_DIV);}

"(" {return(TKN_PARIZQ);}

")" {return(TKN_PARDER);}

"^" {return(TKN_ELEV);}

";" {return(TKN_PTOCOMA);}

"=" {return(TKN_IGUAL);}
"\n" {return(TKN_SALTO);}



<<EOF>>  {  
            eliminarElementoStack(TIPO_FD);
            if(stackVacio(TIPO_FD) == TRUE){
                yyin = stdin;
                yyrestart(yyin);
                
            }else{
                tipoelempila E = topeStack(TIPO_FD);
                yyin = E.fd;
            }

            return TKN_SALTO;
        }
%%

