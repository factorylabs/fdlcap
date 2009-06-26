Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :delayed_job do
    namespace :delayed_job do
      desc "Start delayed_job"
      task :start, :only => {:delayed_job => true} do
        sudo "/usr/bin/monit start all -g dj_#{application}"
      end
      desc "Stop delayed_job"
      task :stop, :only => {:delayed_job => true} do
        sudo "/usr/bin/monit stop all -g dj_#{application}"
      end
      desc "Restart delayed_job"
      task :restart, :only => {:delayed_job => true} do
        sudo "/usr/bin/monit restart all -g dj_#{application}"
      end        
    end
  
    after "deploy:restart", "delayed_job:restart"
    after "deploy:start",   "delayed_job:start"
    after "deploy:stop",    "delayed_job:stop"
  end
end