module Athenry
  class Build
    include Athenry::Helper

    def initialize
      must_be_root
      check_for_setup
    end
    
    def mount
      announcing "Mounting dev, sys, and proc" do
        cmd "mount -o bind /dev #{CONFIG.chrootdir}/dev"
        cmd "mount -o bind /sys #{CONFIG.chrootdir}/sys"
        cmd "mount -t proc none #{CONFIG.chrootdir}/proc"
      end
    end

    def chroot
      announcing "Entering Chroot" do
        cmd "chmod +x #{CONFIG.chrootdir}/root/compile.sh"
        cmd "chroot #{CONFIG.chrootdir} /root/compile.sh"
      end
    end
  end
end
