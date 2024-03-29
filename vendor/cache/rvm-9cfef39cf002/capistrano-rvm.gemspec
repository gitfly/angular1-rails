# -*- encoding: utf-8 -*-
# stub: capistrano-rvm 0.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "capistrano-rvm"
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Kir Shatrov"]
  s.date = "2015-03-16"
  s.description = "RVM integration for Capistrano"
  s.email = ["shatrov@me.com"]
  s.files = [".gitignore", "CHANGELOG.md", "Gemfile", "LICENSE.txt", "README.md", "Rakefile", "capistrano-rvm.gemspec", "lib/capistrano-rvm.rb", "lib/capistrano/rvm.rb", "lib/capistrano/tasks/rvm.rake"]
  s.homepage = "https://github.com/capistrano/rvm"
  s.rubygems_version = "2.4.5"
  s.summary = "RVM integration for Capistrano"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, ["~> 3.0"])
      s.add_runtime_dependency(%q<sshkit>, ["~> 1.2"])
    else
      s.add_dependency(%q<capistrano>, ["~> 3.0"])
      s.add_dependency(%q<sshkit>, ["~> 1.2"])
    end
  else
    s.add_dependency(%q<capistrano>, ["~> 3.0"])
    s.add_dependency(%q<sshkit>, ["~> 1.2"])
  end
end
