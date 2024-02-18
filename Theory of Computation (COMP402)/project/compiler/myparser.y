%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "helperFiles/cgen.h"
  extern int yylex(void);
  extern int line_num;
%}
%define parse.error verbose
%union{
    char* str;
}

/* Terminal */
%token KEYWORD_INT   
%token KEYWORD_FOR   
%token KEYWORD_NIL  
%token KEYWORD_BEGIN   
%token KEYWORD_BREAK
%token KEYWORD_REAL   
%token KEYWORD_VAR  
%token KEYWORD_WHILE   
%token KEYWORD_STRING  
%token KEYWORD_CONST   
%token KEYWORD_BOOL
%token KEYWORD_IF   
%token KEYWORD_CONTINUE  
%token KEYWORD_ELSE  
%token KEYWORD_FUNC
%token KEYWORD_RETURN  

%token ASSIGN_OP
%token KEYWORD_BOOL_TRUE   
%token KEYWORD_BOOL_FALSE  

%token SEMICOLON   /*Delimeters*/     
%token L_BRACKET   
%token R_BRACKET
%token L_CURLY_BRACKET
%token R_CURLY_BRACKET
%left COMMA

%token F_READSRING  /* Pi functions */
%token F_READINT
%token F_READREAL
%token F_WRITESTRING
%token F_WRITEINT
%token F_WRITEREAL

%token <str> INTEGER
%token <str> REAL  
%token <str> CONST_STRING             
%token <str> IDENTIFIER 

%left KEYWORD_LOGIC_OR 
%left KEYWORD_LOGIC_AND 

%left EQUAL_OP NEQ_OP LESS_OP LEQ_OP GREATER_OP GEQ_OP 

%left PLUS_OP MINUS_OP

%left MULT_OP MOD_OP DIV_OP 


%left POWER_OP

%left KEYWORD_LOGIC_NOT

%left L_PAREN
  
%right R_PAREN


%type <str> expression
%type <str> invoked_function
%type <str> func_arguments

%type <str> data_type
%type <str> array_struc

%type <str> var_or_const

%type <str> variable_declaration
%type <str> variables
%type <str> variable_args
%type <str> exp_or_str

%type <str> constant_value_declaration
%type <str> constant_value
%type <str> constant_args

%type <str> complex_statements
%type <str> simple_statements
%type <str> simple_statements_begin
%type <str> statements_begin

%type <str> statements
%type <str> assign_state
%type <str> if_state
%type <str> for_state
%type <str> while_state
%type <str> break_state
%type <str> continue_state
%type <str> return_state

%type <str> func_readString
%type <str> func_readInt
%type <str> func_readReal
%type <str> func_writeString
%type <str> func_writeInt
%type <str> func_writeReal

%type <str> write_functions
%type <str> read_functions
%type <str> writeReal_args
%type <str> writeString_args
%type <str> writeInt_args


%type <str> begin_function
%type <str> function_begin_body
%type <str> function_arg
%type <str> function_decl
%type <str> function_definition
%type <str> function_body
%type <str> line
%type <str> prog_components
/*set cases*/
%type <str> varBegin funcBegin varFuncBegin constBegin constFuncBegin constVarBegin beginf constVarFuncBegin

%left BEGINF
%left VAR_BEGIN 
%left FUNC_BEGIN  
%left VAR_FUNC_BEGIN
%left CONST_BEGIN
%left CONST_FUNC_BEGIN
%left CONST_VAR_BEGIN
%left CONST_VAR_FUNC_BEGIN

%start init

%%
init: line { 
//    printf("/* Program in c*/ \n\n");
//    puts("#include <pilib.h>");
//    puts("#include <math.h>");
  if (yyerror_count == 0) {
FILE *fp;
    fp = fopen("mytest.c", "w+");
    fputs("#include <math.h>\n", fp);
    fputs("#include <stdio.h>\n", fp);
    fputs(c_prologue, fp);
    fputs($1, fp);
    fputs("\n\n", fp);
    fclose(fp);
    // include the pilib.h file
  }
}
;

line: line prog_components { $$ = template("%s\n%s", $1, $2); }
    | prog_components
; 

prog_components: constVarFuncBegin %prec CONST_VAR_FUNC_BEGIN
               | constVarBegin %prec CONST_VAR_BEGIN 
               | constFuncBegin %prec CONST_FUNC_BEGIN
               | constBegin %prec CONST_BEGIN
               | varFuncBegin %prec VAR_FUNC_BEGIN
               | funcBegin %prec FUNC_BEGIN
               | varBegin %prec VAR_BEGIN
               | beginf %prec BEGINF 
;
/* Cases */
constVarFuncBegin: constant_value_declaration variable_declaration function_decl begin_function { $$ = template("%s\n%s\n%s\n %s",$1, $2, $3,$4); };
constVarBegin: constant_value_declaration variable_declaration begin_function { $$ = template("%s\n%s\n%s",$1,$2,$3); };
constFuncBegin: constant_value_declaration function_decl begin_function { $$ = template("%s\n%s\n%s",$1,$2,$3); };
constBegin: constant_value_declaration begin_function { $$ = template("%s\n%s",$1,$2); };
varFuncBegin: variable_declaration function_decl begin_function { $$ = template("%s\n%s\n%s",$1,$2,$3); };
funcBegin: function_decl begin_function { $$ = template("%s\n%s",$1,$2); };
varBegin: variable_declaration begin_function { $$ = template("%s\n%s",$1,$2); };
beginf: begin_function { $$ = template("%s",$1); };

expression:   INTEGER     { $$ = template($1);}
          |   REAL        { $$ = template($1);}
          |   IDENTIFIER  { $$ = template($1);}
          |   expression POWER_OP expression {$$ = template("pow(%s,%s)", $1, $3);}
          |   expression MULT_OP expression  {$$ = template("%s * %s", $1, $3);}   
          |   expression DIV_OP expression   {$$ = template("%s / %s", $1, $3);}
          |   expression MOD_OP expression   {$$ = template("%s %s %s", $1,"%", $3);}
          |   expression PLUS_OP expression   {$$ = template("%s + %s", $1, $3);}
          |   expression MINUS_OP expression   {$$ = template("%s - %s", $1, $3);}
          |   expression EQUAL_OP expression   {$$ = template("%s == %s", $1, $3);}
          |   expression NEQ_OP expression   {$$ = template("%s != %s", $1, $3);}
          |   expression LESS_OP expression   {$$ = template("%s < %s", $1, $3);}
          |   expression GREATER_OP expression   {$$ = template("%s > %s", $1, $3);}
          |   expression LEQ_OP expression   {$$ = template("%s <= %s", $1, $3);}
          |   expression GEQ_OP expression   {$$ = template("%s >= %s", $1, $3);}
          |   KEYWORD_LOGIC_NOT expression { $$ = template("!%s", $2);}
          |   expression KEYWORD_LOGIC_AND expression   {$$ = template("%s && %s", $1, $3);}
          |   expression KEYWORD_LOGIC_OR expression   {$$ = template("%s || %s", $1, $3);} 
          |   L_PAREN expression R_PAREN   {$$ = template("( %s )", $2);}
          |   IDENTIFIER L_BRACKET expression R_BRACKET   {$$ = template("%s[%s]", $1, $3);} 
          |   MINUS_OP expression {$$ = template("-%s", $2);}
          |   PLUS_OP expression {$$ = template("%s", $2);}
          |   KEYWORD_BOOL_TRUE  {$$ = template("1");}
          |   KEYWORD_BOOL_FALSE  {$$ = template("0");}
          |   invoked_function  
          |   read_functions 
          |   write_functions 
;


/* variables - constant Declaration*/

var_or_const: constant_value_declaration variable_declaration {$$ = template("%s \n%s", $1,$2);}
            | variable_declaration
;

/* variables */
variable_declaration: variables variable_declaration {$$ = template("%s \n%s", $1,$2);}
                    | variables { $$ = $1;}
;

variables: KEYWORD_VAR variable_args data_type SEMICOLON { $$ = template("%s %s;",$3,$2);} /* var data type */
;

variable_args: IDENTIFIER    { $$ = template("%s",$1);} /* x */
             | IDENTIFIER ASSIGN_OP exp_or_str { $$ = template("%s = %s",$1, $3);} /* x = data */
             | variable_args COMMA variable_args   { $$ = template("%s, %s",$1,$3);} /* data1, data2 */
             | array_struc    { $$ = $1; }
;

data_type:  KEYWORD_INT     { $$ = template("int"); }
         |  KEYWORD_REAL    { $$ = template("double"); }
         |  KEYWORD_STRING  { $$ = template("char*"); }
         |  KEYWORD_BOOL    { $$ = template("int"); }
;

array_struc: IDENTIFIER L_BRACKET expression R_BRACKET  { $$ = template("%s[%s]",$1,$3); }  /* ID[length] -> id[length] */
           | IDENTIFIER L_BRACKET R_BRACKET     { $$ = template("%s*",$1); }  /* X[] -> X* */
;


/* Constant */
constant_value_declaration: constant_value constant_value_declaration {$$ = template("%s \n%s", $1,$2);}
                          | constant_value { $$ = $1;}
;

constant_value: KEYWORD_CONST constant_args data_type SEMICOLON{ $$ = template("const %s %s;",$3,$2);} /* const data type */
;

constant_args: IDENTIFIER ASSIGN_OP exp_or_str { $$ = template("%s = %s",$1, $3);} /* x = data */
             | constant_args COMMA constant_args   { $$ = template("%s, %s",$1,$3);} /* data1, data2 */
;

/* Statements */

complex_statements: L_CURLY_BRACKET simple_statements R_CURLY_BRACKET {$$ = template("{\n%s\n}", $2);}
                  | statements
;

simple_statements: simple_statements statements {$$ = template("%s \n%s", $1,$2);}
                 | statements
;

simple_statements_begin: statements_begin simple_statements_begin {$$ = template("%s \n%s", $1,$2);}
                       | statements_begin
;

statements_begin: assign_state SEMICOLON { $$ = template("%s;", $1); }
          | if_state
          | for_state
          | while_state
          | break_state
          | continue_state
          | read_functions SEMICOLON { $$ = template("%s;", $1);}
          | write_functions
          | invoked_function SEMICOLON { $$ = template("%s;", $1);}
;

statements: assign_state SEMICOLON { $$ = template("%s;", $1); }
          | if_state
          | for_state
          | while_state
          | break_state
          | continue_state
          | return_state
          | read_functions SEMICOLON { $$ = template("%s;", $1);}
          | write_functions
          | invoked_function SEMICOLON { $$ = template("%s;", $1);}
;
assign_state: IDENTIFIER ASSIGN_OP exp_or_str { $$ = template("%s = %s",$1,$3); } // a = num/string;
            | array_struc ASSIGN_OP exp_or_str { $$ = template("%s = %s",$1,$3); } // a = num/string;
;
if_state: KEYWORD_IF L_PAREN expression R_PAREN complex_statements { $$ = template("if (%s) \n\t%s",$3,$5); } // if (expr) \n\tstm
        | KEYWORD_ELSE complex_statements  { $$ = template("else \n\t%s",$2); } // else \n\t stm
;
for_state: KEYWORD_FOR L_PAREN assign_state SEMICOLON expression SEMICOLON assign_state R_PAREN complex_statements 
            { $$ = template("for (%s; %s; %s) \t%s",$3,$5,$7,$9); }
;
while_state: KEYWORD_WHILE L_PAREN expression R_PAREN complex_statements { $$ = template("while (%s) \n%s",$3,$5); }
;
break_state: KEYWORD_BREAK SEMICOLON { $$ = template("break;"); }
;
continue_state: KEYWORD_CONTINUE SEMICOLON { $$ = template("continue;"); }
;
return_state: KEYWORD_RETURN SEMICOLON { $$ = template("return;"); }
            | KEYWORD_RETURN exp_or_str SEMICOLON { $$ = template("return %s;",$2); }
;

invoked_function: IDENTIFIER L_PAREN func_arguments R_PAREN {$$ = template("%s(%s)", $1, $3);} // in expression and statements
;
func_arguments: exp_or_str   { $$ = template("%s",$1);}
              | func_arguments COMMA exp_or_str { $$ = template("%s,%s",$1,$3);}
              | %empty  { $$ = template("");}
;

/* Predefined functions */

/* Read Functons */

read_functions: func_readInt 
              | func_readReal
              | func_readString
;
func_readInt: F_READINT L_PAREN R_PAREN { $$ = template("readInt()"); } 
;
func_readReal: F_READREAL L_PAREN R_PAREN { $$ = template("readReal()"); }
;
func_readString: F_READSRING L_PAREN R_PAREN { $$ = template("readString()"); } 
/* Write Functons */

write_functions: func_writeString SEMICOLON { $$ = template("%s;",$1); }
               | func_writeInt SEMICOLON { $$ = template("%s;",$1); }
               | func_writeReal SEMICOLON {$$ = template("%s;",$1); }
;
func_writeString: F_WRITESTRING L_PAREN writeString_args R_PAREN { $$ = template("writeString(%s)",$3 ); } 
;
func_writeInt: F_WRITEINT L_PAREN writeInt_args R_PAREN { $$ = template("writeInt(%s)",$3 ); } 
;
func_writeReal: F_WRITEREAL L_PAREN writeReal_args R_PAREN { $$ = template("writeReal(%s)",$3 ); }
;

/* Predefined function arguments */

writeReal_args: IDENTIFIER
             | MINUS_OP REAL { $$ = template("-%s",$2 ); }
             | REAL
             | IDENTIFIER L_BRACKET expression R_BRACKET { $$ = template("%s[%s]",$1,$3 ); }
;
writeInt_args: IDENTIFIER
             | MINUS_OP INTEGER { $$ = template("-%s",$2 ); }
             | INTEGER
             | IDENTIFIER L_BRACKET expression R_BRACKET { $$ = template("%s[%s]",$1,$3 ); }
;
writeString_args: IDENTIFIER
                | CONST_STRING
                | IDENTIFIER L_BRACKET expression R_BRACKET { $$ = template("%s[%s]",$1,$3 ); }
;


// /* Functions Prototype*/

// function_prototype: KEYWORD_FUNC IDENTIFIER L_PAREN function_arg R_PAREN data_type SEMICOLON { $$ = template("%s %s(%s);",$6,$2,$4); }
// ;

function_arg: IDENTIFIER data_type { $$ = template("%s %s",$2, $1); } /* b int -> int b */
            | array_struc data_type  { $$ = template("%s %s",$2, $1); } /*x []int -> int b*/
            | function_arg COMMA function_arg { $$ = template("%s, %s",$1, $3); } /*x []int -> int b*/
            | %empty  { $$ = template("");}
;

/* Function definition */
begin_function: KEYWORD_FUNC KEYWORD_BEGIN L_PAREN R_PAREN L_CURLY_BRACKET function_begin_body R_CURLY_BRACKET
                { $$ = template("int main()\t{\n%s\n}",$6); }
;

function_decl: function_decl function_definition  { $$ = template("%s\n%s",$1, $2); }
             | function_definition
;
function_definition: KEYWORD_FUNC IDENTIFIER L_PAREN function_arg R_PAREN data_type L_CURLY_BRACKET function_body R_CURLY_BRACKET
                     { $$ = template("\n%s %s(%s)\t{\n%s\n}",$6,$2,$4,$8); }
                   | KEYWORD_FUNC IDENTIFIER L_PAREN function_arg R_PAREN L_CURLY_BRACKET function_body R_CURLY_BRACKET
                     { $$ = template("\n%void %s(%s)\t{\n%s\n}",$2,$4,$7); }
;

function_body: var_or_const simple_statements { $$ = template("%s\n%s",$1,$2); } 
             | simple_statements { $$ = template("%s",$1); }
;

function_begin_body: var_or_const simple_statements_begin { $$ = template("%s\n%s",$1,$2); } 
             | simple_statements_begin { $$ = template("%s",$1); }
;

exp_or_str: expression  /* (...=) expr */
          | CONST_STRING  /* (...=) str */
;
%%
int main() {
    if (yyparse() != 0)
        printf("Rejected!\n");
}