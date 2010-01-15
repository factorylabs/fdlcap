Capistrano::Configuration.instance(:must_exist).load do

  define_recipe :automigrate do
    after 'deploy:finalize_update' do
      look_for_db_changes
      after("deploy:symlink_configs", "deploy:migrate") if db_changed?
    end
  end
  
end