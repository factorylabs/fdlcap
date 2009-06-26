Capistrano::Configuration.instance(:must_exist).load do
  
  namespace :slice do

    desc "Tail the Rails import log for this environment"
    task :tail_import_logs, :roles => :utility do
      run "tail -f #{shared_path}/log/import-#{rails_env}.log" do |channel, stream, data|
        puts # for an extra line break before the host name
        puts "#{channel[:server]} -> #{data}"
        break if stream == :err
      end
    end
    
    desc "Tail the Rails log for this environment"
    task :tail_logs, :roles => :utility do
      run "tail -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
        puts # for an extra line break before the host name
        puts "#{channel[:server]} -> #{data}"
        break if stream == :err
      end
    end
    
  end
  
  # Deploy the custom maintenance page
  define_recipe :custom_maintenance_page do
    
    desc "Copy the maintenance page from the public directory to the shared directory"
    task :copy_maintenance_page, :roles => :app do
      upload "public/maintenance.html","#{shared_path}/system/maintenance.html.custom", :via => :scp
    end
    
    before "deploy:web:disable",      "slice:copy_maintenance_page"
  end
  
end