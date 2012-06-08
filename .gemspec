# -*- encoding: utf-8 -*-
require 'rubygems' unless Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/debugger/completion"

Gem::Specification.new do |s|
  s.name        = "debugger-completion"
  s.version     = Debugger::Completion::VERSION
  s.authors     = ["Gabriel Horner"]
  s.email       = "gabriel.horner@gmail.com"
  s.homepage    = "http://github.com/cldwalker/debugger-completion"
  s.summary = "Mission: autocomplete debugger"
  s.description =  "Provides debugger command and command arguments completion with a completion system more powerful than irb's, compliments of bond."
  s.required_rubygems_version = ">= 1.3.6"
  s.add_dependency 'bond', '>= 0.3.3'
  s.add_dependency 'debugger', '~> 1.1'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc,md} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec}
  s.extra_rdoc_files = ["README.md", "LICENSE.txt"]
  s.license = 'MIT'
end
