%{
#include <stdio.h>
%}

%%

[^\n]*\n    {
                printf("Linea leida: %s", yytext);
            }

.           ;

%%

int main() {
    yylex();
    return 0;
}
