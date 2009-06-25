# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fdlcap}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Factory Design Labs"]
  s.date = %q{2009-06-25}
  s.default_executable = %q{fdlcap}
  s.email = %q{interactive@factorylabs.com}
  s.executables = ["fdlcap"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README",
     "README.rdoc"
  ]
  s.files = [
    "LICENSE",
     "README",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/fdlcap",
     "features/fdlcap.feature",
     "features/step_definitions/fdlcap_steps.rb",
     "features/support/env.rb",
     "lib/fdlcap.rb",
     "lib/fdlcap/autotagger.rb",
     "lib/fdlcap/craken.rb",
     "lib/fdlcap/database.rb",
     "lib/fdlcap/delayed_job.rb",
     "lib/fdlcap/deploy.rb",
     "lib/fdlcap/geminstaller.rb",
     "lib/fdlcap/newrelic.rb",
     "lib/fdlcap/nginx.rb",
     "lib/fdlcap/performance.rb",
     "lib/fdlcap/rake.rb",
     "lib/fdlcap/recipes.rb",
     "lib/fdlcap/rsync.rb",
     "lib/fdlcap/sass.rb",
     "lib/fdlcap/slice.rb",
     "lib/fdlcap/ssh.rb",
     "lib/fdlcap/symlinks.rb",
     "lib/fdlcap/templates/nginx.auth.conf.erb",
     "lib/fdlcap/templates/nginx.conf.erb",
     "lib/fdlcap/templates/nginx.vhost.conf.erb",
     "lib/fdlcap/thin.rb",
     "lib/fdlcap/thinking_sphinx.rb",
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
