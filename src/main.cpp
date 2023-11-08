#include <cstring>
#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <curl/curl.h>
#include "./webReq.cpp"
 
using namespace std;


bool    usrChoice       (string question, bool defaultAns);
string  osys            (const string& command);
void    copy            (string content);
string  account         (int line);
void    savePassword    (string passwordName, string password);
string  genPassword     (vector<const char*> charsToUse, int length);
string  getPassword     (string passwordName);

int main(int argc, char *argv[]) {

    if (argc == 1) {
        cout << "Use: 'man jogpm' OR 'jogpm help' for more information" << endl;
        return 1;
    }
    
    string mode = argv[1];
    if (mode == "help") {
        system("man jogpm");
    } else if (mode == "gen") {
        const char* chars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
        const char* nums = "1234567890";
        const char* symbols = "_.-";
        const char* symbolsSpecial = "~!@#$%^&*()_+`-={}|[]\\:;\"',<.>/?";
        vector<const char*> charsToUse;
        bool passwordAccepted = 0;
        string password;
        int tm;
        bool copyPassword = false;
        
        // check argument amounts
        if (argc < 4) {
            cout << "Usage: jogpm gen <length> <flags>" << endl << "Missing argument, run 'man jogpm' for more information" << endl;
            return 1;
        }

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
            if (strcmp(argv[i], "--cp") == 0)
                copyPassword = true;
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

        //copy password
        if (copyPassword) {
            copy(password);
            cout << "Password copied to clipboard!" << endl;
        }

        bool saveGenedPassword = usrChoice("save this password", 1);
        if (saveGenedPassword) {
            string passwordName;
            cout << "Where will this password be used > ";
            cin >> passwordName;
            savePassword(passwordName, password);
            cout << endl << "Password saved!" << endl << "password name: " << passwordName << endl << "password value: " << password << endl;
        }
    } else if (strcmp(argv[1], "save") == 0) {
        savePassword(argv[2], argv[3]);
    } else if (strcmp(argv[1], "signup") == 0) {
        string headers[] = {"username:mrdog233o5", "password:root"};
        post("https://jogpm-backend.vercel.app/signup", "{}", headers, 2);
    } else if (strcmp(argv[1], "get") == 0) {
        string password = getPassword(argv[2]);
        cout << "password named " << argv[2] << " : " << password << endl;
        for (int i = 2; i < argc; i++) {
            if (strcmp(argv[i], "--cp") == 0) {
                copy(password);
                cout << "Password copied to clipboard!" << endl;
            }
        }

    } else {
        cout << "read the manual: man jogpm" << endl;
        return 1;
    }

    return 0;
}



void setup() {
    ifstream fin;
    string user = getenv("USER");
    string file = "/Users/"+user+"/.jogpm/setup.conf";
    string settedUp = "0";

    fin.open(file, ios::in);
    getline(fin, settedUp);
    fin.close();

    if (settedUp == "0") return; // check if setted up already

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

string osys(const string& command) {
    string result;
    char buffer[128];

    FILE* pipe = popen(command.c_str(), "r");

    while (fgets(buffer, sizeof(buffer), pipe) != nullptr) {
        result += buffer;
    }

    pclose(pipe);

    return result;
}

void copy(string content) {
    string command = "echo \"";
    command += content;
    command += "\" | pbcopy";
    system(command.c_str());
}

string account(int lineNeeded) {
    string USER = getenv("USER");
    string accountFile = "/Users/" + USER + "/.jogpm/account.conf";
    string contents[2];

    FILE *fp = fopen(accountFile.c_str(), "r");
    if (fp == nullptr) {
        printf("Failed to open the file.\n");
        return "";
    }
    int size = 128;
    int temp = 0;
    char buffer[size];
    string bufferStr;
    while (fgets(buffer, size, fp) != nullptr) {
        bufferStr = buffer;
        bufferStr.erase(remove(bufferStr.begin(), bufferStr.end(), '\n'), bufferStr.end());
        contents[temp] = bufferStr;
        temp++;
    }

    fclose(fp);
    return contents[lineNeeded];
}

void savePassword(string passwordName, string password) {
    string headers[] = {"username:"+account(0), "password:"+account(1)};
    post("https://jogpm-backend.vercel.app/set", "{'passwordName':'"+passwordName+"', 'password': '"+password+"'}", headers, 2);
}

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

string getPassword(string passwordName) {
    string password;
    string headers[] = {"username:"+account(0), "password:"+account(1), "passwordName:"+passwordName};
    password = get("https://jogpm-backend.vercel.app/get", headers, 3);
    return password;
}
