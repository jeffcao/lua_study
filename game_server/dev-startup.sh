#!/bin/sh
bundle exec thin -s6 -S /tmp/rtddz_game_server.sock -e development start
