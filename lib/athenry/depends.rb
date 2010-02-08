require 'uri'
require 'erubis'
require 'readline'
require 'fileutils'
require 'digest/md5' 
require 'digest/sha1'
require 'net/http'
require 'time'
require 'ostruct'

begin
  gem 'rconfig', '>= 0.3.2'
  require 'rconfig'
rescue Gem::LoadError
end

begin
  gem 'progressbar', '>= 0.9.0'
  require 'progressbar'
rescue Gem::LoadError
end
