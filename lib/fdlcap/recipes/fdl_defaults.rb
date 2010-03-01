Capistrano::Configuration.instance(:must_exist).load do

  define_recipe :fdl_defaults do |*args|

    set :ey_environment, !args.empty? ? args.shift : true unless exists?(:ey_environment)

    if ey_environment
      # Load external eycap dependencies
      require 'eycap/recipes'
    end

    # defaults for fdl
    set :scm, :git
    set :keep_releases, 5
    set :deploy_via, :remote_cache

    use_recipe :symlinks
    use_recipe :perform_cleanup
    use_recipe :symlink_configs
    use_recipe :automigrate

  end

end