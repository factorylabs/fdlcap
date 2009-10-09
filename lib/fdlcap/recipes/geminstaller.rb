Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :geminstaller do |*sources|
    gem_sources = sources || ['http://gems.github.com', 'http://gemcutter.org']
    set :gem_sources, gem_sources.flatten unless exists?(:gem_sources) && !gem_sources.empty?

    #
    # Tasks
    #
    namespace :geminstaller do
      desc <<-DESC
      install geminstaller
      DESC
      task :install, :only => { :geminstaller => true } do
        as = fetch(:runner, "app")
        via = fetch(:run_method, :sudo)
        invoke_command "gem install geminstaller", :via => via, :as => as
      end

      desc <<-DESC
      run geminstaller rake task to install gems on the server
      DESC
      task :run, :only => { :geminstaller => true } do
        as = fetch(:runner, "app")
        via = fetch(:run_method, :sudo)
        use_geminstaller_sudo = fetch(:geminstaller_sudo, false)
        invoke_command "/usr/bin/geminstaller #{use_geminstaller_sudo ? '-s' : ''} -c #{current_path}/config/geminstaller.yml  --geminstaller-output=all --rubygems-output=all", :via => via, :as => as
      end

      desc <<-DESC
      add geminstaller config to list of remote dependencies.
      DESC
      task :add_remote_gem_dependencies, :only => { :geminstaller => true } do
        CONFIG_PATH = File.join('config', 'geminstaller.yml')
        if File.exists?(CONFIG_PATH)
          gems = YAML.load(ERB.new(File.read(CONFIG_PATH)).result)['gems']
          gems.each do |gem|
            depend :remote, :gem, gem['name'], gem['version']
          end
        end
      end

      desc <<-DESC
      add gem sources to server
      DESC
      task :source_gem_servers, :only => { :geminstaller => true } do
        as = fetch(:runner, "app")
        via = fetch(:run_method, :sudo)
        gem_sources.each do |source|
          puts source
          unless check("gem source | grep '#{source}' = '#{source}'", :via => via, :as => as)
            invoke_command "gem source -a #{source}", :via => via, :as => as
          end
        end
      end

      #
      # Callbacks
      #
      before "deploy:check",          "geminstaller:add_remote_gem_dependencies"
      after "deploy:setup",          "geminstaller:install"
      after "geminstaller:install",  "geminstaller:run"
      after "deploy:update",         "geminstaller:run"

      before "geminstaller:install", "geminstaller:source_gem_servers"
      before "geminstaller:run",     "geminstaller:source_gem_servers"
    end

  end
end
