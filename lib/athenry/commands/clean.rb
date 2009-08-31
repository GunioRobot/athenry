module Athenry
  class Clean
    include Athenry::Helper
    
    def unmount
      announcing "Unmounting dev, sys, and proc" do
        dirs = %w[ dev sys proc ]
        dirs.each do |dir|
          cmd "umount #{CONFIG.workdir}/#{CONFIG.chrootdir}/#{dir}"
        end
      end
    end
  
  end
end
