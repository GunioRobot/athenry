module Athenry
  module Helper

    private

    def error(msg)
      puts "\e[31m*\e[0m #{msg} \n"
    end

    def success(msg)
      puts "\e[32m*\e[0m #{msg} \n"
    end

    def warning(msg)
      puts "\e[33m*\e[0m #{msg} \n"
    end
    
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

    def send_to_log(msg, level="error")
      logger do
          if @logfile then @logfile.puts "#{level.upcase}: #{msg} [#{Time.now}]\n" end
      end
    end

    def is_mounted?
      mtab ||= File.read("/etc/mtab")
      if mtab =~ /#{CONFIG.chrootdir}\/(dev|proc|sys)/
        return true
      else
        return false
      end
      mtab.close
    end

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

    def check_for_setup
      raise "Must run setup before build" unless File.directory?("#{CONFIG.workdir}/#{CONFIG.chrootdir}") && File.directory?("#{CONFIG.workdir}/#{CONFIG.logdir}")
    end

    def setup_environment
      dirs = [ CONFIG.chrootdir, CONFIG.logdir, CONFIG.statedir ]
      dirs.each do |dir|
        unless File.directory?("#{CONFIG.workdir}/#{dir}")
          FileUtils.mkdir_p("#{CONFIG.workdir}/#{dir}")
        end
      end
    end

    def must_be_root
      error('Must run as root') unless Process.uid == 0
    end

    def announcing(msg)
      logger do
        if @logfile then @logfile.puts "* #{msg} [#{Time.now}]\n" end
      end
      success("#{msg} \n")
      yield
    end 

    def die(msg)
      unless $? == 0
        error("#{msg} \n")
        unless $SHELL_IS_RUNNING
          exit 1
        end
      end
    end

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
