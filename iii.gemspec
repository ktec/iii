# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "iii/version"

spec = Gem::Specification.new do |s| 
  s.name = 'iii'
  s.version = Iii::VERSION
  s.author = 'Keith Salisbury'
  s.email = 'keithsalisbury@gmail.com'
  s.homepage = 'http://github.com/ktec/iii'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A command line interface to iii.co.uk'
# Add your other files here if you make them
  s.files = `git ls-files`.split("\n")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','iii.rdoc']
  s.rdoc_options << '--title' << 'iii' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'iii'
  s.add_dependency 'mechanize'
  s.add_dependency 'encryptor'
  s.add_dependency 'highline'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
end
