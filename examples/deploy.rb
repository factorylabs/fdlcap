#####################
# GLOBAL VARS
#####################

require 'fdlcap/recipes'
require 'lib/recipes/ftp_server'
require 'lib/recipes/queue_daemon'

#
# Bring in fdlcap recipes
#

use_recipe :symlink_configs
use_recipe :stages, [ :express, :staging, :production, :translation ]
use_recipe :symlinks
use_recipe :geminstaller
use_recipe :delayed_job
use_recipe :release_tagger, [ :ci, :staging, :production ]
use_recipe :sass
use_recipe :thinking_sphinx
use_recipe :newrelic
use_recipe :perform_cleanup
use_recipe :craken
use_recipe :custom_maintenance_page               

#
# Symlink directories
#
set :symlink_dirs, [  'data',
                      'public/images/vehicles',
                      'public/images/staff',
                      'db/sphinx' ]
                      
# 
# SCM config
#
set :scm,           :git
set :keep_releases, 5
set :repository,    "git@github.com:factorylabs/fdlcap.git"
set :deploy_via,    :remote_cache

#
# Callback config
#



#
# Custom Tasks
#

namespace :retrieve do
  desc "run rake retrieve:import_dag"
  task :import_dag, :roles => :db do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} rake retrieve:import_dag"
  end
end