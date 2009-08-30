begin
  gem "configatron", ">= 2.3"
  require "configatron"
rescue Gem::LoadError
  # handle the error somehow
end

CONFIG = configatron
CONFIG.configure_from_yaml("#{ATHENRY_ROOT}/config.yml")

#require 'yaml'
#CONFIG = YAML::load(File.open("../" + "config.yml"))
