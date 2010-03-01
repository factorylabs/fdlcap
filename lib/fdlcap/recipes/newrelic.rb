Capistrano::Configuration.instance(:must_exist).load do
  define_recipe :newrelic do
    require 'new_relic/recipes'
    # Tell Newrelic that we've deployed
    before "deploy:cleanup", "newrelic:notice_deployment"
  end
end