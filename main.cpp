#include <charconv>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <iterator>
#include <string>

using namespace std;

string genPassword(const char* chars, int length) {
    string password;
    srand(time(nullptr));
    for (int i = 0; i < length; i++) {
        password += chars[rand() % sizeof(chars)/sizeof(chars[0])];
    }
    return password;
}

int main(int argc, char *argv[]) {
    const char *chars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
    const char *nums = "1234567890";
    const char *symbols = "~!@#$%^&*()_+`-={}|[]\\:;\"',<.>/?";
    cout << genPassword(chars, 8);

    return 0;
}
