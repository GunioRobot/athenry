module Athenry
  class Target 

    def initialize
    end

    def build(*args)
      args.each { |cmd| send(cmd) }
    end

    # Steps required to build a stage3
    # @see Athenry::build
    # @return [String]
    def stage3
      set_temp_options(:nopaludis => true) do
        Athenry::build.target("install_pkgmgr", "sync", "update_everything", "update_configs", "rebuild")
      end
    end

    # Steps required to build a custom stage
    # @see Athenry::build
    # @return [String]
    def custom
      Athenry::build.target("install_pkmgr", "sync", "update_everything", "rebuild", "update_configs", "install_overlays", "install_sets", "rebuild")
    end

    def setup
      Athenry::setup.target("fetchstage", "extractstage", "fetchsnapshot", "updatesnapshot", "copysnapshot", "copy_scripts", "copy_configs")
    end

  end
end
