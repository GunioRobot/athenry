module Athenry
  class Run
    
    # Executes steps for setup
    def setup
      Athenry::Execute::setup.fetch
      Athenry::Execute::setup.extract
      Athenry::Execute::setup.snapshot
      Athenry::Execute::setup.generate_bashscripts
      Athenry::Execute::setup.copy_scripts
      Athenry::Execute::setup.copy_configs
    end

    # Executes steps for build
    def build
      Athenry::Execute::build.mount
      Athenry::Execute::build.chroot
    end

    # Executes steps to cleanup
    def clean
      Athenry::Execute::clean.unmount
    end

    # Executes the shell
    def shell
      Athenry::Execute::shell.shellinput
    end

    # Resumes from last saved state
    def resume
      Athenry::Execute::resume.from
    end
  end
end
