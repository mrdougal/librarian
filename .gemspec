# ripped from http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended/

# gems:
#   - zipruby (0.3.6)

=begin
# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'bundler/version'
 
Gem::Specification.new do |s|
  s.name        = "bundler"
  s.version     = Bundler::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Carl Lerche", "Yehuda Katz", "André Arko"]
  s.email       = ["carlhuda@engineyard.com"]
  s.homepage    = "http://github.com/carlhuda/bundler"
  s.summary     = "The best way to manage your application's dependencies"
  s.description = "Bundler manages an application's dependencies through its entire life, across many machines, systematically and repeatably"
 
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "bundler"
 
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
  s.executables  = ['bundle']
  s.require_path = 'lib'
end

=end
