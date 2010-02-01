module Athenry
  class Extract

    attr_accessor :uri, :path, :digest, :location, :filename, :filetype

    #def initialize(uri, path, digest="DIGESTS", location=nil)
    def initialize(opts={})
      self.uri = URI.parse(opts[:uri])
      self.filename = URI.parse(opts[:uri]).path[%r{[^/]+\z}]
      self.path = opts[:path]
      self.digest = opts[:digest]
      self.location = opts[:location]
      self.filetype = File.extname(opts[:uri])

      unless self.digest
        self.digest = "DIGESTS"
      end
    end
    
    # Checks the md5sum of a file from a url. If the md5sum doesn't passes it exits immediately.
    # @param [String] url URL to extract filename from.
    # @param [String] digest Extension for the digest file. We assume the digest file is filename.digest.
    # @example
    #   md5sum('http://www.foobar.com/path/file.tar.bz2', 'md5sum') #=> md5sum -c file.tar.bz2.md5sum --status
    # @return [String]
    def md5sum
      unverified_digest = Digest::MD5.hexdigest(File.read("#{path}/#{filename}"))
      verified_digest = IO.readlines("#{path}/#{filename}.#{digest}")[1].split.first
      if "#{unverified_digest}" == "#{verified_digest}"
        success "md5sum passsed"
      else
        raise "md5sum of #{@filename} failed!"
        exit 1
      end
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
