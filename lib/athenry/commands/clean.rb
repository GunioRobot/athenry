module Athenry
  class Clean
    include Athenry::Helper
    
    def unmount
      announcing "Unmounting dev, sys, and proc" do
        cmd "umount #{CONFIG.chrootdir}/dev"
        cmd "umount #{CONFIG.chrootdir}/sys"
        cmd "umount #{CONFIG.chrootdir}/proc"
      end
    end
  
  end
end
