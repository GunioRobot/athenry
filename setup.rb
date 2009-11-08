#!/usr/bin/env ruby
# vim: set sw=2 sts=2 et tw=80 :

require 'rubygems'
require 'fileutils'

# 
# Options 
#
@options = {
  "destdir"    => "/usr/local",
  "prefix"     => "/athenry",
  "bindir"     => "/usr/bin",
  "sysconfdir" => "/etc/athenry",
  "confdirs"   => ["etc", "etc/x86", "etc/amd64"],
}

unless Process.uid == 0
  puts "Must be root to install"
  exit 1
end

unless File.directory?("#{@options['destdir']}")
  FileUtils.mkdir_p("#{@options['destdir']}")
end

FileUtils.cp_r( "#{ENV['PWD']}", "#{@options['destdir']}", :verbose => true )

unless File.exists?("#{@options['bindir']}/athenry")
  FileUtils.ln_s( "#{@options['destdir']}/#{@options['prefix']}/bin/athenry", "#{@options['bindir']}/athenry" )
end

unless File.directory?("#{@options['sysconfdir']}")
  @options['confdirs'].each do |dir|
    FileUtils.mkdir_p("#{@options['sysconfdir']}/#{dir}")
  end
end

FileUtils.install( "#{ENV['PWD']}/config.yml", "#{@options['sysconfdir']}/config.yml.example", :mode => 0644, :verbose => true )
