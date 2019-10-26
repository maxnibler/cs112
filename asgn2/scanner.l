%{
#include <cassert>

#include "lyutils.h"
#include "astree.h"

#define YY_USER_ACTION  { lexer::advance(); }
#define YY_FATAL_ERROR(msg) { lexer::fatal_error (msg); }

%}

%option 8bit
%option debug
%option nobackup
%option nodefault
%option noinput
%option nounput
%option noyywrap
%option warn

digit                [0-9]
nonzero              [1-9]
letter               [a-zA-Z]

%%

"#".*\n              {  lexer::include();
                        lexer::newline(); }

"+"                  { return lexer::token('+');        }
"-"                  { return lexer::token('-');        }
"*"                  { return lexer::token('*');        }
"/"                  { return lexer::token('/');        }
"%"                  { return lexer::token('%');        }
"("                  { return lexer::token('(');        }
")"                  { return lexer::token(')');        }
"["                  { return lexer::token('[');        }
"]"                  { return lexer::token(']');        }
"{"                  { return lexer::token('{');        }
"}"                  { return lexer::token('}');        }
";"                  { return lexer::token(';');        }
","                  { return lexer::token(',');        }
"="                  { return lexer::token('=');        }
"=="                 { return lexer::token(TOK_EQ);     }
"<>"                 { return lexer::token(TOK_NE);     }
"<"                  { return lexer::token(TOK_LT);     }
">"                  { return lexer::token(TOK_GT);     }
"<="                 { return lexer::token(TOK_LE);     }
">="                 { return lexer::token(TOK_GE);     }
"->"                 { return lexer::token(TOK_ARROW);  }
"if"                 { return lexer::token(TOK_IF);     }
"else"               { return lexer::token(TOK_ELSE);   }
"while"              { return lexer::token(TOK_WHILE);  }
"return"             { return lexer::token(TOK_RETURN); }
"alloc"              { return lexer::token(TOK_ALLOC);  }
"nullptr"            { return lexer::token(TOK_NULLPTR);}
"not"                { return lexer::token(TOK_NOT);    }
"int"                { return lexer::token(TOK_INT);    }
"string"             { return lexer::token(TOK_STRING); }
"struct"             { return lexer::token(TOK_STRUCT); }
"array"              { return lexer::token(TOK_ARRAY);  }
"ptr"                { return lexer::token(TOK_PTR);    }
"void"               { return lexer::token(TOK_VOID);   }

{letter}({letter}|{digit})* {
                return lexer::token(TOK_IDENT);         }

{nonzero}({digit})*         {
                return lexer::token(TOK_INTCON);        }

{letter}                    {
                return lexer::token(TOK_CHARCON);
                                          }

{letter}*                   {
                return lexer::token(TOK_STRINGCON);
                                          }

%%

