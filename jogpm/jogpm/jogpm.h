//
//  jogpm.h
//  jogpm
//
//  Created by mrdog233o5 on 16/11/2023.
//

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <time.h>
#include <stdlib.h>
#include <curl/curl.h>

CURL *curl_easy_init();

struct MemoryStruct {
    char* memory;
    size_t size;
};

char*   genPassword     (char* charsToUse, int ctuLen, int length);
char*   gen             (int length, bool Char, bool Num, bool Syb);
size_t  WriteCallback   (void* contents, size_t size, size_t nmemb, struct MemoryStruct* data);
char*   reqGet             (const char* url, char *headers[], int headerNum);
void    reqPost            (const char* url, const char* body, const char* headerStuff[], int headerAmount);


char* gen(int length, bool Char, bool Num, bool Syb) {

    const char* chars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
    const char* nums = "1234567890";
    const char* symbols = "!@#$%^&*-_+=";
    char charsToUse[100];
    static char password[100];
    strcpy(password, "");
    strcpy(charsToUse, "");
    
    // check generating flags
    if (Char == true)
        strcat(charsToUse, chars);
    
    if (Num == true)
        strcat(charsToUse, nums);

    if (Syb == true)
        strcat(charsToUse, symbols);

    strcpy(password, genPassword(charsToUse, strlen(charsToUse), length));
    return password;
}

char* genPassword(char* charsToUse, int ctuLen, int length) {
    int index;
    char* password = malloc((length + 1) * sizeof(char));
    password[0] = '\0';
    srand(time(0));

    for (int i = 0; i < length; i++) {
        index = rand() % ctuLen;
        strncat(password, &charsToUse[index], 1);
    }
        
    return password;
}

size_t WriteCallback(void* contents, size_t size, size_t nmemb, struct MemoryStruct* data) {
    size_t totalSize = size * nmemb;
    data->memory = realloc(data->memory, data->size + totalSize + 1);
    if (data->memory == NULL) {
        printf("Failed to allocate memory!\n");
        return 0;
    }
    memcpy(&(data->memory[data->size]), contents, totalSize);
    data->size += totalSize;
    data->memory[data->size] = '\0';
    return totalSize;
}

char* reqGet(const char* url, char* headers[], int headerNum) {
    struct MemoryStruct response;
    response.memory = malloc(1);
    response.size = 0;

    CURL* curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

        struct curl_slist* headerList = NULL;
        for (int i = 0; i < headerNum; i++) {
            headerList = curl_slist_append(headerList, headers[i]);
        }
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headerList);

        CURLcode res = curl_easy_perform(curl);
        curl_slist_free_all(headerList);
        curl_easy_cleanup(curl);

        if (res != CURLE_OK) {
            free(response.memory);
            return "";
        }
    }

    return response.memory;
}

void reqPost(const char* url, const char* body, const char* headerStuff[], int headerAmount) {
    CURL *curl;
    CURLcode res;
    struct curl_slist *headers = NULL;

    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url);

        for (int i = 0; i < headerAmount; i++) {
            headers = curl_slist_append(headers, headerStuff[i]);
        }
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body);

        res = curl_easy_perform(curl);
        if (res != CURLE_OK) return;

        curl_easy_cleanup(curl);
        curl_slist_free_all(headers);
    }
    curl_global_cleanup();
}
