Capistrano::Configuration.instance(:must_exist).load do
  desc "Execute an arbitrary rake task on slices with a specified role (ROLES=x,y,z TASK=p)"
  task :rake do
    task = ENV['TASK']
    run "cd #{current_path} && rake #{task} RAILS_ENV=#{rails_env}"
  end

  desc "Execute an arbitrary runner command on slices with a specified role (ROLES=x,y,z CMD=p)"
  task :runner do
    cmd = ENV['CMD']
    run "cd #{current_path} && script/runner -e #{rails_env} '#{cmd}'"
  end
  
  desc "Execute an arbitrary UNIX command on slices with a specified role (ROLES=x,y,z CMD=p)"
  task :command do
    cmd = ENV['CMD']
    run "cd #{current_path} && #{cmd}"
  end
end