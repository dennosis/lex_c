/* Grupo: Dennis Aguiar,Felipe Juchem, William de Oliveira*/

%option noyywrap

%{
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* concat(const char *s1, const char *s2){
    char *result = malloc(strlen(s1) + strlen(s2) + 1); 
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}

char* integer_to_string(int x)
{
    char* buffer = malloc(sizeof(char) * sizeof(int) * 4 + 1);
    if (buffer)
    {
         sprintf(buffer, "%d", x);
    }
    return buffer; 
}


typedef struct {
  char **array;
  int size;
} Array;

Array arrayId;

void initArray(char element[]) {
  arrayId.array = (char**)malloc(sizeof(char *));
  arrayId.size = 1;
  arrayId.array[0] = element;
}

void pushArray(char element[]) {
    arrayId.array = realloc(arrayId.array, (arrayId.size+1) * sizeof(char *));
    arrayId.array[arrayId.size] = element;
    arrayId.size = arrayId.size + 1;
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

int printid(char value[]){  

    if(arrayId.array == NULL){
        initArray(value);
        qprintf("id", "1");
    }else{
        int i;
        for (i = 0; i < arrayId.size; i++){
            if(strcmp(value, arrayId.array[i]) == 0){
                qprintf("id", integer_to_string(i+1));
                return 1;
            }
        }
        pushArray(value);
        qprintf("id", integer_to_string(i+1));
        return 0;
    }

}

%}

DIGIT	[0-9]
ID	[_a-zA-Z][_a-zA-Z0-9]*

%%

"do"|"while"|"if"|"else"|"switch"|"for"|"return"|"null"|"int"|"float"|"double"|"string"|"bool"|"break"|"case"|"void"|"char"|"#include"|"printf"|"getch"|"clrscr"|"scanf" {qprintf("reserved_word", "%s");}

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

{DIGIT}+ { qprintf("num", "%s");}

{DIGIT}"."{DIGIT}* {qprintf("num", "%s");}

["][^"]*["] {qprintf("string_literal", "%s");}

{ID}  {
    char *string = malloc(strlen(yytext)*sizeof(char)); strcpy(string, yytext);
    printid(string);
    }

{ID}".h" {qprintf("library", "%s");}

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
