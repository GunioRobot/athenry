require 'rubygems'
require 'uri'

begin
  gem 'configatron', '>= 2.5'
  require 'configatron'
  
  gem "commander", ">= 4.0"
  require "commander/import"
rescue Gem::LoadError
end
