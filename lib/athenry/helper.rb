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
          @logfile = File.new("#{CONFIG.workdir}/#{CONFIG.logdir}/#{CONFIG.logfile}", 'a')
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
          statefile = File.new("#{CONFIG.workdir}/#{CONFIG.statedir}/#{CONFIG.statefile}", 'w')
          statefile.puts(%Q{#{stage}:#{state["#{stage}"]["#{step}"]}})
        ensure
          statefile.close
        end
      end
    end
   
    # Takes CONFIG.overlays and builds an array usable by our erb template, 
    # this is then used to generate a configuration file for bash.
    # @return [Array]
    def overlays_basharray
      CONFIG.overlay_array=[]
      CONFIG.overlays.each_with_index do |(k,v), i|
        CONFIG.overlay_array.push("OVERLAYKEY[#{i.to_i}]=#{k.to_s.inspect}\n")
        CONFIG.overlay_array.push("OVERLAYVAL[#{i.to_i}]=#{v.to_s.inspect}\n")
      end
    end
    
    # Takes a erb template file and output file, to generate bash from ruby
    # @param template [File]
    # @param outfile [File]
    # @param data [Hash optional]
    # @return [String]
    def generate_bash(template, outfile, data={})
      erbfile = File.open("#{ATHENRY_ROOT}/lib/athenry/templates/#{template}.erb", 'r')
      outfile = File.new("#{ATHENRY_ROOT}/scripts/athenry/lib/#{outfile}", 'w')
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
    def check_for_setup(run = nil)
      dirs = [ CONFIG.chrootdir, CONFIG.logdir ]
      dirs.each { |dir|
        unless File.directory?("#{CONFIG.workdir}/#{dir}")
          run.nil? ? raise("Must run setup before build") : Athenry::Execute::run.setup 
        end
      } 
    end

    # Creates necessary dirs to setup our chroot.
    def setup_environment
      dirs = [ CONFIG.chrootdir, CONFIG.logdir, CONFIG.statedir ]
      dirs.each { |dir|
        unless File.directory?("#{CONFIG.workdir}/#{dir}")
          FileUtils.mkdir_p("#{CONFIG.workdir}/#{dir}")
        end
      }
    end

    # Checks if the Process.uid is run by root. If not raise an error and die. 
    # @raise "Must run as root"
    # @return [String]
    def must_be_root
      raise 'Must run as root' unless Process.uid == 0
    end

    # Takes a URI and parses it ruturning just the filename and extension
    # @param [String]
    # @example 
    #   filename('http://www.example.com/path/to/file.tar.bz2') => file.tar.bz2
    # @return [String]
    def filename(filename)
      filename = URI.parse(filename).path[%r{[^/]+\z}]
    end

    # Sets global $set_nopaludis to either true or false. Used for builds where we want to force emerge, like updating a stage3.
    # @param bool [Boolean]
    # @example
    #   set_nopaludis(:true) => $set_nopaludis => true
    #   set_nopaludis(:false) => $set_nopaludis => false
    def set_nopaludis(bool)
      $set_nopaludis = bool
    end

    # Accepts a action to pass to the chroot
    # @param action [String]
    # @param dir [String, nil]
    # @example 
    #   chroot 'install_pkgmgr'
    #   chroot('freshen', 'stage5')
    # @return [String]
    def chroot(action, chrootdir = CONFIG.chrootdir)
        if $set_nopaludis == :true
          cmd "chroot #{CONFIG.workdir}/#{chrootdir} /root/athenry/run.sh #{action} true"
        else
          cmd "chroot #{CONFIG.workdir}/#{chrootdir} /root/athenry/run.sh #{action}"
        end
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
        unless $shell_is_running
          exit 1
        end
      end
    end
    
    # Copies build scripts into #{CONFIG.chrootdir}/root
    # @param chroot [String]
    # @return [String]
    def update_scripts(chrootdir = CONFIG.chrootdir)
      announcing 'Updating scripts in chroot' do
        cmd "cp -Ruv #{CONFIG.scripts}/athenry/ #{CONFIG.workdir}/#{chrootdir}/root/"
        cmd "chmod +x #{CONFIG.workdir}/#{chrootdir}/root/athenry/run.sh"
      end
    end

    # Copies user config files into #{CONFIG.chrootdir}/etc
    # @param chroot [String]
    # @return [String]
    def update_configs(chrootdir = CONFIG.chrootdir)
      announcing 'Updating configs in chroot' do
        cmd "cp -Ruv #{CONFIG.configs}/* #{CONFIG.workdir}/#{chrootdir}/etc/"
      end
    end

    # Copies config files and scripts into the chroot that have changed
    # @return [String]
    def update_chroot
      update_scripts
      update_configs
    end
    
    # First checks if dev,proc,sys are mounted if not we mount 
    # @return [String]
    def mount
      if is_mounted?
        warning('dev, sys, proc are already mounted')
      else
        announcing 'Mounting dev, sys, and proc' do
          cmd "mount -o rbind /dev #{CONFIG.workdir}/#{CONFIG.chrootdir}/dev"
          cmd "mount -o bind /sys #{CONFIG.workdir}/#{CONFIG.chrootdir}/sys"
          cmd "mount -t proc none #{CONFIG.workdir}/#{CONFIG.chrootdir}/proc"
        end
      end
    end
   
    # Loops through *args and uses method.send to evaluation ruby methods.
    # @param [String]
    def execute(*args)
      args.each { |method| send(method) }
    end
    
    # Takes a shell command to run, decides verbose level, optionally logs
    # output, and dies if the exit status was not 0
    # @param command [String]
    # @example
    #   cmd("uname -s") => "Linux"
    # @return [String]
    def cmd(command)
      logger do
        begin
          pipe = IO.popen("#{command}")
          pipe.each_line { |line|
            if @logfile then @logfile.puts "#{line}" end
            if CONFIG.verbose then puts "#{line}" end
          }
        ensure
          pipe.close
        end
      end
      die("#{command} Failed to complete successfully")
    end
  end
end
