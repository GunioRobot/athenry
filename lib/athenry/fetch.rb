module Athenry
  class Fetch

    attr_accessor :uri, :location, :output, :filename, :force, :progress_bar, :proxy

    # @param [String] uri URI to the file you want to download
    # @param [String] location Where to save the file
    # @param [String] output Optional name to save the file as
    def initialize(opts={})
      self.uri            = URI.parse(opts[:uri])
      self.filename       = URI.parse(opts[:uri]).path[%r{[^/]+\z}]
      self.location       = opts[:location]
      self.output         = opts[:output]
      self.force          = opts[:force]
      self.progress_bar   = nil
      self.proxy          = HTTP_PROXY ? URI.parse(HTTP_PROXY) : OpenStruct.new

      unless self.output
        self.output = self.filename
      end
    end

    # If the file is alreay download return true, if not donload the file
    # @return [True,String]
    def fetch_file
      if check_file 
        success "#{filename} already exists, skipping"
        true
      else
        download
      end
    end
   
    # Fetches the file
    def download
      begin
        fetch = File.open(File.join(self.location, self.output), 'w')
        Net::HTTP::Proxy(proxy.host, proxy.port, proxy.user, proxy.password).start(uri.host) do |http|
          progress_bar = ProgressBar.new('progress', http.head(uri.path).content_length)
          progress_bar.file_transfer_mode
          http.get(uri.path) do |data|
            fetch.write(data) 
            progress_bar.inc(data.size)
          end
        end
      ensure
        fetch.try(:close)
        progress_bar && progress_bar.finish
        return fetch
      end
    end

    protected 

    def http_proxy
        proxy = URI.parse(HTTP_PROXY)
    end

    # If the file exists and the file size is the same return true else return false
    # @return [True,False]
    def check_file
      File.exists?("#{location}/#{output}") && check_size ? true : false
    end

    # Checks the size of the file at the uri and locally to see if we have the whole file.
    # @return [True,False]
    def check_size
      Net::HTTP.start(uri.host) do |http|
        httpsize ||= http.head(uri.path).content_length
        localsize ||= File.stat("#{location}/#{output}").size
        httpsize == localsize ? true : false
      end
    end

  end
end
