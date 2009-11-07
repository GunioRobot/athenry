module Athenry
  class Run
    
    # Executes steps for setup
    # @see Athenry::Setup
    def setup
      Athenry::Execute::setup.fetch
      Athenry::Execute::setup.extract
      Athenry::Execute::setup.snapshot
      Athenry::Execute::setup.generate_bashscripts
      Athenry::Execute::setup.copy_scripts
      Athenry::Execute::setup.copy_configs
    end

    # Executes steps for build
    # @see Athenry::Build
    def build
      Athenry::Execute::build.mount
      Athenry::Execute::build.install_pkgmgr
      Athenry::Execute::build.sync
      Athenry::Execute::build.install_overlays
      Athenry::Execute::build.update_pkgmgr
    end

    # Executes steps to cleanup
    # @see Athenry::Clean
    def clean
      Athenry::Execute::clean.unmount
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
