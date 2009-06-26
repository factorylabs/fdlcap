Capistrano::Configuration.instance(:must_exist).load do
  
  namespace :web do
    task :disable, :roles => :web, :except => { :no_release => true } do
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }
      run "cp #{current_path}/public/maintenance.html #{shared_path}/system/maintenance.html"
    end
  end
  
  namespace :deploy do
    desc "Pull files from a remote server"
    task :download_file, :roles => :app, :except => { :no_release => true } do
      ENV['FILES'].split(',').each do |file|
        get "#{current_path}/#{file}", File.basename(file)
      end
    end
  end
  
  # Clean up old releases
  define_recipe :perform_cleanup do
    after "deploy",                   "deploy:cleanup"
    after "deploy:migrations" ,       "deploy:cleanup"
    after "deploy:long" ,             "deploy:cleanup"
  end
  
end