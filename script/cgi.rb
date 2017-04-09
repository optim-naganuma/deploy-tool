
BASE_DIR = File.expand_path(File.dirname(__FILE__)+"/..")

require "#{BASE_DIR}/lib/boot.rb"

require "cgi"

GitDeploy.run

cgi = CGI.new
cgi.out{ "OK" }

