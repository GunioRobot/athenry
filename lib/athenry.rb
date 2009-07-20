require "athenry/config"
require "athenry/helper"
require "athenry/run"
require "athenry/setup"
require "athenry/build"

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
  end
end

