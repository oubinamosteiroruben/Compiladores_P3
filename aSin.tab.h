/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_ASIN_TAB_H_INCLUDED
# define YY_YY_ASIN_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TKN_NUM = 258,
    TKN_FNC = 259,
    TKN_VAR = 260,
    TKN_CTE = 261,
    TKN_NOINI = 262,
    TKN_MAS = 263,
    TKN_MENOS = 264,
    TKN_MULT = 265,
    TKN_DIV = 266,
    TKN_PTOCOMA = 267,
    TKN_SALTO = 268,
    TKN_ELEV = 269,
    TKN_PARIZQ = 270,
    TKN_PARDER = 271,
    TKN_SIN = 272,
    TKN_COS = 273,
    TKN_IGUAL = 274,
    TKN_EXIT = 275,
    TKN_ADD = 276,
    TKN_HELP = 277,
    TKN_IMPRIMIR = 278,
    TKN_GETVARS = 279,
    TKN_GETCTES = 280,
    TKN_RESET = 281,
    TKN_LOAD = 282,
    TKN_DEFINIR = 283,
    TKN_ARCHIVO = 284
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{

  /* TKN_NUM  */
  double TKN_NUM;
  /* Igualacion  */
  double Igualacion;
  /* Expresion  */
  double Expresion;
  /* Expr_Mult  */
  double Expr_Mult;
  /* Expr_Elev  */
  double Expr_Elev;
  /* Valor  */
  double Valor;
  /* TKN_ARCHIVO  */
  tipoArchivo TKN_ARCHIVO;
  /* TKN_FNC  */
  tipoelem TKN_FNC;
  /* TKN_VAR  */
  tipoelem TKN_VAR;
  /* TKN_CTE  */
  tipoelem TKN_CTE;
  /* TKN_NOINI  */
  tipoelem TKN_NOINI;
#line 107 "aSin.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_ASIN_TAB_H_INCLUDED  */
