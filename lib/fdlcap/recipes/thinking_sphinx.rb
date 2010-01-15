Capistrano::Configuration.instance(:must_exist).load do
  # These recipies assume an engineyard configuration
  
  # searchd assumes indexing and configuring being called directly on searchd
  define_recipe :thinking_sphinx do
    after 'deploy:finalize_update' do
      look_for_db_changes
      if db_changed?
        after "deploy:symlink_configs",   "thinking_sphinx:symlink"
        after "deploy:migrate",           "sphinx:configure"
        after "deploy:migrate",           "sphinx:reindex"
      end
    end
  end
  
end