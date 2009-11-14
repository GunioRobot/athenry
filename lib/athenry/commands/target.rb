module Athenry
  class Target 

    def initialize
      must_be_root
      check_for_setup(:run)
    end

    def build(args)
      args.each { |cmd| send(cmd) }
    end

    # Steps required to build a stage3
    def stage3
      set_nopaludis(:true)
      Athenry::Execute::build.sync
      Athenry::Execute::build.update_everything
      Athenry::Execute::build.update_configs
      Athenry::Execute::build.rebuild
      set_nopaludis(:false)
    end

    # Steps required to build a custom stage
    def custom
      Athenry::Execute::build.install_pkgmgr
      Athenry::Execute::build.sync
      Athenry::Execute::build.update_everything
      Athenry::Execute::build.update_configs
      Athenry::Execute::build.install_overlays
      Athenry::Execute::build.rebuild
    end

  end
end
