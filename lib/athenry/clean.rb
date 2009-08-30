module Athenry
  class Clean < Helper
    def test
      puts "#{CONFIG.workdir}"
    end

    def unmount
      announcing "Unmounting dev, sys, and proc" do
        silent "sudo umount #{CONFIG.base}/dev"
        silent "sudo umount #{CONFIG.base}/sys"
        silent "sudo umount #{CONFIG.base}/proc"
      end
    end
  end
end
