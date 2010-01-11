Capistrano::Configuration.instance(:must_exist).load do

  define_recipe :automigrate do
    after "deploy:update",            "deploy:migrate"
  end
  
end