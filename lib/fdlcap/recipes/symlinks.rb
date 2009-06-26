Capistrano::Configuration.instance(:must_exist).load do
  
  define_recipe :symlinks do
    # 
    # Callbacks
    # 
    after "deploy:update_code", "symlinks:create"
  
    # 
    # Configuration
    #
    set :symlink_dirs,          []
    set :symlink_absolute_dirs, []
  
    #
    # Tasks
    #
    namespace :symlinks do

      desc "fix symlinks to shared directory"
      task :fix, :roles => [:app, :web] do
        # for folders stored under public
        symlink_dirs.each do |share|
          run "rm -rf #{current_path}/#{share}"
          run "mkdir -p #{shared_path}/#{share}"
          run "ln -nfs #{shared_path}/#{share} #{current_path}/#{share}"
        end
      end

      desc "create symlinks to shared directory"
      task :create, :roles => [:app, :web] do
        # for folders stored under public
        symlink_dirs.each do |share|
          run "rm -rf #{release_path}/#{share}"
          run "mkdir -p #{shared_path}/#{share}"
          run "ln -nfs #{shared_path}/#{share} #{release_path}/#{share}"
        end

        symlink_absolute_dirs.each do |share|
          run "rm -rf #{share[:symlink]}"
          run "mkdir -p #{share[:source]}"
          run "ln -nfs #{share[:source]} #{share[:symlink]}"
        end
      end

    end
  end
end