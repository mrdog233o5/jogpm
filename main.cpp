#include <cstring>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

string genPassword(vector<const char*> charsToUse, int length) {
    int index;
    string password;
    srand(time(0));

    for (int i = 0; i < length; i++) {
        index = rand() % charsToUse.size();
        password += charsToUse[index][rand() % strlen(charsToUse[index])];
    }
    return password;
}

bool usrChoice(string question, bool defaultAns) {
    string result;
    cout << question;
    if (defaultAns) {
        cout << " (Y,n) > ";
        getline(cin, result);
        if (result == "n")
            return 0;
        return 1;
    } else {
        cout << " (y,N) > ";
        getline(cin, result);
        if (result == "y")
            return 1;
        return 0;
    }
}

int main(int argc, char *argv[]) {

    if (argc == 1) {
        cout << "no mode given" << endl;
        return 1;
    }
    
    string mode = argv[1];
    if (mode == "help") {

        system("cat ./guide.txt");

    } else if (mode == "init") {

        system("./setup.sh");

    } else if (mode == "gen") {

        const char* chars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
        const char* nums = "1234567890";
        const char* symbols = "_.-";
        const char* symbolsSpecial = "~!@#$%^&*()_+`-={}|[]\\:;\"',<.>/?";
        vector<const char*> charsToUse;
        bool passwordAccepted = 0;
        string password;
        int tm;

        // check generating flags
        for (int i = 3; i < argc; i++) {
            if (strcmp(argv[i], "--char") == 0)
                charsToUse.push_back(chars);
            
            if (strcmp(argv[i], "--num") == 0)
                charsToUse.push_back(nums);
            if (strcmp(argv[i], "--syb") == 0)
                charsToUse.push_back(symbols);
            if (strcmp(argv[i], "--sybSpec") == 0)
                charsToUse.push_back(symbolsSpecial);
        }



        while (!passwordAccepted) {
            cout << "generating password" << endl;
            while (tm == time(0)) {}
            password = genPassword(charsToUse, stoi(argv[2]));
            cout << password << endl;
            passwordAccepted = usrChoice("use this passowrd", 0);
            cout << endl;
            tm = time(0);
        }
        cout << "your password > " << password << endl;

    } else {
        cout << "mode not found" << endl;
    }

    return 0;
}
