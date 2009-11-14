CONFIG = configatron # global alias, shorter than typing configatron

# Options we didn't really want to leave up the user as of right now. 
CONFIG.logdir = 'log'
CONFIG.chrootdir = "chroot"
CONFIG.logfile = "#{CONFIG.chrootdir}.log"
CONFIG.statedir = '.athenry'
CONFIG.statefile = 'state'
CONFIG.scripts = "#{ATHENRY_ROOT}/scripts/"
CONFIG.homeconfig = "#{ENV['HOME']}/.config/athenry/config.rb"
CONFIG.etcconfig = '/etc/athenry/config.rb'

if File.readable?("#{CONFIG.homeconfig}")
  require "#{CONFIG.homeconfig}"
  CONFIG.configs = "#{ENV['HOME']}/.config/athenry/etc/#{CONFIG.arch}"
elsif File.readable?("#{CONFIG.etcconfig}")
  require "#{CONFIG.etcconfig}"
  CONFIG.configs = "/etc/athenry/etc/#{CONFIG.arch}"
else
  raise 'No configuration file present, please refer to doc/quickstart.markdown'
end
