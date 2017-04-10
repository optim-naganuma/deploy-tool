class GitDeploy
  CONF_FILE = "#{BASE_DIR}/config/config.yml"
  STATUS_FILE = "#{BASE_DIR}/config/status.yml"

  autoload :Cgi,    "git_deploy/cgi.rb"
  autoload :Server, "git_deploy/server.rb"

  def config
    @config ||= YAML.load(File.open(CONF_FILE, "r", &:read))
  end

  def status
    return @status if @status
    @status = YAML.load(File.open(STATUS_FILE, "r", &:read)) rescue nil
    @status = {} unless @status.kind_of?(Hash)
    @status
  end

  def update_status
    File.open(STATUS_FILE, "w") do | io |
      io.write(self.status.to_yaml)
    end
  end

  def run
    Dir["#{config["target_path"]}/*/"].each do | path |
      git_pull_for(path)
    end
  end

  def git_pull_for(path)
    self.status[path] ||= {}

    Dir.chdir(path) do
      Tempfile.open("log", "#{BASE_DIR}/tmp/") do | io |

        git_update(io: io)

        io.rewind
        message = io.read

        self.status[path]["message"] = message.split(/[\r\n]/)
        self.status[path]["last_check_at"] = now
        self.status[path]["name"] = path.gsub(/^#{Regexp.escape(config["target_path"])}/, "")

      end
    end

  rescue => e
    self.status[path]["message"] = [e.to_s]

  ensure
    update_status

  end

  def now
    @now ||= Time.now
  end

  def git_update(io: nil)
    system("git", "pull", err: io, out: io)
    system("git", "rev-parse", "HEAD", err: io, out: io)
  end

  class << self
    def run
      self.new.run
    end
  end

end



