module Athenry
  class Info
    
    def target(*args)
      args.each { |cmd| send(cmd) }
    end

    def chroots 
      chroot_dirs.each do |chroot|
        puts File.basename(chroot)
      end
    end

    def sync 
      heading 'Last & Next Sync' do
        row 'Last Sync', lastsync.strftime(RConfig.athenry.general.datetime_format)
        row 'Next Sync', nextsync.strftime(RConfig.athenry.general.datetime_format)
      end
    end

    def builds
      heading 'Latest Builds' do
        latest_builds
      end
    end

    def env
      heading 'Athenry' do
        row 'Version', Athenry::Version::STRING
      end
      heading 'General Settings' do
        row 'Workdir', WORKDIR
        row 'Timezone', RConfig.athenry.general.timezone
        row 'Verbose', $verbose
        row 'Config Profile', RConfig.athenry.general.config_profile
      end
      heading 'URLs' do
        row 'Stage URL', $stageurl
        row 'Snapshot URL', $snapshoturl
      end
      heading 'Overlays' do
        print_overlays
      end
      heading 'Gentoo' do
        row 'Rsync Mirror', SYNC
        row 'Sets', RConfig.athenry.gentoo.sets
        row 'Package Manager', RConfig.athenry.gentoo.package_manager
        row 'Profile', RConfig.athenry.gentoo.profile
      end
      heading 'proxy' do
        row 'HTTP Proxy', HTTP_PROXY
        row 'FTP Proxy', FTP_PROXY
      end
    end

  end
end
