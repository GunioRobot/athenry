module Athenry
  class Clean < Helper
    def unmount
      announcing "Unmounting dev, sys, and proc" do
        silent "sudo umount #{CONFIG['BASE']}/dev"
        silent "sudo umount #{CONFIG['BASE']}/sys"
        silent "sudo umount #{CONFIG['BASE']}/proc"
      end
    end
  end
end
