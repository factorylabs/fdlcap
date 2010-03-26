Capistrano::Configuration.instance(:must_exist).load do
  
  namespace :slice do
    
    desc "Tail the Rails log for this environment"
    task :tail_logs, :roles => :app do
      run "tail -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
        puts # for an extra line break before the host name
        puts "#{channel[:server]} -> #{data}"
        break if stream == :err
      end
    end
    
    desc "Tail the system log for this environment"
    task :tail_syslog, :roles => :app do
      sudo "tail -f /var/log/syslog" do |channel, stream, data|
        puts # for an extra line break before the host name
        puts "#{channel[:server]} -> #{data}"
        break if stream == :err
      end
    end
    
    desc "Tail the message log for this environment"
    task :tail_messages, :roles => :app do
      sudo "tail -f /var/log/messages" do |channel, stream, data|
        puts # for an extra line break before the host name
        puts "#{channel[:server]} -> #{data}"
        break if stream == :err
      end
    end
    
    desc <<-DESC
    grep the production.log to find long running queries
    DESC
    task :grep_requests, :roles => :app do
      run "grep 'Completed in [0-9]*' #{shared_path}/log/#{rails_env}.log"
    end

    desc <<-DESC
    grep the production.log to find long running queries
    DESC
    task :grep_long_requests, :roles => :app do
      run "grep 'Completed in [0-9][0-9]' #{shared_path}/log/#{rails_env}.log"
    end
    
  end
  
  # Deploy the custom maintenance page
  define_recipe :custom_maintenance_page do
    
    namespace :slice do
      desc "Copy the maintenance page from the public directory to the shared directory"
      task :copy_maintenance_page, :roles => :app do
        upload "public/maintenance.html","#{shared_path}/system/maintenance.html.custom", :via => :scp
      end
    end
    
    before "deploy:web:disable",      "slice:copy_maintenance_page"
  end
  
end