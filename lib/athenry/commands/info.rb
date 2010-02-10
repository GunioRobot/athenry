module Athenry
  class Info
    
    def target(*args)
      args.each { |cmd| send(cmd) }
    end

    def list 
      chroots ||= Dir.entries("#{WORKDIR}/builds/")
      chroots.each do |chroot|
        next if chroot =~ /\.+/
        puts chroot
      end
    end
  end
end
