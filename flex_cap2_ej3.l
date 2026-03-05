%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define INITIAL_SIZE 1024
#define LOAD_FACTOR 0.75
#define MULT 31

struct sym {
    char *name;
    int count;
    struct sym *next;
};

struct sym **symtab;
int table_size = INITIAL_SIZE;
int num_symbols = 0;

/* -------- HASH -------- */
unsigned symhash(char *sym)
{
    unsigned int hash = 0;
    unsigned c;

    while ((c = *sym++))
        hash = hash * MULT + tolower(c);

    return hash % table_size;
}

/* -------- REHASH -------- */
void rehash()
{
    int old_size = table_size;
    struct sym **old_tab = symtab;

    table_size *= 2;
    symtab = calloc(table_size, sizeof(struct sym *));
    num_symbols = 0;

    for (int i = 0; i < old_size; i++) {
        struct sym *sp = old_tab[i];
        while (sp) {
            struct sym *next = sp->next;

            unsigned hash = symhash(sp->name);
            sp->next = symtab[hash];
            symtab[hash] = sp;
            num_symbols++;

            sp = next;
        }
    }

    free(old_tab);
}

/* -------- LOOKUP -------- */
struct sym *lookup(char *sym)
{
    unsigned hash = symhash(sym);
    struct sym *sp = symtab[hash];

    while (sp) {
        if (!strcasecmp(sp->name, sym))
            return sp;
        sp = sp->next;
    }
    return NULL;
}

/* -------- ADD -------- */
struct sym *addsym(char *sym)
{
    struct sym *sp = lookup(sym);
    if (sp) return sp;

    if ((float)num_symbols / table_size > LOAD_FACTOR)
        rehash();

    sp = malloc(sizeof(struct sym));
    sp->name = strdup(sym);
    sp->count = 0;

    unsigned hash = symhash(sym);
    sp->next = symtab[hash];
    symtab[hash] = sp;

    num_symbols++;

    return sp;
}

/* -------- SORT -------- */
int compare(const void *a, const void *b)
{
    struct sym *s1 = *(struct sym **)a;
    struct sym *s2 = *(struct sym **)b;
    return strcasecmp(s1->name, s2->name);
}
%}

%%

[[:alpha:]]+    {
                    struct sym *sp = addsym(yytext);
                    sp->count++;
                }

.|\n            ;

%%

int main()
{
    symtab = calloc(table_size, sizeof(struct sym *));

    yylex();

    struct sym **arr = malloc(num_symbols * sizeof(struct sym *));
    int idx = 0;

    for (int i = 0; i < table_size; i++) {
        struct sym *sp = symtab[i];
        while (sp) {
            arr[idx++] = sp;
            sp = sp->next;
        }
    }

    qsort(arr, num_symbols, sizeof(struct sym *), compare);

    for (int i = 0; i < num_symbols; i++)
        printf("%s: %d\n", arr[i]->name, arr[i]->count);

    return 0;
}
