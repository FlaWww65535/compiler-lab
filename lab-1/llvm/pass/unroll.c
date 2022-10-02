#include<stdio.h>
int main(){
	int b=0;
	for(int i=0;i<100;i++)
		for(int j=0;j<100;j++)
			b+=10;
	printf("%d",b);
}
