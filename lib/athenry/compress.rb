module Athenry
  class Compress
 
    attr_accessor :chroot, :outdir, :chrootdir

    def initialize()
      self.chroot = $chrootname
      self.outdir = $imagedir
      self.chrootdir = $chrootdir
    end

    def bzip2 
      Dir.chdir("#{chrootdir}") do
        cmd("tar -cjpP --ignore-failed-read -f #{outdir}/#{outfile}.tar.bz2 . #{excludes}")
      end
    end
    
    def gzip
      Dir.chdir("#{chrootdir}") do
        cmd("tar -czpP --ignore-failed-read -f #{outdir}/#{outfile}.tar.gz . #{excludes}")
      end
    end

    private

    def excludes
      excludes ||=%w[--exclude=proc/* --exclude=sys/* 
                  --exclude=tmp/* --exclude=var/lock/* 
                  --exclude=var/log/* --exclude=*.pid 
                  --exclude=home/* --exclude=var/tmp/paludis/* 
                  --exclude=var/tmp/portage/* --exclude=var/tmp/ccache/* 
                  --exclude=.bash_history --exclude=lost+found 
                  --exclude=usr/portage/*].join(" ")
    end

    def outfile 
      "#{chroot}-#{Time.now.strftime("%m%d%Y%I%M")}"
    end
  
  end
end
