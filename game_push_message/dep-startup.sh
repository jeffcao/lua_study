#!/bin/sh
bundle exec thin -s1 -S /tmp/message_dep_server.sock -e development start
#bundle exec thin -s1 -p 5004 -e development start
