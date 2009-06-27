Capistrano::Configuration.instance(:must_exist).load do
  # These recipies assume an engineyard configuration
  
  # searchd assumes indexing and configuring being called directly on searchd
  define_recipe :thinking_sphinx_searchd do
    after "deploy:update_code",       "deploy:symlink_configs"
    after "deploy:symlink_configs",   "thinking_sphinx:symlink"
    after "thinking_sphinx:symlink",  "sphinx:configure"
    after "deploy:update",            "sphinx:reindex"
  end
  
  # rake assumes the explicit ey cap tasks that call TS rake tasks for indexing and configuring
  define_recipe :thinking_sphinx_rake do
    after "deploy:update_code",       "deploy:symlink_configs"
    after "deploy:symlink_configs",   "thinking_sphinx:symlink"
    after "thinking_sphinx:symlink",  "thinking_sphinx:configure"
    after "deploy:update",            "thinking_sphinx:reindex"
  end
end