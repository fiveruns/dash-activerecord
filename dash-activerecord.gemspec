# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dash-activerecord}
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["FiveRuns Development Team"]
  s.date = %q{2009-02-18}
  s.description = %q{Provides an API to send metrics from applications using ActiveRecord to the FiveRuns Dash service}
  s.email = %q{dev@fiveruns.com}
  s.files = ["README.rdoc", "VERSION.yml", "lib/fiveruns", "lib/fiveruns/dash", "lib/fiveruns/dash/recipes", "lib/fiveruns/dash/recipes/activerecord.rb", "lib/fiveruns-dash-activerecord.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/fiveruns/dash-activerecord}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{FiveRuns Dash recipe for ActiveRecord}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fiveruns-dash-ruby>, [">= 0.8.0"])
    else
      s.add_dependency(%q<fiveruns-dash-ruby>, [">= 0.8.0"])
    end
  else
    s.add_dependency(%q<fiveruns-dash-ruby>, [">= 0.8.0"])
  end
end
