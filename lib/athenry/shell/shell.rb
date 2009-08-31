module Athenry
  class Shell 
    include Athenry::Helper
    include Athenry::ShellAliases

    def initialize
      must_be_root
    end

    def quit
      announcing "Exiting Athenry shell" do
        exit 0
      end
    end

    def help
      File.open("#{ATHENRY_ROOT}/templates/help.txt", 'r').each_line{ |line|
        puts "#{line}"
      }
    end

    def prompt
      #print ">> "
      #gets
      ask(">>")
    end   

    def execute(cmd)
      eval(cmd)
    end
    
    def shellinput
      puts "Type Help if you don't know what to do:"
      begin
        while command = prompt 
          execute command
        end
      rescue => e
        puts "No such command!"
        shellinput
      end
    end
  end
end
