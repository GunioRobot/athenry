module Athenry
  class Run
    
    # Executes steps for setup
    # @see Athenry::Setup
    def setup
      Athenry::Execute::setup.stage
      Athenry::Execute::setup.snapshot
      Athenry::Execute::setup.generate_bashscripts
      Athenry::Execute::setup.copy_scripts
      Athenry::Execute::setup.copy_configs
    end

    # Executes a single command on the chroot
    # @see Athenry::Build
    def build(args)
      Athenry::Execute::build.target(*args)
    end

    # Executes a group set of commands on the chroot
    # @see Athenry::Target
    def target(args)
      Athenry::Execute::target.build(*args)
    end

    # Updates an existing chroot 
    # @see Athenry::Freshen
    def freshen(args)
      Athenry::Execute::freshen.update(*args)
    end

    # Executes steps to cleanup
    # @see Athenry::Clean
    def clean
      Athenry::Execute::clean.unmount
    end
  
    # Executes steps to chroot into shell
    # @see Athenry::Rescue
    def rescue 
      Athenry::Execute::rescue.target
    end
    
    # Executes the shell
    # @see Athenry::Shell
    def shell
      Athenry::Execute::shell.shellinput
    end

    # Resumes from last saved state
    # @see Athenry::Resume
    def resume
      Athenry::Execute::resume.from
    end
  end
end
