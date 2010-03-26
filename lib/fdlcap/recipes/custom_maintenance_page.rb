Capistrano::Configuration.instance(:must_exist).load do
  # Deploy the custom maintenance page
  define_recipe :custom_maintenance_page do
    
    # Callbacks
    before "deploy:web:disable",      "slice:copy_maintenance_page"
    
    # Tasks
    namespace :slice do
      desc "Copy the maintenance page from the public directory to the shared directory"
      task :copy_maintenance_page, :roles => :app do
        upload "public/maintenance.html","#{shared_path}/system/maintenance.html.custom", :via => :scp
      end
    end
    
  end
end