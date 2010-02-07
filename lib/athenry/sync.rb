module Athenry
  class Sync 

    attr_accessor :uri, :output, :options

    # @param [String] uri This can be a file path or a url
    # @param [String] output Location to copy files
    # @param [String] options Options to pass to rsync
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
