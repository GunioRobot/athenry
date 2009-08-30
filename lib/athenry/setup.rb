module Athenry
  class Setup < Helper
    
    def fetch
      announcing "Fetching" do
        unless File.exists?("#{CONFIG['WORKDIR']}/stage3-amd64-current.tar.bz2")
          silent "wget -c #{CONFIG['STAGEURL']} -O #{CONFIG['WORKDIR']}/stage3-amd64-current.tar.bz2"
        end
      end
    end

    def extract
      announcing "Extracting stage file" do
        silent "sudo tar xjpf stage3-amd64-current.tar.bz2 -C #{CONFIG['BASE']}"
      end
    end

    def snapshot
      announcing "Fetching and extracting portage snapshot" do
        unless File.exists?("#{CONFIG['WORKDIR']}/portage-latest.tar.bz2")
          silent "wget -c #{CONFIG['SNAPSHOTURL']} -O #{CONFIG['WORK']}/portage-latest.tar.bz2"
        end
        silent "sudo tar xjpf #{CONFIG['WORK']}/portage-latest.tar.bz2 -C #{CONFIG['BASE']}/usr"
      end
    end

    def copy_scripts
      announcing "Copying scripts into chroot" do
        silent "sudo cp #{CONFIG['SCRIPTS']}/compile.sh #{CONFIG['BASE']}/root/compile.sh"
      end
    end

    def copy_configs
      announcing "Copying configs into chroot" do
        silent "sudo cp #{CONFIG['CONFIGS']}/resolv.conf #{CONFIG['BASE']}/etc/resolv.conf"
        silent "sudo cp #{CONFIG['CONFIGS']}/make.conf #{CONFIG['BASE']}/etc/make.conf"
        silent "sudo cp -R #{CONFIG['CONFIGS']}/paludis/ #{CONFIG['BASE']}/etc/"
        silent "sudo cp -R #{CONFIG['CONFIGS']}/portage/ #{CONFIG['BASE']}/etc/"
      end
    end
  end
end
