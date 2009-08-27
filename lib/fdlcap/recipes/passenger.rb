Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :passenger do
    namespace :deploy do
      task :start, :roles => :app do
        run "touch #{current_release}/tmp/restart.txt"
      end

      task :stop, :roles => :app do
        # Do nothing.
      end

      task :restart, :roles => :app do
        run "touch #{current_release}/tmp/restart.txt"
      end
    end
  end
end