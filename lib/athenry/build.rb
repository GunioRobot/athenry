class Build < Helper 
  def mount
    announcing "Mounting dev, sys, and proc" do
      silent "sudo mount -o bind /dev #{CONFIG['BASE']}/dev"
      silent "sudo mount -o bind /sys #{CONFIG['BASE']}"
      silent "sudo mount -t proc none #{CONFIG['BASE']}/proc"
    end
  end

  def chroot
    announcing "Entering Chroot" do
      silent "sudo chmod +x #{CONFIG['BASE']}/root/compile.sh"
      silent "sudo chroot #{CONFIG['BASE']}/root/compile.sh"
    end
  end
end
