module Athenry
  class Build

    def initialize
      check_for_setup(:run)
      update_chroot
      mount
    end
    
    def target(*args)
      args.each { |cmd| send(cmd) }
    end
    
    # Syncs the portage tree within your chroot
    # @return [String]
    def sync
      announcing 'Syncing Portage Tree' do
        chroot 'sync'
      end
      set_state
    end
    
    # Installs the package manager set via RCONFIG.athenry.package_manager
    # @return [String]
    def install_pkgmgr
      announcing 'Installing Package Manager' do
        chroot 'install_pkgmgr'
      end
      set_state
    end

    # Updates world and system
    # @return [String]
    def update_everything
      announcing 'Updating All Packages' do
        chroot 'update_everything'
      end
      set_state
    end

    def emerge_system
      announcing "Installing system packages" do
        chroot 'emerge_system'
      end
    set_state
    end

    def bootstrap
      announcing "Bootstraping" do
        chroot 'bootstrap'
      end
      set_state
    end

    # Runs etc-update to update your config files
    # @return [String]
    def etc_update 
      announcing 'Running etc-update' do
        system("chroot #{$chrootdir} /scripts/run.sh update_configs")
      end
      set_state
    end

    # Installs any overlays you have specified via CONFIG.overlays 
    # using either playman or layman.
    # @return [String]
    def install_overlays
      announcing 'Installing Overlays' do
        chroot 'install_overlays'
      end
      set_state
    end

    # Installs sets you have specified via CONFIG.sets
    # @return [String]
    def install_sets
      announcing 'Installing Sets' do
        chroot 'install_sets'
      end
      set_state
    end

    # This attempts to fix any problems in your chroot by running
    # some common commands.
    # * Emerge:
    #   - revdep-rebuild
    #   - python-updater
    # * Paludis:
    #   - reconcilio
    #   - python-updater -P paludis
    def rebuild
      announcing 'Rebuilding' do
        chroot 'rebuild'
      end
      set_state
    end

  end
end
