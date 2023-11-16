#include <stdio.h>
#include <string.h>
#include <curl/curl.h>
#include <stdbool.h>
#include <time.h>
#include <stdlib.h>
 

char*   account         (int line);
char*   genPassword     (char* charsToUse, int ctuLen, int length);

int main(int argc, char *argv[]) {

    if (argc == 1) {
        printf("<rtfm>");
        return 1;
    }
    
    const char* mode = argv[1];
    if (strcmp(mode, "gen") == 0) {
        const char* chars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
        const char* nums = "1234567890";
        const char* symbols = "!@#$%^&*-_+=";
        char charsToUse[100];
        int passwordLen = 0;
        passwordLen = atoi(argv[2]);
        char password[100];
        
        // check argument amounts
        if (argc < 4) {
            printf("<missing argv>");
            return 1;
        }

        // check generating flags
        for (int i = 3; i < argc; i++) {
            if (strcmp(argv[i], "--char") == 0)
                strcat(charsToUse, chars);
            
            if (strcmp(argv[i], "--num") == 0)
                strcat(charsToUse, nums);

            if (strcmp(argv[i], "--syb") == 0)
                strcat(charsToUse, symbols);
        }

        strcpy(password, genPassword(charsToUse, strlen(charsToUse), passwordLen));
        printf("%s", password);

    } else {
        printf("<cmd not found>");
        return 1;
    }

    return 0;
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
