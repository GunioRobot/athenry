module Athenry
  class Setup < Helper
    
    def initialize
      unless File.directory?("#{CONFIG.base}")
        FileUtils.mkdir_p("#{CONFIG.base}")
      end
      Dir.chdir("#{CONFIG.workdir}")
    end
    
    def fetch
      announcing "Fetching" do
        unless File.exists?("#{CONFIG.workdir}/stage3-amd64-current.tar.bz2")
          silent "wget -c #{CONFIG.stageurl} -O #{CONFIG.workdir}/stage3-amd64-current.tar.bz2"
        end
      end
    end

    def extract
      announcing "Extracting stage file" do
        silent "sudo tar xjpf stage3-amd64-current.tar.bz2 -C #{CONFIG.base}"
      end
    end

    def snapshot
      announcing "Fetching and extracting portage snapshot" do
        unless File.exists?("#{CONFIG.workdir}/portage-latest.tar.bz2")
          silent "wget -c #{CONFIG.snapshoturl} -O #{CONFIG.workdir}/portage-latest.tar.bz2"
        end
        silent "sudo tar xjpf portage-latest.tar.bz2 -C #{CONFIG.base}/usr"
      end
    end

    def copy_scripts
      announcing "Copying scripts into chroot" do
        silent "sudo cp #{CONFIG.scripts}/compile.sh #{CONFIG.base}/root/compile.sh"
      end
    end

    def copy_config
      announcing "Copying CONFIG. into chroot" do
        silent "sudo cp #{CONFIG.config}/resolv.conf #{CONFIG.base}/etc/resolv.conf"
        silent "sudo cp #{CONFIG.config}/make.conf #{CONFIG.base}/etc/make.conf"
        silent "sudo cp -R #{CONFIG.config}/paludis/ #{CONFIG.base}/etc/"
        silent "sudo cp -R #{CONFIG.config}/portage/ #{CONFIG.base}/etc/"
      end
    end
  end
end
