#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(){

	//Static allocation
	int *p;
	int n,d;

	printf("Please input the size of array N=");
	scanf("%d",&n);
	printf("\n");

	p=(int*) malloc(n*sizeof(int));

	printf("Print initial values\n");
	for(int i=0;i<n;i++){
		//printf("%d ",d[i]);
		printf("%d ",*(p+i));
	}
	printf("\n\n");

	for(int i=0;i<n;i++){
		//d[i]=i;
		*(p+i)=i;
	}

	printf("Print values after init\n");

	

	for(int i=0;i<n;i++){
		//printf("%d ",d[i]);
		printf("%d ",p[i]);
	}

	printf("\n\n");

	free(p);

	return 0;
}

