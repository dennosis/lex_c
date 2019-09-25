/* Scanner para uma linguagem Pascal simplificada */

%option noyywrap

%{
#include <math.h>
#include <string.h>
#include <stdlib.h>

typedef struct queueElem{  
    struct queueElem*next; 
    char data[15]; 
}queueELEM;                    
typedef struct queue{
    struct queueElem*begin;
    struct queueElem*end;
}queue;
int opt;

queue*create(){
    queue*q = (queue*)malloc(sizeof(queue));
    if(!q)
        exit(1);
    else{
     q->begin = NULL;
     q->end = NULL;
    }
    return q;
}
int emptyQUEUE(queue*q){
    if(q==NULL) return 1;
    if(q->begin==NULL) return 1;
    else return 0;
}

queueELEM* allocate(char value[]){
    queueELEM* node = malloc(sizeof(queueELEM) + 15*sizeof(char*));
    if(!node)
        exit(1);
    else{
        strcpy(node->data, value);
        node->next = NULL;
        return node; 
        
    }
}
void enqueue(queue*q,char value[]){
      
    queueELEM*node = allocate(value);
    
    if(!node)
        exit(1);
    if(q->end == NULL)
        q->begin = node;
    else
        q->end->next = node;
    q->end = node;
}

int dequeue(queue*q){
    if(emptyQUEUE(q)) return 0;

    queueELEM*node = q->begin;
    q->begin = q->begin->next;
    if(q->begin!=NULL)
        q->end = NULL;
    free(node);
    return 1;
}

char* concat(const char *s1, const char *s2){
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
	result = concat(result, "]");

 	printf(result, yytext);
  	return 1;
}

int printid(char value[]){
        queueELEM*aux = q->begin;
        int id = 1;
        char buf[15];
        while(aux!=NULL){
            if(strcmp(aux->data, value)){
                sprintf(buf, "%i", id);
                qprintf(buf,value);
                return 1;
            }
            aux = aux->next; 
            id++;
        }
        enqueue(q,value);
        sprintf(buf, "%i", id);
        qprintf(buf,value);
        return 0;       
}

%}

DIGIT	[0-9]
ID	[_a-zA-Z]*

%%

"do"|"while"|"if"|"else"|"switch"|"for"|"return"|"null"|"int"|"float"|"double"|"string"|"bool"|"break"|"case"|"void" {qprintf("reserved_word", "%s");}

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

{ID}  {printid("%s")}

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