/* Scanner para uma linguagem Pascal simplificada */

%option noyywrap

%{

#include <math.h>

%}


%%

{DIGIT}+ { printf("Numero inteiro encontrado: %s (%d)\n", yytext, atoi(yytext));}

{DIGIT}"."{DIGIT}* {printf("Numero float encontrado: %s (%f)\n", yytext, atof(yytext));}

if|then|begin|procedure|function	{
		printf("Palavra reservada encontrada: %s\n ", yytext);}

{ID}	{printf("Identificador encontrado: %s\n", yytext);}

"+"|"-"|"*"|"/" {printf("Operador encontrado: %s\n", yytext);}

"do"|"while"|"if"|"else"|"switch"|"for"|"return"|"null"|"int"|"float"|"double"|"string"|"bool"|"break"|"case"  {printf("reserved_word: %s\n", yytext);}

"<"|"<="|"=="|"!="|">="|">"  {printf("Relational_Op: %s\n", yytext);}

"||"|"&&"  {printf("logic_op: %s\n", yytext);}

"=" {printf("equal: %s\n", yytext);}
"(" {printf("l_paren: %s\n", yytext);}
")" {printf("r_paren: %s\n", yytext);}
"{" {printf("l_bracket: %s\n", yytext);}
"}" {printf("r_bracket: %s\n", yytext);}
"," {printf("comma: %s\n", yytext);}
";" {printf("semicolon,: %s\n", yytext);}


"{"[\^{}}\n]*"}"	

[ \t\n]+		

.	printf("Caractere nao reconhecido: %s\n", yytext);

%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	return 0;
}
