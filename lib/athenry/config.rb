module Athenry
  module Config
      $shell_is_running = false
      
      # These are dynamic and are changed by Athenry::Helper#set_temp_options
      CONFIG.nopaludis=false
      CONFIG.freshen=false
      # Options we didn't really want to leave up the user as of right now. 
      CONFIG.logdir = 'log'
      CONFIG.chrootdir = "chroot"
      CONFIG.logfile = "#{CONFIG.chrootdir}.log"
      CONFIG.statedir = '.athenry'
      CONFIG.statefile = 'state'
      CONFIG.scripts = "#{ATHENRY_ROOT}/scripts/"
      CONFIG.homeconfig = "#{ENV['HOME']}/.config/athenry"
      CONFIG.etcconfig = '/etc/athenry'

      if File.readable?("#{CONFIG.homeconfig}/config.rb")
        require "#{CONFIG.homeconfig}/config.rb"
        CONFIG.configs = "#{CONFIG.homeconfig}/etc/#{CONFIG.arch}"
      elsif File.readable?("#{CONFIG.etconfig}/config.rb")
        require "#{CONFIG.etcconfig}/config.rb"
        CONFIG.configs = "#{CONFIG.etcconfig}/etc/#{CONFIG.arch}"
      else
        raise 'No configuration file present, please refer to doc/quickstart.markdown'
      end
  end
end
