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
      send_to_state('build', 'sync')
    end
    
    # Installs the package manager set via CONFIG.pkgmgr
    # @return [String]
    def install_pkgmgr
      announcing 'Installing Package Manager' do
        chroot 'install_pkgmgr'
      end
      send_to_state('build', 'install_pkgmgr')
    end

    # Updates world and system
    # @return [String]
    def update_everything
      announcing 'Updating All Packages' do
        chroot 'update_everything'
      end
      send_to_state('build', 'update_everything')
    end

    # Runs etc-update to update your config files
    # @return [String]
    def etc_update 
      announcing 'Running etc-update' do
        system("chroot #{$chrootdir} /scripts/run.sh update_configs")
      end
      send_to_state('build', 'etc_update')
    end

    # Installs any overlays you have specified via CONFIG.overlays 
    # using either playman or layman.
    # @return [String]
    def install_overlays
      announcing 'Installing Overlays' do
        chroot 'install_overlays'
      end
      send_to_state('build', 'install_overlays')
    end

    # Installs sets you have specified via CONFIG.sets
    # @return [String]
    def install_sets
      announcing 'Installing Sets' do
        chroot 'install_sets'
      end
      send_to_state('build', 'install_sets')
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
      send_to_state('build', 'rebuild')
    end

  end
end
