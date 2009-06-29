Capistrano::Configuration.instance(:must_exist).load do
  
  define_recipe :fdl_defaults do
    # defaults for fdl
    set :scm,           :git
    set :keep_releases, 5
    set :deploy_via,    :remote_cache
  end
  
end