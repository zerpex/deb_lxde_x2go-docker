#!/bin/bash

# Set timezone & locale vars
TZ="${TIME_ZONE:-Europe/Paris}"
CP="${TIME_ZONE:-UTF-8}" 
LANG="${LANGUAGE:-fr_FR}" 

if [ -f /.first_run ]; then
        exit 0
fi

# Set locale (fix the locale warnings)
localedef -v -c -i $LANG -f $CP $LANG.$CP || :
update-locale LANG=$LANG.$CP
echo "$TZ" > /etc/timezone && \
dpkg-reconfigure --frontend noninteractive tzdata


PASS="${ROOT_PASS:-$(pwgen -s 12 1)}"
_word=$( [ ${ROOT_PASS} ] && echo "preset" || echo "random" )
echo "=> Setting a $_word password to the root user"
echo "root:$PASS" | chpasswd

adduser --disabled-password --gecos "" dockerx
adduser dockerx sudo
DPASS=$(pwgen -s 12 1)

echo "=> Setting a password to the docker user"
echo "dockerx:$DPASS" | chpasswd


echo "=> Done!"
touch /.first_run

echo "========================================================================"
echo "You can now connect to this container via SSH using:"
echo ""
echo "    ssh -p <port> root@<host>"
echo "and enter the root password '$PASS' when prompted"
echo ""
echo " dockerx password : $DPASS "
echo "use this to connect to the x2go server from your x2go client!"
echo "Please remember to change the above password as soon as possible!"
echo "========================================================================"
