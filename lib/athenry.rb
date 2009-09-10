ATHENRY_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(ATHENRY_ROOT)

require "athenry/config"
require "athenry/helper"
require "athenry/state"
require "athenry/resumetree"
require "athenry/run"
require "athenry/commands"
require "athenry/shell"

module Athenry
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
