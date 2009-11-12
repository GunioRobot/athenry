module Athenry
  class Setup
    
    def initialize
      setup_environment
    end
   
    # If stage file is not found it fetches one from #{CONFIG.stageurl}, then extracts the file.
    # @return [String]
    def stage
      announcing 'Fetching stage tarball' do
        if File.exists?("#{CONFIG.workdir}/#{CONFIG.stageurl}")
          send_to_log('Stage file already exists skipping fetch', 'info')
        else
          cmd "wget -c #{CONFIG.stageurl} -P #{CONFIG.workdir}"
          cmd "wget -c #{CONFIG.stageurl}.DIGESTS -P #{CONFIG.workdir}"
          cmd "wget -c #{CONFIG.stageurl}.CONTENTS -P #{CONFIG.workdir}"
        end
        md5sum(CONFIG.stageurl, 'DIGESTS')
        extract(CONFIG.stageurl, "#{CONFIG.workdir}/#{CONFIG.chrootdir}")
      end
      send_to_state('setup', 'fetch')
    end

    # Fetches a portage snapshot and extracts it to #{CONFIG.chrootdir}/usr/
    # @return [String]
    def snapshot
      announcing 'Fetching portage snapshot' do
        if File.exists?("#{CONFIG.workdir}/#{CONFIG.snapshoturl}")
          send_to_log('Portage snapshot already exists skipping fetch', 'info')
        else
          cmd "wget -c #{CONFIG.snapshoturl} -P #{CONFIG.workdir}"
          cmd "wget -c #{CONFIG.snapshoturl}.md5sum -P #{CONFIG.workdir}"
        end
        md5sum(CONFIG.snapshoturl, 'md5sum')
        extract(CONFIG.snapshoturl, "#{CONFIG.workdir}/#{CONFIG.chrootdir}/usr")
      end
      send_to_state('setup', 'snapshot')
    end

    # Generates dynamic bash configs based on data from config.yml
    # @return [String]
    def generate_bashscripts
      announcing 'Generate bash configuration file' do
        generate_bash('bashconfig', 'config.sh')
      end
      send_to_state('setup', 'generate_bashscripts')
    end

    # Copies build scripts into #{CONFIG.chrootdir}/root
    # @return [String]
    def copy_scripts
      announcing 'Copying scripts into chroot' do
        cmd "cp -Rv #{CONFIG.scripts}/athenry/ #{CONFIG.workdir}/#{CONFIG.chrootdir}/root/"
        cmd "chmod +x #{CONFIG.workdir}/#{CONFIG.chrootdir}/root/athenry/run.sh"
      end
      send_to_state('setup', 'copy_scripts')
    end

    # Copies user config files into #{CONFIG.chrootdir}/etc
    # @return [String]
    def copy_configs
      announcing 'Copying configs into chroot' do
        cmd "cp -vR #{CONFIG.configs}/* #{CONFIG.workdir}/#{CONFIG.chrootdir}/etc/"
      end
      send_to_state('setup', 'copy_configs')
    end
    
    private

    # Checks the md5sum of a file from a url. If the md5sum doesn't passes it exits immediately.
    # @param url [String]
    # @param digest [String]
    # @example
    #   md5sum('http://www.foobar.com/path/file.tar.bz2', 'md5sum') => md5sum -c file.tar.bz2.md5sum --status
    # @return [String]
    def md5sum(url, digest)
      announcing "Checking md5sum of #{filename(url)}" do
        Dir.chdir("#{CONFIG.workdir}") do
          cmd "md5sum -c #{CONFIG.workdir}/#{filename(url)}.#{digest} --status"
        end
      end
    end

    # Extracts the filename from a url, and extracts it to the specified path.
    # @param url [String]
    # @param path [String]
    # @example
    #   extract('http://www.example.com/path/file.tar.bz2', '/var/tmp/athenry/stage5')
    # @return [String]
    def extract(url, path)
      announcing "Extracting #{filename(url)}" do
        cmd "tar xvjpf #{CONFIG.workdir}/#{filename(url)} -C #{path}"
      end
    end

  end
end
