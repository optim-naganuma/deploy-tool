require "cgi"
require "haml"

class GitDeploy::Cgi < ::CGI

  def run
    index
  end

  def index
    render("index.haml")
  end

  def deploy
    git_deploy.run

    out{ "OK" }
  end

  def render(path)
    template = File.read("#{BASE_DIR}/app/view/#{path}")
    engine = Haml::Engine.new(template)
    out{ engine.render(self) }
  end

  def git_deploy
    @git_deploy ||= GitDeploy.new
  end

  class << self
    def run
      self.new.run
    end
  end
end
