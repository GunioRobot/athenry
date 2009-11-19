module Athenry
  class Shell
    include ShellAliases

    def initialize
      $shell_is_running = true
      @debug = false
      
      must_be_root
      aliases
      help_data
      generate_list
      greeting
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
      template = ERB.new(File.open("#{ATHENRY_ROOT}/lib/athenry/templates/help.erb").read, 0, "%<>")
      puts "#{template.result(binding)}"
    end

    def debug
      @debug ? @debug=false : @debug=true
    end

    def shellinput
      Readline.completion_append_character = " "
      Readline.completion_proc = @comp

      begin
        while cmd = Readline.readline('>> ', true)
          execute(cmd.rstrip) 
        end
      rescue NoMethodError, ArgumentError => e
        if cmd.length > 0 then puts "#{cmd} is a invalid command" end
        if @debug then puts "#{e}" end
        shellinput
      end
    end
    
    private

    def greeting
      puts "Welcome to the Athenry shell"
      puts %Q{Type "help" for more information or "quit" to exit the shell}
    end

    def generate_list
      list ||= [].concat([@setup, @build, @target, @freshen, @clean, @help]).flatten.sort
      @comp ||= proc { |s| list.grep( /^#{Regexp.escape(s)}/ ) }
    end

    def help_data
      @setup ||= Athenry::Setup.instance_methods(false)
      @build ||= Athenry::Build.instance_methods(false)
      @target ||= Athenry::Target.instance_methods(false)
      @freshen ||= Athenry::Freshen.instance_methods(false)
      @clean ||= Athenry::Clean.instance_methods(false)
      @help ||= ["debug", "help", "quit"]
    end

  end
end
