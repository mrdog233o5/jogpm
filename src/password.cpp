#include <string>
#include <vector>
#include <iostream>
#include <fstream>

std::string genPassword(std::vector<const char*> charsToUse, int length) {
    int index;
    std::string password;
    srand(time(0));

    for (int i = 0; i < length; i++) {
        index = rand() % charsToUse.size();
        password += charsToUse[index][rand() % strlen(charsToUse[index])];
    }
    return password;
}

std::string getPassword(std::string passwordName) {
    std::ifstream fin;
    std::string user = getenv("USER");
    std::string passwordFile = "/Users/"+user+"/.jogpm/passwords/"+passwordName+".passwd";
    std::string password;

    fin.open(passwordFile, std::ios::in);
    if (!fin.is_open()) {
        std::cout << "error occored when reading password file, or password name \"" << passwordName << "\" doesnt exist" << std::endl;
        throw 1;
    }

    getline(fin, password);
    fin.close();

    return password;
}

