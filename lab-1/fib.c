int fib(int n){
	if(n<=0)return 0;
	int pre0=0;
	int pre1=1;
	int temp=0;
	for(int i=1;i<=n;i++){
		temp=pre0+pre1;
		pre0=pre1;
		pre1=temp;
	}
	return pre1;
}

int main(){
	int a,b;
	a=getint();
	b=fib(a);
	putint(b);
	return 0;
}
