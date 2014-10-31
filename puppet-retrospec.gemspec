# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: puppet-retrospec 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "puppet-retrospec"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Corey Osman"]
  s.date = "2014-10-31"
  s.description = "Retrofits and generates valid puppet rspec test code to existing modules"
  s.email = "corey@logicminds.biz"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".travis.yml",
    "Gemfile",
    "LICENSE",
    "README.md",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/helpers.rb",
    "lib/puppet-retrospec.rb",
    "lib/templates/fixtures_file.erb",
    "lib/templates/resource-spec_file.erb",
    "lib/templates/shared_context.erb",
    "lib/templates/spec_helper_file.erb",
    "puppet-retrospec.gemspec",
    "spec/fixtures/includes-class.pp",
    "spec/fixtures/includes-defines.pp",
    "spec/spec_helper.rb",
    "spec/unit/puppet-retrospec_spec.rb"
  ]
  s.homepage = "http://github.com/logicminds/puppet-retrospec"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.1"
  s.summary = "Generates puppet rspec test code based on the classes and defines inside the manifests directory. Aims to reduce some of the boilerplate coding with default test patterns."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<puppet>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.7"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.7"])
    else
      s.add_dependency(%q<puppet>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<yard>, ["~> 0.7"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.7"])
    end
  else
    s.add_dependency(%q<puppet>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<yard>, ["~> 0.7"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.7"])
  end
end

