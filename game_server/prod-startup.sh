#!/bin/sh
bundle exec thin -s2 -S /tmp/ddz_game_server.sock -e production start
