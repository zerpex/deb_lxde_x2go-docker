#!/bin/bash
if [ ! -f /.first_run ]; then
        /first_run.sh
fi

exec /usr/sbin/sshd -D
