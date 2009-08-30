module Athenry
  class Build < Helper 
    def mount
      announcing "Mounting dev, sys, and proc" do
        silent "sudo mount -o bind /dev #{CONFIG.base}/dev"
        silent "sudo mount -o bind /sys #{CONFIG.base}/sys"
        silent "sudo mount -t proc none #{CONFIG.base}/proc"
      end
    end

    def chroot
      announcing "Entering Chroot" do
        silent "sudo chmod +x #{CONFIG.base}/root/compile.sh"
        silent "sudo chroot #{CONFIG.base} /root/compile.sh"
      end
    end
  end
end
