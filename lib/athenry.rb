require "athenry/config"
require "athenry/helper"
require "athenry/run"
require "athenry/setup"
require "athenry/build"
require "athenry/clean"
require "athenry/shell"

module Athenry
  module Execute
    def self.setup
      @setup ||= Setup.new
    end

    def self.build
      @build ||= Build.new
    end

    def self.run
      @run ||= Run.new
    end

    def self.clean
      @clean ||= Clean.new 
    end

    def self.shell
      @shell ||= Shell.new
    end
  end
end

