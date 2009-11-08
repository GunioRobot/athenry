module Athenry
  class Clean
   
    # First we check if dev,sys,proc are already mounted, if
    # they are we unmount them.
    # @return [String]
    def unmount
      if !is_mounted?
        warning('dev, sys, and proc are already unmounted')
      else
        announcing 'Unmounting dev, sys, and proc' do
          dirs = %w[ dev sys proc ]
          dirs.each do |dir|
            cmd "umount -l #{CONFIG.workdir}/#{CONFIG.chrootdir}/#{dir}"
          end
        end
      end
    end
  
  end
end
