Capistrano::Configuration.instance(:must_exist).load do
  task :ssh do
    role = (ENV['ROLE'] || :app).to_sym
    servers = find_servers :roles => role
    server = servers.first
    ssh_cmd = (File.exists?('/usr/bin/ssh-forever') ? '/usr/bin/ssh-forever' : '/usr/bin/ssh')
    if server
      `echo '#{password}' | /usr/bin/pbcopy`
      exec "#{ssh_cmd} #{user}@#{server.host} -p #{server.port || 22} "
    end
  end
  
  #namespace :ssh do
    task :tunnel do
      remote_port = ENV['REMOTE_PORT'] || 80
      local_port  = ENV['LOCAL_PORT']  || 2000
      role = (ENV['ROLE'] || :app).to_sym
      
      servers = find_servers :roles => role
      server = servers.first
      if server
        puts "Opening a tunnel from port #{local_port} locally to port #{remote_port} on #{server.host}"
        Net::SSH.start(server.host, user, :password => password, :port => server.port) do |ssh|
          ssh.forward.local(local_port, "127.0.0.1", remote_port)
          ssh.loop { true }
        end
      end
    end
  #end
  
end