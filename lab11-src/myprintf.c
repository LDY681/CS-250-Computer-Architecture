//For this lab, we will implement 
//c,s,x,d,%
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

//need to declare printx and printd here otherwist implicit declaration
void printx(int i);
void printd(int i);

int myprintf(const char *format, ...){
	//we make a char* arg pointed to the address of format
	//we increment arg to get the next address, where other arguments are located
	int *args = (int*)&format;
	args++;
	int len = strlen(format);


	int i;
	for (i = 0; i < len; i++){
		if (format[i] == '%'){
			if (format[i+1] == 'c'){	//need to get next char
				int arg = *args;
				putchar(arg);
				args++;
				i++;
			}else if(format[i+1] == 's'){	//need to get next string
				//(char*)args is the type char pointer of args
				//(char**)args is the type char pointer to the char pointer of args
				//which is like a group of pointers pointing to (char*)args
				//so we can read multiple chars
				char *str = *(char**)args;
				int len1 = strlen(str);
				int j;
				for (j = 0 ; j < len1;j++){
					putchar(str[j]);
				}
				args++;
				i++;
			}else if (format[i+1] == 'x'){	//need to get next hex
				int arg = *args;
				printx(arg);
				args++;
				i++;
			}else if (format[i+1] == 'd'){	//need to get next integer
				int arg = *args;
				if (arg == -2147483648){
					putchar('-');
					putchar('2');
					putchar('1');
					putchar('4');
					putchar('7');
					putchar('4');
					putchar('8');
					putchar('3');
					putchar('6');
					putchar('4');
					putchar('8');
				}else{
					printd(arg);
				}
				args++;
				i++;
				
			}else{	//just print %
				putchar('%');
			}		
		}
		else{	//case ", \n etc"
				putchar(format[i]);
		}
	}
	

}
