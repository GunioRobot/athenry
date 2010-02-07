module Athenry
  RESUMETREE = {
    'setup' => {
      '1' => [ 'extractstage', 'fetchsnapshot', 'extractsanpshot', 'updatesnapshot', 'copysnapshot', 'copy_scripts', 'copy_configs'  ],
      '2' => [ 'fetchsnapshot', 'extractsanpshot', 'updatesnapshot', 'copysnapshot', 'copy_scripts', 'copy_configs'  ],
      '3' => [ 'extractsanpshot', 'updatesnapshot', 'copysnapshot', 'copy_scripts', 'copy_configs'  ],
      '4' => [ 'updatesnapshot', 'copysnapshot', 'copy_scripts', 'copy_configs'  ],
      '5' => [ 'copysnapshot', 'copy_scripts', 'copy_configs'  ],
      '6' => [ 'copy_scripts', 'copy_configs'  ],
      '7' => [ 'copy_configs'  ],
    },
    'build' => {
      '1' => [ 'sync', 'install_pkgmgr', 'update_everything', 'etc_update', 'install_overlays', 'install_sets', 'rebuild'  ],
      '2' => [ 'install_pkgmgr', 'update_everything', 'etc_update', 'install_overlays', 'install_sets', 'rebuild'  ],
      '3' => [ 'update_everything', 'etc_update', 'install_overlays', 'install_sets', 'rebuild'  ],
      '4' => [ 'etc_update', 'install_overlays', 'install_sets', 'rebuild'  ],
      '5' => [ 'install_overlays', 'install_sets', 'rebuild'  ],
      '6' => [ 'install_sets', 'rebuild'  ],
      '7' => [ 'rebuild'  ],
    },
  }
end
