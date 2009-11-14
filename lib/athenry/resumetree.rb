module Athenry
  module ResumeTree 
    # The steps required to resume from a specific saved state
    # @return [Hash]
    def resume
      @resume ||= {
        'setup' => {
          '1' => [ 'snapshot', 'generate_bashscripts', 'copy_scripts', 'copy_configs' ],
          '2' => [ 'generate_bashscripts', 'copy_scripts', 'copy_configs' ],
          '3' => [ 'copy_scripts', 'copy_configs' ],
          '4' => [ 'copy_configs' ],
        },
        'build' => {
          '1' => [ 'install_pkgmgr', 'update_everything', 'etc_update', 'install_overlays', 'install_sets', 'rebuild'  ],
          '2' => [ 'update_everything', 'etc_update', 'install_overlays', 'install_sets', 'rebuild'  ],
          '3' => [ 'etc_update', 'install_overlays', 'install_sets', 'rebuild'  ],
          '4' => [ 'install_overlays', 'install_sets', 'rebuild'  ],
          '5' => [ 'install_sets', 'rebuild'  ],
          '6' => [ 'rebuild'  ],
        },
      }
    end
  end
end
