require "athenry/config"
require "athenry/helper"
require "athenry/setup"
require "athenry/build"

module Athenry
  module Execute
    def setup
      @setup ||= Setup.new
      @setup.fetch
      @setup.extract
    end

    def build
      @build ||= Build.new
    end
  end
end

