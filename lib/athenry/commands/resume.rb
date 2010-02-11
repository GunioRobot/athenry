module Athenry
  class Resume
    
    def initialize
      aliases
    end

    # Runs steps required to execute from last step.
    # @return [String]
    def from
      begin
        send(RESUMETREE[load_state.first.to_sym][load_state.last.to_i])
      rescue
        raise InvalidResumePoint
      end
    end
  
  end
end
