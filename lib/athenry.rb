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
      @setup ||= Setup.new
    end

    def self.build
      @build ||= Build.new
    end

    def self.resume
      @resume ||= Resume.new
    end

    def self.clean
      @clean ||= Clean.new 
    end

    def self.shell
      @shell ||= Shell.new
    end
    
    def self.run
      @run ||= Run.new
    end
  end
end

