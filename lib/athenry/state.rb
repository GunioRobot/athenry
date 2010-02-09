module Athenry
  STATE = {
    'setup' => {
      'fetchstage' => 1,
      'extractstage' => 2,
      'fetchsnapshot' => 3,
      'extractsnapshot' => 4,
      'updatesnapshot' => 5,
      'copysnapshot' => 6,
      'copy_scripts' => 7,
      'copy_configs' => 8,
    },
    'custom' => {
      'install_pkgmgr' => 1,
      'update_everything' => 2,
      'rebuild' => 3,
      'etc_update' => 4,
      'install_overlays' => 5,
      'install_sets' => 6,
      'rebuild' => 7,
    },
    'stage3' => {
      'install_pkgmgr' => 1,
      'update_everything' => 2,
      'etc_update' => 3,
      'rebuild' => 4,
    },
  }
end
