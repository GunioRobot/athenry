module Athenry
  module Config

    begin
      RConfig.config_paths = ["#{ENV['HOME']}/.config/athenry/", "/etc/athenry/"]
    rescue ConfigError 
      $stderr.puts "No configuration file found"
    end

    if File.exists?("#{ENV['HOME']}/.config/athenry/athenry.conf")
      CONFIGS = "#{ENV['HOME']}/.config/athenry/etc/#{RConfig.athenry.general.arch}"
    else
      CONFIGS = "/etc/athenry/etc/#{RConfig.athenry.general.arch}"
    end

    $stageurl = "#{RConfig.athenry.stage.url}" unless $stageurl
    $snapshoturl = "#{RConfig.athenry.snapshot.url}" unless $snapshoturl

    $shell_is_running = false
    $verbose = RConfig.athenry.general.verbose

    $nopaludis = RConfig.internal.bools.nopaludis
    $freshen = RConfig.internal.bools.freshen
    
    WORKDIR = "#{RConfig.athenry.general.workdir}"
    SCRIPTS = "#{ATHENRY_ROOT}/scripts"
    LOGDIR = "#{WORKDIR}/#{RConfig.internal.paths.logdir}"
    STATEDIR = "#{WORKDIR}/#{RConfig.internal.paths.statedir}"
    STAGEDIR = "#{WORKDIR}/#{RConfig.internal.paths.stagedir}"
    SNAPSHOTDIR = "#{WORKDIR}/#{RConfig.internal.paths.snapshotdir}"
    SNAPSHOTCACHE = "#{WORKDIR}/#{RConfig.internal.paths.snapshotdir}/#{RConfig.internal.paths.snapshotcache}"

  end
end
