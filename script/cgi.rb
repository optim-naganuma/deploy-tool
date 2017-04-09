#!/bin/bash

env > /tmp/aa.log
exit

BASE_DIR = File.expand_path(File.dirname(__FILE__)+"/..")

require "#{BASE_DIR}/lib/boot.rb"

GitDeploy::Cgi.run
