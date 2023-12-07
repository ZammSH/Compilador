/*PROYECTO 1. EQUIPO 7: Hinojosa Ruiz Zianya Samanta, Coronilla Hernandéz Emmanuel, Arriaga Saldaña Jonathan Esaú.*/
%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
void yyerror(const char *); /*Declaración de Funciones*/
void count();
char *buff; /*Declaración de variables*/
int bufflen = 0;
int column = 0;
int nlines =1;
enum {
	VOIDVAL = 0,
	CHARVAL,
	INTVAL,
	DOUBLEVAL
};
%}
H			[0-9a-fA-F]
VARNAME		[a-zA-Z_][a-zA-Z0-9_]*
IS			[uUlL]|[lL][uU]|[uU][lL]
E			[Ee][+-]?[0-9]+
FS			[fFlL]

%x INCOMMENT INSTRING INCHAR
%%
"/*"			{ count(); BEGIN INCOMMENT;}
<INCOMMENT>"*/" { count(); BEGIN INITIAL;}
<INCOMMENT>.|\n { count();}
<INCOMMENT><<EOF>>	{yyerror("ERROR: Comentario sin fin de comentario!\n");}
^"#".*			{ count();}
"auto"			{ count(); return(AUTO); }
"break"			{ count(); return(BREAK); }
"case"			{ count(); return(CASE); }
"char"			{ count(); return(CHAR); }
"const"			{ count(); return(CONST); }
"continue"		{ count(); return(CONTINUE); }
"default"		{ count(); return(DEFAULT); }
"do"			{ count(); return(DO); }
"double"		{ count(); return(DOUBLE); }
"else"			{ count(); return(ELSE); }
"enum"			{ count(); return(ENUM); }
"extern"		{ count(); return(EXTERN); }
"float"			{ count(); return(FLOAT); }
"for"			{ count(); return(FOR); }
"goto"			{ count(); return(GOTO); }
"if"			{ count(); return(IF); }
"int"			{ count(); return(INT); }
"long"			{ count(); return(LONG); }
"register"		{ count(); return(REGISTER); }
"return"		{ count(); return(RETURN); }
"short"			{ count(); return(SHORT); }
"signed"		{ count(); return(SIGNED); }
"sizeof"		{ count(); return(SIZEOF); }
"static"		{ count(); return(STATIC); }
"struct"		{ count(); return(STRUCT); }
"switch"		{ count(); return(SWITCH); }
"typedef"		{ count(); return(TYPEDEF); }
"union"			{ count(); return(UNION); }
"unsigned"		{ count(); return(UNSIGNED); }
"void"			{ count(); return(VOID); }
"volatile"		{ count(); return(VOLATILE); }
"while"			{ count(); return(WHILE); }
{VARNAME}		{ count(); 
					yylval.name = strdup(yytext);
						return(IDENTIFIER);
				}
0[xX][0-9a-fA-F]+	{	count(); 
						yylval.ival = strtol(yytext+2, NULL, 16);
						yylval.valtype = INTVAL;
						return CONSTANT;
					}
0[0-7]*		    { count();
					yylval.ival = strtol(yytext+1, NULL, 8);
					yylval.valtype = INTVAL;
					return CONSTANT;
				}
[0-9]+{IS}?		{ count();  
					yylval.ival = strtol(yytext, NULL, 10);
					yylval.valtype = INTVAL;
					return CONSTANT;
				}

[0-9]+\.[0-9]*({E})?{FS}?	{ count(); 
								yylval.dval = atof(yytext);
								yylval.valtype = DOUBLEVAL;
								return CONSTANT;
							}
[0-9]*\.[0-9]+({E})?{FS}?	{ count(); 
								yylval.dval = atof(yytext);
								yylval.valtype = DOUBLEVAL;
								return CONSTANT;
							}
L?\"				{	BEGIN INSTRING;
						buff = (char *)malloc(1);
						buff[0] = 0;
						bufflen = 0;
					}
<INSTRING>\\[0-7]{1,3}	{	buff = (char *)realloc(buff, bufflen+2);
							buff[bufflen] = strtol(yytext+1, NULL, 8);
							bufflen++;
						}
<INSTRING>\\x{H}{1,2}	{	buff = (char *)realloc(buff, bufflen+2);
							buff[bufflen] = strtol(yytext+2, NULL, 16);
							bufflen++;
						}
<INSTRING>\\.		{	buff = (char *)realloc(buff, bufflen+2);
						switch(yytext[1]){
							case 'a':
								buff[bufflen] = '\a';
								break;
							case 'b':
								buff[bufflen] = '\b';
								break;
							case 'f':
								buff[bufflen] = '\f';
								break;
							case 'n':
								buff[bufflen] = '\n';
								break;
							case 'r':
								buff[bufflen] = '\r';
								break;
							case 't':
								buff[bufflen] = '\t';
								break;
							case 'v':
								buff[bufflen] = '\v';
								break;
							default:
								buff[bufflen] = yytext[1];
								break;
						}
						bufflen++;
					}
<INSTRING>[^\\"]	{	buff = (char *)realloc(buff, bufflen+2);
						buff[bufflen] = yytext[0];
						bufflen++;
					}
<INSTRING>\"		{	BEGIN INITIAL; count();
						yylval.sval = strdup(buff);
						return(STRING_LITERAL);
					}
L?'					{	BEGIN INCHAR;
						buff = (char *)malloc(1);
						buff[0] = 0;
						bufflen = 0;
					}
<INCHAR>\\[0-7]{1,3}	{
							if(bufflen>0)
							{
								printf("Renglón: %d Columna: %d\n", nlines, column);
								yyerror("ERROR: Constante caracater demasiado larga");
							}
							buff[bufflen] = strtol(yytext+1, NULL, 8);
							bufflen++;
						}
<INCHAR>\\x{H}{1,2}		{
							if(bufflen>0)
							{
								printf("Renglón: %d Columna: %d\n", nlines, column);
								yyerror("ERROR: Constante caracater demasiado larga");
							}
							buff[bufflen] = strtol(yytext+2, NULL, 16);
							bufflen++;
						}						
<INCHAR>\\.		{		if(bufflen>0)
						{
							printf("Renglón: %d Columna: %d\n", nlines, column);
							yyerror(".ERROR: Constante caracater demasiado larga");
						}
						switch(yytext[1]){
							case 'a':
								buff[bufflen] = '\a';
								break;
							case 'b':
								buff[bufflen] = '\b';
								break;
							case 'f':
								buff[bufflen] = '\f';
								break;
							case 'n':
								buff[bufflen] = '\n';
								break;
							case 'r':
								buff[bufflen] = '\r';
								break;
							case 't':
								buff[bufflen] = '\t';
								break;
							case 'v':
								buff[bufflen] = '\v';
								break;
							default:
								buff[bufflen] = yytext[1];
								break;
						}
						bufflen++;
					}
<INCHAR>[^\\']		{	if(bufflen>0)
						{
							printf("Renglón: %d Columna: %d\n", nlines, column);
							yyerror("ERROR: Constante caracater demasiado larga");
						}
						buff[bufflen] = yytext[0];
						bufflen++;
					}
<INCHAR>'		{	BEGIN INITIAL; count();
					yylval.cval = buff[0];
					yylval.valtype = CHARVAL;
					return(CONSTANT);
				
				}
"..."		{ count(); return(ELLIPSIS); }
">>="		{ count(); return(RIGHT_ASSIGN); }
"<<="		{ count(); return(LEFT_ASSIGN); }
"+="		{ count(); return(ADD_ASSIGN); }
"-="		{ count(); return(SUB_ASSIGN); }
"*="		{ count(); return(MUL_ASSIGN); }
"/="		{ count(); return(DIV_ASSIGN); }
"%="		{ count(); return(MOD_ASSIGN); }
"&="		{ count(); return(AND_ASSIGN); }
"^="		{ count(); return(XOR_ASSIGN); }
"|="		{ count(); return(OR_ASSIGN); }
">>"		{ count(); return(RIGHT_OP); }
"<<"		{ count(); return(LEFT_OP); }
"++"		{ count(); return(INC_OP); }
"--"		{ count(); return(DEC_OP); }
"->"		{ count(); return(PTR_OP); }
"&&"		{ count(); return(AND_OP); }
"||"		{ count(); return(OR_OP); }
"<="		{ count(); return(LE_OP); }
">="		{ count(); return(GE_OP); }
"=="		{ count(); return(EQ_OP); }
"!="		{ count(); return(NE_OP); }
";"			{ count(); return(';'); }
("{"|"<%")	{ count(); return('{'); }
("}"|"%>")	{ count(); return('}'); }
","			{ count(); return(','); }
":"			{ count(); return(':'); }
"="			{ count(); return('='); }
"("			{ count(); return('('); }
")"			{ count(); return(')'); }
("["|"<:")	{ count(); return('['); }
("]"|":>")	{ count(); return(']'); }
"."			{ count(); return('.'); }
"&"			{ count(); return('&'); }
"!"			{ count(); return('!'); }
"~"			{ count(); return('~'); }
"-"			{ count(); return('-'); }
"+"			{ count(); return('+'); }
"*"			{ count(); return('*'); }
"/"			{ count(); return('/'); }
"%"			{ count(); return('%'); }
"<"			{ count(); return('<'); }
">"			{ count(); return('>'); }
"^"			{ count(); return('^'); }
"|"			{ count(); return('|'); }
"?"			{ count(); return('?'); }

[ \t\v\n\f]	{ count(); }
.			{ /* ignore bad characters */ }

%%

int yywrap()
{
	return(1);
}

void yyerror(const char *msg)
{
	printf("\nError: %s en línea %d columna %d\n", msg, nlines, column+1);
	exit(2);
}

void count()
{
	int i;

	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
		{
			column = 0;
			nlines++;
		}	
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;

	;
}

char * tokens[] = {
	"AUTO",
    "BREAK",
    "CASE",
    "CHAR",
    "CONST",
    "CONTINUE",
    "DEFAULT",
    "DO",
    "DOUBLE",
    "ELSE",
    "ENUM",
    "EXTERN",
    "FLOAT",
    "FOR",
    "GOTO",
    "IF",
    "INT",
    "LONG",
    "REGISTER",
    "RETURN",
    "SHORT",
    "SIGNED",
    "SIZEOF",
    "STATIC",
    "STRUCT",
    "SWITCH",
    "TYPEDEF",
    "UNION",
    "UNSIGNED",
    "VOID",
    "VOLATILE",
    "WHILE",
    "IDENTIFIER",
    "CONSTANT",
    "STRING_LITERAL",
    "ELLIPSIS",
    "RIGHT_ASSIGN",
    "LEFT_ASSIGN",
    "ADD_ASSIGN",
    "SUB_ASSIGN",
    "MUL_ASSIGN",
    "DIV_ASSIGN",
    "MOD_ASSIGN",
    "AND_ASSIGN",
    "XOR_ASSIGN",
    "OR_ASSIGN",
    "RIGHT_OP",
    "LEFT_OP",
    "INC_OP",
    "DEC_OP",
    "PTR_OP",
    "AND_OP",
    "OR_OP",
    "LE_OP",
    "GE_OP",
    "EQ_OP",
    "NE_OP"
};

void print_token(int c)
{
	if(c<256)
	{
		printf("<%c>\n", c);
	}
	else
	{
		switch(c)
		{
			case CONSTANT:
				switch(yylval.valtype)
				{
					case INTVAL:
						printf("<%s, %d>\n", tokens[c-AUTO], yylval.ival);
						break;
					case DOUBLEVAL:
						printf("<%s, %g>\n", tokens[c-AUTO], yylval.dval);
						break;
					case CHARVAL:
                        printf("<%s, \'\\x%02x\'>\n", tokens[c-AUTO], (unsigned char)yylval.cval);
                        break;
                }
                break;
            case IDENTIFIER:
                printf("<%s, \"%s\">\n", tokens[c-AUTO], yylval.name);
                break;
            case STRING_LITERAL:
                printf("<%s, \"%s\">\n", tokens[c-AUTO], yylval.sval);
                break;
            default:
                printf("<%s>\n", tokens[c-AUTO]);
                break;
		}
	}
}