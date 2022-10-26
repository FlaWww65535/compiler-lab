%{
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<stdbool.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token NUMBER

%left ADD NEG 
%left MUL DIV
%left RBR
%right UMINUS
%right LBR

%%

lines	:		lines expr ';' { printf("%f\n",$2);}
		|		lines ';'
		|		/* */			{/* */} 	
		;
expr 	:		expr ADD expr 	{ $$ = $1 + $3; }
	  	|       expr NEG expr 	{ $$ = $1 - $3; }	
		|       expr MUL expr 	{ $$ = $1 * $3; }
		|       expr DIV expr 	{ $$ = $1 / $3; }
		|      	LBR expr RBR	{ $$ = $2;}
		|		NEG expr %prec UMINUS {$$ = -$2;}
		|		NUMBER			{$$ = $1;}
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
			yylval=0;
			while(isdigit(s)){
				yylval=yylval*10+(s-'0');
				s=getchar();
			}
			ungetc(s,stdin);
			return NUMBER;
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



