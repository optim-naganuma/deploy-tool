require "webrick"

class GitDeploy::Server < WEBrick::HTTPServer

  def initialize
    super(
      BindAddress:    "0.0.0.0",
      Port:           3000,
      DocumentRoot:   "#{BASE_DIR}/public")

    self.mount_proc("/") do | req, res |
      binding.pry

      cgi = GitDeploy::Cgi.new
      cgi.run

      res.body = cgi
    end

  end

  def start
    Signal.trap(:INT){ self.shutdown }

    super
  end

  class << self
    def run
      self.new.start
    end
  end
end
