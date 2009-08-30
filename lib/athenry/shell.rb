module Athenry
  class Shell < Helper
    alias :quit :exit

    def quit
      puts "Exiting Athenry shell"
      exit 0
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
        $stderr.puts e.message
        shellinput
      end
    end
  end
end
