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
          'sync' => 1,
          'install_pkgmgr' => 2,
          'update_everything' => 3,
          'etc_update' => 4,
          'install_overlays' => 5,
          'install_sets' => 6,
          'rebuild' => 7,
        },
      }
    end
  end
end
