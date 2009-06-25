set :thin_servers, 2
set :thin_port, 8000
set :thin_address, "127.0.0.1"
set :thin_environment, "production"
set :thin_conf, nil
set :thin_user, nil
set :thin_group, nil
set :thin_prefix, nil
set :thin_pid_file, nil
set :thin_log_file, nil
set :thin_config_script, nil

namespace :thin do      
    desc <<-DESC
    Install Thin script on the app server.  This uses the :use_sudo variable to determine whether to use sudo or not. By default, :use_sudo is
    set to true.
    DESC
    task :install , :roles => :app do      
      send(run_method, "gem install thin") 
      send(run_method, "thin install") 
    end
    
    desc <<-DESC
    Configure thin processes on the app server. This uses the :use_sudo
    variable to determine whether to use sudo or not. By default, :use_sudo is
    set to true.
    DESC
    task :configure, :roles => :app do
      set_conf
      
      argv = []
      argv << "thin"
      argv << "-s #{thin_servers.to_s}"
      argv << "-p #{thin_port.to_s}"
      argv << "-e #{thin_environment}"
      argv << "-a #{thin_address}"
      argv << "-c #{current_path}"
      argv << "-C #{thin_conf}"
      argv << "-P #{thin_pid_file}" if thin_pid_file
      argv << "-l #{thin_log_file}" if thin_log_file
      argv << "--user #{thin_user}" if thin_user
      argv << "--group #{thin_group}" if thin_group
      argv << "--prefix #{thin_prefix}" if thin_prefix 
      argv << "config"
      cmd = argv.join " "
      send(run_method, cmd)
    end 
    
    task :setup, :roles => :app do  
      thin.install
      thin.configure
    end
    
    desc <<-DESC
    Start Thin processes on the app server.  This uses the :use_sudo variable to determine whether to use sudo or not. By default, :use_sudo is
    set to true.
    DESC
    task :start , :roles => :app do
      set_conf
      cmd = "thin start -C #{thin_conf}" 
      send(run_method, cmd)
    end

    desc <<-DESC
    Restart the Thin processes on the app server by starting and stopping the cluster. This uses the :use_sudo
    variable to determine whether to use sudo or not. By default, :use_sudo is set to true.
    DESC
    task :restart , :roles => :app do
      set_conf
      cmd = "thin restart -C #{thin_conf}" 
      send(run_method, cmd)
    end

    desc <<-DESC
    Stop the Thin processes on the app server.  This uses the :use_sudo
    variable to determine whether to use sudo or not. By default, :use_sudo is
    set to true.
    DESC
    task :stop , :roles => :app do
      set_conf
      cmd = "thin stop -C #{thin_conf}"
      send(run_method, cmd)
    end


    def set_conf
      set :thin_conf, "/etc/thin/#{application}.yml" unless thin_conf
    end
end

namespace :deploy do
  desc <<-DESC
  Restart the Thin processes on the app server by calling thin:restart.
  DESC
  task :restart, :roles => :app do
    thin.restart
  end

  desc <<-DESC
  Start the Thin processes on the app server by calling thin:start.
  DESC
  task :start, :roles => :app do
    thin.start
  end
  
  desc <<-DESC
  Stop the Thin processes on the app server by calling thin:stop.
  DESC
  task :stop, :roles => :app do
    thin.stop
  end
end 