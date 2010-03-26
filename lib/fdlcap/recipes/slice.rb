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
  
end