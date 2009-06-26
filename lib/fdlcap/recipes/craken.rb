Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :craken do
    after "deploy:update", "craken:install"
  end
end