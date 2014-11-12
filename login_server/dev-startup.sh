#!/bin/sh
bundle exec thin -s2 -S /tmp/rtddz_login_server.sock -e development start
