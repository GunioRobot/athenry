module Athenry
  module Helper

    # Displays an error message
    # @param msg [String]
    # @example
    #   error("Error Will Robinson") => "* Error Will Robinson"
    # @return [String]
    def error(msg)
      puts "\e[31m*\e[0m #{msg} \n"
    end

    # Displays a success message
    # @param msg [String]
    # @example
    #   error("FTW!") => "* FTW!"
    # @return [String]
    def success(msg)
      puts "\e[32m*\e[0m #{msg} \n"
    end

    # Displays a warning message
    # @param msg [String]
    # @example
    #   warning("FTL!") => "* FTL!"
    # @return [String]
    def warning(msg)
      puts "\e[33m*\e[0m #{msg} \n"
    end
   
    # Writes verbose output to #{CONFIG.logfile} unless #{CONFIG.logfile} is nil
    # @return [String]
    def logger
      begin
        unless CONFIG.logfile.empty? or CONFIG.logfile.nil?
          @logfile = File.new("#{CONFIG.workdir}/#{CONFIG.logdir}/#{CONFIG.logfile}", "a")
        end
        yield
      ensure
        @logfile.close
      end
    end

    # Writes messages to #{CONFIG.logfile}
    # @param msg [String]
    # @param level [String]
    # @example
    #   send_to_log("Epic Fail", level="error") => "ERROR: Epic Fail [Fri Sep 13
    #   21:21:16 -0400 2009]
    # @return [String]
    def send_to_log(msg, level="error")
      logger do
          if @logfile then @logfile.puts "#{level.upcase}: #{msg} [#{Time.now}]\n" end
      end
    end

    # Looks at /etc/mtab on the host system and checks to see if dev,proc,sys
    # are mounted.
    # @return [Boolean]
    def is_mounted?
      mtab ||= File.read("/etc/mtab")
      if mtab =~ /#{CONFIG.chrootdir}\/(dev|proc|sys)/
        return true
      else
        return false
      end
      mtab.close
    end
  
    # if the last command was sucessfull write the current state to file
    # @param stage [String]
    # @param step [String]
    # @example
    #   send_to_state("Setup", "copy_scripts")
    # @return [String]
    def send_to_state(stage, step)
      if $? == 0
        begin
          statefile = File.new("#{CONFIG.workdir}/#{CONFIG.statedir}/#{CONFIG.statefile}", "w")
          statefile.puts(%Q{#{stage}:#{state["#{stage}"]["#{step}"]}})
        ensure
          statefile.close
        end
      end
    end

    # Takes a erb template file and output file, to generate bash from ruby
    # @param template [File]
    # @param outfile [File]
    # @param data [Hash optional]
    # @return [String]
    def generate_bash(template, outfile, data={})
      erbfile = File.open("#{ATHENRY_ROOT}/lib/athenry/templates/#{template}.erb", "r")
      outfile = File.new("#{CONFIG.workdir}/#{CONFIG.chrootdir}/root/#{outfile}", "w")
      begin
        parse = ERB.new(erbfile, 0, "%<>")
        outfile.puts "#{parse.result}"
      ensure
        outfile.close
      end
    end
    
    # Checks to make sure setup was run before any build command is ran.
    # Looks for #{CONFIG.workdir} and #{CONFIG.chrootdir} to verify.
    # @raise "Must run setup before build"
    # @return [String]
    def check_for_setup
      raise "Must run setup before build" unless File.directory?("#{CONFIG.workdir}/#{CONFIG.chrootdir}") && File.directory?("#{CONFIG.workdir}/#{CONFIG.logdir}")
    end

    # Creates necessary dirs to setup our chroot.
    def setup_environment
      dirs = [ CONFIG.chrootdir, CONFIG.logdir, CONFIG.statedir ]
      dirs.each do |dir|
        unless File.directory?("#{CONFIG.workdir}/#{dir}")
          FileUtils.mkdir_p("#{CONFIG.workdir}/#{dir}")
        end
      end
    end

    # Checks if the Process.uid is run by root. If not raise an error and die. 
    # @raise "Must run as root"
    # @return [String]
    def must_be_root
      raise "Must run as root" unless Process.uid == 0
    end

    # Wraps verbose out put in a message block for nicer verbose output
    # @param msg [String]
    # @return [String]
    def announcing(msg)
      logger do
        if @logfile then @logfile.puts "* #{msg} [#{Time.now}]\n" end
      end
      success("#{msg} \n")
      yield
    end 

    # If the last exit status was not true then dispaly an error and exit,
    # unless SHELL_IS_RUNNING is true, then just display the error and return
    # @return [string]
    # @param msg [String]
    # @example
    #   die "Foo bar" => "* Foo bar"
    def die(msg)
      unless $? == 0
        error("#{msg} \n")
        unless SHELL_IS_RUNNING
          exit 1
        end
      end
    end

    # Takes a shell command to run, decides verbose level, optionally logs
    # output, and dies if the exit status was not 0
    # @param command
    # @example
    #   cmd("uname -s") => "Linux"
    # @return [String]
    def cmd(command)
      logger do
        begin
          pipe = IO.popen("#{command}")
          pipe.each_line do |line|
            if @logfile then @logfile.puts "#{line}" end
            if CONFIG.verbose then puts "#{line}" end
          end
        ensure
          pipe.close
        end
      end
      die("#{command} Failed to complete successfully")
    end
  end
end
