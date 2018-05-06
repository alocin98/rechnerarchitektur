#include <stdio.h>
#include <stdlib.h>

int main(){
	
	int a=10;
	int *p=&a;

	printf("Value of a %d\n",a);
	printf("Address of pointer p is %p\n",p);
	printf("Pointer p is pointing to value %d\n",*p);
	printf("\n\n\n");
	
	a=20;

	printf("Value of a %d\n",a);
	printf("Address of pointer p is %p\n",p);
	printf("Pointer p is pointing to value %d\n",*p);
	printf("\n\n\n");

	*p=7;

	printf("Value of a %d\n",a);
	printf("Address of pointer p is %p\n",&p);
	printf("Pointer p is pointing to value %d\n",*p);


	return 0;
}

