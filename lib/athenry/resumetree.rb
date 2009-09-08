module Athenry
  module ResumeTree 
    def resume
      @resume ||= {
        "setup" => {
          "1" => [ "extract", "snapshot", "generate_bashscripts", "copy_scripts", "copy_configs" ],
          "2" => [ "snapshot", "generate_bashscripts", "copy_scripts", "copy_configs" ],
          "3" => [ "generate_bashscripts", "copy_scripts", "copy_configs" ],
          "4" => [ "copy_scripts", "copy_configs" ],
          "5" => [ "copy_configs" ]
        },
        "build" => {
          "1" => [ "chroot" ]
        },
      }
    end
  end
end
