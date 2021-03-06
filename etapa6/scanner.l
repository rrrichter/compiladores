%{
	#include "symbols.h"
	#include "y.tab.h"
	
	int running = 1;
	extern int yylineno;
	extern map_t scannedSymbolsMap;
	
	extern void initMe();
	int isRunning();
	extern int getLineNumber(void);
%}

%option yylineno


%%

char return KW_CHAR;
int return KW_INT;
float return KW_FLOAT;
if return KW_IF;
then return KW_THEN;
else return KW_ELSE;
while return KW_WHILE;
for return KW_FOR;
to return KW_TO;
read return KW_READ;
return return KW_RETURN;
print return KW_PRINT;

[a-zA-Z_][0-9a-zA-Z_]* {
	yylval.symbol = addSymbol(scannedSymbolsMap,TK_IDENTIFIER, yytext, yylineno);
	return TK_IDENTIFIER;
}
\<\= return OPERATOR_LE;
\>\= return OPERATOR_GE;
\=\= return OPERATOR_EQ;
\!\= return OPERATOR_NE;
\&\& return OPERATOR_AND;
\|\| return OPERATOR_OR;

[0-9]+ {
	yylval.symbol = addSymbol(scannedSymbolsMap,LIT_INTEGER, yytext, yylineno);
	return LIT_INTEGER;
}

[0-9]+\.[0-9]+ {
	yylval.symbol = addSymbol(scannedSymbolsMap,LIT_REAL, yytext, yylineno);
	return LIT_REAL;
}

\'.\' {
	yylval.symbol = addSymbol(scannedSymbolsMap,LIT_CHAR, yytext, yylineno);
	return LIT_CHAR;
}

\"([^"]|\\\"|\\n)*\" {
	yylval.symbol = addSymbol(scannedSymbolsMap,LIT_STRING, yytext, yylineno);
	return LIT_STRING;
}

[\-,;:()\[\]{}+\*\/<>=!&$#] return yytext[0];
\/\/.* yylineno++;
"/*"([^*]|\*+[^*/])*\*+"/" ;
[ \t\r\n]+ ;
. return TOKEN_ERROR;

%%

// Funções

void initMe() {
	running = 1;
	initMaps();
}

int yywrap(void) {
	running = 0;
	
	return 1;
}

int getLineNumber(void) {
	return yylineno;
}

int isRunning(void) {
	return running;
}