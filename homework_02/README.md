PART 1 - FLEX  
-------------------
Compilation
flex -o gpp_lexer.c gpp_lexer.l  
gcc gpp_lexer.c -o gpp_lexer  

run :
./gpp_lexer  

- If test file wanted to be used, it can be passed as an argument.
- Lexer is tested with test1.g++, test2.g++, input.txt files.
- Program terminates if exit keyword is entered.

PART 2 - LISP  
-------------------
Compilation  
clisp gpp_lexer.lisp  

- If test file wanted to be used, it can be passed as an argument.
- Lexer is tested with test1.g++, test2.g++, input.txt files.
- Program terminates if lexical error occurs.  
