module Athenry
  class Freshen 

    def initialize
      check_for_setup(:run)
      update_chroot
      mount
    end

    # Performs the steps required to freshen an existing chroot.
    # @see Athenry::Execute::build
    def update
      set_temp_options(:freshen => true) do
        Athenry::build.sync
        Athenry::build.update_everything
        Athenry::build.etc_update
        Athenry::build.rebuild
      end
    end
  
  end
end
