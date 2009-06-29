Capistrano::Configuration.instance(:must_exist).load do
  
  define_recipe :symlink_configs do
    after "deploy:update_code",       "deploy:symlink_configs"
  end
  
end