module Athenry
  # These are all aliases for the shell command
  # See the respective classes for more information.
  # * {Athenry::Setup}.
  # * {Athenry::Build}.
  # * {Athenry::Clean}.
  module ShellAliases
   
    # @see Athenry::Setup#stage
    def stage 
      Athenry::Execute::setup.stage
    end

    # @see Athenry::Setup#snapshot
    def snapshot
      Athenry::Execute::setup.snapshot
    end

    # @see Athenry::Setup#copy_scripts
    def copy_scripts
      Athenry::Execute::setup.copy_scripts
    end

    # @see Athenry::Setup#copy_configs
    def copy_configs
      Athenry::Execute::setup.copy_configs
    end
    
    # @see Athenry::Setup#generate_bashscripts
    def generate_bashscripts 
      Athenry::Execute::setup.generate_bashscripts
    end

    # @see Athenry::Build#mount
    def mount
      Athenry::Execute::build.mount
    end

    # @see Athenry::Build#chroot
    def chroot 
      Athenry::Execute::build.chroot
    end

    # @see Athenry::Clean#unmount
    def unmount
      Athenry::Execute::clean.unmount
    end

    # @see Athenry::Resume#from
    def continue 
      Athenry::Execute::resume.from
    end
    
  end
end
