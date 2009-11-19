require 'rubygems'
require 'uri'
require 'erb'
require 'readline'

begin
  gem 'configatron', '>= 2.5'
  require 'configatron'
  
  gem "commander", ">= 4.0"
  require "commander/import"
  CONFIG = configatron
rescue Gem::LoadError
end

