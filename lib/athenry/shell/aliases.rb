module Athenry
  # These are all aliases for the shell command
  # See the respective classes for more information.
  # * {Athenry::Setup}.
  # * {Athenry::Build}.
  # * {Athenry::Clean}.
  module ShellAliases
    
    def fetch 
      Athenry::Execute::setup.fetch
    end

    def extract
      Athenry::Execute::setup.extract
    end

    def snapshot
      Athenry::Execute::setup.snapshot
    end

    def copy_scripts
      Athenry::Execute::setup.copy_scripts
    end

    def copy_configs
      Athenry::Execute::setup.copy_configs
    end
    
    def generate_bashscripts 
      Athenry::Execute::setup.generate_bashscripts
    end

    def mount
      Athenry::Execute::build.mount
    end

    def chroot 
      Athenry::Execute::build.chroot
    end

    def unmount
      Athenry::Execute::clean.unmount
    end

    def continue 
      Athenry::Execute::resume.from
    end
    
  end
end
