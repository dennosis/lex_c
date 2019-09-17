/* Scanner para uma linguagem Pascal simplificada */

%option noyywrap

%{

#include <math.h>

%}

DIGIT	[0-9]
ID	[a-z][a-z0-9]*

%%

\\n printf("\n%s\n", yytext);		

"/"[\^{}}\n]*"/" {printf("comment%s", yytext);}

"+"|"-"|"*"|"/" {printf("Arith_Op: %s", yytext);}

"do"|"while"|"if"|"else"|"switch"|"for"|"return"|"null"|"int"|"float"|"double"|"string"|"bool"|"break"|"case"  {printf("reserved_word: %s", yytext);}

"<"|"<="|"=="|"!="|">="|">"  {printf("Relational_Op: %s", yytext);}

"||"|"&&"  {printf("logic_op: %s", yytext);}

"=" {printf("equal: %s", yytext);}
"(" {printf("l_paren: %s", yytext);}
")" {printf("r_paren: %s", yytext);}
"{" {printf("l_bracket: %s", yytext);}
"}" {printf("r_bracket: %s", yytext);}
"," {printf("comma: %s", yytext);}
";" {printf("semicolon,: %s", yytext);}


{DIGIT}+ { printf("Numero inteiro encontrado: %s (%d)", yytext, atoi(yytext));}

{DIGIT}"."{DIGIT}* {printf("Numero float encontrado: %s (%f)", yytext, atof(yytext));}

{ID}	{printf("Identificador encontrado: %s", yytext);}



[ \t\n]+		

.	printf("Caractere nao reconhecido: %s", yytext);

%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	return 0;
}
