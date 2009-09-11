ATHENRY_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(ATHENRY_ROOT)

require "athenry/config"
require "athenry/helper"
require "athenry/state"
require "athenry/resumetree"
require "athenry/run"
require "athenry/commands"
require "athenry/shell"

# This module contains everything Athenry related
#
# * {Athenry::Execute.setup} is the class used to create directories, and fetch files.
# * {Athenry::Execute.build} is the class used to mount and chroot into your stage for building.
# * {Athenry::Execute.resume} is the class that allows you to resume from your previous state.
# * {Athenry::Execute.clean} is the class that will unmount and clean up temp files.
# * {Athenry::Execute.shell} is the class that gives you an irb like shell.
# * {Athenry::Execute.run} is a class that wraps all the steps need for each step.

module Athenry
  # See {Athenry} for more details
  module Execute
    def self.setup
      Setup.new
    end

    def self.build
      Build.new
    end

    def self.resume
      Resume.new
    end

    def self.clean
      Clean.new 
    end

    def self.shell
      Shell.new
    end
    
    def self.run
      Run.new
    end
  end
end
