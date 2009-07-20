module Athenry
  class Run
    def initialize
      Dir.chdir("#{CONFIG['WORKDIR']}")
    end
    
    def setup
      puts "Setup"
      puts Dir.pwd
    end

    def build
      puts "Build"
    end
  end
end
