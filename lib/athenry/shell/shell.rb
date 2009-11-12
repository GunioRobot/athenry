module Athenry
  class Shell
    include ShellAliases

    def initialize
      must_be_root
      aliases
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
      setup ||= Athenry::Setup.instance_methods(false)
      build ||= Athenry::Build.instance_methods(false)
      clean ||= Athenry::Clean.instance_methods(false)
      
      template = ERB.new(File.open("#{ATHENRY_ROOT}/lib/athenry/templates/help.erb").read, 0, "%<>")
      puts "#{template.result(binding)}"
    end

    # Takes user input and executes the ruby command
    # @return [String]
    def shellinput
      puts 'Type help for a list of commands:'
      begin
        while command = prompt 
          execute(command)
        end
      rescue => e
        puts "Error: #{e}"
        shellinput
      end
    end

    private
 
    def prompt
      ask('>>')
    end   

    def execute(*args)
      args.each { |method| send(method) }
    end
  end
end
