#!/bin/sh
bundle exec thin -s1 -S /tmp/message_dep_server.sock stop
#bundle exec thin -s1 -p 5004 stop
