require "webrick"

class GitDeploy::Server < WEBrick::HTTPServer

  def initialize
    super(
      BindAddress:    "0.0.0.0",
      Port:           3000,
      DocumentRoot:   "#{BASE_DIR}/public")

    self.mount("/", WEBrick::HTTPServlet::CGIHandler, "#{BASE_DIR}/script/cgi.rb")

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
