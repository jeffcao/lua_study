#!/bin/sh
bundle exec thin -s1 -S /tmp/admin_dep_server.sock -e development start
#bundle exec thin -s1 -p 5000 -e development start
