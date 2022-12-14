%code top{
    #include <iostream>
	#include <vector>
    #include <assert.h>
    #include "parser.h"
    extern Ast ast;
    int yylex();
    int yyerror( char const * );
}

%code requires {
    #include "Ast.h"
    #include "SymbolTable.h"
    #include "Type.h"
}

%union {
    int itype;
    char* strtype;
    StmtNode* stmttype;
    ExprNode* exprtype;
    Type* type;
	IDList* idlist;
	IDListElement* idlistelement;
	std::vector<std::pair<Type*,std::string>> *paramlist;
}

%start Program
%token <strtype> ID 
%token <itype> INTEGER
%token IF ELSE WHILE CONTINUE BREAK
%token CONST
%token INT VOID
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA
%token ADD SUB MUL DIV MOD OR AND LESS GREATER LESSEQ GREATEREQ NOTEQ EQUAL ASSIGN
%token RETURN
%right: UMINUS UPLUS NOT

%nterm <stmttype> Stmts Stmt AssignStmt BlockStmt IfStmt ReturnStmt ExpStmt /*DeclStmt DeclAssignStmt*/ FuncDef WhileStmt IDListDeclStmt
%nterm <idlist> IDList
%nterm <idlistelement> IDListEle

%nterm <exprtype> Exp Cond AddExp MulExp  UnaryExp FuncUseExp FuncRParams PrimaryExp LVal RelExp LAndExp LOrExp
%nterm <paramlist> ParamList

%nterm <type> Type

%precedence THEN
%precedence ELSE
%%
Program
    : Stmts {
        ast.setRoot($1);
    }
    ;
Stmts
    : Stmt {$$=$1;}
    | Stmts Stmt{
        $$ = new SeqNode($1, $2);
    }
    ;
Stmt
    : AssignStmt {$$=$1;}
    | BlockStmt {$$=$1;}
    | IfStmt {$$=$1;}
	| WhileStmt {$$=$1;}
    | ReturnStmt {$$=$1;}
    /*| DeclStmt {$$=$1;}
	| DeclAssignStmt{$$=$1;}*/
    | FuncDef {$$=$1;}
	| IDListDeclStmt {$$=$1;}
	| ExpStmt{$$=$1;}
	//| Exp SEMICOLON{$$=$1}
    ;
ExpStmt
    :
    Exp SEMICOLON{
        $$=new ExpStmt($1);
    }
    ;
LVal
    : ID {
        SymbolEntry *se;
        se = identifiers->lookup($1);
        if(se == nullptr)
        {
            fprintf(stderr, "identifier \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        $$ = new Id(se);
        delete []$1;
    }
    ;
AssignStmt
    :
    LVal ASSIGN Exp SEMICOLON {
		Id * lval = dynamic_cast<Id *>$1;
		const IdentifierSymbolEntry *lvalEntry=dynamic_cast<const IdentifierSymbolEntry *>(lval->getEntry());
		if(lvalEntry->getType()->isConstInt())
		{
            fprintf(stderr, "identifier \"%s\" is const\n", (char*)$1);
            delete [](char*)$1;
		}
        $$ = new AssignStmt($1, $3);
    }
    ;
BlockStmt
    :   LBRACE 
        {identifiers = new SymbolTable(identifiers);} 
        Stmts RBRACE 
        {
            $$ = new CompoundStmt($3);
            SymbolTable *top = identifiers;
            identifiers = identifiers->getPrev();
            delete top;
        }
    ;
IfStmt
    : IF LPAREN Cond RPAREN Stmt %prec THEN {
        $$ = new IfStmt($3, $5);

    }
    | IF LPAREN Cond RPAREN Stmt ELSE Stmt {
        $$ = new IfElseStmt($3, $5, $7);

    }
    ;
WhileStmt
	: WHILE LPAREN Cond RPAREN Stmt{
		$$ = new WhileStmt($3,$5);
	}
	;
ReturnStmt
    :
    RETURN Exp SEMICOLON{
        $$ = new ReturnStmt($2);
    }
	|RETURN SEMICOLON{
		$$ = new ReturnStmt(new Constant(new ConstantSymbolEntry(new VoidType(),0)));
	}
    ;
Exp
    :
    AddExp {$$ = $1;}
    ;
Cond
    :
    LOrExp {$$ = $1;}
    ;
PrimaryExp
    :
    LVal {
        $$ = $1;
    }
    | INTEGER {
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, $1);
        $$ = new Constant(se);
    }
    |
    LPAREN Exp RPAREN{
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new PrimaryExp(se,$2);
    }
    ;
AddExp
    :
    MulExp {$$ = $1;}
    |
    AddExp ADD MulExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::ADD, $1, $3);
    }
    |
    AddExp SUB MulExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::SUB, $1, $3);
    }
    ;
MulExp
    :
    UnaryExp{$$ = $1;}
    |
    MulExp MUL UnaryExp
    {
        SymbolEntry *se=new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MUL, $1, $3);
    }
    |
    MulExp DIV UnaryExp
    {
        SymbolEntry *se=new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::DIV, $1, $3);
    }
    |
    MulExp MOD UnaryExp
    {
        SymbolEntry *se=new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MOD, $1, $3);
    }
    ;
UnaryExp
    :
    PrimaryExp{$$=$1;}
    |
    FuncUseExp{$$=$1;}
    |
    SUB UnaryExp %prec UMINUS
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new UnaryExpr(se,UnaryExpr::UMINUS,$2);
    }
    |
    ADD UnaryExp %prec UPLUS
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new UnaryExpr(se,UnaryExpr::UPLUS,$2);
    }
    |
    NOT UnaryExp
    {
         SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
         $$ = new UnaryExpr(se,UnaryExpr::NOT,$2);
    }
    ;
FuncUseExp
    :
    LVal LPAREN FuncRParams RPAREN
    {
        SymbolEntry *se=new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$=new FuncUseExpr(se,$1,$3);
    }
    |
    LVal LPAREN RPAREN
    {
        SymbolEntry *se=new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$=new FuncUseExpr(se,$1);
    }
    ;
FuncRParams
    :
    Exp
    {
        $$=$1;
    };
    |
    FuncRParams COMMA Exp
    {
         SymbolEntry *se=new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
         $$=new FuncRParams(se,$3,$1);
    }
    ;
RelExp
    :
    AddExp {$$ = $1;}
    |
    RelExp LESS AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESS, $1, $3);
    }
    |
    RelExp GREATER AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::GREATER, $1, $3);
    }
    |
     RelExp LESSEQ AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESSEQ, $1, $3);
    }
    |
     RelExp GREATEREQ AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::GREATEREQ, $1, $3);
    }
    |
    RelExp NOTEQ AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::NOTEQ, $1, $3);
    }
    |
    RelExp EQUAL AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::EQUAL, $1, $3);
    }
    ;
LAndExp
    :
    RelExp {$$ = $1;}
    |
    LAndExp AND RelExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::AND, $1, $3);
    }
    ;
LOrExp
    :
    LAndExp {$$ = $1;}
    |
    LOrExp OR LAndExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::OR, $1, $3);
    }
    ;
Type
    : INT {
        $$ = TypeSystem::intType;
    }
    | VOID {
        $$ = TypeSystem::voidType;
    }
	| CONST INT {
		$$ = TypeSystem::constIntType;
	}
    ;
/*DeclStmt
    :
    Type IDList SEMICOLON {
        SymbolEntry *se;
        se = new IdentifierSymbolEntry($1, $2, identifiers->getLevel());
        identifiers->install($2, se);
        $$ = new DeclStmt(new Id(se));
        delete []$2;
    }
    ;*/
/*
DeclAssignStmt
	:
	Type ID ASSIGN Exp SEMICOLON{
		SymbolEntry *se;
		se = new IdentifierSymbolEntry($1,$2,identifiers->getLevel());
		identifiers->install($2,se);
		StmtNode* declTmp = new DeclStmt(new Id(se));

		Id* lvalTmp = new Id(se);

		StmtNode* asgnTmp = new AssignStmt(lvalTmp,$4);

		$$ = new SeqNode(declTmp,asgnTmp);
		
	}
	;*/
IDListEle
	:
	ID ASSIGN Exp{
		$$ = new IDListElement($1,$3);	
	}
	|ID{
		$$ = new IDListElement($1,nullptr);	
	}
	;
IDList
	:
	IDListEle{
		$$=new IDList;
		$$->insert($1);
	}
	|IDListEle COMMA IDList{
		$$=$3;
		$$->insert($1);
	}
	;

IDListDeclStmt
	:
	Type IDList SEMICOLON{
		//??????List?????????Type
		std::vector l= $2->list;
		IDListElement* head=l[0];
		SymbolEntry *se;
		se = new IdentifierSymbolEntry($1,head->getName(),identifiers->getLevel());
		identifiers->install(head->getName(),se);
		StmtNode *prestmt = new DeclStmt(new Id(se));
		if(head->isInit()){
			prestmt = new SeqNode(
				prestmt,
				new AssignStmt(
					new Id(se),head->getVal()
				)
			);
		}

		for(int i=1;i<(int)l.size();i++){
			se = new IdentifierSymbolEntry($1,l[i]->getName(),identifiers->getLevel());
			identifiers->install(l[i]->getName(),se);
			StmtNode *pretmp = new DeclStmt(new Id(se));
			if(l[i]->isInit()){
				pretmp = new SeqNode(
					pretmp,
					new AssignStmt(
						new Id(se),l[i]->getVal()
					)
				);
			}
			prestmt = new SeqNode(prestmt,pretmp);
		}
		$$ = (StmtNode *)prestmt;
	}
	;

ParamList
	:
	Type ID{
		$$ = new std::vector<std::pair<Type*,std::string>>; 
		$$->push_back(std::make_pair($1,$2));
	}
	|Type ID COMMA ParamList{
		$$ = $4;
		$$->push_back(std::make_pair($1,$2));
	}
    ;
FuncDef
    :
    Type ID 
    LPAREN RPAREN
	{
        Type *funcType;
        funcType = new FunctionType($1,{});
        SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getLevel());
        identifiers->install($2, se);
        identifiers = new SymbolTable(identifiers);
    }
    BlockStmt
    {
        SymbolEntry *se;
        se = identifiers->lookup($2);
        assert(se != nullptr);
        $$ = new FunctionDef(se, $6);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
        delete []$2;
    }
	|
    Type ID LPAREN ParamList{
        Type *funcType;

		std::vector<std::pair<Type*,std::string>> l = *$4; 
		std::vector<Type* > *tl = new std::vector<Type*>;
		for(int i=0;i<(int)l.size();i++)
		{
			tl->push_back(l[i].first);
		}
        funcType = new FunctionType($1,*tl);
        
		SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getLevel());
        identifiers->install($2, se);
        identifiers = new SymbolTable(identifiers);

		for(int i=0;i<(int)l.size();i++){
			SymbolEntry *param = new IdentifierSymbolEntry(l[i].first,l[i].second,identifiers->getLevel());
        	identifiers->install(l[i].second, param);
		}
    }
	RPAREN
    BlockStmt
    {
        SymbolEntry *se;
        se = identifiers->lookup($2);

        assert(se != nullptr);
        $$ = new FunctionDef(se, $7);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
        delete []$2;
	}
    ;
%%

int yyerror(char const* message)
{
    std::cerr<<"yyerror:"<<message<<std::endl;
    return -1;
}
