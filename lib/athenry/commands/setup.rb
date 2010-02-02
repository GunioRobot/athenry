module Athenry
  class Setup
    
    def initialize
      setup_environment
    end
    
    def target(*args)
      args.each { |cmd| send(cmd) }
    end

    # If stage file is not found it fetches one from $stageurl, then extracts the file.
    # @return [String]
    def fetchstage
      announcing 'Fetching stage tarball' do
          Athenry::fetch(:uri => $stageurl, :location => STAGEDIR)
          Athenry::fetch(:uri => "#{$stageurl}.DIGESTS", :location => STAGEDIR)
          Athenry::fetch(:uri => "#{$stageurl}.CONTENTS", :location => STAGEDIR)
      end
      send_to_state('setup', 'fetchstage')
    end

    def extractstage
      announcing 'Extracting stage tarball' do
        unless File.exists?("#{$chrootdir}/root/")
          Athenry::md5sum(:uri => $stageurl, :path => STAGEDIR)
          Athenry::extract(:uri => $stageurl, :path => STAGEDIR, :location => $chrootdir)
        end
      end
      send_to_state('setup', 'extractstage')
    end

    # Fetches a portage snapshot and extracts it to $chrootdir/usr/
    # @return [String]
    def fetchsnapshot
      announcing 'Fetching portage snapshot' do
        unless File.exists?("#{SNAPSHOTDIR}/#{filename($snapshoturl)}")
          Athenry::fetch(:uri => $snapshoturl, :location => SNAPSHOTDIR)
          Athenry::fetch(:uri => "#{$snapshoturl}.md5sum", :location => SNAPSHOTDIR)
        end
        unless File.exists?("#{SNAPSHOTCACHE}/portage/")
          Athenry::md5sum(:uri => $snapshoturl, :path => SNAPSHOTDIR, :digest => 'md5sum')
          Athenry::extract(:uri => $snapshoturl, :path => SNAPSHOTDIR, :location => SNAPSHOTCACHE)
        end
      end
      send_to_state('setup', 'snapshot')
    end

    def updatesnapshot
      announcing "Updating snapshot cache" do
        if safe_sync 
          Athenry::sync(:uri => "rsync://rsync.gentoo.org/gentoo-portage", :output => "#{SANPSHOTCACHE}/portage/")
        end
      end
      send_to_state('setup', 'updatesnapshot')
    end
    
    def copysnapshot
      announcing 'Copying snapshot to chroot' do
        Athenry::sync(:options => "-rPIh --delete", :uri => "#{SNAPSHOTCACHE}/portage/", :output => "#{$chrootdir}/usr/portage/")
      end
      send_to_state('setup', 'copysnapshot')
    end

    # Copies build scripts into $chrootdir/root
    # @return [String]
    def copy_scripts
      announcing 'Copying scripts into chroot' do
        update_scripts
      end
      send_to_state('setup', 'copy_scripts')
    end

    # Copies user config files into $chrootdir/etc
    # @return [String]
    def copy_configs
      announcing 'Copying configs into chroot' do
        update_configs
      end
      send_to_state('setup', 'copy_configs')
    end
    
  end
end
