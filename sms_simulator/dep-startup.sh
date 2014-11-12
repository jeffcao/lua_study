#!/bin/sh
bundle exec thin -s1 -S /tmp/mock_sim_dep_server.sock -e development start
#bundle exec thin -s1 -p 5001 -e development start
