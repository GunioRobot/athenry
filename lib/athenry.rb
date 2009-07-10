require "athenry/config"
require "athenry/helper"
require "athenry/setup"
require "athenry/build"

module Athenry

  def self.setup
    @setup ||= Setup.new
  end

  def self.build
    @build ||= Build.new
  end

end

