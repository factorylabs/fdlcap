# Set up configuration defaults
Capistrano::Configuration.instance(:must_exist).load do
  unless exists?(:stages)
    set :stages,            [ :staging, :production ]
  end
  
  unless exists?(:use_release_tagger) && exists?(:autotagger_stages)
    set :autotagger_stages, [ :ci, :staging, :production ]
  end
  
  unless exists?(:default_stage)
    set :default_stage,     :staging
  end
end

# Load fdlcap dependencies
require 'release_tagger'
require 'capistrano/ext/multistage'
require 'eycap/recipes'

# Load up custom recipes and callbacks
require 'fdlcap/recipes/autotagger'
require 'fdlcap/recipes/craken'
require 'fdlcap/recipes/database'
require 'fdlcap/recipes/delayed_job'
require 'fdlcap/recipes/deploy'
require 'fdlcap/recipes/geminstaller'
require 'fdlcap/recipes/newrelic'
require 'fdlcap/recipes/performance'
require 'fdlcap/recipes/rake'
require 'fdlcap/recipes/rsync'
require 'fdlcap/recipes/sass'
require 'fdlcap/recipes/ssh'
require 'fdlcap/recipes/slice'
require 'fdlcap/recipes/thinking_sphinx'