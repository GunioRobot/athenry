module Athenry
  class Fetch

    attr_accessor :uri, :location, :output, :filename, :force

    def initialize(opts={})
      self.uri = URI.parse(opts[:uri])
      self.filename = URI.parse(opts[:uri]).path[%r{[^/]+\z}]
      self.location = opts[:location]
      self.output = opts[:output]
      self.force = opts[:force]

      unless self.output
        self.output = self.filename
      end
    end

    def fetch_file
      if check_file || !force
        success "#{filename} already exists, skipping"
        return true
      else
        download
      end
    end
    
    def download
      begin
        fetch = File.open(File.join(location, output), 'w')
        progress_bar = nil
        Net::HTTP.start(uri.host) do |http|
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

    def check_file
      if File.exists?("#{location}/#{output}") && check_size
        return true
      else
        return false
      end 
    end

    def check_size
      Net::HTTP.start(uri.host) do |http|
        httpsize ||= http.head(uri.path).content_length
        localsize ||= File.stat("#{location}/#{output}").size
        if httpsize == localsize
          return true
        else
          return false
        end
      end
    end

  end
end
