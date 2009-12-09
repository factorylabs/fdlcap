Capistrano::Configuration.instance(:must_exist).load do
  # These recipies assume an engineyard configuration
  
  # searchd assumes indexing and configuring being called directly on searchd
  define_recipe :thinking_sphinx do
    after "deploy:symlink_configs",   "thinking_sphinx:symlink"
    after "deploy:update",            "deploy:migrate"
    after "deploy:migrate",           "sphinx:configure"
    after "deploy:migrate",           "sphinx:reindex"
  end
  
end