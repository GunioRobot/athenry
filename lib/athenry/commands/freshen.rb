module Athenry
  class Freshen 

    def initialize
      must_be_root
      check_for_setup(:run)
      update_chroot
      mount
    end

    # Performs the steps required to freshen an existing chroot.
    def update(args)
      Athenry::Execute::build.sync
      Athenry::Execute::build.update_everything
      Athenry::Execute::build.update_configs
      Athenry::Execute::build.rebuild
    end
  
  end
end
