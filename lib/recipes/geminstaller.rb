before "deploy:check", "geminstaller:add_remote_gem_dependencies"
# after  "deploy:setup", "geminstaller:install"
namespace :geminstaller do
  desc <<-DESC
  install geminstaller
  DESC
  task :install, :roles => :app do
    run "gem source -a http://gems.github.com"
    as = fetch(:runner, "app")
    via = fetch(:run_method, :sudo)
    invoke_command "gem install geminstaller", :via => via, :as => as
  end

  desc <<-DESC
  run geminstaller rake task to install gems on the server
  DESC
  task :remote_run, :roles => :app do
    as = fetch(:runner, "app")
    via = fetch(:run_method, :sudo)
    invoke_command "geminstaller -c #{current_path}/config/geminstaller.yml", :via => via, :as => as
  end

  desc <<-DESC
  add geminstaller config to list of remote dependencies.
  DESC
  task :add_remote_gem_dependencies, :roles => :app do
    CONFIG_PATH = File.join('config', 'geminstaller.yml')
    if File.exists?(CONFIG_PATH)
      gems = YAML.load(ERB.new(File.read(CONFIG_PATH)).result)['gems']
      gems.each do |gem|
        depend :remote, :gem, gem['name'], gem['version']
      end
    end
  end
end