require 'rake'
require 'rake/clean'
require 'rake/testtask'

@gems=%w[commander rconfig progressbar yard erubis]

CLEAN << "athenry-latest.tar.bz2" << "yarddocs" << "coverage" << "tmp"

task :default => :features

# =======================
# Testing
# =======================
#Rake::TestTask.new(:test) { |t| t.pattern = 'test/**/*_test.rb' }

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "features --format progress"
    t.rcov = true
  end
  namespace :features do
    Cucumber::Rake::Task.new(:pretty) do |t|
      t.cucumber_opts = "features --format progress"
      t.rcov = true
    end
  end
rescue LoadError
  puts "missing cucumber gem, run gem install cucumber"
end

begin
  require 'spec/rake/spectask'
  desc "Run all specs"
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ['--options', "spec/spec.opts"]
    #t.rcov = true
  end
rescue LoadError
  puts "missing rspec gem, run gem install rspec"
end


# =======================
# = Installation tasks =
# =======================

desc "install athenry"
task :install do
  system("setup.rb install")
end

desc "uninstall athenry"
task :uninstall do
  system("setup.rb uninstall")
end

desc "install gems"
task 'install:gems' do
  @gems.each do |gem|
    unless Gem.available?(gem)
      system("sudo gem install #{gem}")
    end
  end
end

# =======================
# = Build Tar & Diagram =
# =======================

namespace :build do
  desc "Generate tarball"
    task :tar do
      system("tar -cjf athenry-latest.tar.bz2 ../athenry --exclude 'athenry-latest.tar.bz2' --exclude '.git' --exclude='.yardoc' --exclude '.gitignore' --exclude '.gitmodules' --exclude 'yarddocs'")
  end
  
  desc "Generate Yard Diagram"
    task :diagram do
      system("yard-graph --dependencies --full | dot -T png -o diagram.png")
    end
end

# =======================
# = Documentation tasks =
# =======================

begin
  require 'yard'
  require 'yard/rake/yardoc_task'
  YARD::Rake::YardocTask.new(:yardoc) do |t|
    t.files = ['lib/**/*.rb']
    t.options = ['--output-dir=yarddocs',
                 '--title', 'Athenry YARD documentation']

  end
rescue LoadError
  puts "Missing yard gem, run gem install yard"
end
