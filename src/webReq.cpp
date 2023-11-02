#include <curl/curl.h>
#include <string>

CURL *curl_easy_init();

void post(std::string url, std::string body, std::string *headerStuff, int headerAmount) {
    CURL *curl;
    CURLcode res;
    
    // Initialize the libcurl
    curl_global_init(CURL_GLOBAL_ALL);
    
    // Create a curl handle
    curl = curl_easy_init();
    if (curl) {
        // Set the URL
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        
        // Set the request headers
        struct curl_slist *headers = nullptr;
        for (int i = 0; i < headerAmount; i++) headers = curl_slist_append(headers, headerStuff[i].c_str());


        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
        
        // BODY
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body.c_str());
        
        // Perform the request
        res = curl_easy_perform(curl);
        
        // Check for errors
        if (res != CURLE_OK)
            return;
        
        // Cleanup
        curl_easy_cleanup(curl);
        
        // Free the headers list
        curl_slist_free_all(headers);
    }
    
    // Cleanup libcurl
    curl_global_cleanup();
}
