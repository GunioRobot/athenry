module Athenry
  class Setup < Helper
    
    def intialize
      # ... execute a command given on STDIN
      while command = prompt
        dirs.each do |dir|
          begin
            Dir.chdir(dir) do
              puts "~ #{dir}:"
              system command
            end
          rescue Errno::ENOENT => e
            $stderr.puts e.message
          end
        end
      end
    end

    def prompt
      print ">> "
      gets
    end

  end
end
