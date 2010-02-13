module Athenry
  module Config

    if ENV['XDG_CONFIG_HOME'].blank?
      XDG_CONFIG_HOME ="#{ENV['HOME']}/.config/athenry"
    else
      XDG_CONFIG_HOME="#{ENV['XDG_CONFIG_HOME']}/athenry"
    end
    
    begin
      RConfig.config_paths = ["#{XDG_CONFIG_HOME}", "/etc/athenry/"]
    rescue ConfigError 
      $stderr.puts "No configuration file found"
      exit 1
    end

    unless $configpath.nil?
      if File.directory?($configpath) 
        @userconfig = RConfig.add_config_path($configpath)
      else
        @userconfig = RConfig.add_config_path(File.dirname($configpath))
      end
    end

    if File.exists?("#{@userconfig}/athenry.conf")
      CONFIGS = "#{@userconfig}/athenry.conf"
    elsif File.exists?("#{XDG_CONFIG_HOME}/athenry.conf")
      CONFIGS = "#{XDG_CONFIG_HOME}/etc/#{RConfig.athenry.general.config_profile}"
    else
      CONFIGS = "/etc/athenry/etc/#{RConfig.athenry.general.config_profile}"
    end

    $stageurl = RConfig.athenry.stage.url unless $stageurl
    $snapshoturl = RConfig.athenry.snapshot.url unless $snapshoturl

    $shell_is_running = false
    $verbose = RConfig.athenry.general.verbose

    $nopaludis = RConfig.internal.bools.nopaludis
    $freshen = RConfig.internal.bools.freshen
    
    WORKDIR = RConfig.athenry.general.workdir
    SCRIPTS = "#{ATHENRY_ROOT}/scripts"
    LOGDIR = RConfig.internal.paths.logdir
    STATEDIR = RConfig.internal.paths.statedir
    STAGEDIR = "#{WORKDIR}/#{RConfig.internal.paths.stagedir}"
    SNAPSHOTDIR = "#{WORKDIR}/#{RConfig.internal.paths.snapshotdir}"
    SNAPSHOTCACHE = "#{WORKDIR}/#{RConfig.internal.paths.snapshotdir}/#{RConfig.internal.paths.snapshotcache}"
    SYNC = RConfig.athenry.gentoo.sync
    HTTP_PROXY = RConfig[:HTTP_PROXY]
    FTP_PROXY = RConfig[:FTP_PROXY]
    ERRORFILE = "#{LOGDIR}/failures.log"
    DATETIME_FORMAT = RConfig.athenry.general.datetime_format

  end
end
