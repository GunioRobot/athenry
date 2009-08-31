module Athenry
  class Setup
    include Athenry::Helper
    
    def initialize
      setup_environment
    end
    
    def fetch
      announcing "Fetching stage file" do
        if File.exists?("#{CONFIG.workdir}/stage3-amd64-current.tar.bz2")
          send_to_log("Stage file already exists skipping fetch", "info")
        else
          cmd "wget -c #{CONFIG.stageurl} -O #{CONFIG.workdir}/stage3-amd64-current.tar.bz2"
        end
      end
    end

    def extract
      announcing "Extracting stage file" do
        cmd "tar xvjpf stage3-amd64-current.tar.bz2 -C #{CONFIG.chrootdir}"
      end
    end

    def snapshot
      announcing "Fetching and extracting portage snapshot" do
        if File.exists?("#{CONFIG.workdir}/portage-latest.tar.bz2")
          send_to_log("Portage snapshot already exists skipping fetch", "info")
        else
          cmd "wget -c #{CONFIG.snapshoturl} -O #{CONFIG.workdir}/portage-latest.tar.bz2"
          cmd "tar xvjpf portage-latest.tar.bz2 -C #{CONFIG.chrootdir}/usr"
        end
      end
    end

    def generate_bashscripts
      announcing "Generate bash configuration file" do
        generate_bash("bashconfig", "config.bash")
      end
    end

    def copy_scripts
      announcing "Copying scripts into chroot" do
        cmd "cp -v #{CONFIG.scripts}/compile.sh #{CONFIG.chrootdir}/root/compile.sh"
      end
    end

    def copy_configs
      announcing "Copying configs into chroot" do
        cmd "cp -v #{CONFIG.configs}/resolv.conf #{CONFIG.chrootdir}/etc/resolv.conf"
        cmd "cp -v #{CONFIG.configs}/make.conf #{CONFIG.chrootdir}/etc/make.conf"
        cmd "cp -vR #{CONFIG.configs}/paludis/ #{CONFIG.chrootdir}/etc/"
        cmd "cp -vR #{CONFIG.configs}/portage/ #{CONFIG.chrootdir}/etc/"
      end
    end
  end
end
