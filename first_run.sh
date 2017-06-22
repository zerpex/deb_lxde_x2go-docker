#!/bin/bash

# Set timezone & locale vars
TZ="${TIME_ZONE:-Europe/Paris}"
CP="${CODEPAGE:-UTF-8}" 
LANG="${LANGUAGE:-fr_FR}" 
USR="${USER:-logan}"
UPASS="${USER_PASS:-$(pwgen -s 12 1)}"
PASS="${ROOT_PASS:-$(pwgen -s 12 1)}"

export LANG

if [ -f /.first_run ]; then
        exit 0
fi

# Set locale (fix the locale warnings)
localedef -v -c -i $LANG -f $CP $LANG.$CP || :
echo "$TZ" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
echo "$LANG.$CP $CP" > /etc/locale.gen
locale-gen --purge $LANG.$CP
echo -e 'LANG="$LANG.$CP"\nLANGUAGE="$LANG"\n' > /etc/default/locale
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=$LANG.$CP


_word=$( [ ${ROOT_PASS} ] && echo "preset" || echo "random" )
echo "=> Setting a $_word password to the root user"
echo "root:$PASS" | chpasswd

adduser --disabled-password --gecos "" $USR
adduser $USR sudo

echo "=> Setting a password to the docker user"
echo "$USR:$UPASS" | chpasswd


echo "=> Done!"
touch /.first_run

echo "================================================================="
echo "You can now connect to this container via SSH using:"
echo ""
echo "    ssh -p <port> root@<host>"
echo "and enter the root password '$PASS' when prompted"
echo ""
echo " $USR password : $UPASS "
echo "use this to connect to the x2go server from your x2go client!"
echo "Please remember to change the above password as soon as possible!"
echo "================================================================="
