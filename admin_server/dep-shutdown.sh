#!/bin/sh
bundle exec thin -s1 -S /tmp/admin_dep_server.sock stop
#bundle exec thin -s1 -p5000 stop
