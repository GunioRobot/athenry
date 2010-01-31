require 'uri'
require 'erubis'
require 'readline'

begin
  gem 'rconfig', '>= 0.3.2'
  require 'rconfig'
rescue Gem::LoadError
end
