#!/usr/bin/env ruby
# vim: set sw=2 sts=2 et tw=80 :

require 'rubygems'
begin
  gem "commander", ">= 4.0"
  require "commander/import"
rescue Gem::LoadError
end
require 'fileutils'
require 'rbconfig'

# 
# Options 
#
@options = {
  :destdir    => "#{Config::CONFIG["sitedir"]}/#{Config::CONFIG["ruby_version"]}",
  :prefix     => 'athenry',
  :bindir     => '/usr/sbin',
  :sysconfdir => '/etc/athenry',
  :confdirs   => ['etc', 'etc/x86', 'etc/amd64'],
  :conffiles  => ['athenry.conf', 'internal.conf'],
  :mandir     => '/usr/local/man/man1',
  :zshdir     => '/usr/share/zsh/site-functions',
  :zshcomp_files => [ '_athenry' ],
  :manpages   => ['athenry.1', 'athenry-build.1', 'athenry-clean.1', 'athenry-rescue.1', 'athenry-resume.1', 'athenry-setup.1', 'athenry-target.1']
}

unless Process.uid == 0
  puts "Must be root to install"
  exit 1
end

program :name, 'setup'
program :version, "0.1" 
program :description, 'Installs or Removes Athenry'
program :help, 'Author', 'Greg Fitzgerald <netzdamon@gmail.com>'

default_command :install

command :install do |c|
  c.syntax = 'athenry install'
  c.description = 'Installs Athenry'
  c.when_called do |args, options|
    install
 end
end

command :uninstall do |c|
  c.syntax = 'athenry uninstall'
  c.description = 'Uninstalls Athenry'
  c.when_called do |args, options|
    uninstall
 end
end

def uninstall
  if File.exists?("#{@options[:bindir]}/athenry")
    FileUtils.rm("#{@options[:bindir]}/athenry", :verbose => true)
  end
  if File.directory?("#{@options[:destdir]}/#{@options[:prefix]}")
    FileUtils.rm_rf("#{@options[:destdir]}/#{@options[:prefix]}", :verbose => true)
  end

  @options[:manpages].each do |page|
    FileUtils.rm_f("#{@options[:mandir]}/#{page}", :verbose => true)
  end

  @options[:zshcomp_files].each do |file|
    FileUtils.rm_f("#{@options[:zshdir]}/#{file}", :verbose => true)
  end

  puts "Files in #{@options[:sysconfdir]} are saved, remove them if you wish"
end

def install
  unless File.directory?("#{@options[:destdir]}")
    FileUtils.mkdir_p("#{@options[:destdir]}")
  end

  FileUtils.cp_r("#{ENV['PWD']}", "#{@options[:destdir]}", :verbose => true)

  unless File.exists?("#{@options[:bindir]}/athenry")
    FileUtils.ln_s("#{@options[:destdir]}/#{@options[:prefix]}/bin/athenry", "#{@options[:bindir]}/athenry")
  end

  unless File.directory?("#{@options[:sysconfdir]}")
    @options[:confdirs].each do |dir|
      FileUtils.mkdir_p("#{@options[:sysconfdir]}/#{dir}")
    end
  end

  unless File.directory?("#{@options[:mandir]}")
      FileUtils.mkdir_p("#{@options[:mandir]}")
  end

  @options[:conffiles].each do |file|
    FileUtils.install("#{ENV['PWD']}/conf/#{file}", "#{@options[:sysconfdir]}", :mode => 0644, :verbose => true)
  end

  @options[:manpages].each do |page|
    FileUtils.install("#{ENV['PWD']}/man/#{page}", "#{@options[:mandir]}", :mode => 0644, :verbose => true)
  end

  FileUtils.chown_R('root', 'root', "#{@options[:sysconfdir]}", :verbose => true)
  FileUtils.chown_R('root', 'root', "#{@options[:destdir]}/#{@options[:prefix]}", :verbose => true)
  FileUtils.chown('root', 'root', "#{@options[:bindir]}/athenry", :verbose=> true)

  @options[:zshcomp_files].each do |file|
    FileUtils.install("#{ENV['PWD']}/zsh-completion/#{file}", "#{@options[:zshdir]}", :mode => 0644, :verbose => true)
  end

end
