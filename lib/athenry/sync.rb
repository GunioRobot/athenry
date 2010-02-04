module Athenry
  class Sync 

    attr_accessor :uri, :output, :options

    def initialize(opts={})
      self.uri = opts[:uri]
      self.output = opts[:output]
      self.options = opts[:options]
    end
    
    def files
      cmd "rsync #{options} #{uri} #{output}"
    end
  end
end
