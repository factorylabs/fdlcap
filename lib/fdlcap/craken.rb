Capistrano::Configuration.instance(:must_exist).load do
  # Run craken to get cron tasks installed
  if exists?(:use_craken)
    after "deploy:update",            "craken:install"
  end
end