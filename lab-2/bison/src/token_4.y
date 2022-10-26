%{
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<stdbool.h>
#include<string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif

char idStr[50];
char numStr[50];

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}


%token NUMBER
%token ID

%left ADD NEG 
%left MUL DIV
%left RBR
%right UMINUS
%right LBR

%%

lines	:		lines expr ';' { printf("%s\n",$2);}
		|		lines ';'
		|		/* */			{/* */} 	
		;
expr 	:		expr ADD expr 	{ 
	  								$$ = (char *)malloc(50*sizeof(char));
	  								strcpy($$,$1);strcat($$,$3);strcat($$,"+ ");
								}
	  	|       expr NEG expr 	{ 
									$$ = (char *)malloc(50*sizeof(char));
                                    strcpy($$,$1);strcat($$,$3);strcat($$,"- ");
								}	

		|       expr MUL expr 	{
									$$ = (char *)malloc(50*sizeof(char));
                                    strcpy($$,$1);strcat($$,$3);strcat($$,"* ");
								}
		|       expr DIV expr 	{
									$$ = (char *)malloc(50*sizeof(char));
                                    strcpy($$,$1);strcat($$,$3);strcat($$,"/ ");
								}
		|      	LBR expr RBR	{ $$ = $2;}
		|		NEG expr %prec UMINUS	{
									 		$$ = (char *)malloc(50*sizeof(char));
                                        	strcpy($$,"-");strcat($$,$2);
									 	}
		|		NUMBER			{
									$$ = (char *)malloc(50*sizeof(char));
                                    strcat($$,$1);strcat($$," ");
								}
		|		ID				{
									$$ = (char *)malloc(50*sizeof(char));
                                    strcat($$,$1);strcat($$," ");
								}
		;


%%


int trans(char s)
{
	switch(s){
	case '+':
		return ADD;
	case '-':
		return NEG;
	case '*':
		return MUL;
	case '/':
		return DIV;
	case '(':
		return LBR;
	case ')':
		return RBR;
	default:
		return s;
	}
}

int yylex(){
	int s;
	while(true){
		s=getchar();
		if(s == ' '||s == '\n'||s == '\t'){
			/*do nothing*/
		}else if(isdigit(s)){
			int len=0;
			while(isdigit(s)){
				numStr[len]=s;
				s=getchar();
				len++;
			}
			numStr[len]='\0';
			yylval=numStr;
			ungetc(s,stdin);
			return NUMBER;
		}else if(isalpha(s)||s=='_'){
			int len=0;
			while(isalpha(s)||s=='_'||isdigit(s)){
				idStr[len]=s;
				s=getchar();
				len++;
			}
			idStr[len]='\0';
			yylval=idStr;
			ungetc(s,stdin);
			return ID;
		}else{
			return trans(s);
		}
	}
}

int main (){
	yyin = stdin;
	do {
			yyparse();
	} while(!feof(yyin));
	return 0;
}
void yyerror(const char* s){
	fprintf(stderr,"Parse error: %s\n",s);
	exit(1);
}



