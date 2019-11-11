%{
// $Id: parser.y,v 1.22 2019-04-23 14:07:52-07 - - $
// Dummy parser for scanner project.

#include <cassert>
using namespace std;
#include "lyutils.h"
#include "astree.h"

%}

%debug
%defines
%token-table
%verbose

%initial-action {
   parser::root = new astree (TOK_ROOT, {0, 0, 0}, "<<ROOT>>");
 }

%token TOK_VOID TOK_INT TOK_STRING
%token TOK_IF TOK_ELSE TOK_WHILE TOK_RETURN TOK_STRUCT
%token TOK_NULLPTR TOK_ARRAY TOK_ARROW TOK_ALLOC TOK_PTR
%token TOK_EQ TOK_NE TOK_LT TOK_LE TOK_GT TOK_GE TOK_NOT
%token TOK_IDENT TOK_INTCON TOK_CHARCON TOK_STRINGCON
%token TOK_ROOT TOK_BLOCK TOK_CALL TOK_FUNC TOK_TYPE_ID TOK_PARAM

%right  '='
%left   TOK_EQ TOK_NE TOK_LT TOK_LE TOK_GT TOK_GE
%left   '+' '-'
%left   '*' '/' '%'
%right  '^'
%right  TOK_NOT
%left   TOK_ARROW

%start program

%%

program   : program structdef    { $$ = $1->adopt ($2);     }
          | program function     { $$ = $1->adopt ($2);     }
          | program vardecl      { $$ = $1->adopt ($2);     }
          | program error '}'    { $$ = $1;                 }
          | program error ';'    { $$ = $1;                 }
	  | %empty               { $$ = parser::root;       }
	  ;
structdef : TOK_STRUCT TOK_IDENT '{'
           { $$ = $1->adopt($2); destroy($3); }
          | structdef type TOK_IDENT ';'
           { $$ = $1->adopt($2, $3); destroy($4); }
          | structdef '}' ';'
           { $$ = $1; destroy($2, $3);                      }
          ;
type      : plaintype
          | TOK_ARRAY '<' plaintype '>' { $$ = $1->adopt($3); }
          ;
plaintype : TOK_INT
          | TOK_STRING
          | TOK_PTR TOK_LT TOK_STRUCT TOK_IDENT TOK_GT
           { $$ = $1->adopt($3, $4); destroy($2, $5); }
          | TOK_VOID
          ;
function  : plaintype TOK_IDENT
           { $$ = new astree(TOK_FUNC, $1->loc, "");
             astree* temp = new astree(TOK_TYPE_ID, $1->loc, "");
             temp->adopt($1, $2); $$->adopt(temp);}
          | function parameters
           { $$ = $1->adopt($2); }
| function block
{ $$ = $1->adopt($2); }
          ;
parameters: '(' {$$ = new astree(TOK_PARAM, $1->loc, "("); }
          | parameters type TOK_IDENT
            { $$ = $1->adopt($2, $3);}
          | parameters ',' type TOK_IDENT
	   { $$ = $1->adopt($3, $4); destroy($2);                }
          | parameters ')' { destroy($2); }
	  ;
block     : '{' { $$ = new astree(TOK_BLOCK, $1->loc, "{");}
          | block statement { $$ = $1->adopt($2); }
          | block '}' {destroy($2);}
          ;
statement : vardecl    { $$ = $1; }
	  | expr ';'   { $$ = $1; destroy($2);}
          | block
	  | while
	  | ifelse
          | return              { $$ = $1; }
          | ';'
          ;
vardecl   : type TOK_IDENT ';'   { destroy($3); $$ = $1;}
          | type TOK_IDENT '=' expr ';'
	   { destroy($3, $5); $$ = $1->adopt ($2); $$ = $1->adopt($4);}
          ;
while     : TOK_WHILE '(' expr ')' statement
           { $$ = $1->adopt($3, $5); destroy($2, $4); }
          ;
ifelse    : TOK_IF '(' expr ')' statement
           { $$ = $1->adopt($3, $5); destroy($2, $4); }
          | ifelse TOK_ELSE statement
	  { $$ = $1->adopt($2); $2->adopt($3); }
          ;
return    : TOK_RETURN expr ';' {destroy($3); $$ = $1->adopt($2); }
          | TOK_RETURN ';' {destroy($2); $$ = $1; }
          ;
expr      : expr binop expr { $$ = $2->adopt($1, $3);}
          | variable
	  | call
	  | constant
	  | allocator
	  | '(' expr ')' { $$ = $2; destroy($1, $3);}
          ;
binop     : '+' | '-' | '*' | '/' | '%' | '=' | '^'
          | TOK_GT | TOK_GE | TOK_LT | TOK_LE | TOK_NE
          | TOK_EQ
          ;
allocator : TOK_ALLOC TOK_LT TOK_STRING TOK_GT '(' expr ')'
           { $$ = $1->adopt($6);}
          | TOK_ALLOC TOK_LT TOK_STRUCT TOK_IDENT TOK_GT '(' ')'
           { $$ = $1;}
          | TOK_ALLOC TOK_LT TOK_ARRAY TOK_LT plaintype
	    TOK_GT TOK_GT '(' expr ')'
           { $$ = $1->adopt($9); }
          ;
call      : TOK_IDENT '(' 
           { $$ = new astree(TOK_CALL, $1->loc, "(");
             $$->adopt($1); destroy($2);}
          | call expr { $$ = $1->adopt($2); }
          | call ')' {$$ = $1; destroy($2);}
          ;
variable  : TOK_IDENT
          | expr TOK_ARROW TOK_IDENT { $$ = $2->adopt($1, $3);}
          ;
constant  : TOK_INTCON
          | TOK_STRINGCON
          | TOK_CHARCON
          | TOK_NULLPTR
          ;
%%


const char *parser::get_tname (int symbol) {
   return yytname [YYTRANSLATE (symbol)];
}


bool is_defined_token (int symbol) {
   return YYTRANSLATE (symbol) > YYUNDEFTOK;
}   
