module Athenry
  class Checksum

    attr_accessor :uri, :path, :digest, :filename

    def initialize(opts={})
      self.uri = URI.parse(opts[:uri])
      self.filename = URI.parse(opts[:uri]).path[%r{[^/]+\z}]
      self.path = opts[:path]
      self.digest = opts[:digest]

      unless self.digest
        self.digest = "DIGESTS"
      end
    end

    def md5 
      unverified_digest = Digest::MD5.hexdigest(File.read("#{path}/#{filename}"))
      verified_digest = File.read("#{path}/#{filename}.#{digest}").match('^([a-zA-z0-9]){32}')
      if "#{unverified_digest}" == "#{verified_digest}"
        success "md5sum of #{filename} passsed"
      else
        raise "md5sum of #{filename} failed!"
        exit 1
      end
    end

  end
end
