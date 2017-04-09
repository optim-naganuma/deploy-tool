
=begin

git clone https://github.com/optim-naganuma/gababen

https://gababen.sakura.ne.jp/gababen/

=end

$: << "#{BASE_DIR}/lib"

require "yaml"
require "tempfile"
require "pry"

autoload :GitDeploy, "git_deploy.rb"
