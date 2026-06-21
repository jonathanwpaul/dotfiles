#!/bin/bash

exec setsid xdg-terminal-exec -e "$1" "${@:2}"
