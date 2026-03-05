%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <strings.h>

#define NHASH 9997
#define MULT  31

/* Definimos estructura */
struct sym {
    char *name;
    int count;
    struct sym *next;
};

/* Tabla hash */
struct sym *symtab[NHASH];

unsigned symhash(char *sym);
struct sym *lookup(char *sym);
void print_symtab(void);
%}

WORD    [A-Za-z]+

%%

{WORD} {
    struct sym *sp = lookup(yytext);
    sp->count++;
}

.   ;
\n  ;

%%

/* Hash usando tolower() */
unsigned symhash(char *sym)
{
    unsigned int hash = 0;
    unsigned c;

    while((c = *sym++))
        hash = hash * MULT + tolower(c);

    return hash % NHASH;
}

/* Lookup usando strcasecmp() */
struct sym *lookup(char *sym)
{
    struct sym *sp;
    unsigned int hash = symhash(sym);

    for(sp = symtab[hash]; sp; sp = sp->next) {
        if(strcasecmp(sp->name, sym) == 0)
            return sp;
    }

    sp = malloc(sizeof(struct sym));
    if(!sp) {
        fprintf(stderr, "out of memory\n");
        exit(1);
    }

    sp->name = strdup(sym);
    sp->count = 0;
    sp->next = symtab[hash];
    symtab[hash] = sp;

    return sp;
}

void print_symtab(void)
{
    int i;
    struct sym *sp;

    for(i = 0; i < NHASH; i++) {
        for(sp = symtab[i]; sp; sp = sp->next) {
            printf("%s\t%d\n", sp->name, sp->count);
        }
    }
}

int main(int argc, char **argv)
{
    if(argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if(!file) {
            perror(argv[1]);
            return 1;
        }
        yyin = file;
    }

    yylex();
    print_symtab();
    return 0;
}
