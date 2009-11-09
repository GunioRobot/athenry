module Athenry
  class Shell 
    include Athenry::ShellAliases

    def initialize
      must_be_root
      $shell_is_running = true
    end

    # Exits the shell
    def quit
      announcing 'Exiting Athenry shell' do
        exit 0 
      end
    end

    # Loads the help template and prints to stdout
    # @return [String]
    def help
      File.open("#{ATHENRY_ROOT}/lib/athenry/templates/help.txt", 'r').each_line{ |line| puts "#{line}" }
    end

    # Takes user input and executes the ruby command
    # @return [String]
    def shellinput
      puts 'Type help for a list of commands:'
      begin
        while command = prompt 
          execute command
        end
      rescue => e
        puts 'No such command!'
        shellinput
      end
    end
    
    private
    
    def prompt
      ask('>>')
    end   

    def execute(cmd)
      Athenry::ShellAliases.call(cmd)
    end
  end
end
