Capistrano::Configuration.instance(:must_exist).load do
  
  define_recipe :check_revision do
    before "deploy:update_code", "deploy:check_revision"
 
    namespace :deploy do
      desc "Make sure there is something to deploy"
      task :check_revision, :roles => [:web] do
        unless `git rev-parse HEAD` == `git rev-parse origin/master`
          puts ""
          puts "  \033[1;33m**************************************************\033[0m"
          puts "  \033[1;33m* WARNING: HEAD is not the same as origin/master *\033[0m"
          puts "  \033[1;33m**************************************************\033[0m"
          puts ""
 
          exit
        end
      end
    end
    
  end
end