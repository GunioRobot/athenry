module Athenry
  class Build

    def initialize
      must_be_root
      check_for_setup
    end
   
    # First checks if dev,proc,sys are mounted if not we mount them and save
    # state
    # @return [String]
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

    def update_pkgmgr
      announcing "Updating Package Manager" do
        chroot update_pkgmgr
      end
      send_to_state("build", "update_pkgmgr")
    end

    def sync
      announcing "Syncing Portage Tree" do
        chroot sync
      end
      send_to_state("build", "sync")
    end

    def repair
      announcing "Entering Repair Mode" do
        chroot repair
      end
      send_to_state("build", "repair")
    end

    def freshen
      announcing "Freshening" do
        chroot freshen
      end
      send_to_state("build", "freshen")
    end

    def chroot
      announcing "Entering Chroot" do
        chroot chroot
      end
      send_to_state("build", "chroot")
    end

    def update_everything
      announcing "Updating All Packages" do
        chroot update_everything
      end
      send_to_state("build", "update_everything")
    end

    def install_overlays
      announcing "Installing Overlays" do
        chroot install_overlays
      end
      send_to_state("build", "install_overlays")
    end

    def tar
      announcing "Creating Archive" do
        chroot tar
      end
      send_to_state("build", "tar")
    end

    private

    def chroot(action)
      cmd "chroot #{CONFIG.workdir}/#{CONFIG.chrootdir} /root/athenry/run.sh #{action}"
    end

  end
end
