module Athenry
  class Run

    attr_accessor :chrootname, :chrootdir, :statefile, :logfile

    def initialize
      must_be_root
      
      $chrootname = "chroot" unless $chrootname
      $chrootdir = "#{WORKDIR}/builds/#{$chrootname}"
      $statefile = "#{STATEDIR}/#{$chrootname}.state" 
      $logfile = "#{LOGDIR}/#{$chrootname}.log"
    end
    
    # Executes steps for setup
    # @see Athenry::Setup
    def setup(args)
      Athenry::setup.target(*args)
    end

    # Executes a single command on the chroot
    # @see Athenry::Build
    def build(args)
      Athenry::build.target(*args)
    end

    # Executes a group set of commands on the chroot
    # @see Athenry::Target
    def target(args)
      Athenry::target.build(*args)
    end

    # Updates an existing chroot 
    # @see Athenry::Freshen
    def freshen(args)
      Athenry::freshen.update(*args)
    end

    # Executes steps to cleanup
    # @see Athenry::Clean
    def clean(args)
      Athenry::clean.target(*args)
    end
  
    # Executes steps to chroot into shell
    # @see Athenry::Rescue
    def rescue(args)
      Athenry::rescue.target(*args)
    end
    
    # Executes the shell
    # @see Athenry::Shell
    def shell
      Athenry::shell.shellinput
    end

    # Resumes from last saved state
    # @see Athenry::Resume
    def resume
      Athenry::resume.from
    end
  end
end
