class Capistrano::Configuration
  def execute(command, failure_message = "Command failed")
    puts "Executing: #{command}"
    system(command) || raise(failure_message)
  end
end

Capistrano::Configuration.instance(:must_exist).load do
  namespace :rsync do
    desc <<-DESC
    use rsync to sync assets locally or between servers
    DESC
    task :pull_shared , :roles => :app do
      servers = find_servers :roles => :app, :except => { :no_release => true }
      server = servers.first
      if server
        symlink_dirs.each do |share|
          `echo '#{password}' | /usr/bin/pbcopy`
          execute( "rsync -P -a -h -e 'ssh -p #{server.port || 22}' #{user}@#{server.host}:#{shared_path}/#{share}/* #{share}", "unable to run rsync files")
        end
      else
        puts 'no server found'
      end
    end

    desc <<-DESC
    use rsync to sync assets locally or between servers
    DESC
    task :push_shared , :roles => :app do
      servers = find_servers :roles => :app, :except => { :no_release => true }
      server = servers.first
      if server
        symlink_dirs.each do |share|
          `echo '#{password}' | /usr/bin/pbcopy`
          execute( "rsync -P -a -h -e 'ssh -p #{server.port || 22}' #{share}/* #{user}@#{server.host}:#{shared_path}/#{share}/", "unable to run rsync files")
        end
      else
        puts 'no server found'
      end
    end
  end
end