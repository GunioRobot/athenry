module Athenry
  class Resume
    
    def initialize
      aliases
      load_state
    end

    # Runs steps required to execute from last step.
    # @return [String]
    def from
      begin
        send(RESUMETREE["#{@current_state.first}"]["#{@current_state.last}"])
      rescue
        raise InvalidResumePoint
      end
    end
  
  end
end
