module Athenry
  class Shell
    include ShellAliases

    attr_accessor :debug

    def initialize
      $shell_is_running = true
      debug = false
      
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
      display_erb("help.erb")
    end

    def debug
      debug ? debug=false : debug=true
    end

    def shellinput
      Readline.completion_append_character = " "
      Readline.completion_proc = generate_list

      begin
        while cmd = history_management 
          execute(cmd.rstrip) 
        end
      rescue NoMethodError, ArgumentError => e
        if cmd.length > 0 then puts "#{cmd} is a invalid command" end
        if debug then puts "#{e}" end
        shellinput
      end
    end
    
    private

    def history_management
      cmdline = Readline.readline('>> ', true)
      return nil if cmdline.nil?
      if cmdline =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == cmdline
        Readline::HISTORY.pop
      end
      cmdline
    end

    def greeting
      puts 'Welcome to the Athenry shell'
      puts 'Type "help" for more information or "quit" to exit the shell'
    end

    def generate_list
      list ||= [].concat([@setup, @build, @target, @clean, @help]).flatten.sort
      comp ||= proc { |s| list.grep( /^#{Regexp.escape(s)}/ ) }
    end

    def help_data
      @setup    ||= Athenry::Setup.instance_methods(false)
      @build    ||= Athenry::Build.instance_methods(false)
      @target   ||= Athenry::Target.instance_methods(false)
      @clean    ||= Athenry::Clean.instance_methods(false)
      @help     ||= ["debug", "help", "quit"]
    end

  end
end
