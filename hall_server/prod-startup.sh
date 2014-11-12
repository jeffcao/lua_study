#!/bin/sh
bundle exec thin -s2 -S /tmp/ddz_hall_server.sock -e production start
