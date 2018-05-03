/*
 *
 * author(s):   Cedric Aebi
 *              (Nicolas Mueller)
 * modified:    2010-01-07
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include "memory.h"
#include "mips.h"
#include "compiler.h"
 
int main ( int argc, char** argv ) {
    if(argc < 3){
        printf("%s" "%s " "%s\n","usage: ", argv[0], "expression filename");
    }
    else{
        printf("%s" "%s\n","Input: ",argv[1]);
        printf("%s","Postfix: ");
        compiler(argv[1], argv[2]);
        printf("%s" "%s\n", "MIPS Binary saved to ", argv[2]);
    }
    return EXIT_SUCCESS;

}

