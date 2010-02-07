module Athenry
  class Setup
    
    def initialize
      setup_environment
    end
    
    def target(*args)
      args.each { |cmd| send(cmd) }
    end

    # If stage file is not found it fetches one from $stageurl
    # @return [String]
    def fetchstage
      announcing 'Fetching stage tarball' do
          Athenry::fetch(:uri => $stageurl, :location => STAGEDIR)
          Athenry::fetch(:uri => "#{$stageurl}.DIGESTS", :location => STAGEDIR)
          Athenry::fetch(:uri => "#{$stageurl}.CONTENTS", :location => STAGEDIR)
      end
      send_to_state('setup', 'fetchstage')
    end

    # Extracts the stage file we downloaded.
    # @return [String]
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
      end
      send_to_state('setup', 'fetchsnapshot')
    end

    # Extracts the snapshot tarball
    # @return [String]
    def extractsnapshot
      announcing 'Extracting portage snapshot' do
        unless File.exists?("#{SNAPSHOTCACHE}/portage/")
          Athenry::md5sum(:uri => $snapshoturl, :path => SNAPSHOTDIR, :digest => 'md5sum')
          Athenry::extract(:uri => $snapshoturl, :path => SNAPSHOTDIR, :location => SNAPSHOTCACHE)
        end
      end
      send_to_state('setup', 'extractsnapshot')
    end

    # Uses rsync and RConfig.gentoo.sync to update the snapshot cache
    # @return [String]
    def updatesnapshot
      announcing "Updating snapshot cache" do
        if safe_sync 
          Athenry::sync(:options => "--recursive --links --safe-links --perms --times --compress --force\
                        --whole-file --delete --stats --timeout=180 --exclude=/distfiles --exclude=/local\
                        --exclude=/packages", 
                        :uri => "#{SYNC}", 
                        :output => "#{SANPSHOTCACHE}/portage/")
        end
      end
      send_to_state('setup', 'updatesnapshot')
    end
   
    # Copies the snapshot cache into your chroot directory
    # @return [String]
    def copysnapshot
      announcing 'Copying snapshot to chroot' do
        Athenry::sync(:options => "--verbose --progress --recursive --links --safe-links --perms\
                      --times --force --whole-file --delete --stats",
                      :uri => "#{SNAPSHOTCACHE}/portage/", 
                      :output => "#{$chrootdir}/usr/portage/")
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
