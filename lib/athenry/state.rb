module Athenry
  module State 
    # Returns the save state files so we know what last sucessfully finished
    # @return [Hash]
    def state 
      @states ||= {
        'setup' => {
          'fetch' => 1,
          'extract' => 2,
          'snapshot' => 3,
          'generate_bashscripts' => 4,
          'copy_scripts' => 5,
          'copy_configs' => 6,
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
