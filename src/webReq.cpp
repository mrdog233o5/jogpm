#include <curl/curl.h>
#include <string>

CURL *curl_easy_init();

// (TOTALLY NOT WRITTEN BY GPT)
size_t WriteCallback(void* contents, size_t size, size_t nmemb, std::string* response) {
    size_t totalSize = size * nmemb;
    response->append(static_cast<char*>(contents), totalSize);
    return totalSize;
}

// GET REQ (TOTALLY NOT WRITTEN BY GPT)
std::string get(const std::string& url, std::string *headers, int headerNum) {
    std::string response = "";
    CURL* curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
        struct curl_slist* headerList = nullptr;
        for (int i = 0; i < headerNum; i++) headerList = curl_slist_append(headerList, headers[i].c_str());
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headerList);
        CURLcode res = curl_easy_perform(curl);
        curl_slist_free_all(headerList);
        curl_easy_cleanup(curl);
        if (res != CURLE_OK) return "";
    }
    return response;
}

// POST REQ (TOTALLY NOT WRITTEN BY GPT)
void post(std::string url, std::string body, std::string *headerStuff, int headerAmount) {
    CURL *curl;
    CURLcode res;
    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        struct curl_slist *headers = nullptr;
        for (int i = 0; i < headerAmount; i++) headers = curl_slist_append(headers, headerStuff[i].c_str());
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body.c_str());
        res = curl_easy_perform(curl);
        if (res != CURLE_OK) return;
        curl_easy_cleanup(curl);
        curl_slist_free_all(headers);
    }
    curl_global_cleanup();
}
