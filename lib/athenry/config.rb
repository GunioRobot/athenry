begin
  gem "configatron", ">= 2.5"
  require "configatron"
rescue Gem::LoadError
  # handle the error somehow
end

CONFIG = configatron # global alias, shorter than typing configatron
CONFIG.configure_from_yaml("#{ATHENRY_ROOT}/config.yml") # Load configuration from yaml
