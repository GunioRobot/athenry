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
# * {Athenry::Setup} is the class used to create directories, and fetch files.
# * {Athenry::Build} is the class used to mount and chroot into your stage for building.
# * {Athenry::Resume} is the class that allows you to resume from your previous state.
# * {Athenry::Clean} is the class that will unmount and clean up temp files.
# * {Athenry::Shell} is the class that gives you an irb like shell.
# * {Athenry::Run} is a class that wraps all the steps need for each step.

module Athenry
  # See {Athenry} for more information. 
  module Execute
    # @see Athenry::Setup
    def self.setup
      Setup.new
    end
    
    # @see Athenry::Build
    def self.build
      Build.new
    end

    # @see Athenry::Resume
    def self.resume
      Resume.new
    end

    # @see Athenry::Clean
    def self.clean
      Clean.new 
    end

    # @see Athenry::Shell
    def self.shell
      Shell.new
    end
    
    # @see Athenry::Run
    def self.run
      Run.new
    end
  end
end
