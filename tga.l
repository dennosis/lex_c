/* Scanner para uma linguagem Pascal simplificada */

%option noyywrap

%{
#include <math.h>
#include <string.h>
#include <stdlib.h>

char* concat(const char *s1, const char *s2)
{
    char *result = malloc(strlen(s1) + strlen(s2) + 1); // +1 for the null-terminator
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}



int qprintf(char type[], char value[]){
	
	char *result = "";
	result = concat("[", result);
	result = concat(result, type);
	result = concat(result, ",");
	result = concat(result, value);
	result = concat(result, "]\n");

 	printf(result, yytext);
  	return 1;
}

%}

DIGIT	[0-9]
ID	[_a-zA-Z][_a-zA-Z0-9]*

%%

"do"|"while"|"if"|"else"|"switch"|"for"|"return"|"null"|"int"|"float"|"double"|"string"|"bool"|"break"|"case"|"void"|#include.*$  {qprintf("reserved_word", "%s");}

"+"|"-"|"*"|"/" {qprintf("Arith_Op", "%s");}

"<"|"<="|"=="|"!="|">="|">"  {qprintf("Relational_Op", "%s");}

"||"|"&&"  {qprintf("logic_op", "%s");}

"=" {qprintf("equal", "%s");}
"(" {qprintf("l_paren", "%s");}
")" {qprintf("r_paren", "%s");}
"{" {qprintf("l_bracket ", "%s");}
"}" {qprintf("r_bracket", "%s");}
"," {qprintf("comma", "%s");}
";" {qprintf("semicolon", "%s");}


{DIGIT}+ { qprintf("integer", "%s");}

{DIGIT}"."{DIGIT}* {qprintf("float", "%s");}

["][^"]*["] {qprintf("string", "%s");}

{ID}	{qprintf("id", "%s");}


[ \t\n]+	/* eat up whitespace */	

"//"(.)*"\n"  /*ignora comentarios */

[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]    /*ignora comentarios */

.	qprintf("Caractere nao reconhecido", "%s");

%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	return 0;
}
