module Athenry
  class Resume
    include Athenry::ShellAliases

    def initialize
      must_be_root
      check_for_setup
      load_state
    end

    # Runs steps required to execute from last step.
    # @return [String]
    def from
      begin
        start = resume["#{@current_state.first}"]["#{@current_state.last}"]
        start.each { |step| eval(step) }
      rescue 
        error('Invalid resume point')
        exit 1
      end
    end

    private
    # Loads the current state into an instance variable
    # Example:
    #   load_state => Setup:2
    # @return [String]
    def load_state
      begin
        statefile = "#{CONFIG.workdir}/#{CONFIG.statedir}/#{CONFIG.statefile}"
        if File.file?("#{statefile}") && File.readable?("#{statefile}") 
          @current_state = File.read(statefile).strip.split(':')
        end
      rescue
        error('Invalid no No Resume point')
        exit 1
      end
      return @current_state
    end

  end
end
