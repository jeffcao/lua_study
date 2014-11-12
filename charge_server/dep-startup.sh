#!/bin/sh
bundle exec thin -s1 -S /tmp/charge_dep_server.sock -e development start
#bundle exec thin -s1 -p 5005 -e development start