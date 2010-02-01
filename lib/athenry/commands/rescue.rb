module Athenry
  class Rescue 

    def initialize
      must_be_root
      check_for_setup
      mount
    end
  
    # Executes the rescue shell on an existing chroot. Allows uses to perform 
    # commands manually if they choose, great for rescue operations.
    #
    # We use system here instead of our normal Athenry::Helper#cmd so we can
    # have a interactive session.
    # @see Athenry::Helper#cmd
    def target
      system("chroot #{CONFIG.workdir}/#{CONFIG.chrootdir} /root/athenry/run.sh rescue")
    end

  end
end