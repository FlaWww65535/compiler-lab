#ifndef __AST_H__
#define __AST_H__

#include <fstream>
#include <vector>

class SymbolEntry;

class Node
{
private:
    static int counter;
    int seq;
public:
    Node();
    int getSeq() const {return seq;};
    virtual void output(int level) = 0;
};



class ExprNode : public Node
{
protected:
    SymbolEntry *symbolEntry;
public:
    ExprNode(SymbolEntry *symbolEntry) : symbolEntry(symbolEntry){};
};

class BinaryExpr : public ExprNode
{
private:
    int op;
    ExprNode *expr1, *expr2;
public:
    enum {ADD, SUB, MUL,DIV,MOD,AND, OR, LESS,GREATER,LESSEQ,GREATEREQ,NOTEQ,EQUAL};
    BinaryExpr(SymbolEntry *se, int op, ExprNode*expr1, ExprNode*expr2) : ExprNode(se), op(op), expr1(expr1), expr2(expr2){};
    void output(int level);
};
class UnaryExpr : public ExprNode
{
private:
    int op;
    ExprNode *expr1;
public:
    enum {UMINUS,UPLUS,NOT};
    UnaryExpr(SymbolEntry *se, int op, ExprNode*expr1) : ExprNode(se),op(op),expr1(expr1){};
    void output(int level);
};
class PrimaryExp : public ExprNode
{
private :
     ExprNode *expr1;
public :
     PrimaryExp(SymbolEntry *se,ExprNode* expr1):ExprNode(se),expr1(expr1){};
     void output(int level);
};
class FuncUseExpr : public ExprNode
{
private:
    ExprNode *funcName,*funcRParams;
public:
    FuncUseExpr(SymbolEntry *se, ExprNode*funcName, ExprNode* funcRParams):  ExprNode(se),funcName(funcName), funcRParams(funcRParams){};
    FuncUseExpr(SymbolEntry *se, ExprNode*funcName): ExprNode(se),funcName(funcName),funcRParams(nullptr){};
    void output(int level);
};

class FuncRParams: public ExprNode
{
private:
    ExprNode *expr1,* funcRParams;
public:
    FuncRParams(SymbolEntry *se,ExprNode *expr1,ExprNode* funcRParams): ExprNode(se),expr1(expr1),funcRParams(funcRParams){};
    void output(int level);
};

class Constant : public ExprNode
{
public:
    Constant(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
};

class Id : public ExprNode
{
public:
    Id(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
	const SymbolEntry* getEntry(){return ExprNode::symbolEntry;};
};

class StmtNode : public Node
{};

class CompoundStmt : public StmtNode
{
private:
    StmtNode *stmt;
public:
    CompoundStmt(StmtNode *stmt) : stmt(stmt) {};
    void output(int level);
};

class SeqNode : public StmtNode
{
private:
    StmtNode *stmt1, *stmt2;
public:
    SeqNode(StmtNode *stmt1, StmtNode *stmt2) : stmt1(stmt1), stmt2(stmt2){};
    void output(int level);
};

class DeclStmt : public StmtNode
{
private:
    Id *id;
public:
    DeclStmt(Id *id) : id(id){};
    void output(int level);
};

class IfStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *thenStmt;
public:
    IfStmt(ExprNode *cond, StmtNode *thenStmt) : cond(cond), thenStmt(thenStmt){};
    void output(int level);
};

class IfElseStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *thenStmt;
    StmtNode *elseStmt;
public:
    IfElseStmt(ExprNode *cond, StmtNode *thenStmt, StmtNode *elseStmt) : cond(cond), thenStmt(thenStmt), elseStmt(elseStmt) {};
    void output(int level);
};

class WhileStmt : public StmtNode
{
private:
	ExprNode *cond;
	StmtNode *loopStmt;
public:
	WhileStmt(ExprNode *cond,StmtNode *loopStmt):cond(cond),loopStmt(loopStmt){};
	void output(int level);
};

class ReturnStmt : public StmtNode
{
private:
    ExprNode *retValue;
public:
    ReturnStmt(ExprNode*retValue) : retValue(retValue) {};
    void output(int level);
};
class ExpStmt : public StmtNode
{

private:
    ExprNode *expr1;
public :
    ExpStmt(ExprNode* expr1): expr1(expr1){};
    void output(int level);
};
class AssignStmt : public StmtNode
{
private:
    ExprNode *lval;
    ExprNode *expr;
public:
    AssignStmt(ExprNode *lval, ExprNode *expr) : lval(lval), expr(expr) {};
    void output(int level);
};

class IDListElement
{
private:
	std::string name;
	ExprNode* val;
public:
	IDListElement(std::string name,ExprNode* val):name(name),val(val){}
	bool isInit()const {return val!=nullptr;}
	std::string getName()const {return name;}
	ExprNode* getVal()const {return val;}
};

class IDList
{
public:
	std::vector<IDListElement *> list;
	void insert(IDListElement *s){list.push_back(s);}
};

class FunctionDef : public StmtNode
{
private:
    SymbolEntry *se;
    StmtNode *stmt;
public:
    FunctionDef(SymbolEntry *se, StmtNode *stmt) : se(se), stmt(stmt){};
    void output(int level);
};

class Ast
{
private:
    Node* root;
public:
    Ast() {root = nullptr;}
    void setRoot(Node*n) {root = n;}
    void output();
};

#endif
