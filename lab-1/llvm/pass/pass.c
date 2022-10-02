#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int fib(int n){
	if(n<=1)return 1;
	return n*fib(n-1);
}

const int a=10;


void bar(){
	return;
}

void foo(){
	bar();
}


int main(){
	int *arr = (int*)malloc(a*(sizeof(int)));
	int b=a*a;
	int op;
	scanf("%d",&op);
	switch(op){
		case 1:
		for(int i=0;i<a;i++){
			while(b--){
				printf("%d",fib(b));	
			}
		}
		break;
		
		case 2:
		foo();
		break;
	}
	for(int i=0;i<a;i++){
		arr[i]=i;
	}
	int sum=0;
	for(int i=0;i<a;i++){
	   	sum+=i;
    }
	if(0){
		for(int i=0;i<a;i++){ 	
        	arr[i]=i;
        }
	}
	return 0;
}




