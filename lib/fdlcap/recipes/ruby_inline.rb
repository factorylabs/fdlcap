Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :ruby_inline do
    
    #
    # Tasks
    #
    task :ruby_inline, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
      run "mkdir -p #{release_path}/tmp/ruby_inline/"
      run "mkdir -p #{release_path}/tmp/ruby_inline/.ruby_inline"
      sudo "chmod 755 #{release_path}/tmp/ruby_inline/"
      sudo "chmod 755 #{release_path}/tmp/ruby_inline/.ruby_inline"
    end
    
    #
    # Callbacks
    #
    after "deploy:symlink_configs", "ruby_inline"
  end
end