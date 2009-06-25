Capistrano::Configuration.instance(:must_exist).load do
  # Notify newrelic of the deploy
  if exists?(:use_newrelic)
    before "deploy:cleanup", "newrelic:notice_deployment"
  end
end