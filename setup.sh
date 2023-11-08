#!/usr/bin/env bash

gainSudoAccess() {
    if [ $UID != 0 ]; then
        echo "Rerunning script with root user"
        sudo $0 $@
    fi
}

installStuff() {

    if [[ "$OSTYPE" == "darwin"* ]]; then
        mkdir -p /usr/local/bin
        install -v ./main /usr/local/bin/jogpm
    else
        install -v ./main /usr/bin/jogpm
    fi

    echo "installed jogpm" | lolcat

    mkdir -p /usr/local/share/man/man1
    install jogpm.1 /usr/local/share/man/man1/jogpm.1

    echo "installed man page of jogpm" | lolcat
}

setup() {
    mkdir ~/.jogpm
    mkdir ~/.jogpm/passwords
    touch ~/.jogpm/account.conf
    install ./account.conf ~/.jogpm/account.conf
    echo "files setted up" | lolcat
}

main() {
    gainSudoAccess
    installStuff
    setup
    echo "jogpm installed successfully" | lolcat
}

main
