module Athenry
  class Build

    def initialize
      must_be_root
      check_for_setup
      update_chroot
      mount
    end
    
    def target(args)
      args.each { |cmd| send(cmd) }
    end

    def sync
      announcing 'Syncing Portage Tree' do
        chroot 'sync'
      end
      send_to_state('build', 'sync')
    end
    
    def install_pkgmgr
      announcing 'Installing Package Manager' do
        chroot 'install_pkgmgr'
      end
      send_to_state('build', 'install_pkgmgr')
    end

    def update_everything
      announcing 'Updating All Packages' do
        chroot 'update_everything'
      end
      send_to_state('build', 'update_everything')
    end

    def etc_update 
      announcing 'Running etc-update' do
        chroot 'update_configs'
      end
      send_to_state('build', 'etc_update')
    end

    def install_overlays
      announcing 'Installing Overlays' do
        chroot 'install_overlays'
      end
      send_to_state('build', 'install_overlays')
    end

    def install_sets
      announcing 'Installing Sets' do
        chroot 'install_sets'
      end
      send_to_state('build', 'install_overlays')
    end

    def rebuild
      announcing 'Rebuilding' do
        chroot 'rebuild'
      end
      send_to_state('build', 'rebuild')
    end

  end
end
