# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_as_list}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bruno Michel", "Ryan Bates", "Rails Core"]
  s.date = %q{2011-01-24}
  s.description = %q{Gem version of acts_as_list Rails plugin}
  s.email = %q{bmichel@menfin.info}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "README",
    "Rakefile",
    "init.rb",
    "lib/active_record/acts/list.rb",
    "test/list_test.rb"
  ]
  s.homepage = %q{http://github.com/rails/acts_as_list}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Gem version of acts_as_list Rails plugin}
  s.test_files = [
    "test/list_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 1.15.4.7794"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 1.15.4.7794"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 1.15.4.7794"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
