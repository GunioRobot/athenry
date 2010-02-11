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
      heading 'Last & Next Sync'
      row 'Last Sync', lastsync
      row 'Next Sync', nextsync
    end

    def builds
      heading 'Latest Builds'
      latest_builds
    end

    def env
      heading 'Athenry'
      row 'Version', Athenry::Version::STRING
      heading 'General Settings'
      row 'Workdir', WORKDIR
      row 'Timezone', RConfig.athenry.general.timezone
      row 'Verbose', $verbose
      row 'Config Profile', RConfig.athenry.general.config_profile
      heading 'URLs'
      row 'Stage URL', $stageurl
      row 'Snapshot URL', $snapshoturl
      heading 'Overlays'
      print_overlays
      heading 'Gentoo'
      row 'Rsync Mirror', SYNC
      row 'Sets', RConfig.athenry.gentoo.sets
      row 'Package Manager', RConfig.athenry.gentoo.package_manager
      row 'Profile', RConfig.athenry.gentoo.profile
      heading 'proxy'
      row 'HTTP Proxy', HTTP_PROXY
      row 'FTP Proxy', FTP_PROXY
    end

  end
end
