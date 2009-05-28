Capistrano::Configuration.instance(:must_exist).load do
  task :ssh do
    role = (ENV['ROLE'] || :app).to_sym
    servers = find_servers :roles => role
    server = servers.first
    if server
      `echo '#{password}' | /usr/bin/pbcopy`
      exec "/usr/bin/ssh #{user}@#{server.host} -p #{server.port || 22} "
    end
  end
end