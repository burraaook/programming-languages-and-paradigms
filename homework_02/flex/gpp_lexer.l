
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	/* function for tokenizing valuestr */
	void get_str_val(char* str);
	
	/* flag for indicating " state */
	int is_closed = 1;
	
%}

VALUEI    	[1-9]+[0-9]*|[0]
VALUEF   	([1-9]+[0-9]*|[0])[f]([1-9]+[0-9]*)
IDENTIFIER  [_a-zA-Z][_a-zA-Z0-9]*
COMMENT 	[;]{2}.*
SKIP		[ \n\r\t]
INVALIDIDT	[0-9]+[_a-zA-Z]+
INVALIDVAL	[0]+[0-9]+
VALUESTR 	["].*["]
INVALIDFVAL ([1-9]+[0-9]*|[0])[f]([0]+[1-9]*)


%%

and 		{ printf("%s: KW_AND\n", yytext) ;}
or			{ printf("%s: KW_OR\n", yytext); }
not			{ printf("%s: KW_NOT\n", yytext); }
equal 		{ printf("%s: KW_EQUAL\n", yytext); }
less		{ printf("%s: KW_LESS\n", yytext); }
nil			{ printf("%s: KW_NIL\n", yytext); }	
list 		{ printf("%s: KW_LIST\n", yytext) ;}
append		{ printf("%s: KW_APPEND\n", yytext); }
concat		{ printf("%s: KW_CONCAT\n", yytext); }
set 		{ printf("%s: KW_SET\n", yytext); }
deffun		{ printf("%s: KW_DEFFUN\n", yytext); }
for			{ printf("%s: KW_FOR\n", yytext); }	
if 			{ printf("%s: KW_IF\n", yytext) ; }
exit		{ printf("%s: KW_EXIT\n", yytext);	return 0; }
load		{ printf("%s: KW_LOAD\n", yytext); }
disp 		{ printf("%s: KW_DISP\n", yytext); }
true		{ printf("%s: KW_TRUE\n", yytext); }
false		{ printf("%s: KW_FALSE\n", yytext); }

"+"		{ printf("%s: OP_PLUS\n", yytext); }
"-"		{ printf("%s: OP_MINUS\n", yytext); }
"/"		{ printf("%s: OP_DIV\n", yytext); }
"*"		{ printf("%s: OP_MULT\n", yytext); }
"("		{ printf("%s: OP_OP\n", yytext); }
")"		{ printf("%s: OP_CP\n", yytext); }
"**"	{ printf("%s: OP_DBLMULT\n", yytext); }
"\""	{ 
			if (is_closed == 1) {printf("%s: OP_OC\n", yytext);}
			else {printf("%s: OP_CC\n", yytext);} 
			is_closed = is_closed * -1;
		}
","		{ printf("%s: OP_COMMA\n", yytext); }
	
{COMMENT} { printf("%s: COMMENT\n", ";;"); }
	
{VALUEI} { printf("%s: VALUEI\n", yytext); }
{VALUEF} { printf("%s: VALUEF\n", yytext); }

{IDENTIFIER} { printf("%s: IDENTIFIER\n", yytext); }

{INVALIDIDT} { printf("LEXICAL ERROR:  %s is not valid identifier.\n", yytext); }
{INVALIDVAL} { printf("LEXICAL ERROR:  %s is not valid value.\n", yytext); }
{INVALIDFVAL} { printf("LEXICAL ERROR:  %s is not valid fractional value.\n", yytext); }
{VALUESTR} { get_str_val(yytext); }
{SKIP} {;}

.	{ printf("LEXICAL ERROR:  %s cannot be tokenized\n", yytext); }
%%

/* prints the valuestr token */
void get_str_val(char * str) {
	char* temp = malloc((strlen(str) + 1)*sizeof(char));
	strcpy(temp, str);
	temp[strlen(str) - 1] = '\0';
	temp = &temp[1];
	printf("%c: OP_OC\n%s: VALUESTR\n%c: OP_CC\n",str[0], temp, str[strlen(str) - 1]);
}

int yywrap(void) { return 1; }	

int main(int argc, char **argv) {
	if (argc > 1) {
		yyin = fopen(argv[1], "r");
		if (yyin == NULL) {
			printf("File does not exist.\n");
			return 0;
		}
	}
	yylex();

	return 0;
}

