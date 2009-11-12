require 'rubygems'
require 'uri'
require 'erb'

begin
  gem 'configatron', '>= 2.5'
  require 'configatron'
  
  gem "commander", ">= 4.0"
  require "commander/import"
rescue Gem::LoadError
end
