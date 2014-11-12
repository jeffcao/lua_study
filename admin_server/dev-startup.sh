#!/bin/sh
bundle exec thin -s1 -S /tmp/ddz_admin_server.sock -e development start
#bundle exec thin -s1 -p6000 -e development start
