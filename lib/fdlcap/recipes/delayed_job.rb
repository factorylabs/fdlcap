Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :delayed_job do |*args|

    options = args.empty? ? {} : args.first
    prefix = options[:prefix] || 'dj'
    set :dj_monit_prefix, prefix unless exists?(:dj_monit_prefix)
    
    namespace :delayed_job do

      desc "Start delayed_job"
      task :start, :only => {:delayed_job => true} do
        sudo "/usr/bin/monit start all -g #{dj_monit_prefix}_#{application}"
      end
      desc "Stop delayed_job"
      task :stop, :only => {:delayed_job => true} do
        sudo "/usr/bin/monit stop all -g #{dj_monit_prefix}_#{application}"
      end
      desc "Restart delayed_job"
      task :restart, :only => {:delayed_job => true} do
        sudo "/usr/bin/monit restart all -g #{dj_monit_prefix}_#{application}"
      end        
    end
  
    after "deploy:restart", "delayed_job:restart"
    after "deploy:start",   "delayed_job:start"
    after "deploy:stop",    "delayed_job:stop"
  end
end