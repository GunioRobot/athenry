module Athenry
  class Freshen 
    include Athenry::Helper

    def initialize
      must_be_root
      check_for_setup
    end
  end
end
