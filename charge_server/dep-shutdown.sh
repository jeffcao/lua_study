#!/bin/sh
bundle exec thin -s1 -S /tmp/charge_dep_server.sock stop
#bundle exec thin -s1 -p 5005 stop