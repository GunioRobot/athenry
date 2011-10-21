module Athenry
  class Clean

    def target(*args)
      args.each { |cmd| send(cmd) }
    end

    # First we check if dev,sys,proc are already mounted, if
    # they are we unmount them.
    # @return [String]
    def unmount
      if !is_mounted?
        warning('dev, sys, and proc are already unmounted')
      else
        announcing 'Unmounting dev, sys, and proc' do
          dirs = %w[ dev sys proc ]
          dirs.each{|dir| cmd("umount -l #{$chrootdir}/#{dir}", exit=false) }
        end
      end
    end

    # Remove temporary files within your chroot.
    # This means /tmp /var/tmp /usr/portage/distfiles  as well as
    # the /scripts we installed during the setup
    def tmp
      announcing "Removing temporary files from #{$chrootname}" do
        if File.exists?("#{$chrootdir}") then
          FileUtils.rm_rf(Dir.glob("#{$chrootdir}/tmp/*"), :verbose => $verbose)
          FileUtils.rm_rf(Dir.glob("#{$chrootdir}/var/tmp/*"), :verbose => $verbose)
          FileUtils.rm_rf(Dir.glob("#{$chrootdir}/usr/portage/distfiles/*"), :verbose => $verbose)
          FileUtils.rm_rf("#{$chrootdir}/scripts/", :verbose => $verbose)
        end
      end
    end

    # Destroys the chrootdir by running rm -rf after it's unmounted.
    def destroy
      announcing "Removing #{$chrootname}" do
        print 7.chr
        warning "Sleeping for 10 seconds..."
        warning "*******************************************************************"
        warning "You are about to completley remove #{$chrootname} from your system"
        warning "If you wish to cancel hit ctrl-c now!"
        warning "*******************************************************************"
        sleep(10)
        if File.exists?("#{$chrootdir}")
          unmount
          FileUtils.rm_rf("#{$chrootdir}", :verbose => $verbose)
        end
      end
    end

  end
end
