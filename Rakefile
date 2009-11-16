require File.join(File.expand_path(File.dirname(__FILE__)), 'vendor', 'gems', 'environment')
Bundler.require_env
require 'rake'
require 'bundler'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fdlcap"
    gem.summary = %Q{a set of capistrano recipies we use regularly at Factory Design Labs}
    gem.email = "interactive@factorylabs.com"
    gem.homepage = "http://github.com/factorylabs/fdlcap"
    gem.authors = ["Factory Design Labs", "Gabe Varela", "Jay Zeschin" ]

    manifest = Bundler::Environment.load(File.dirname(__FILE__) + '/Gemfile')
    manifest.dependencies.each do |d|
      next if d.only
      gem.add_dependency(d.name, d.version)
    end

    gem.files.exclude('.gitignore')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fdlcap #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

