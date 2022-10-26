%{
#include<stdio.h>
#include<stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%left ADD NEG 
%left MUL DIV
%left RBR
%right UMINUS
%right LBR

%%

lines	:		lines expr '\n' { printf("%f\n",$2);}
		|		lines '\n'
		|		/* */			{/* */} 	
		;
expr 	:		expr ADD expr 	{ $$ = $1 + $3; }
	  	|       expr NEG expr 	{ $$ = $1 - $3; }	
		|       expr MUL expr 	{ $$ = $1 * $3; }
		|       expr DIV expr 	{ $$ = $1 / $3; }
		|      	LBR expr RBR	{ $$ = $2;}
		|		NEG expr %prec UMINUS {$$ = -$2;}
		|		NUMBER
		;

NUMBER	:		'0'				{$$=0.0;}
	   	|		'1'				{$$=1.0;}
		|		'2'				{$$=2.0;}
		|		'3'				{$$=3.0;}
		|		'4'				{$$=4.0;}
		|		'5'				{$$=5.0;}
		|		'6'				{$$=6.0;}
		|		'7'				{$$=7.0;}
		|		'8'				{$$=8.0;}
		|		'9'				{$$=9.0;}
		;

%%


int yylex()
{
	char s = getchar();
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



