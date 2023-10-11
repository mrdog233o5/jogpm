#!/opt/homebrew/bin/python3

from sys import argv
import termlib
import random

def main():
    prt=termlib.printer()
    commandList = [
        ["-h | help", "list all commands"],
        ["gen", "generate password"],
    ]
    argc = len(argv)

    if argc > 1:
        if getArg("mode",1) in ["help"]:
            prt.printgrid(commandList, space=15)
        elif argv[1] == "gen":
            generatePassword(int(getArg("length", 2)), argc)
        else:
            print("command not found")
            exit(1)
    else:
        print("use help for a list of command")
        exit(1)

def generatePassword(passwordLength, argc):
    allChars = {
        "char":list("qwertyuiopasdfghjklzxcvbnm"),
        "num":list("11234567890"),
        "symbol":"_.",
        "symbolSpecial":"`~!@#$%^&*()-=+[]{}\\|;:'\",./<>?",
    }
    charUsed = {
        "char":False,
        "num":False,
        "symbol":False,
        "symbolSpecial":False
    }
    outputPassword = ""
    charToUse=[]
    for i in range(3,argc):
        if argv[i].startswith("--") and argv[i][2:] in list(charUsed.keys()):
            charUsed[argv[i][2:]] = True
            print(argv[i])
        else:
            print(f"{argv[i]} not found")
    for i in list(charUsed.keys()):
        if charUsed[i]:
            charToUse+=allChars[i]
    for i in range(passwordLength):
        outputPassword+=random.choice(charToUse)
    print(outputPassword)

def getArg(name, place):
    value = ""
    try:
        value = argv[place]
    except IndexError:
        print(f"Missing argument: {name}")
    return value

if __name__ == "__main__":
    main()
