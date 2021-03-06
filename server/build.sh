#!/bin/bash

# This script was based on the one from hw06-hw08
export SECRET_KEY_BASE=insecure
export MIX_ENV=prod
export PORT=4800
export SPOTIFY_CLIENT_ID=135bad1f37bc489b95aa2c2d2e7fd4c6

# Setup secret config file.
# From lecture notes
# https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0212/hangman/deploy.sh
CFGD=$(readlink -f $HOME/.config/melody_match)

if [ ! -d "$CFGD" ]; then
    mkdir -p "$CFGD"
fi

DATABASE_URL=$(cat "$CFGD/postgres")
SPOTIFY_CLIENT_SECRET=$(cat "$CFGD/spotify")
export DATABASE_URL
export SPOTIFY_CLIENT_SECRET

echo "Building..."

mix local.hex --force
mix local.rebar --force
mix deps.get
mix compile

if [ ! -e "$CFGD/base" ]; then
    mix phx.gen.secret > "$CFGD/base"
fi

SECRET_KEY_BASE=$(cat "$CFGD/base")
export SECRET_KEY_BASE

mix phx.digest

echo "Generating release..."
mix release --force --overwrite

echo "Migrating database..."
mix ecto.create
mix ecto.migrate
