# Pull in cap extensions
require 'fdlcap/extensions/configuration'
require 'fdlcap/extensions/recipe_definition'

# Set up configuration defaults
require 'fdlcap/defaults'

# Load external fdlcap dependencies
require 'capistrano/ext/multistage'
require 'eycap/recipes'

# Load up custom recipe chunks
require 'fdlcap/recipes/autotagger'
require 'fdlcap/recipes/craken'
require 'fdlcap/recipes/database'
require 'fdlcap/recipes/delayed_job'
require 'fdlcap/recipes/deploy'
require 'fdlcap/recipes/geminstaller'
require 'fdlcap/recipes/newrelic'
require 'fdlcap/recipes/nginx'
require 'fdlcap/recipes/performance'
require 'fdlcap/recipes/rake'
require 'fdlcap/recipes/rsync'
require 'fdlcap/recipes/ruby_inline'
require 'fdlcap/recipes/sass'
require 'fdlcap/recipes/slice'
require 'fdlcap/recipes/ssh'
require 'fdlcap/recipes/symlinks'
require 'fdlcap/recipes/thin'
require 'fdlcap/recipes/thinking_sphinx'