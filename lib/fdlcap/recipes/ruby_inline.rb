Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :ruby_inline do
    
    #
    # Tasks
    #
    task :ruby_inline, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
      run "mkdir -p #{release_path}/tmp/ruby_inline/.ruby_inline"
      run "chmod -R 755 #{release_path}/tmp/ruby_inline/"
    end
    
    # todo - revisit this, currently a hack to temporarily fix an issue with sphinx and ruby_inline
    task :chmod_release_path, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
      run "chmod 755 #{release_path}"
    end
    
    #
    # Callbacks
    #
    after "deploy:symlink_configs", "ruby_inline"
    after "deploy:symlink",         "chmod_release_path"
    
  end
end