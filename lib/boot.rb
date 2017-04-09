
=begin

git clone https://github.com/optim-naganuma/gababen

https://gababen.sakura.ne.jp/gababen/

=end

require "yaml"
require "tempfile"
require "cgi"

class GitDeploy
  CONF_FILE = "#{BASE_DIR}/config/config.yml"
  STATUS_FILE = "#{BASE_DIR}/config/status.yml"

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
      Dir.chdir(path) do
        Tempfile.open("log") do | io |

          git_update(io: io)

          io.rewind
          message = io.read

          self.status[path] ||= {}
          self.status[path]["message"] = message.split(/[\r\n]/)
          self.status[path]["last_check"] = now

        end
      end
    end
  ensure
    update_status
  end

  def now
    @now ||= Time.now
  end

  def git_update(io: nil)
    system("git", "pull", err: io, out: io)
  end

  class << self
    def run
      self.new.run
    end
  end

end

