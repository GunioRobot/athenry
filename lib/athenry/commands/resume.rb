module Athenry
  class Resume
    include ShellAliases
    
    def initialize
      check_for_setup
      aliases
      load_state
    end

    # Runs steps required to execute from last step.
    # @return [String]
    def from
      begin
        send(resume["#{@current_state.first}"]["#{@current_state.last}"])
      rescue
        error('Invalid resume point')
        exit 1
      end
    end

    private
    # Loads the current state into an instance variable
    # Example:
    #   load_state #=> Setup:2
    # @return [String]
    def load_state
      begin
        if File.file?("#{STATEFILE}") && File.readable?("#{STATEFILE}") 
          @current_state = File.read("#{STATEFILE}").strip.split(':')
        end
      rescue
        error('Invalid no No Resume point')
        exit 1
      end
    end
    
  end
end
