

class GitDeploy::Cgi < ::WEBrick::CGI

  def do_GET(request, responce)
    @request = request
    @responce = responce

    case request.query["command"]
    when "update_all"
      git_deploy.run

      redirect_to_index

    when "update"
      path = request.query["target"].to_s

      return render_404 unless git_deploy.status[path]

      git_deploy.git_pull_for(path)

      redirect_to_index
    else
      render :index

    end
  end

  def run
    index
  end

  def redirect_to_index
    @responce.set_redirect WEBrick::HTTPStatus::TemporaryRedirect, "?"
  end

  def render_404
    render("404")
  end

  def render(path, type=:html)
    template = File.read("#{BASE_DIR}/app/view/#{path}.haml")
    engine = Haml::Engine.new(template)
    @responce.body = engine.render(self)
    @responce.content_type = "text/#{type}"
  end

  def git_deploy
    @git_deploy ||= GitDeploy.new
  end

  class << self
    def get_instance(*params)
      self.new
    end

    def run
      self.new.start
    end
  end
end
