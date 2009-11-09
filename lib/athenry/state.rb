module Athenry
  module State 
    # Returns the save state files so we know what last sucessfully finished
    # @return [Hash]
    def state 
      @states ||= {
        'setup' => {
          'stage' => 1,
          'snapshot' => 2,
          'generate_bashscripts' => 3,
          'copy_scripts' => 4,
          'copy_configs' => 5,
        },
        'build' => {
          'mount' => 1,
          'install_pkgmgr' => 2,
          'sync' => 3,
          'repair' => 4,
          'update_everything' => 5,
          'install_overlays' => 6,
          'tar' => 7,
        },
      }
    end
  end
end
