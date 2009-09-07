module Athenry
  class Build

    def initialize
      must_be_root
      check_for_setup
    end
    
    def mount
      if is_mounted?
        warning("dev, sys, proc are already mounted")
      else
        announcing "Mounting dev, sys, and proc" do
          cmd "mount -o rbind /dev #{CONFIG.workdir}/#{CONFIG.chrootdir}/dev"
          cmd "mount -o bind /sys #{CONFIG.workdir}/#{CONFIG.chrootdir}/sys"
          cmd "mount -t proc none #{CONFIG.workdir}/#{CONFIG.chrootdir}/proc"
        end
      end
      send_to_state("build", "mount")
    end

    def chroot
      announcing "Entering Chroot" do
        cmd "chmod +x #{CONFIG.workdir}/#{CONFIG.chrootdir}/root/compile.sh"
        cmd "chroot #{CONFIG.workdir}/#{CONFIG.chrootdir} /root/compile.sh"
      end
      send_to_state("build", "chroot")
    end
  end
end
