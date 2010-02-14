module Athenry
  class Make 

    def target(*args)
      args.empty? ? bzip2 : args.each {|cmd| send(cmd)}
    end

    def bzip2
      Athenry::bzip2
    end

    def gzip
      Athenry::gzip
    end

  end
end
