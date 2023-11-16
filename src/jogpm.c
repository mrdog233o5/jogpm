#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <time.h>
#include <stdlib.h>
 

char*   account         (int line);
char*   genPassword     (char* charsToUse, int ctuLen, int length);
void   gen             (int len, bool Char, bool Num, bool Syb);

int main(int argc, char *argv[])
{
    return 0;
}

void gen(int len, bool Char, bool Num, bool Syb) {

    const char* chars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
    const char* nums = "1234567890";
    const char* symbols = "!@#$%^&*-_+=";
    char charsToUse[100];
    char password[100];
    
    // check generating flags
    if (Char == true)
        strcat(charsToUse, chars);
    
    if (Num == true)
        strcat(charsToUse, nums);

    if (Syb == true)
        strcat(charsToUse, symbols);

    strcpy(password, genPassword(charsToUse, strlen(charsToUse), len));
    printf("%s", password);

}

char* genPassword(char* charsToUse, int ctuLen, int length) {
    int index;
    char* password;
    srand(time(0));

    for (int i = 0; i < length; i++) {
        index = rand() % ctuLen;
        strncat(password, &charsToUse[index], 1);
    }
    return password;
}
