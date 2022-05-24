%{
#include <stdio.h>

#define NUMBER 256
#define BUFFER 100
#define OP 257
#define nl 101
%}

/* regexp definitions */
num [0-9]+
delim[ \t]+
whitespace {delim}+
letter[A-Za-z]
nl \n

%%

{num} { return NUMBER; }
{whitespace} {}
[+,-] {return OP;}
[*,/] {printf("\nError: %s not recognized\n", yytext); exit(0);}  
{nl} {return nl;}
{letter} {printf("\nError: %s not recognized\n", yytext); exit(0);}
%%

int main () {
  int token;
  char stack[BUFFER];  
  int top = -1;  
  int flag = 1;
  int idx = 0;
  
  while ((token = yylex())!= nl) {	
	 idx++;
	 switch (token) {
        case NUMBER:
			if(flag == 0){
				printf("\nError: %s not recognized\n", yytext);
				exit(0);
			}		
			printf("%s ", yytext);			
			flag = 0;			
			break;			
        case OP:
			if(flag == 1){
				printf("\nError: %s not recognized\n", yytext);
				exit(0);
			}
			if(top == -1){									
				stack[++top] = yytext[0];
				flag = 1;
				
			}else{ 				
				printf("%c ", stack[top--]);							
				stack[++top] = yytext[0];
				flag = 1;				
			}			
			break;
		default:
			printf("Error: %s not recognized\n", yytext);
			break;
     }	 
  }
  if(idx == 1){
	  printf("\nError: not mathematical exp\n");	
	  exit(0);
  }
  while(top > -1){
	printf("%c ", stack[top--]);	
  }
  
  printf("\n");
}