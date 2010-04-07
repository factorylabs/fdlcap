Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :rolling_restart do
    
    # Define the rolling_restart task for mongrel
    namespace :mongrel do
      desc <<-DESC
      Do a rolling restart of mongrels, one app server at a time.
      DESC
      task :rolling_restart do
        server_list = find_servers(:roles => :app)
        server_list.each do |server|
          ENV['HOSTS'] = "#{server.host}:#{server.port}"
          nginx.stop
          if server_list.size > 1
            puts "Waiting 10 seconds for mongrels to finish processing on #{ENV['HOSTS']}."
            sleep 10
          end
          mongrel.restart
          if server_list.size > 1
            puts "Waiting 60 seconds for mongrels to come back up on #{ENV['HOSTS']}."
            sleep 60
          end
          nginx.start
        end
      end
    end
    
    # Use a rolling restart by default.  Theoretically, if we're doing migrations we should be using deploy:long anyway
    namespace :deploy do
      task :restart do
        mongrel.rolling_restart
      end
    end
    
  end
end