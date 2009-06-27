# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fdlcap}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Factory Design Labs"]
  s.date = %q{2009-06-26}
  s.default_executable = %q{fdlcap}
  s.email = %q{interactive@factorylabs.com}
  s.executables = ["fdlcap"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/fdlcap",
     "fdlcap.gemspec",
     "features/fdlcap.feature",
     "features/step_definitions/fdlcap_steps.rb",
     "features/support/env.rb",
     "lib/fdlcap.rb",
     "lib/fdlcap/defaults.rb",
     "lib/fdlcap/extensions/configuration.rb",
     "lib/fdlcap/extensions/recipe_definition.rb",
     "lib/fdlcap/recipes.rb",
     "lib/fdlcap/recipes/autotagger.rb",
     "lib/fdlcap/recipes/craken.rb",
     "lib/fdlcap/recipes/database.rb",
     "lib/fdlcap/recipes/delayed_job.rb",
     "lib/fdlcap/recipes/deploy.rb",
     "lib/fdlcap/recipes/geminstaller.rb",
     "lib/fdlcap/recipes/newrelic.rb",
     "lib/fdlcap/recipes/nginx.rb",
     "lib/fdlcap/recipes/performance.rb",
     "lib/fdlcap/recipes/rake.rb",
     "lib/fdlcap/recipes/rsync.rb",
     "lib/fdlcap/recipes/ruby_inline.rb",
     "lib/fdlcap/recipes/sass.rb",
     "lib/fdlcap/recipes/slice.rb",
     "lib/fdlcap/recipes/ssh.rb",
     "lib/fdlcap/recipes/stages.rb",
     "lib/fdlcap/recipes/symlinks.rb",
     "lib/fdlcap/recipes/thin.rb",
     "lib/fdlcap/recipes/thinking_sphinx.rb",
     "lib/fdlcap/templates/nginx.auth.conf.erb",
     "lib/fdlcap/templates/nginx.conf.erb",
     "lib/fdlcap/templates/nginx.vhost.conf.erb",
     "test/fdlcap_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/factorylabs/fdlcap}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{a set of capistrano recipies we use regularly at Factory Design Labs}
  s.test_files = [
    "test/fdlcap_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<engineyard-eycap>, [">= 0.4.7"])
      s.add_runtime_dependency(%q<zilkey-auto_tagger>, [">= 0.0.9"])
      s.add_runtime_dependency(%q<capistrano>, [">= 2.5.5"])
      s.add_runtime_dependency(%q<capistrano-ext>, [">= 1.2.1"])
    else
      s.add_dependency(%q<engineyard-eycap>, [">= 0.4.7"])
      s.add_dependency(%q<zilkey-auto_tagger>, [">= 0.0.9"])
      s.add_dependency(%q<capistrano>, [">= 2.5.5"])
      s.add_dependency(%q<capistrano-ext>, [">= 1.2.1"])
    end
  else
    s.add_dependency(%q<engineyard-eycap>, [">= 0.4.7"])
    s.add_dependency(%q<zilkey-auto_tagger>, [">= 0.0.9"])
    s.add_dependency(%q<capistrano>, [">= 2.5.5"])
    s.add_dependency(%q<capistrano-ext>, [">= 1.2.1"])
  end
end
