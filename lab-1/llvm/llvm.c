int foo(int first,int second){
	return first+second;
}
int a=5;
int main(){
	int b=0;
	for(int i=0;i<4;i++){
		b+=1;
	}
	return foo(a,b);
}

