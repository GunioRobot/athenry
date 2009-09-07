module Athenry
  class Resume
    def initialize
      must_be_root
      check_for_setup
    end

    def from
      statefile = "#{CONFIG.workdir}/#{CONFIG.statedir}/#{CONFIG.statefile}"
      if File.file?("#{statefile}") && File.readable?("#{statefile}") 
        File.open(statefile, "r") do |f| 
          f.each_line do |line|
            puts "#{line}" 
          end
        end
      else
        error("No resume point")
        exit 1
      end
    end

  end
end
