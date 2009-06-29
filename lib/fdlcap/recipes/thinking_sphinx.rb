Capistrano::Configuration.instance(:must_exist).load do
  # These recipies assume an engineyard configuration
  
  # searchd assumes indexing and configuring being called directly on searchd
  define_recipe :thinking_sphinx do
    after "deploy:update_code",       "deploy:symlink_configs"
    after "deploy:symlink_configs",   "thinking_sphinx:symlink"
    after "thinking_sphinx:symlink",  "sphinx:configure"
    after "deploy:update",            "sphinx:reindex"
  end
  
end