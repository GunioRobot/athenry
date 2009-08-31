module Athenry
  module Helper

    def logger
      unless CONFIG.logfile.empty? or CONFIG.logfile.nil?
        @logfile = File.new("#{CONFIG.workdir}/#{CONFIG.logdir}/#{CONFIG.logfile}", "a")
      end
      yield
      @logfile.close
    end

    def send_to_log(msg, level="error")
      logger do
          if @logfile then @logfile.puts "#{level.upcase}: #{msg} [#{Time.now}]\n" end
      end
    end

    def generate_bash(template, outfile, data={})
      erbfile = File.open("#{ATHENRY_ROOT}/lib/athenry/templates/#{template}.erb", "r")
      outfile = File.new("#{CONFIG.workdir}/#{CONFIG.chrootdir}/root/#{outfile}", "w")
      parse = ERB.new(erbfile, 0, "%<>")

      bash = parse.result
      outfile.puts "#{bash}"
      outfile.close
    end

    def check_for_setup
      raise "Must run setup before build" unless File.directory?(CONFIG.chrootdir) && File.directory?(CONFIG.logdir)
    end

    def setup_environment
      dirs = [ CONFIG.chrootdir, CONFIG.logdir ]
      dirs.each do |dir|
        unless File.directory?("#{CONFIG.workdir}/#{dir}")
          FileUtils.mkdir_p("#{CONFIG.workdir}/#{dir}")
        end
      end
      #raise "Can't chdir to #{CONFIG.workdir}" unless Dir.chdir("#{CONFIG.workdir}")
    end

    def must_be_root
      raise 'Must run as root' unless Process.uid == 0
    end

    def announcing(msg)
      logger do
        if @logfile then @logfile.puts "* #{msg} [#{Time.now}]\n" end
      end
      puts "\e[32m*\e[0m #{msg} \n"
      yield
    end 

    def cmd(command)
      logger do
        pipe = IO.popen("#{command}")
        pipe.each_line do |line|
          if @logfile then @logfile.puts "#{line}" end
          if CONFIG.verbose then puts "#{line}" end
        end
      end
    end
  
  end
end
