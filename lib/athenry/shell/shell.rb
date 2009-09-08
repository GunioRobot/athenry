module Athenry
  class Shell 
    include Athenry::ShellAliases

    def initialize
      must_be_root
      $SHELL_IS_RUNNING = "true"
    end

    def quit
      announcing "Exiting Athenry shell" do
        exit 0 
      end
    end

    def help
      File.open("#{ATHENRY_ROOT}/lib/athenry/templates/help.txt", 'r').each_line{ |line|
        puts "#{line}"
      }
    end

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
