#include "Type.h"
#include <sstream>

IntType TypeSystem::commonInt = IntType(4);
VoidType TypeSystem::commonVoid = VoidType();
ConstIntType TypeSystem::commonConstInt = ConstIntType(4);

Type* TypeSystem::intType = &commonInt;
Type* TypeSystem::voidType = &commonVoid;
Type* TypeSystem::constIntType = &commonConstInt;

std::string IntType::toStr()
{
    return "int";
}

std::string ConstIntType::toStr()
{
	return "const int";
}

std::string VoidType::toStr()
{
    return "void";
}

std::string FunctionType::toStr()
{
    std::ostringstream buffer;
    buffer << returnType->toStr() << "(";
	if(paramsType.size()>0){
		buffer<<paramsType[0]->toStr();
	}
	for(int i=1;i<(int)paramsType.size()&&i<4;i++){
		buffer<<", "<<paramsType[i]->toStr();
		
	}
	if(paramsType.size()>4){buffer<<"...";}
	buffer<<")";
    return buffer.str();
}
