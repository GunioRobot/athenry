module Athenry
  module ResumeTree 
    # The steps required to resume from a specific saved state
    # @return [Hash]
    def resume
      @resume ||= {
        'setup' => {
          '1' => [ 'extract', 'snapshot', 'generate_bashscripts', 'copy_scripts', 'copy_configs' ],
          '2' => [ 'snapshot', 'generate_bashscripts', 'copy_scripts', 'copy_configs' ],
          '3' => [ 'generate_bashscripts', 'copy_scripts', 'copy_configs' ],
          '4' => [ 'copy_scripts', 'copy_configs' ],
          '5' => [ 'copy_configs' ]
        },
        'build' => {
          '1' => [ 'mount', 'install_pkgmgr', 'sync', 'install_overlays'  ],
          '2' => [ 'mount', 'sync', 'install_overlays' ],
          '3' => [ 'mount', 'install_overlays' ]
        },
      }
    end
  end
end
