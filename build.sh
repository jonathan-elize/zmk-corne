#!/bin/bash

# python3 -m venv ~/.venvs/zmk
# source ~/.venvs/zmk/bin/activate
# python -m pip install --upgrade pip
# python -m pip install west
# west init -l config
# west update
# python -m pip install -r zephyr/scripts/requirements.txt
#
# install sdk https://docs.zephyrproject.org/3.5.0/develop/getting_started/index.html
#
# go to zmk/app
# build command

config="/Users/jonathanelize/projects/zmk-corne/config"
variation="${1:-nice_epaper}"

function build() {
    target="$1"
    type="$2"

    if [ -z "$target" ]; then
        echo "Must enter left or right"
        exit 1
    fi

    build_dir="build/$type$target"

    west build -d "$build_dir" \
        -p auto \
        -b "nice_nano_v2" -- \
        -DZMK_CONFIG="$config" \
        -DSHIELD="corne_$target nice_view_adapter $type"

    cp "$build_dir/zephyr/zmk.uf2" "build/$target.uf2"
    cp "$build_dir/zephyr/zmk.uf2" "$HOME/Desktop/$target.uf2"
}

function clear() {
    west build -d build/settings_reset -p always \
        -b nice_nano_v2 -- \
        -DSHIELD="settings_reset"

    cp "build/settings_reset/zephyr/zmk.uf2" "$HOME/Desktop/reset.uf2"
}

build left "$variation"
build right "$variation"
