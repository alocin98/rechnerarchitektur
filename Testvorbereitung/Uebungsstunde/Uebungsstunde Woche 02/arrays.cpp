#include <stdio.h>
#include <stdlib.h>

int main(){

	//Static allocation
	int d[10];

	for(int i=0;i<10;i++){
		//printf("%d ",d[i]);
		printf("%d ",*(d+i));
	}

	printf("\n\n");

	for(int i=0;i<10;i++){
		//d[i]=i;
		*(d+i)=i;
	}

	for(int i=0;i<10;i++){
		//printf("%d ",d[i]);
		printf("%d ",*(d+i));
	}

	printf("\n");
	
	return 0;
}

