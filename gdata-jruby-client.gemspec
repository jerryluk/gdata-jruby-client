Gem::Specification.new do |s|
  s.name = %q{gdata-jruby-client}
  s.version = '0.7.4'
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ['Jerry Luk']
  s.date = %q{2010-02-03}
  s.description = %q{The GData JRuby Client allows you to easily access data through Google Data APIs. It uses the GData Java Client Library from Google.}
  s.email = %q{jerry@presdo.com}
  s.files = ["README", "MIT-LICENSE"] + Dir.glob("{lib, spec}/**/*")
  s.homepage = %q{http://github.com/jerryluk/gdata-jruby-client}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = s.description
  s.test_files = Dir.glob("spec/**/*")
  s.add_dependency('activesupport', '>=2.2.2')
end