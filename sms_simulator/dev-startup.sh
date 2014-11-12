#!/bin/sh
bundle exec thin -s1 -S /tmp/rtddz_mock_server.sock -e development start
#bundle exec thin -s1 -p 5001 -e development start
