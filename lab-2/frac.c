#include<stdio.h>

int frac(int n){
	if(n<=0)return 0;
	int temp=1;
	for(int i=1;i<=n;i++){
		temp=temp*i;
	}
	return temp;
}

int main(){
	int a,b;
	
	scanf("%d",&a);
	b=frac(a);

	printf("result: %d",b);
	return 0;
}
