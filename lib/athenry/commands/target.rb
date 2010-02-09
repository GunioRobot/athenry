module Athenry
  class Target 

    def build(*args)
      args.each { |cmd| send(cmd) }
    end

    # Steps required to build a stage3
    # @see Athenry::build
    # @return [String]
    def stage3
      set_target
      set_temp_options(:nopaludis => true) do
        Athenry::build.target("install_pkgmgr", "update_everything", "etc_update", "rebuild")
      end
    end

    # Steps required to build a custom stage
    # @see Athenry::build
    # @return [String]
    def custom
      set_target
      Athenry::build.target("install_pkgmgr", "update_everything", "rebuild", "etc_update", "install_overlays", "install_sets", "rebuild")
    end

    # Steps required to setup a chroot
    # @see Athenry::setup
    # @return [String]
    def setup
      set_target
      Athenry::setup.target("fetchstage", "extractstage", "fetchsnapshot", "extractsnapshot", "updatesnapshot", "copysnapshot", "copy_scripts", "copy_configs")
    end

    def freshen
      set_target
      set_temp_options(:freshen => true) do
        Athenry::build.target("update_everything", "etc_update", "rebuild")
      end
    end

  end
end
