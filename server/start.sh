#!/bin/bash

# This script was copied from hw06-08
export SECRET_KEY_BASE=W68eso5YQOlbtvSNUR50N/HDWj6IaEhAwMR3LtzuBEQAefwYVbX84bvoTA7XtiGi
export MIX_ENV=prod
export PORT=4800
export SPOTIFY_CLIENT_ID=135bad1f37bc489b95aa2c2d2e7fd4c6

echo "Stopping old copy of app, if any..."

_build/prod/rel/melody_match/bin/melody_match stop || true

CFGD=$(readlink -f ~/.config/melody_match)

if [ ! -e "$CFGD/base" ]; then
    echo "run build first"
    exit 1
fi

SECRET_KEY_BASE=$(cat "$CFGD/base")
DATABASE_URL=$(cat "$CFGD/postgres")
SPOTIFY_CLIENT_SECRET=$(cat "$CFGD/spotify")
export SECRET_KEY_BASE
export DATABASE_URL
export SPOTIFY_CLIENT_SECRET

echo "Starting app..."

_build/prod/rel/melody_match/bin/melody_match start
