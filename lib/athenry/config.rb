#begin
  #gem "configatron", ">= 2.3"
  #require "commander"
#rescue Gem::LoadError
  ## handle the error somehow
#end
require 'yaml'
CONFIG = YAML::load(File.open("../" + "config.yml"))
