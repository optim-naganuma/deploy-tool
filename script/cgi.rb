#!/c/Tools/Ruby/Ruby22-x64/bin/ruby

BASE_DIR = File.expand_path(File.dirname(__FILE__)+"/..")

require "#{BASE_DIR}/lib/boot.rb"



GitDeploy::Cgi.run
