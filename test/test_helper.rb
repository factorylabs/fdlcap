require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'vendor', 'gems', 'environment')
Bundler.require_env(:test)
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'fdlcap'

class Test::Unit::TestCase
end
