%option noyywrap
%option yylineno
%{
    /*
    * You will need to comment this line in lab5.
    */
    #define ONLY_FOR_LEX
    
    #ifdef ONLY_FOR_LEX
    #else
    #define YYSTYPE void *
    #include "parser.h"
    #endif

    #define YY_NO_UNPUT
    #define YY_NO_INPUT
    #include <string>

    #ifdef ONLY_FOR_LEX
    #include <ostream>
    #include <fstream>
	#include<iomanip>
    #include<unordered_map>
	using namespace std;
    extern FILE *yyin; 
    extern FILE *yyout;

	int total_num=0;

	struct Var{
		int v;
		Var* next;
	};
	struct Symbol{
		string s;
		Var* head;
	};

	unordered_map<string,Symbol>sy_hash;
    
	struct BlockVar{
		string s;
		BlockVar* next;
	};
	struct BlockFrame{
		int scope;
		BlockVar* head;
		BlockFrame* next;
	};
	BlockFrame* BlockFrameList;

	void unload(BlockFrame* l){
		for(BlockVar* i=l->head;i!=NULL;i=i->next){
			//Var* tmp=sy_hash[i->s].head;
			printf("i->s= %s\n",i->s.c_str());
			//sy_hash[i->s].head=sy_hash[i->s].head->next;
			//delete tmp;
		}
	}
		

	void DEBUG_FOR_LAB4(string token,string lexeme,int lineno,int val){
		fprintf(yyout,"%10s%10s%10d%10d\n",token.c_str(),lexeme.c_str(),lineno,val);
    }
    #endif
%}

HEX (\+|\-)?0(X|x)[0-9a-fA-F]+
OCTAL (\+|\-)?0[0-7]+
DECIMAL (\+|\-)?[0-9]+
INT {HEX}|{OCTAL}|{DECIMAL}
ID [[:alpha:]_][[:alpha:][:digit:]_]*
EOL (\r\n|\n|\r)
WHITE [\t ]
line_comment "//".*\n
comment_begin "/*"
comment_element .|\n
comment_end "*/"
%x BLOCKCOMMENT

%%

"int" {
    /*
    * Questions: 
    *   Q1: Why we need to return INT in further labs?
    *   Q2: What is "INT" actually?
    */
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("INT","int",yylineno,0);
    #else
        return INT;
    #endif
}
"void" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("VOID","void",yylineno,0);
    #else
        return VOID;
    #endif 
}
"if" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("IF","if",yylineno,0);
    #else
        return IF;
    #endif
};
"else" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ELSE","else",yylineno,0);
    #else
        return ELSE;
    #endif
};
"return" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RETURN","return",yylineno,0);
    #else
        return RETURN;
    #endif
}

"=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ASSIGN","=",yylineno,0);
    #else
        return ASSIGN;
    #endif
}
"<" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LESS","<",yylineno,0);
    #else
        return LESS;
    #endif
}
"+" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ADD","+",yylineno,0);
    #else
        return ADD;
    #endif
}
";" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SEMICOLON",";",yylineno,0);
    #else
        return SEMICOLON;
    #endif
}
"(" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LPAREN","(",yylineno,0);
    #else
        return LPAREN;
    #endif
}
")" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RPAREN",")",yylineno,0);
    #else
    return RPAREN;
    #endif
}
"{" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LBRACE","{",yylineno,0);
		BlockFrame* tmp=BlockFrameList;
		BlockFrameList=new BlockFrame;
		BlockFrameList->scope=yylineno;
		BlockFrameList->next=tmp;
    #else
        return LBRACE;
    #endif
}
"}" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RBRACE","}",yylineno,0);
		printf("meet RBRACE at %d \n",yylineno);
		//unload(BlockFrameList);
		BlockFrame* tmp=BlockFrameList;
		BlockFrameList=BlockFrameList->next;
		delete tmp;
    #else
        return RBRACE;
    #endif
}
{EOL}
{WHITE} {}
{line_comment} {}
{comment_begin} BEGIN(BLOCKCOMMENT);
<BLOCKCOMMENT>{comment_element} {}
<BLOCKCOMMENT>{comment_end} BEGIN(INITIAL);
{ID} {
	string s = yytext;
	BlockVar* tmp = BlockFrameList->head;
	BlockVar* nxt = new BlockVar;
	
	BlockFrameList->head = nxt;
	nxt->s = s;
	nxt->next = tmp;
	//insert into BF

	auto iter=sy_hash.find(s);
	if(iter != sy_hash.end()){
		if(sy_hash[s].head->v!=BlockFrameList->scope){
			//说明存在shadow
			sy_hash[s].s = s;
			Var* vtmp = sy_hash[s].head;
			Var* thisvar = new Var;
			thisvar->next=vtmp;
			thisvar->v=BlockFrameList->scope;
			sy_hash[s].head = thisvar;
		}
	}else{
		sy_hash[s].s=s;
		sy_hash[s].head=new Var;
		sy_hash[s].head->v=BlockFrameList->scope;
		sy_hash[s].head->next=NULL;
	}
	DEBUG_FOR_LAB4("ID",s.c_str(),yylineno,sy_hash[s].head->v);
}
{INT} {
	int i;
	sscanf(yytext,"%i",&i);
	DEBUG_FOR_LAB4("NUM",yytext,yylineno,i);
}
%%

#ifdef ONLY_FOR_LEX
int main(int argc, char **argv){
    if(argc != 5){
        fprintf(stderr, "Argument Not Enough");
        exit(EXIT_FAILURE);
    }

    if(!(yyin = fopen(argv[1], "r"))){
        fprintf(stderr, "No such file or directory: %s", argv[1]);
        exit(EXIT_FAILURE);
    }

    if(!(yyout = fopen(argv[3], "w"))){
        fprintf(stderr, "No such file or directory: %s", argv[3]);
        exit(EXIT_FAILURE);
    }
	BlockFrameList = new BlockFrame;
	BlockFrameList->scope=yylineno;
	BlockFrameList->head=NULL;
	BlockFrameList->next=NULL;
	fprintf(yyout,"%10s%10s%10s%10s\n","token","lexeme","lineno","val");
    yylex();
    return 0;
}
#endif
