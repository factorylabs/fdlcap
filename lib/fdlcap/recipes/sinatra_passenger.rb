Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :sinatra_passenger do
    namespace :sinatra_passenger do
      desc "Set file permissions"
      task :chmod_directories_config do
        run "cd #{release_path} && find -maxdepth 1 -type d -exec chmod 755 {} \\"
      end

      desc "Set public folder permissions"
      task :chmod_directories_public do
        run "cd #{release_path}/public && find -type d -exec chmod 755 {} \\"
      end
    end

    after "deploy:update_code", "sinatra_passenger:chmod_directories_config"
    after "deploy:update_code", "sinatra_passenger:chmod_directories_public"
  end
end
