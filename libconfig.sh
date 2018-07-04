#!/bin/sh

LOCAL_CONFIG_FILE_PATH=""

function check () {
    if [ "$1" -ne 0 ]
    then
        msg err "$2"
        exit 1
    fi
}

function set_dbg () {
    if [ "$1" = "true" ]
    then
        set -x
    else
        set +x
    fi
}

function reset_config () {
    if [ -f "$LOCAL_CONFIG_FILE_PATH" ]
    then
        msg info "File already existing, deleting it..."
        rm -f $LOCAL_CONFIG_FILE_PATH
    else
        msg info "Creating a new config file..."
    fi
}

function msg () {
    # 3 type of messages:
    # - info
    # - warn
    # - err
    local color=""
    local readonly default="\033[m" #reset
    if [ "$1" = "info" ]
    then
        color="\033[0;32m" #green
    elif [ "$1" = "warn" ]
    then
        color="\033[1;33m" #yellow
    elif [ "$1" = "err" ]
    then
        color="\033[0;31m" #red
    fi

    echo -e "$color==> $2$default"
}

function set_config_path () {
    LOCAL_CONFIG_FILE_PATH="$1"
}

function get_config_path () {
    echo "$LOCAL_CONFIG_FILE_PATH"
}
