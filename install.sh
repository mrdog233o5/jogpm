#!/usr/bin/env bash
if [ $UID != 0 ]; then
    echo "Rerunning script with root user"
    sudo $0 $@
fi

mkdir -p /usr/local/share/man/man1

echo installing jogPM
if [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir -p /usr/local/bin
    install -v main /usr/local/bin/jogPM
else
    install -v main /usr/bin/jogPM
fi
install jogpm.1 /usr/local/share/man/man1/jogpm.1