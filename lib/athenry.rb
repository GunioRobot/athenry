ATHENRY_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(ATHENRY_ROOT)

require 'athenry/depends'
require 'athenry/version'
require 'athenry/config'
require 'athenry/helper'
require 'athenry/state'
require 'athenry/resumetree'
require 'athenry/run'
require 'athenry/commands'
require 'athenry/shell'

# This module contains everything Athenry related
#
# * {Athenry::Setup} is the class used to create directories, and fetch files.
# * {Athenry::Build} is the class used to mount and chroot into your stage for building one command at a time.
# * {Athenry::Resume} is the class that allows you to resume from your previous state.
# * {Athenry::Target} is the class that allows you to build a full target stage, stage3 or custom.
# * {Athenry::Freshen} is the class that will update an existing chroot
# * {Athenry::Rescue} is the class that will chroot you into an existing chrootdir to preform manual repairs/commands
# * {Athenry::Clean} is the class that will unmount and clean up temp files.
# * {Athenry::Shell} is the class that gives you an irb like shell.
# * {Athenry::Run} is a class that wraps all the steps need for each step.
module Athenry
  # See {Athenry} for more information. 
  module Execute
    
    # Initiates Setup [Class]
    # @see Athenry::Setup
    def self.setup
      Setup.new
    end
   
    # Initiates Build [Class]
    # @see Athenry::Build
    def self.build
      Build.new
    end
    
    # Initiates Target [Class]
    # @see Athenry::Target
    def self.target
      Target.new
    end
 
    # Initiates Freshen [Class]
    # @see Athenry::Freshen
    def self.freshen
      Freshen.new
    end   
    
    # Initiates Resume [Class]
    # @see Athenry::Resume
    def self.resume
      Resume.new
    end

    # Initiates Clean [Class]
    # @see Athenry::Clean
    def self.clean
      Clean.new 
    end

    # Initiates Shell [Class]
    # @see Athenry::Shell
    def self.shell
      Shell.new
    end
    
    # Initiates Rescue [Class]
    # @see Athenry::Rescue
    def self.rescue
      Rescue.new
    end
    
    # Initiates Run [Class]
    # @see Athenry::Run
    def self.run
      Run.new
    end
  end
end
