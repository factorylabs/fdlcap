Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :geminstaller do
    #
    # Tasks
    #
    namespace :geminstaller do
      desc "Run geminstaller"
      task :run, :only => { :geminstaller => true } do
        sudo "/usr/bin/geminstaller -c #{release_path}/config/geminstaller.yml --geminstaller-output=all --rubygems-output=all"
      end

      desc "Install geminstaller"
      task :install, :only => { :geminstaller => true } do
        sudo "gem install geminstaller"
        sudo "gem source -a http://gems.github.com"
      end
    end
    
    # 
    # Callbacks
    #
    after "deploy:setup",             "geminstaller:install"
    after "geminstaller:install",     "geminstaller:run"
    after "deploy:symlink",           "geminstaller:run"
    after "geminstaller:run",         "deploy:migrate"
  end
  
end