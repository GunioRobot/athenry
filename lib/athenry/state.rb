module Athenry
  module State 
    # Returns the save state files so we know what last sucessfully finished
    # @return [Hash]
    def state 
      @states ||= {
        "setup" => {
          "fetch" => 1,
          "extract" => 2,
          "snapshot" => 3,
          "generate_bashscripts" => 4,
          "copy_scripts" => 5,
          "copy_configs" => 6,
        },
        "build" => {
          "mount" => 1,
          "chroot" => 2,
        },
      }
    end
  end
end
