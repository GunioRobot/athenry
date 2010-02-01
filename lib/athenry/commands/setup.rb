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
        if File.exists?("#{STAGEDIR}/#{$stageurl}")
          send_to_log('Stage file already exists skipping fetch', 'info')
        else
          Athenry::fetch(:uri => $stageurl, :location => STAGEDIR).fetch_file
          Athenry::fetch(:uri => "#{$stageurl}.DIGESTS", :location => STAGEDIR).fetch_file
          Athenry::fetch(:uri => "#{$stageurl}.CONTENTS", :location => STAGEDIR).fetch_file
        end
      end
      send_to_state('setup', 'fetchstage')
    end

    def extractstage
      announcing 'Extracting stage tarball' do
        unless File.exists?("#{$chrootdir}/root/")
          Athenry::extract(:uri => $stageurl, :path => STAGEDIR).md5sum
          Athenry::extract(:uri => $stageurl, :path => STAGEDIR, :location => $chrootdir).deflate
        end
      end
      send_to_state('setup', 'extractstage')
    end

    # Fetches a portage snapshot and extracts it to $chrootdir/usr/
    # @return [String]
    def fetchsnapshot
      announcing 'Fetching portage snapshot' do
        if File.exists?("#{WORKDIR}/#{$snapshoturl}")
          send_to_log('Portage snapshot already exists skipping fetch', 'info')
        else
          Athenry::fetch(:uri => $snapshoturl, :location => SNAPSHOTDIR).fetch_file
          Athenry::fetch(:uri => "#{$snapshoturl}.md5sum", :location => SNAPSHOTDIR).fetch_file
        end
        unless File.exists?("#{SNAPSHOTCACHE}/portage/")
          Athenry::extract(:uri => $snapshoturl, :path => SNAPSHOTDIR).md5sum
          Athenry::extract(:uri => $snapshoturl, :path => SNAPSHOTDIR, :location => SNAPSHOTCACHE).deflate
        end
      end
      send_to_state('setup', 'snapshot')
    end

    def updatesnapshot
      Dir.chdir("#{SNAPSHOTCACHE}/portage") do 
        cmd "rsync -apv --delete rsync://rsync.gentoo.org/gentoo-portage ."
      end
      send_to_state('setup', 'updatesnapshot')
    end
    
    def copysnapshot
      announcing 'Copying snapshot to chroot' do
        cmd "rsync -rPIh --delete #{SNAPSHOTCACHE}/portage/ #{$chrootdir}/usr/portage/"
      end
      send_to_state('setup', 'copysnapshot')
    end

    # Generates dynamic bash configs based on data from config.rb
    # @return [String]
    def generate_bashscripts
      announcing 'Generate bash configuration file' do
        generate_bash('bashconfig', 'config.sh')
      end
      send_to_state('setup', 'generate_bashscripts')
    end

    # Copies build scripts into $chrootdir/root
    # @return [String]
    def copy_scripts
      announcing 'Copying scripts into chroot' do
        cmd "cp -Rv #{SCRIPTS}/athenry/ #{$chrootdir}/root/"
        cmd "chmod +x #{$chrootdir}/root/athenry/run.sh"
      end
      send_to_state('setup', 'copy_scripts')
    end

    # Copies user config files into $chrootdir/etc
    # @return [String]
    def copy_configs
      announcing 'Copying configs into chroot' do
        cmd "cp -vR #{CONFIGS}/* #{$chrootdir}/etc/"
      end
      send_to_state('setup', 'copy_configs')
    end
    
  end
end
