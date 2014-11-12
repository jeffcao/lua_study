#!/bin/sh
bundle exec thin -s6 -S /tmp/ddz_game_dep_server.sock -e development start
