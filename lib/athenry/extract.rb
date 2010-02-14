module Athenry
  class Extract

    attr_accessor :uri, :path, :location, :filename, :filetype

    def initialize(opts={})
      self.uri        = URI.parse(opts[:uri])
      self.filename   = URI.parse(opts[:uri]).path[%r{[^/]+\z}]
      self.path       = opts[:path]
      self.location   = opts[:location]
      self.filetype   = File.extname(opts[:uri])
    end
    
    # Extracts the filename from a url, and extracts it to the specified path.
    # @param [String] url URL to extract filename from.
    # @param [String] path Path to extract file to.
    # @example
    #   extract('http://www.example.com/path/file.tar.bz2', '/var/tmp/athenry/stage5')
    # @return [String]
    def deflate
      FileUtils.mkdir_p("#{location}") unless File.directory?("#{location}")
      case filetype
      when /.bz2/
        cmd "tar xvjpf #{path}/#{filename} -C #{location}"
      when /.gz/
        cmd "tar xvpf #{path}/#{filename} -C #{location}"
      when /.tar/
        cmd "tar xvpf #{path}/#{filename} -C #{location}"
      else
        raise "Unknown filetype, unable to extract"
        exit 1
      end
    end

  end
end
