begin
  gem "configatron", ">= 2.5"
  require "configatron"
rescue Gem::LoadError
end

CONFIG = configatron # global alias, shorter than typing configatron

# These I feel should be configurable, but not really left up to the user till
# the configuration system is reworked.
CONFIG.logdir = "log"
CONFIG.statedir = ".athenry"
CONFIG.statefile = "state"
CONFIG.scripts = "#{ATHENRY_ROOT}/scripts/"
CONFIG.homeconfig = "#{ENV['HOME']}/.config/athenry/config.yml"
CONFIG.etcconfig = "/etc/athenry/config.yml"

if File.readable?("#{CONFIG.homeconfig}")
  CONFIG.configure_from_yaml("#{CONFIG.homeconfig}") # Load configuration from yaml
elsif File.readable?("#{CONFIG.etcconfig}")
  CONFIG.configure_from_yaml("#{CONFIG.etcconfig}") 
else
  raise "No configuration file present, please refer to doc/quickstart.markdown"
end
