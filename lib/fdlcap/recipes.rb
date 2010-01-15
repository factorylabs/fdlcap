# Pull in cap extensions
require 'fdlcap/extensions/configuration'
require 'fdlcap/extensions/recipe_definition'
require 'fdlcap/extensions/check_for_changes'

# Load external fdlcap dependencies
require 'eycap/recipes'

# Load up custom recipe chunks
Dir.glob(File.join(File.dirname(__FILE__),'recipes','*.rb')).each do |file|
  require file
end