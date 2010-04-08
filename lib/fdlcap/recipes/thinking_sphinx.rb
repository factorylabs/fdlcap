Capistrano::Configuration.instance(:must_exist).load do
  # These recipies assume an engineyard configuration
  
  # searchd assumes indexing and configuring being called directly on searchd
  define_recipe :thinking_sphinx do
    
    #ALWAYS need to do this
    after "deploy:symlink_configs",   "thinking_sphinx:symlink"
    
    # Only need to do this if DB has changed
    after 'deploy:finalize_update' do
      look_for_db_changes
      if db_changed?
        after "deploy:migrate",           "sphinx:configure"
        after "deploy:migrate",           "sphinx:reindex"
      end
    end
  end
  
end