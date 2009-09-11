module Athenry
  # If the shell is executed we set SHELL_IS_RUNNING, this changes die not to
  # exit 1 but to return an error
  # @return [Boolean]
  SHELL_IS_RUNNING = true
  class Shell 
    include Athenry::ShellAliases

    def initialize
      must_be_root
    end

    # Exits the shell
    def quit
      announcing "Exiting Athenry shell" do
        exit 0 
      end
    end

    # Loads the help template and prints to stdout
    # @return [String]
    def help
      File.open("#{ATHENRY_ROOT}/lib/athenry/templates/help.txt", 'r').each_line{ |line|
        puts "#{line}"
      }
    end

    # Takes user input and executes the ruby command
    # @return [String]
    def shellinput
      puts "Type help for a list of commands:"
      begin
        while command = prompt 
          execute command
        end
      rescue => e
        puts "No such command!"
        shellinput
      end
    end
    
    private
    
    def prompt
      ask(">>")
    end   

    def execute(cmd)
      eval(cmd)
    end
  end
end
