#!/opt/homebrew/bin/python3

from sys import argv
import termlib
import random

argv = ["", "gen", "8", "--char", "--num"]

def main():
    prt=termlib.printer()
    commandList = [
        ["-h | help", "list all commands"],
        ["gen", "generate password"],
    ]
    argc = len(argv)
    if argc <= 1:
        print("use help for a list of command")
        exit(1)
    if argc > 1:
        if getArg("mode",1) in ["help"]:
            prt.printgrid(commandList, space=15)
        elif argv[1] == "gen":
            passwordAccepted = False
            passwordLen = int(getArg("length", 2))
            while not passwordAccepted:
                generatePassword(passwordLen, argc)
                passwordAccepted = decide("use this password", True)
        else:
            print("command not found")
            exit(1)

def generatePassword(passwordLength, argc):
    allChars = {
        "char":list("qwertyuiopasdfghjklzxcvbnm"),
        "num":list("11234567890"),
        "symbol":"_",
        "symbolSpecial":"`~!@#$%^&*()=+[]{}\\|;:'\",/<>?",
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
        else:
            print(f"{argv[i]} not found")
    for i in list(charUsed.keys()):
        if charUsed[i]:
            charToUse+=allChars[i]
    for i in range(passwordLength):
        if charToUse == []:
            print("no flags chosen")
            exit(1)
        outputPassword+=random.choice(charToUse)
    print(outputPassword)

def decide(question, default) -> bool:
    print(question, end="")
    if default:
        print(" (y,N) > ", end="")
        result = input("")
        if result == "y":
            return True
        return False

    else:
        print(" (Y,n) > ", end="")
        result = input("")
        if result == "n":
            return False
        return True

def getArg(name, place):
    value = ""
    try:
        value = argv[place]
    except IndexError:
        print(f"Missing argument: {name}")
    return value

if __name__ == "__main__":
    main()
