module Athenry
  module Helper
    include Athenry::Config

    # Displays an error message
    # @param [String] msg Error message to be displayed.
    # @example
    #   error("Error Will Robinson") #=> "* Error Will Robinson"
    # @return [String]
    def error(msg)
      puts "\e[31m*\e[0m #{msg} \n"
    end

    # Displays a success message
    # @param [String] msg The success message to be displayed.
    # @example
    #   error("FTW!") #=> "* FTW!"
    # @return [String]
    def success(msg)
      puts "\e[32m*\e[0m #{msg} \n"
    end

    # Displays a warning message
    # @param [String] msg The warning message to be displayed.
    # @example
    #   warning("FTL!") #=> "* FTL!"
    # @return [String]
    def warning(msg)
      puts "\e[33m*\e[0m #{msg} \n"
    end
   
    # Writes verbose output to #{$logfile} unless #{$logfile} is nil
    # @yield [String] All contents of yield are logged to the logfile.
    # @return [String]
    def logger
      begin
        unless $logfile.empty? or $logfile.nil?
          @logfile = File.new("#{$logfile}", 'a')
        end
        yield
      ensure
        @logfile.try(:close)
      end
    end

    # Writes messages to #{$logfile}
    # @param [String] msg Message to send to the logfile
    # @param [Optional, String] level Optional error level to be displayed, defaults to error.
    # @example
    #   send_to_log("Epic Fail", level="error") #=> "ERROR: Epic Fail [Fri Sep 13 21:21:16 -0400 2009]"
    # @return [String]
    def send_to_log(msg, level="error")
      logger do
          if @logfile then @logfile.puts "#{level.upcase}: #{msg} [#{Time.now}]\n" end
      end
    end

    # Looks at /etc/mtab on the host system and checks to see if dev,proc,sys
    # are mounted.
    # @return [Boolean] true/false
    def is_mounted?
      mtab ||= File.read("/etc/mtab")
      if mtab =~ /#{$chrootdir}\/(dev|proc|sys)/
        return true
      else
        return false
      end
      mtab.try(:close)
    end

    # if the last command was sucessfull write the current state to file
    # @param [String] stage
    # @param [String] step
    # @example
    #   send_to_state("Setup", "copy_scripts")
    # @return [String]
    def send_to_state(stage, step)
      if $? == 0
        begin
          statefile = File.new("#{$statefile}", 'w')
          statefile.puts(%Q{#{stage}:#{STATE["#{stage}"]["#{step}"]}})
        ensure
          statefile.try(:close)
        end
      end
    end
   
    # Takes RConfig.athenry.overlays and builds an array usable by our erb template, 
    # this is then used to generate a configuration file for bash.
    # @return [Array]
    def overlays_basharray
      @overlays=[]
      RConfig.athenry.overlays.each_with_index do |(k,v), i|
        @overlays.push("OVERLAYKEY[#{i.to_i}]=#{k.to_s.inspect}")
        @overlays.push("OVERLAYVAL[#{i.to_i}]=#{v.to_s.inspect}")
      end
    end

    def filename(uri)
      URI.parse(uri).path[%r{[^/]+\z}]
    end
    
    # Takes a erb template file and output file, to generate bash from ruby.
    # @param [File, #open] template Template file to open.
    # @param [File, #read] outfile Filename to write to.
    # @return [String]
    def generate_bash(template, outfile)
      erbfile ||= File.read("#{ATHENRY_ROOT}/lib/athenry/templates/#{template}.erb")
      outfile = File.new("#{ATHENRY_ROOT}/scripts/lib/#{outfile}", 'w')
      begin
        overlays_basharray
        parse = Erubis::Eruby.new(erbfile)
        outfile.puts "#{parse.result(binding())}"
      ensure
        outfile.close
      end
    end
    
    # Checks to make sure setup was run before any build command is ran.
    # Looks for #{WORKDIR} and #{$chrootdir} to verify.
    # @raise "Must run setup before build"
    # @param [Optional, Symbol] run If set we run the setup for the user.
    # @example
    #   check_for_setup(:run)
    # or
    # @example
    #   check_for_setup
    # @return [String]
    def check_for_setup(run = nil)
      dirs = [ $chrootdir, LOGDIR, STAGEDIR, SNAPSHOTDIR, "#{$chrootdir}/scripts/run.sh", "#{$chrootdir}/bin/bash", "#{$chrootdir}/dev/null", "#{$chrootdir}/usr/portage/skel.ebuild" ]
      
      dirs.each do |dir|
        if File.exists?("#{dir}")
          next
        else
          if run.nil? then raise("Must run setup first!") end
          Athenry::target.setup
        end
      end
    end

    # Creates necessary dirs to setup our chroot.
    def setup_environment
      dirs = [ $chrootdir, LOGDIR, STATEDIR, SNAPSHOTDIR, STAGEDIR, SNAPSHOTCACHE ]
      dirs.each { |dir| FileUtils.mkdir_p("#{dir}") }
    end

    # Checks if the Process.uid is run by root. If not raise an error and die. 
    # @raise "Must run as root"
    # @return [String]
    def must_be_root
      raise 'Must run as root' unless Process.uid == 0
    end

    # Takes a block with options. Runs any commands inside the block with the
    # options changed, then resets them after all the commands are run.
    #
    # @param [Hash] opts Makes options hash out of params
    # @option opts [true,false] :nopaluids Never use paludis
    # @option opts [true,false] :freshen Detect if paludis is installed if not fall back to emerge
    # @example
    #   set_temp_options(:nopaludis => true) do
    #     chroot("foo")
    #     chroot("bar")
    #   end
    #
    #   or
    #
    #   set_temp_options(:nopaludis => false, :freshen => true) do
    #     chroot("foo")
    #     chroot("bar")
    #   end
    # @return [String]
    def set_temp_options(opts={})
      set_nopaludis = opts[:nopaludis] || false
      set_freshen = opts[:freshen] || false

      if set_nopaludis then $nopaludis="#{set_nopaludis}" end
      if set_freshen then $freshen="#{set_freshen}" end
      yield
      reset_temp_options
    end

    # Resets the options set from set_temp_options to the default setting, false.
    # @see Athenry::Helper#set_temp_options 
    def reset_temp_options
      $nopaludis=false
      $freshen=false
    end

    # Accepts a action to pass to the chroot
    # @param [String] action The command to be run
    # @example 
    #   chroot 'install_pkgmgr'
    # @return [String]
    def chroot(action)
      cmd "chroot #{$chrootdir} /scripts/run.sh #{action}"
    end

    # Wraps verbose out put in a message block for nicer verbose output
    # @param [String] msg The message displayed to the user
    # @yield [Method] Commands to be run
    # @return [String]
    def announcing(msg)
      logger do
        if @logfile then @logfile.puts "* #{msg} [#{Time.now}]\n" end
      end
      success("#{msg} \n")
      yield
    end 

    def display_erb(template)
      template = Erubis::Eruby.new(File.read("#{ATHENRY_ROOT}/lib/athenry/templates/#{template}"))
      puts template.result(binding())
    end

    def safe_sync
      lastsync = Time.parse(File.read("#{SNAPSHOTCACHE}/portage/metadata/timestamp")) 
      nextsync = lastsync + (60 * 60 * 24) #24 hours
      if lastsync >= nextsync && (ENV['FORCESYNC'] == "true" || ENV['forcesync'] == "true")
        return true
      else
        warning "Gentoo Etiquette says we should not sync more than once every 24 hours. However,"
        warning "You may export FORCESYNC=yes to force a sync each time the script is run."
        warning "This is not recommended and may get you BANNED from Gentoo mirrors!"
        return false
      end
    end

    # If the last exit status was not true then dispaly an error and exit,
    # unless SHELL_IS_RUNNING is true, then just display the error and return
    # @param [String] msg Message to display before we exit
    # @return [string]
    # @example
    #   die "Foo bar" #=> "* Foo bar"
    def die(msg)
      unless $? == 0
        error("#{msg} \n")
        exit 1 unless $shell_is_running
      end
    end
    
    # Copies build scripts into #{$chrootdir}/root
    # @return [String]
    def update_scripts
      generate_bash('bashconfig', 'config.sh')
      FileUtils.mkdir_p("#{$chrootdir}/scripts/", :verbose => $verbose)
      FileUtils.cp_r(Dir.glob("#{SCRIPTS}/*"), "#{$chrootdir}/scripts/", :verbose => $verbose)
      FileUtils.chmod(0755, "#{$chrootdir}/scripts/run.sh", :verbose => $verbose)
    end

    # Copies user config files into #{$chrootdir}/etc
    # @return [String]
    def update_configs
      FileUtils.cp_r(Dir.glob("#{CONFIGS}/*"), "#{$chrootdir}/etc/", :verbose => $verbose)
    end

    # Copies config files and scripts into the chroot that have changed
    # @return [String]
    def update_chroot
      update_scripts
      update_configs
    end
    
    # First checks if dev,proc,sys are mounted if not, mount them.
    # @return [String]
    def mount
      if is_mounted?
        warning('dev, sys, proc are already mounted')
      else
        announcing 'Mounting dev, sys, and proc' do
          cmd "mount -o rbind /dev #{$chrootdir}/dev"
          cmd "mount -o bind /sys #{$chrootdir}/sys"
          cmd "mount -t proc none #{$chrootdir}/proc"
        end
      end
    end

    # Loops through *args and uses method.send to evaluate the ruby methods.
    # @param [Array] commands List of commands to run
    def execute(*args)
      args.each { |method| send(method) }
    end
    
    # Takes a shell command to run, decides verbose level, optionally logs
    # output, and dies if the exit status was not 0
    # @param [String] command Shell command to be run.
    # @example
    #   cmd("uname -s") #=> "Linux"
    # @return [String]
    def cmd(command, exit=true)
      logger do
        begin
          pipe = IO.popen("#{command}")
          pipe.each_line { |line|
            if @logfile then @logfile.puts "#{line}" end
            if $verbose then puts "#{line}" end
          }
        ensure
          pipe.close
        end
      end
      exit && die("#{command} Failed to complete successfully") 
    end
  end
end
