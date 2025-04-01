#!/bin/sh

UMASK=${UMASK:-002}
PUID=${PUID:-99} # Use the environment variable value or default (1000) if variable is not set.
PGID=${PGID:-100} # Use the environment variable value or default (1000) if variable is not set.

umask $UMASK
groupmod -o -g "$PGID" nobody # Modify the group id.
usermod -o -u "$PUID" nobody # Modify the user id.

printf "User nobody is running with the following:\n"
printf "\tUMASK: %s\n" "${UMASK}"
printf "\tUID: %s\n" "${PUID}"
printf "\tGID: %s\n" "${PGID}"

cd /App

if [ $DEBUG ]
then
    exec su-exec nobody tail -f /dev/null
else
    exec su-exec nobody "$@"
fi