Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :newrelic do
    # Tell Newrelic that we've deployed
    before "deploy:cleanup", "newrelic:notice_deployment"
  end
end