module Athenry
  # These are all aliases for the shell command
  # See the respective classes for more information.
  # * {Athenry::Setup}.
  # * {Athenry::Build}.
  # * {Athenry::Clean}.
  # * {Athenry::Target}.
  # * {Athenry::Resume}.
  module ShellAliases
   
    # Finds public class methods and dynamically builds alias methods for the shell command.
    # @return [Method]
    def aliases
     klasses.each { |klass|
       klass.instance_methods(false).each { |meth|
         instance_eval "def #{meth}
           #{klass}.new.#{meth}
         end"
       }
     }
    end
    
    def klasses
      @klasses = [Athenry::Setup, Athenry::Build, Athenry::Clean, Athenry::Target]
    end 
  
  end
end
