#!/bin/sh
bundle exec thin -s2 -S /tmp/login_server.sock -e production start
