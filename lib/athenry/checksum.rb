module Athenry
  class Checksum

    attr_accessor :uri, :path, :digest, :filename

    # @param [String] uri Url of the file you want to check
    # @param [String] path Local file system path to where the file was saved
    # @param [String] digest The file extension of the digest file, defaults to DIGESTS
    def initialize(opts={})
      self.uri = URI.parse(opts[:uri])
      self.filename = URI.parse(opts[:uri]).path[%r{[^/]+\z}]
      self.path = opts[:path]
      self.digest = opts[:digest]

      unless self.digest
        self.digest = "DIGESTS"
      end
    end

    # Checks the md5sum of a file, if the checksum does not pass it exists 1
    # @return [String]
    def md5 
      unverified_digest = Digest::MD5.hexdigest(File.read("#{path}/#{filename}"))
      verified_digest = File.read("#{path}/#{filename}.#{digest}").match('\b([a-zA-z0-9]){32}\b')
      if "#{unverified_digest}" == "#{verified_digest}"
        success "md5sum of #{filename} passsed"
      else
        raise "md5sum of #{filename} failed!"
        exit 1
      end
    end

    # Checks the sha1 of a file, if the checksum does not pass it exists 1
    # @return [String]
    def sha1 
      unverified_digest = Digest::SHA1.hexdigest(File.read("#{path}/#{filename}"))
      verified_digest = File.read("#{path}/#{filename}.#{digest}").match('\b([a-f0-9]{40})\b')
      if "#{unverified_digest}" == "#{verified_digest}"
        success "sha1 of #{filename} passsed"
      else
        raise "sha1 of #{filename} failed!"
        exit 1
      end
    end
  end
end
