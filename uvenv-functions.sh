#!/usr/bin/env bash

function find_uvenv() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.uvenv" ]]; then
            echo "$dir/.uvenv"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

function get_latest_version() {
    find "$(uv python dir)" -maxdepth 1 -type d -name "*python-*" |
        sort -V |
        tail -n1 |
        sed -n 's/.*python-\([0-9]\+\.[0-9]\+\).*/\1/p'
}
