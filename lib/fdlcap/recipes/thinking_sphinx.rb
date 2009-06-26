Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :thinking_sphinx do
    after "deploy:update_code",       "deploy:symlink_configs"
    after "deploy:symlink_configs",   "thinking_sphinx:symlink"
    after "thinking_sphinx:symlink",  "sphinx:configure"
    after "deploy:update",            "sphinx:reindex"
  end
end