#!/bin/sh
bundle exec thin -s2 -S /tmp/ddz_hall_dep_server.sock -e development start
#bundle exec thin -s2 -p 8000 -e development start
