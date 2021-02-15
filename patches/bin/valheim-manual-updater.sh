#!/bin/bash
set -e 

chmod $CONFIG_DIRECTORY_PERMISSIONS /config
if [ -d /config/worlds ]; then
    chmod $WORLDS_DIRECTORY_PERMISSIONS /config/worlds
    chmod $WORLDS_FILE_PERMISSIONS /config/worlds/*
fi

./steamcmd.sh +login anonymous +force_install_dir /opt/valheim_dl +app_update 896660 validate +quit
rsync -a --itemize-changes --delete --exclude server_exit.drp --exclude steamapps /opt/valheim_dl/ /opt/valheim | tee "$logfile"
grep '^[*>]' "$logfile" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Valheim Server was updated - restarting"
    supervisorctl restart valheim-server
else
    echo "Valheim Server is already the latest version - doing nothing"
fi