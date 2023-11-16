//
//  jogpm.h
//  test
//
//  Created by mrdog233o5 on 16/11/2023.
//

#ifndef jogpm_h
#define jogpm_h

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <time.h>
#include <stdlib.h>
 

char*   account         (int line);
char*   genPassword     (char* charsToUse, int ctuLen, int length);
char*   gen             (int len, bool Char, bool Num, bool Syb);

char* gen(int len, bool Char, bool Num, bool Syb) {

    const char* chars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
    const char* nums = "1234567890";
    const char* symbols = "!@#$%^&*-_+=";
    char charsToUse[100] = "";
    char password[100] = "";
    strcpy(password, "");
    strcpy(charsToUse, "");
    
    // check generating flags
    if (Char == true)
        strcat(charsToUse, chars);
    
    if (Num == true)
        strcat(charsToUse, nums);

    if (Syb == true)
        strcat(charsToUse, symbols);

    strcpy(password, genPassword(charsToUse, strlen(charsToUse), len));
    printf("%s", password);
    return password;
}

char* genPassword(char* charsToUse, int ctuLen, int length) {
    int index;
    char* password;
    strcpy(password, "");
    srand(time(0));

    for (int i = 0; i < length; i++) {
        index = rand() % ctuLen;
        strncat(password, &charsToUse[index], 1);
    }
    return password;
}


#endif jogpm_h
