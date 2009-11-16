module Athenry
  class Target 

    def initialize
      must_be_root
      check_for_setup(:run)
      update_chroot
    end

    def build(args)
      args.each { |cmd| send(cmd) }
    end

    # Steps required to build a stage3
    # @see Athenry::Execute::build
    # @return [String]
    def stage3
      set_temp_options(:nopaludis => true) do
        Athenry::Execute::build.install_pkgmgr
        Athenry::Execute::build.sync
        Athenry::Execute::build.update_everything
        Athenry::Execute::build.update_configs
        Athenry::Execute::build.rebuild
      end
    end

    # Steps required to build a custom stage
    # @see Athenry::Execute::build
    # @return [String]
    def custom
      Athenry::Execute::build.install_pkgmgr
      Athenry::Execute::build.sync
      Athenry::Execute::build.update_everything
      Athenry::Execute::build.rebuild
      Athenry::Execute::build.update_configs
      Athenry::Execute::build.install_overlays
      Athenry::Execute::build.install_sets
      Athenry::Execute::build.rebuild
    end

  end
end
