#include <stdio.h>
#include <stdlib.h>

union mix_t {
  int l;
  struct {
    short hi;
    short lo;
    } s;
  char c[4];
} mix;

int main(){
	
	mix.l=1;
	printf("i: %d\n",mix.l);
	printf("s.hi: %d, s.lo: %d\n",mix.s.hi,mix.s.lo);
	printf("c[0]: %c\n",mix.c[0]);
	printf("c[1]: %c\n",mix.c[1]);
	printf("c[2]: %c\n",mix.c[2]);
	printf("c[3]: %c\n",mix.c[3]);

	printf("\n\n----------------------\n\n\n");
	
	mix.c[0]='H';
	mix.c[1]='o';
	mix.c[2]='l';
	mix.c[3]='a';
	printf("i: %d\n",mix.l);
	printf("s.hi: %d, s.lo: %d\n",mix.s.hi,mix.s.lo);
	printf("c[0]: %c\n",mix.c[0]);
	printf("c[1]: %c\n",mix.c[1]);
	printf("c[2]: %c\n",mix.c[2]);
	printf("c[3]: %c\n",mix.c[3]);
	
	return 0;
}