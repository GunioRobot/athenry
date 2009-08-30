module Athenry
  class Run
    def initialize
      unless File.directory?("#{CONFIG['BASE']}")
        FileUtils.mkdir_p("#{CONFIG['BASE']}")
      end
      Dir.chdir("#{CONFIG['WORKDIR']}")
    end
    
    def setup
      Athenry::Execute::setup.fetch
      Athenry::Execute::setup.extract
      Athenry::Execute::setup.snapshot
      Athenry::Execute::setup.copy_scripts
      Athenry::Execute::setup.copy_configs
    end

    def build
      Athenry::Execute::build.mount
      Athenry::Execute::build.chroot
    end

    def clean
      Athenry::Execute::clean.unmount
    end

    def shell
      Athenry::Execute::shell
    end
  end
end
