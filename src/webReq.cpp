#include <curl/curl.h>
#include <string>

CURL *curl_easy_init();

void post(std::string url, std::string body, std::string *headerStuff, int headerAmount) {
    CURL *curl;
    CURLcode res;
    
    // init
    curl_global_init(CURL_GLOBAL_ALL);
    
    // Create a curl handle
    curl = curl_easy_init();
    if (curl) {
        // Set the URL
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        
        // headers
        struct curl_slist *headers = nullptr;
        for (int i = 0; i < headerAmount; i++) headers = curl_slist_append(headers, headerStuff[i].c_str());


        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
        
        // body
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body.c_str());
        
        // post
        res = curl_easy_perform(curl);
        
        // check bugs
        if (res != CURLE_OK)
            printf("FUCK\n");
            return;
        
        // cleanup
        curl_easy_cleanup(curl);
        
        // Free the headers list
        curl_slist_free_all(headers);
        printf("BRUH\n");
}
    
    // Cleanup libcurl
    curl_global_cleanup();
    printf("GUD\n");
}