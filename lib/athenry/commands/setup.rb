module Athenry
  class Setup
    
    def initialize
      setup_environment
    end
   
    # If stage file is not found it fetches one from #{CONFIG.stageurl}
    # @return [String]
    def fetch
      announcing "Fetching stage file" do
        if File.exists?("#{CONFIG.workdir}/stage3-amd64-current.tar.bz2")
          send_to_log("Stage file already exists skipping fetch", "info")
        else
          cmd "wget -c #{CONFIG.stageurl} -O #{CONFIG.workdir}/stage3-amd64-current.tar.bz2"
        end
      end
      send_to_state("setup", "fetch")
    end

    # Extracts the downloaded stage tarball to #{CONFIG.chrootdir}
    # @return [String]
    def extract
      announcing "Extracting stage file" do
          cmd "tar xvjpf #{CONFIG.workdir}/stage3-amd64-current.tar.bz2 -C #{CONFIG.workdir}/#{CONFIG.chrootdir}"
        end
      send_to_state("setup", "extract")
    end

    # Fetches a portage snapshot and extracts it to #{CONFIG.chrootdir}/usr/
    # @return [String]
    def snapshot
      announcing "Fetching and extracting portage snapshot" do
        if File.exists?("#{CONFIG.workdir}/portage-latest.tar.bz2")
          send_to_log("Portage snapshot already exists skipping fetch", "info")
        else
          cmd "wget -c #{CONFIG.snapshoturl} -O #{CONFIG.workdir}/portage-latest.tar.bz2"
        end
        cmd "tar xvjpf #{CONFIG.workdir}/portage-latest.tar.bz2 -C #{CONFIG.workdir}/#{CONFIG.chrootdir}/usr"
      end
      send_to_state("setup", "snapshot")
    end

    # Generates dynamic bash configs based on data from config.yml
    # @return [String]
    def generate_bashscripts
      announcing "Generate bash configuration file" do
        generate_bash("bashconfig", "config.bash")
      end
      send_to_state("setup", "generate_bashscripts")
    end

    # Copies build scripts into #{CONFIG.chrootdir}/root
    # @return [String]
    def copy_scripts
      announcing "Copying scripts into chroot" do
        cmd "cp -v #{CONFIG.scripts}/compile.sh #{CONFIG.workdir}/#{CONFIG.chrootdir}/root/compile.sh"
      end
      send_to_state("setup", "copy_scripts")
    end

    # Copies user config files into #{CONFIG.chrootdir}/etc
    # @return [String]
    def copy_configs
      announcing 'Copying configs into chroot' do
        cmd "cp -vR #{CONFIG.configs}/* #{CONFIG.workdir}/#{CONFIG.chrootdir}/etc/"
      end
      send_to_state("setup", "copy_configs")
    end
  end
end
