begin
  gem "configatron", ">= 2.5"
  require "configatron"
rescue Gem::LoadError
  # handle the error somehow
end

CONFIG = configatron # global alias, shorter than typing configatron

# These I feel should be configurable, but not really left up to the user till
# the configuration system is reworked.
CONFIG.logdir = "log"
CONFIG.statedir = ".athenry"
CONFIG.statefile = "state"
CONFIG.scripts = "#{ATHENRY_ROOT}/scripts/"

CONFIG.configure_from_yaml("#{ATHENRY_ROOT}/config.yml") # Load configuration from yaml
