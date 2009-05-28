Capistrano::Configuration.instance(:must_exist).load do
  
  namespace :slice do
    
    desc "Copy the maintenance page from the public directory to the shared directory"
    task :copy_maintenance_page do
      upload "public/maintenance.html","#{shared_path}/system/maintenance.html.custom", :via => :scp
    end

    desc "Tail the Rails import log for this environment"
    task :tail_import_logs, :roles => :queue do
      run "tail -f #{shared_path}/log/import-#{rails_env}.log" do |channel, stream, data|
        puts # for an extra line break before the host name
        puts "#{channel[:server]} -> #{data}"
        break if stream == :err
      end
    end
    
    desc "Execute an arbitrary rake task on slices with a specified role"
    task :rake do
      task = ENV['TASK']
      run "cd #{current_path} && rake #{task} RAILS_ENV=#{rails_env}"
    end
    
  end
  
end