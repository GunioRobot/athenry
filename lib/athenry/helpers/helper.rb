module Athenry
  module Helper

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
          if @logfile then @logfile.puts "#{level.upcase}: #{msg} [#{datetime}]\n" end
      end
    end

    def datetime
      Time.now.strftime(DATETIME_FORMAT)
    end

    def mtab
      mtab ||= File.read('/etc/mtab')
    end

    # Looks at /etc/mtab on the host system and checks to see if dev,proc,sys
    # are mounted.
    # @return [Boolean] true/false
    def is_mounted?
      if mtab =~ /#{$chrootdir}\/(dev|proc|sys)/
        true
      else
        false
      end
      mtab.try(:close)
    end

    def statefile
      File.new($statefile, 'w')
    end

    def set_target
      $target = caller_method_name
    end

    # if the last command was sucessfull write the current state to file
    # @return [String]
    def set_state
      if $? == 0
        begin
          statefile.puts "#{$target}:#{STATE[$target.to_sym][caller_method_name]}"
        ensure
          statefile.try(:close)
        end
      end
    end

    # Loads the current state into an instance variable
    # @example
    #   load_state #=> Setup:2
    # @return [String]
    def load_state
      begin
        File.read($statefile).strip.split(':')
      rescue Errno::ENOENT
         raise MissingStateFile
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

    def check_dirs
      checkdirs = [$chrootdir, LOGDIR, 
                   STAGEDIR, SNAPSHOTDIR, 
                   "#{$chrootdir}/scripts/run.sh", "#{$chrootdir}/bin/bash", 
                   "#{$chrootdir}/dev/null", "#{$chrootdir}/usr/portage/skel.ebuild",
                   $imagedir]
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
      check_dirs.each do |dir|
        if File.exists?(dir)
          next
        else
          if run.nil? then raise MustRunSetup end
          Athenry::target.setup
        end
      end
    end

    def setup_dirs
      [ $chrootdir, LOGDIR, STATEDIR, SNAPSHOTDIR, STAGEDIR, SNAPSHOTCACHE, $imagedir ]
    end

    # Creates necessary dirs to setup our chroot.
    def setup_environment
      setup_dirs.each { |dir| FileUtils.mkdir_p(dir) }
    end

    # Checks if the Process.uid is run by root. If not raise an error and die. 
    # @raise MustRunAsRoot 
    # @return [String]
    def must_be_root
      raise MustRunAsRoot unless Process.uid == 0
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
        if @logfile then @logfile.puts "* #{msg} [#{datetime}]\n" end
      end
      success("#{msg} \n")
      yield
    end 

    # Renders an erb template and prints it to stdout
    # @param [String] template Name of the erb template to render
    # @return [String]
    def display_erb(template)
      template = Erubis::Eruby.new(File.read("#{ATHENRY_ROOT}/lib/athenry/templates/#{template}"))
      puts template.result(binding())
    end

    def lastsync
      Time.parse(File.read("#{SNAPSHOTCACHE}/portage/metadata/timestamp")) 
    end

    def nextsync
      lastsync + (60 * 60 * 24) #24 hours
    end

    # Checks portage/metadata/timestamp, if it's been over 24 hours then we sync again, 
    # other wise display the warning message Using FORCESYNC will override the check.
    # @return [String]
    def safe_sync
      if lastsync >= nextsync && (ENV['FORCESYNC'] == "true" || ENV['forcesync'] == "true")
        true
      else
        warning "Gentoo Etiquette says we should not sync more than once every 24 hours. However,"
        warning "You may export FORCESYNC=yes to force a sync each time the script is run."
        warning "This is not recommended and may get you BANNED from Gentoo mirrors!"
        false
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
        add_to_failures unless $shell_is_running
        exit 1 unless $shell_is_running
      end
    end

    def add_to_failures
      error_file.puts "#{$target} | #{Time.now} | #{$chrootname}"
      error_file.try(:close)
    end

    def error_file
      File.new(ERRORFILE, 'w')
    end

    def read_error
      File.read(ERRORFILE)
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

    def print_overlays
      RConfig.athenry.overlays.each do |name,url|
        row name, url
      end
    end

    def chroot_dirs
      chroot_names = []
      Dir.glob("#{WORKDIR}/builds/*").each do |dir|
        chroot_names.push(dir)
      end
      chroot_names
    end

    def heading(msg)
      $stdout.puts "\e[32m#{msg}\e[0m "
      yield
    end

    def row(var, val)
      $stdout.puts "\s\s\e[33m#{var}\e[35m:\e[0m #{val}"
    end

    def latest_builds
      chroot_dirs.each do |name|
        if File.exists?("#{name}/root/") 
          row File.basename(name), "\t#{File.stat(name).mtime.strftime(DATETIME_FORMAT)}"
        end
      end
    end

    def latest_failures
      read_error.each_line do |errors|
        errors = errors.split('|')
        row errors.last.strip, ''
        row "\tDoing", errors.first.strip
        row "\tAt", Time.parse(errors[1].strip).strftime(DATETIME_FORMAT)
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
          pipe = IO.popen(command)
          pipe.each_line { |line|
            if @logfile then @logfile.puts line end
            if $verbose then puts line end
          }
        ensure
          pipe.try(:close)
        end
      end
      exit && die("#{command} Failed to complete successfully") 
    end
  end
end
