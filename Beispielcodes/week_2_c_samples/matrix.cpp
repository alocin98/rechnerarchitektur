#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(){

	//dynamic allocation
	int **matrix;
	int r,c;

	printf("Please input the number of rows of matrix R=");
	scanf("%d",&r);
	printf("\n");
	printf("Please input the number of cols of matrix C=");
	scanf("%d",&c);
	printf("\n");

	matrix=(int**) malloc(r*sizeof(int*));
	for(int i=0;i<c;i++)
		*(matrix+i)=(int*) malloc(c*sizeof(int));



	printf("Print initial values\n\n");
	for(int i=0;i<r;i++){
		//printf("%d ",d[i]);
		for(int j=0;j<c;j++){
			printf("%d ",*( *(matrix+i)+j ));
		}
		printf("\n");
	}

	printf("Assigning values\n\n");
	for(int i=0;i<r;i++){
		for(int j=0;j<c;j++){
			*( *(matrix+i)+j ) = i+j;
		}
		printf("\n");
	}

	printf("Print assigned values\n\n");
	for(int i=0;i<r;i++){
		for(int j=0;j<c;j++){
			printf("%d ",matrix[i][j]);
		}
		printf("\n");
	}
	printf("\n\n");

	return 0;
}

