%{
#include <stdio.h>    
#include <string.h>
#include "myparser.tab.h"
#include "helperFiles/cgen.h"
int line_num = 1;
%}

ID      [a-zA-Z_][0-9a-zA-Z_]*

NUM     [0-9]
NUM_0   [1-9]
NUMBER  {NUM}{NUM}*
INTEGER ({NUM}|({NUM_0}{NUM}+))

REAL   {INTEGER}"."({NUM}|({NUM}*{NUM_0})+)(([eE][+-]?{NUM_0}+)?)

STRING  \"[^\n]*\"(\n?)


%x      ML_Comment

/* Rules */
%%
"int"       { printf("token KEYWORD_INT: %s\n", yytext); return KEYWORD_INT; }  
"for"       { printf("token KEYWORD_FOR: %s\n", yytext); return KEYWORD_FOR; }
"nil"       { printf("token KEYWORD_NIL: %s\n", yytext); return KEYWORD_NIL; }   
"begin"     { printf("token KEYWORD_BEGIN: %s\n", yytext); return KEYWORD_BEGIN; }
"real"      { printf("token KEYWORD_REAL: %s\n", yytext); return KEYWORD_REAL; }
"var"       { printf("token KEYWORD_VAR: %s\n", yytext); return KEYWORD_VAR; }
"while"     { printf("token KEYWORD_WHILE: %s\n", yytext); return KEYWORD_WHILE; }
"string"    { printf("token KEYWORD_STRING: %s\n", yytext); return KEYWORD_STRING; }
"const"     { printf("token KEYWORD_CONST: %s\n", yytext); return KEYWORD_CONST; }
"break"     { printf("token KEYWORD_BREAK: %s\n", yytext); return KEYWORD_BREAK; }
"bool"      { printf("token KEYWORD_BOOL: %s\n", yytext); return KEYWORD_BOOL; }
"if"        { printf("token KEYWORD_IF: %s\n", yytext); return KEYWORD_IF; }
"continue"  { printf("token KEYWORD_CONTINUE: %s\n", yytext); return KEYWORD_CONTINUE; }
"else"      { printf("token KEYWORD_ELSE: %s\n", yytext); return KEYWORD_ELSE; }
"func"      { printf("token KEYWORD_FUNC: %s\n", yytext); return KEYWORD_FUNC; }
"return"    { printf("token KEYWORD_RETURN: %s\n", yytext); return KEYWORD_RETURN; }

"and"       { printf("token KEYWORD_AND: %s\n", yytext); return KEYWORD_LOGIC_AND; }
"or"        { printf("token KEYWORD_OR: %s\n", yytext); return KEYWORD_LOGIC_OR; }
"not"       { printf("token KEYWORD_NOT: %s\n", yytext); return KEYWORD_LOGIC_NOT; }

"true"      { printf("token KEYWORD_BOOL_TRUE: %s\n", yytext); return KEYWORD_BOOL_TRUE; }
"false"     { printf("token KEYWORD_FALSE: %s\n", yytext); return KEYWORD_BOOL_FALSE; }

"+"         { printf("token PLUS_OP: %s\n", yytext); return PLUS_OP; }
"-"         { printf("token MINUS_OP: %s\n", yytext); return MINUS_OP; }
"*"         { printf("token MULT_OP: %s\n", yytext); return MULT_OP; }
"/"         { printf("token DIV_OP: %s\n", yytext); return DIV_OP; }
"%"         { printf("token MOD_OP: %s\n", yytext); return MOD_OP; }
"**"        { printf("token POWER_OP: %s\n", yytext); return POWER_OP; }
"=="        { printf("token EQUAL_OP: %s\n", yytext); return EQUAL_OP; }
"<"         { printf("token LESS_OP: %s\n", yytext); return LESS_OP; }
">"         { printf("token GREATER_OP: %s\n", yytext); return GREATER_OP; }
"<="        { printf("token LESS_EQ_OP: %s\n", yytext); return LEQ_OP; }
">="        { printf("token GREATER_EQ_OP: %s\n", yytext); return GEQ_OP; }
"!="        { printf("token NOT_EQUALS_OP: %s\n", yytext); return NEQ_OP; }
"="         { printf("token ASSIGN_OP: %s\n", yytext); return ASSIGN_OP; }

";"         { printf("token SEMICOLON: %s\n", yytext); return SEMICOLON; } 
"("         { printf("token L_PARENTHESIS: %s\n", yytext); return L_PAREN; }
")"         { printf("token R_PARENTHESIS: %s\n", yytext); return R_PAREN; }
","         { printf("token COMMA: %s\n", yytext); return COMMA; }
"["         { printf("token L_BRACKET: %s\n", yytext); return L_BRACKET; }
"]"         { printf("token R_BRACKET: %s\n", yytext); return R_BRACKET; }
"{"         { printf("token L_CURLY_BRACKET: %s\n", yytext); return L_CURLY_BRACKET; }
"}"         { printf("token R_CURLY_BRACKET: %s\n", yytext); return R_CURLY_BRACKET; }

"readString"    { printf("token F_READSRING: %s\n", yytext); return F_READSRING; }
"readInt"       { printf("token F_READINT: %s\n", yytext); return F_READINT; }
"readReal"      { printf("token F_READREAL: %s\n", yytext); return F_READREAL; }
"writeString"   { printf("token F_WRITESTRING: %s\n", yytext); return F_WRITESTRING; }
"writeInt"      { printf("token F_WRITEINT: %s\n", yytext); return F_WRITEINT; }
"writeReal"     { printf("token F_WRITEREAL: %s\n", yytext); return F_WRITEREAL; }

{ID}        { printf("token IDENTIFIER: %s\n", yytext); yylval.str = strdup(yytext); return IDENTIFIER; }

{STRING}    { printf("token CONST_STRING: %s\n", yytext); yylval.str = strdup(yytext); return CONST_STRING; }

{INTEGER}   { printf("token INTEGER: %s\n", yytext); yylval.str = strdup(yytext); return INTEGER; }

{REAL}      { printf("token REAL: %s\n", yytext); yylval.str = strdup(yytext); return REAL; }


[ \t\r]+                /* White Space */

"//"[^\n]*  		    /* Line Comments TODO: possible \/\/[^\n]* */ 

"/*"                    { BEGIN(ML_Comment); }
<ML_Comment>([^*\n]*)|("*"+[^*/\n]*)   /* Ignore comments */ 
<ML_Comment>\n             ++line_num; 
<ML_Comment>"*"+"/"        { BEGIN(INITIAL); }

\n                      { ++line_num; }

.                       { printf("Unrecognized token %s in line %d\n", yytext, line_num); exit(1); }



<<EOF>>                 { return EOF; }
%%